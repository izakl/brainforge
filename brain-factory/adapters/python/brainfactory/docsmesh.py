"""Docs-mesh anti-drift checker (validated layer).

Read-only checks over a brain's markdown that keep the docs internally
consistent. Nothing is modified. The module emits a structured report and a
non-zero exit when a *hard* check fails.

Checks:
- Link resolution — every relative markdown link ``[text](path)`` and every
  ``[[wikilink]]`` resolves to an existing file in the brain. (HARD)
- Mermaid — every ```mermaid fenced block is non-empty and the fences are
  balanced; flag GitHub-unsafe patterns (a literal ``\\n`` inside a label —
  recommend ``<br/>``). Unbalanced fences are HARD; the literal-\\n pattern is a
  soft warning.
- Freshness — docs carrying a ``Last reviewed: YYYY-MM-DD`` or
  ``Last generated: YYYY-MM-DD`` stamp are parsed; a stamp that fails to parse
  is a HARD failure. Age is reported, never failed on.

Standard library only. Typed. Same code style as ``inspect.py``.
"""

from __future__ import annotations

import os
import re
from dataclasses import dataclass, field
from datetime import date, datetime
from pathlib import Path
from typing import Any
from urllib.parse import unquote, urlsplit

# Directories never worth scanning (mirrors inspect.py).
_SKIP_DIRS = frozenset(
    {".git", "node_modules", ".venv", "venv", "__pycache__", ".mypy_cache",
     ".pytest_cache", "dist", "build", ".next", ".tox", ".idea"}
)

# Inline markdown link: [text](target).  Excludes image links handled the same.
_LINK_RE = re.compile(r"(?<!\!)\[(?P<text>[^\]]*)\]\((?P<target>[^)]+)\)")
# Wikilink: [[target]] or [[target|alias]].
_WIKILINK_RE = re.compile(r"\[\[(?P<target>[^\]|]+)(?:\|[^\]]*)?\]\]")
# Fenced code blocks (``` or ~~~) capturing the info string.
_FENCE_RE = re.compile(r"^(?P<indent>\s*)(?P<fence>```+|~~~+)(?P<info>[^\n]*)$")
# Freshness stamps.
_FRESHNESS_RE = re.compile(
    r"(?:Last\s+(?:reviewed|generated))\s*:\s*(?P<date>[^\s<]+)", re.IGNORECASE)
# Schemes we treat as external (never resolved on disk).
_EXTERNAL_SCHEMES = frozenset({"http", "https", "mailto", "tel", "ftp", "data"})


@dataclass
class Finding:
    """A single docs-mesh finding."""

    kind: str       # link | wikilink | mermaid | freshness
    severity: str   # error | warning | info
    file: str       # relative-to-brain path
    detail: str
    line: int | None = None

    def to_dict(self) -> dict[str, Any]:
        return {
            "kind": self.kind,
            "severity": self.severity,
            "file": self.file,
            "line": self.line,
            "detail": self.detail,
        }


@dataclass
class DocsMeshResult:
    brain: str
    checked_at: str
    files_scanned: int
    findings: list[Finding] = field(default_factory=list)

    @property
    def errors(self) -> list[Finding]:
        return [f for f in self.findings if f.severity == "error"]

    @property
    def warnings(self) -> list[Finding]:
        return [f for f in self.findings if f.severity == "warning"]

    @property
    def infos(self) -> list[Finding]:
        return [f for f in self.findings if f.severity == "info"]

    @property
    def ok(self) -> bool:
        return not self.errors

    def to_dict(self) -> dict[str, Any]:
        return {
            "brain": self.brain,
            "checked_at": self.checked_at,
            "files_scanned": self.files_scanned,
            "ok": self.ok,
            "summary": {
                "errors": len(self.errors),
                "warnings": len(self.warnings),
                "infos": len(self.infos),
            },
            "findings": [f.to_dict() for f in self.findings],
        }


def _markdown_files(root: Path) -> list[Path]:
    out: list[Path] = []
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = [d for d in dirnames if d not in _SKIP_DIRS]
        for name in filenames:
            if name.lower().endswith((".md", ".mdx", ".markdown")):
                out.append(Path(dirpath) / name)
    return sorted(out)


def _rel(path: Path, root: Path) -> str:
    try:
        return str(path.relative_to(root)).replace(os.sep, "/")
    except ValueError:
        return str(path)


def _all_files_index(root: Path) -> set[str]:
    """POSIX relative paths of every file in the brain, for wikilink resolution."""
    index: set[str] = set()
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = [d for d in dirnames if d not in _SKIP_DIRS]
        for name in filenames:
            index.add(_rel(Path(dirpath) / name, root))
    return index


# ---------------------------------------------------------------------------
# Link resolution
# ---------------------------------------------------------------------------

def _is_external(target: str) -> bool:
    parts = urlsplit(target)
    return bool(parts.scheme) and parts.scheme.lower() in _EXTERNAL_SCHEMES


def _resolve_relative_link(md_file: Path, root: Path, target: str) -> bool:
    """True if a relative link target resolves to an existing file/dir."""
    # Drop any #fragment and ?query; keep the path part.
    path_part = urlsplit(target).path
    if not path_part:
        # Pure in-page anchor like "#section" — always considered resolved.
        return True
    path_part = unquote(path_part)
    if path_part.startswith("/"):
        # Root-relative to the brain root.
        candidate = (root / path_part.lstrip("/")).resolve()
    else:
        candidate = (md_file.parent / path_part).resolve()
    if candidate.exists():
        return True
    # Tolerate a wikilink-style omission of the .md extension.
    if not Path(path_part).suffix:
        return candidate.with_suffix(".md").exists()
    return False


def _check_links(md_file: Path, root: Path, text: str,
                 file_index: set[str]) -> list[Finding]:
    findings: list[Finding] = []
    rel = _rel(md_file, root)
    for lineno, line in enumerate(text.splitlines(), start=1):
        for m in _LINK_RE.finditer(line):
            target = m.group("target").strip()
            if not target or target.startswith("#"):
                continue
            if _is_external(target):
                continue
            if not _resolve_relative_link(md_file, root, target):
                findings.append(Finding(
                    kind="link", severity="error", file=rel, line=lineno,
                    detail=f"unresolved link target: {target!r}"))
        for m in _WIKILINK_RE.finditer(line):
            target = m.group("target").strip()
            if not _resolve_wikilink(target, file_index):
                findings.append(Finding(
                    kind="wikilink", severity="error", file=rel, line=lineno,
                    detail=f"unresolved wikilink: [[{target}]]"))
    return findings


def _resolve_wikilink(target: str, file_index: set[str]) -> bool:
    """A wikilink resolves if any indexed file matches by path or basename.

    Matches: exact relative path, that path + ``.md``, or a file whose stem
    equals the target (case-insensitive on the final component).
    """
    target = target.strip().replace("\\", "/")
    target_md = target if target.lower().endswith(".md") else target + ".md"
    if target in file_index or target_md in file_index:
        return True
    want = Path(target).name.lower()
    want_stem = Path(target).stem.lower()
    for rel in file_index:
        base = Path(rel).name.lower()
        if base == want or base == want.lower() + ".md":
            return True
        if Path(rel).stem.lower() == want_stem:
            return True
    return False


# ---------------------------------------------------------------------------
# Mermaid
# ---------------------------------------------------------------------------

def _check_mermaid(md_file: Path, root: Path, text: str) -> list[Finding]:
    findings: list[Finding] = []
    rel = _rel(md_file, root)
    lines = text.splitlines()

    open_fence: str | None = None       # the exact fence string that opened
    fence_start = 0
    info = ""
    body: list[str] = []
    for lineno, line in enumerate(lines, start=1):
        m = _FENCE_RE.match(line)
        if m is None:
            if open_fence is not None:
                body.append(line)
            continue
        fence = m.group("fence")
        if open_fence is None:
            open_fence = fence
            fence_start = lineno
            info = m.group("info").strip()
            body = []
        elif fence[0] == open_fence[0] and len(fence) >= len(open_fence) \
                and not m.group("info").strip():
            # Closing fence (same fence char, at least as long, no info string).
            if info.lower().startswith("mermaid"):
                findings.extend(_inspect_mermaid_block(rel, fence_start, body))
            open_fence = None
            info = ""
            body = []
        else:
            # A fence-looking line inside a block body.
            body.append(line)

    if open_fence is not None and info.lower().startswith("mermaid"):
        findings.append(Finding(
            kind="mermaid", severity="error", file=rel, line=fence_start,
            detail="unterminated mermaid fence (opening/closing fences unbalanced)"))
    return findings


def _inspect_mermaid_block(rel: str, start_line: int,
                           body: list[str]) -> list[Finding]:
    findings: list[Finding] = []
    if not any(ln.strip() for ln in body):
        findings.append(Finding(
            kind="mermaid", severity="error", file=rel, line=start_line,
            detail="empty mermaid block"))
        return findings
    for offset, line in enumerate(body, start=1):
        if "\\n" in line:
            findings.append(Finding(
                kind="mermaid", severity="warning", file=rel,
                line=start_line + offset,
                detail="GitHub-unsafe literal '\\n' inside a mermaid label — "
                       "use <br/> instead"))
    return findings


# ---------------------------------------------------------------------------
# Freshness
# ---------------------------------------------------------------------------

def _check_freshness(md_file: Path, root: Path, text: str) -> list[Finding]:
    findings: list[Finding] = []
    rel = _rel(md_file, root)
    for lineno, line in enumerate(text.splitlines(), start=1):
        m = _FRESHNESS_RE.search(line)
        if m is None:
            continue
        raw = m.group("date").strip().strip("_*`")
        if raw.lower() in ("never", "n/a", "unknown", "tbd", "(template)"):
            continue
        try:
            stamp = datetime.strptime(raw, "%Y-%m-%d").date()
        except ValueError:
            findings.append(Finding(
                kind="freshness", severity="error", file=rel, line=lineno,
                detail=f"unparseable freshness stamp: {raw!r} "
                       "(expected YYYY-MM-DD)"))
            continue
        age = (date.today() - stamp).days
        findings.append(Finding(
            kind="freshness", severity="info", file=rel, line=lineno,
            detail=f"stamped {stamp.isoformat()} ({age} day(s) old)"))
    return findings


# ---------------------------------------------------------------------------
# Driver
# ---------------------------------------------------------------------------

def check_docs_mesh(brain: str | Path) -> DocsMeshResult:
    """Run all docs-mesh checks over a brain directory (read-only)."""
    root = Path(brain).resolve()
    if not root.is_dir():
        raise NotADirectoryError(f"Brain directory not found: {root}")

    file_index = _all_files_index(root)
    md_files = _markdown_files(root)
    findings: list[Finding] = []
    for md in md_files:
        try:
            text = md.read_text(encoding="utf-8", errors="ignore")
        except OSError:
            continue
        findings.extend(_check_links(md, root, text, file_index))
        findings.extend(_check_mermaid(md, root, text))
        findings.extend(_check_freshness(md, root, text))

    return DocsMeshResult(
        brain=str(root),
        checked_at=date.today().isoformat(),
        files_scanned=len(md_files),
        findings=findings,
    )


def render_report(result: DocsMeshResult) -> str:
    """Render the docs-mesh report as human-readable text."""
    r = result
    lines: list[str] = []
    lines.append(f"=== docs-mesh: {r.brain} ===")
    lines.append(f"Scanned {r.files_scanned} markdown file(s) on {r.checked_at}")
    lines.append(f"Errors: {len(r.errors)}  Warnings: {len(r.warnings)}  "
                 f"Info: {len(r.infos)}")
    lines.append("")
    if r.errors:
        lines.append("ERRORS (hard — these fail the check):")
        for f in r.errors:
            loc = f"{f.file}:{f.line}" if f.line else f.file
            lines.append(f"  [{f.kind}] {loc} — {f.detail}")
        lines.append("")
    if r.warnings:
        lines.append("WARNINGS (soft):")
        for f in r.warnings:
            loc = f"{f.file}:{f.line}" if f.line else f.file
            lines.append(f"  [{f.kind}] {loc} — {f.detail}")
        lines.append("")
    if r.infos:
        lines.append("FRESHNESS (info):")
        for f in r.infos:
            loc = f"{f.file}:{f.line}" if f.line else f.file
            lines.append(f"  [{f.kind}] {loc} — {f.detail}")
        lines.append("")
    lines.append("RESULT: " + ("PASS" if r.ok else "FAIL"))
    return "\n".join(lines)
