"""Read-only repository inspector (Mode B — inspect-first).

Audits a target repo and reports, per core module, a status of
``present`` | ``partial`` | ``missing`` with the evidence (file paths found) and
a recommended action (``keep`` | ``augment`` | ``add``).

The inspector MUST NOT modify the target repo. It only reads.

Heuristics per module are documented inline. Beyond the modules it also detects:
- platform signals (*.ps1 vs *.sh, .github/workflows),
- an EXTERNAL source-of-truth risk (e.g. a Drive-only context) for the
  continuity-log module, which surfaces a prominent migrate-to-GitHub finding.

Outputs are emitted in two forms: a markdown gap report and a JSON summary.
"""

from __future__ import annotations

import fnmatch
import os
import re
from dataclasses import dataclass, field
from datetime import date
from pathlib import Path
from typing import Any

# Directories never worth scanning.
_SKIP_DIRS = frozenset(
    {".git", "node_modules", ".venv", "venv", "__pycache__", ".mypy_cache",
     ".pytest_cache", "dist", "build", ".next", ".tox", ".idea"}
)

# How many evidence paths to keep per signal before truncating.
_MAX_EVIDENCE = 12

# Signals (case-insensitive) that an external, non-GitHub source-of-truth exists.
_EXTERNAL_SOT_SIGNALS = (
    "google drive",
    "drive only",
    "drive-only",
    r"g:\my drive",
    "my drive",
    "single source of truth",
    "source of truth",
)


@dataclass
class ModuleFinding:
    """The audit result for one core module."""

    module: str
    status: str  # present | partial | missing
    action: str  # keep | augment | add
    evidence: list[str] = field(default_factory=list)
    notes: list[str] = field(default_factory=list)

    def to_dict(self) -> dict[str, Any]:
        return {
            "module": self.module,
            "status": self.status,
            "action": self.action,
            "evidence": self.evidence,
            "notes": self.notes,
        }


@dataclass
class InspectionResult:
    repo: str
    inspected_at: str
    modules: list[ModuleFinding]
    platform_signals: dict[str, Any]
    risks: list[dict[str, str]]

    def to_dict(self) -> dict[str, Any]:
        return {
            "repo": self.repo,
            "inspected_at": self.inspected_at,
            "platform_signals": self.platform_signals,
            "risks": self.risks,
            "modules": [m.to_dict() for m in self.modules],
            "summary": {
                "present": sum(1 for m in self.modules if m.status == "present"),
                "partial": sum(1 for m in self.modules if m.status == "partial"),
                "missing": sum(1 for m in self.modules if m.status == "missing"),
            },
        }


def _walk_files(root: Path) -> list[Path]:
    """Return all files under ``root``, skipping noise directories."""
    out: list[Path] = []
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = [d for d in dirnames if d not in _SKIP_DIRS]
        for name in filenames:
            out.append(Path(dirpath) / name)
    return out


def _rel(path: Path, root: Path) -> str:
    try:
        return str(path.relative_to(root))
    except ValueError:
        return str(path)


def _match_any(rel_posix: str, name: str, patterns: tuple[str, ...]) -> bool:
    """Match a file against glob patterns on either its name or relative path."""
    for pat in patterns:
        if "/" in pat:
            if fnmatch.fnmatch(rel_posix, pat):
                return True
        else:
            if fnmatch.fnmatch(name, pat):
                return True
    return False


def _collect(
    files: list[Path], root: Path, *, name_globs: tuple[str, ...] = (),
    path_globs: tuple[str, ...] = (), dir_globs: tuple[str, ...] = (),
) -> list[str]:
    """Collect relative paths matching name/path globs or living under dir globs."""
    found: list[str] = []
    for f in files:
        rel = _rel(f, root)
        rel_posix = rel.replace(os.sep, "/")
        name = f.name
        hit = False
        if name_globs and _match_any(rel_posix, name, name_globs):
            hit = True
        elif path_globs and _match_any(rel_posix, name, path_globs):
            hit = True
        elif dir_globs:
            for dg in dir_globs:
                dg_norm = dg.rstrip("/")
                if rel_posix == dg_norm or rel_posix.startswith(dg_norm + "/"):
                    hit = True
                    break
        if hit:
            found.append(rel_posix)
    return sorted(set(found))[:_MAX_EVIDENCE]


def _decide(status: str) -> str:
    return {"present": "keep", "partial": "augment", "missing": "add"}[status]


def _status_from_count(strong: int, weak: int = 0) -> str:
    if strong:
        return "present"
    if weak:
        return "partial"
    return "missing"


def inspect_repo(repo_path: str | Path) -> InspectionResult:
    """Audit ``repo_path`` read-only and return a structured result."""
    root = Path(repo_path).resolve()
    if not root.is_dir():
        raise NotADirectoryError(f"Target repo not found: {root}")

    files = _walk_files(root)
    modules: list[ModuleFinding] = []
    risks: list[dict[str, str]] = []

    # --- operating-contract ---------------------------------------------------
    # OPERATING-CONTRACT*.md, AGENTS.md, CLAUDE.md
    strong = _collect(files, root, name_globs=("OPERATING-CONTRACT*.md",))
    weak = _collect(files, root, name_globs=("AGENTS.md", "CLAUDE.md",
                                             ".github/copilot-instructions.md"))
    pointers = _collect(files, root, path_globs=(".github/copilot-instructions.md",))
    weak = sorted(set(weak) | set(pointers))[:_MAX_EVIDENCE]
    status = _status_from_count(len(strong), len(weak))
    f_oc = ModuleFinding("operating-contract", status, _decide(status),
                         evidence=sorted(set(strong) | set(weak))[:_MAX_EVIDENCE])
    if not strong and weak:
        f_oc.notes.append(
            "Pointer files exist (CLAUDE.md/AGENTS.md) but no canonical "
            "OPERATING-CONTRACT.md — augment by adding the contract.")
    modules.append(f_oc)

    # --- session-ritual-hooks -------------------------------------------------
    # hooks dirs, SessionStart/SessionEnd hook files, .claude/settings*.json hooks
    hook_files = _collect(
        files, root,
        name_globs=("*SessionStart*", "*SessionEnd*", "session_context.py",
                    "*hook*.py", "*hook*.sh", "*hook*.ps1"),
        dir_globs=("hooks", ".claude/hooks", ".github/hooks"),
    )
    settings_hooks: list[str] = []
    for f in files:
        rel = _rel(f, root).replace(os.sep, "/")
        if fnmatch.fnmatch(f.name, ".claude/settings*.json") or (
            "/.claude/" in "/" + rel and f.name.startswith("settings")
            and f.name.endswith(".json")
        ):
            try:
                if "hooks" in f.read_text(encoding="utf-8", errors="ignore").lower():
                    settings_hooks.append(rel)
            except OSError:
                pass
    evidence = sorted(set(hook_files) | set(settings_hooks))[:_MAX_EVIDENCE]
    status = _status_from_count(len(hook_files), len(settings_hooks))
    f_hooks = ModuleFinding("session-ritual-hooks", status, _decide(status),
                            evidence=evidence)
    if status == "missing":
        f_hooks.notes.append(
            "No SessionStart/SessionEnd hooks found — add the session ritual hooks.")
    modules.append(f_hooks)

    # --- continuity-log -------------------------------------------------------
    # docs/sessions/**, 05-logs/**, decision logs, context docs.
    cont_strong = _collect(
        files, root,
        dir_globs=("docs/sessions", "05-logs", "docs/logs", "sessions"),
        name_globs=("S[0-9]*.md", "*-session-*.md", "*CONTEXT*.md",
                    "*-CONTEXT.md", "PROJECT_KNOWLEDGE.md"),
    )
    cont_weak = _collect(files, root, dir_globs=("context", "docs/context"))
    evidence = sorted(set(cont_strong) | set(cont_weak))[:_MAX_EVIDENCE]
    status = _status_from_count(len(cont_strong), len(cont_weak))
    f_cont = ModuleFinding("continuity-log", status, _decide(status),
                           evidence=evidence)

    # External source-of-truth risk scan.
    ext_hits = _scan_external_sot(files, root)
    if ext_hits:
        f_cont.notes.append(
            "EXTERNAL SOURCE-OF-TRUTH RISK: continuity/context appears to live "
            "outside GitHub. Migrate it into the brain/GitHub so the repo is the "
            "single source of truth.")
        for hit in ext_hits:
            risks.append({
                "kind": "external-source-of-truth",
                "severity": "high",
                "evidence": hit["path"],
                "detail": hit["detail"],
                "recommended_action": (
                    "Migrate external source-of-truth to GitHub (brain repo)."),
            })
        # An external SoT downgrades a 'present' continuity story to 'partial':
        # logs may exist but the authoritative context is off-platform.
        if f_cont.status == "present":
            f_cont.status = "partial"
            f_cont.action = "augment"
    modules.append(f_cont)

    # --- capabilities-map -----------------------------------------------------
    # CAPABILITIES.md or an inventory doc.
    cap = _collect(files, root, name_globs=("CAPABILITIES.md", "CAPABILITIES*.md",
                                            "*INVENTORY*.md", "inventory*.md",
                                            "capabilities*.md"))
    status = _status_from_count(len(cap))
    modules.append(ModuleFinding("capabilities-map", status, _decide(status),
                                 evidence=cap))

    # --- docs-mesh ------------------------------------------------------------
    # link/diagram/freshness check scripts or workflows.
    mesh = _collect(
        files, root,
        name_globs=("*link-check*", "*linkcheck*", "*docs-mesh*", "*freshness*",
                    "*lychee*", "*markdown-link*"),
        dir_globs=("docs/diagrams", "01-docs/diagrams"),
    )
    # Workflow files that mention link checking.
    for f in files:
        rel = _rel(f, root).replace(os.sep, "/")
        if rel.startswith(".github/workflows/") and f.suffix in (".yml", ".yaml"):
            try:
                txt = f.read_text(encoding="utf-8", errors="ignore").lower()
            except OSError:
                continue
            if any(k in txt for k in ("link-check", "lychee", "markdown-link",
                                      "docs-mesh", "freshness")):
                mesh.append(rel)
    mesh = sorted(set(mesh))[:_MAX_EVIDENCE]
    status = _status_from_count(len(mesh))
    f_mesh = ModuleFinding("docs-mesh", status, _decide(status), evidence=mesh)
    if status == "missing":
        f_mesh.notes.append(
            "No docs-mesh checks (link/diagram/freshness) found — add them.")
    modules.append(f_mesh)

    # --- decision-board -------------------------------------------------------
    # docs/decisions/**, ADR*, a decision-board/register file.
    dec = _collect(
        files, root,
        dir_globs=("docs/decisions", "decisions", "00-governance/consensus"),
        name_globs=("ADR-*.md", "ADR*.md", "*decision-board*", "*decision-register*",
                    "decisions*.md"),
    )
    status = _status_from_count(len(dec))
    modules.append(ModuleFinding("decision-board", status, _decide(status),
                                 evidence=dec))

    # --- core-commands --------------------------------------------------------
    # existing skills (SKILL.md), Copilot prompts (*.prompt.md), runbooks, ops scripts.
    cmds = _collect(
        files, root,
        name_globs=("SKILL.md", "*.prompt.md", "*RUNBOOK*.md", "*runbook*.md"),
        dir_globs=("scripts", "08-ops", ".github/prompts",
                   "03-templates/agent-commands"),
    )
    status = _status_from_count(len(cmds))
    f_cmd = ModuleFinding("core-commands", status, _decide(status), evidence=cmds)
    if status == "partial":
        f_cmd.notes.append(
            "Ad-hoc commands/runbooks exist but no skill catalog — augment with "
            "the core command set.")
    modules.append(f_cmd)

    platform_signals = _detect_platforms(files, root)

    return InspectionResult(
        repo=str(root),
        inspected_at=date.today().isoformat(),
        modules=modules,
        platform_signals=platform_signals,
        risks=risks,
    )


def _scan_external_sot(files: list[Path], root: Path) -> list[dict[str, str]]:
    """Scan docs and pointer files for external source-of-truth signals."""
    hits: list[dict[str, str]] = []
    pat = re.compile("|".join(re.escape(s) for s in _EXTERNAL_SOT_SIGNALS),
                     re.IGNORECASE)
    for f in files:
        rel = _rel(f, root).replace(os.sep, "/")
        name = f.name
        is_pointer = "CONTEXT_POINTER" in name.upper() or "_POINTER" in name.upper()
        is_doc = f.suffix.lower() in (".md", ".txt", ".rst")
        if not (is_doc or is_pointer):
            continue
        try:
            text = f.read_text(encoding="utf-8", errors="ignore")
        except OSError:
            continue
        m = pat.search(text)
        if m or is_pointer:
            # Pull the first matching line for a readable detail.
            detail = ""
            for line in text.splitlines():
                if pat.search(line):
                    detail = line.strip()
                    break
            if not detail and is_pointer:
                detail = "Context pointer file references an off-repo location."
            if detail:
                hits.append({"path": rel, "detail": detail[:300]})
    return hits


def _detect_platforms(files: list[Path], root: Path) -> dict[str, Any]:
    """Capture platform signals: *.ps1 vs *.sh, workflows."""
    ps1 = _collect(files, root, name_globs=("*.ps1",))
    sh = _collect(files, root, name_globs=("*.sh",))
    workflows = _collect(files, root, path_globs=(".github/workflows/*.yml",
                                                  ".github/workflows/*.yaml"))
    inferred: list[str] = ["python"]  # the engine itself is python
    if ps1:
        inferred.append("powershell")
    if sh:
        inferred.append("bash")
    return {
        "powershell_scripts": ps1,
        "bash_scripts": sh,
        "github_workflows": workflows,
        "inferred_platforms": sorted(set(inferred)),
    }


# ---------------------------------------------------------------------------
# Rendering
# ---------------------------------------------------------------------------

_STATUS_BADGE = {"present": "present", "partial": "partial", "missing": "missing"}


def render_markdown(result: InspectionResult) -> str:
    """Render the gap report as markdown."""
    r = result
    lines: list[str] = []
    lines.append(f"# Onboarding gap report — {r.repo}")
    lines.append("")
    lines.append(f"- Inspected: {r.inspected_at}")
    s = r.to_dict()["summary"]
    lines.append(
        f"- Modules: {s['present']} present, {s['partial']} partial, "
        f"{s['missing']} missing")
    lines.append(f"- Inferred platforms: "
                 f"{', '.join(r.platform_signals['inferred_platforms'])}")
    lines.append("")
    lines.append("> Read-only audit. This report changes nothing in the target repo.")
    lines.append("")

    if r.risks:
        lines.append("## Risks")
        lines.append("")
        for risk in r.risks:
            lines.append(
                f"- **[{risk['severity'].upper()}] {risk['kind']}** — "
                f"{risk['detail']}")
            lines.append(f"  - Evidence: `{risk['evidence']}`")
            lines.append(f"  - Action: {risk['recommended_action']}")
        lines.append("")

    lines.append("## Modules")
    lines.append("")
    lines.append("| Module | Status | Action | Evidence |")
    lines.append("| --- | --- | --- | --- |")
    for m in r.modules:
        ev = ", ".join(f"`{e}`" for e in m.evidence) if m.evidence else "—"
        lines.append(
            f"| {m.module} | {_STATUS_BADGE[m.status]} | {m.action} | {ev} |")
    lines.append("")

    # Detailed notes per module.
    noted = [m for m in r.modules if m.notes]
    if noted:
        lines.append("### Notes")
        lines.append("")
        for m in noted:
            for note in m.notes:
                lines.append(f"- **{m.module}**: {note}")
        lines.append("")

    lines.append("## Platform signals")
    lines.append("")
    ps = r.platform_signals
    lines.append(f"- PowerShell scripts: "
                 f"{len(ps['powershell_scripts'])} ("
                 f"{', '.join(ps['powershell_scripts']) or 'none'})")
    lines.append(f"- Bash scripts: {len(ps['bash_scripts'])} "
                 f"({', '.join(ps['bash_scripts']) or 'none'})")
    lines.append(f"- GitHub workflows: {len(ps['github_workflows'])} "
                 f"({', '.join(ps['github_workflows']) or 'none'})")
    lines.append("")
    return "\n".join(lines)
