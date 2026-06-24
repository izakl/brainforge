"""Placeholder substitution and brain-template instantiation.

Templates use ``{{KEY}}`` tokens. The supported keys are the four the
brain-template documents: PROJECT_NAME, PROJECT_SLUG, BRAIN_REPO, CMD_PREFIX.

Only files whose name ends in ``.tmpl`` are substituted; the trailing ``.tmpl``
is stripped so ``OPERATING-CONTRACT.md.tmpl`` lands as ``OPERATING-CONTRACT.md``.
Every other file is copied verbatim. This keeps generic, non-personalized assets
(for example ``brain.manifest.schema.json``, whose description text legitimately
contains a literal ``{{CMD_PREFIX}}``) intact in a provisioned brain.
"""

from __future__ import annotations

import re
import shutil
from pathlib import Path

# Keys callers may supply. Anything else is rejected so typos surface early.
ALLOWED_KEYS: frozenset[str] = frozenset(
    {"PROJECT_NAME", "PROJECT_SLUG", "BRAIN_REPO", "CMD_PREFIX"}
)

_TOKEN_RE = re.compile(r"\{\{([A-Z_][A-Z0-9_]*)\}\}")


def substitute(text: str, mapping: dict[str, str]) -> str:
    """Replace ``{{KEY}}`` tokens in ``text`` using ``mapping``.

    Unknown tokens are left untouched (they may be legitimate literal braces in
    a template body). All keys in ``mapping`` must be in :data:`ALLOWED_KEYS`.
    """
    bad = set(mapping) - ALLOWED_KEYS
    if bad:
        raise ValueError(f"Unknown substitution keys: {sorted(bad)}")

    def _replace(match: re.Match[str]) -> str:
        key = match.group(1)
        return mapping.get(key, match.group(0))

    return _TOKEN_RE.sub(_replace, text)


def find_unsubstituted(text: str) -> set[str]:
    """Return the set of ``{{KEY}}`` tokens still present in ``text``."""
    return set(_TOKEN_RE.findall(text))


def strip_tmpl_suffix(name: str) -> str:
    """Strip a single trailing ``.tmpl`` from a filename."""
    return name[:-5] if name.endswith(".tmpl") else name


# Files that are almost certainly binary; copied verbatim without substitution.
_BINARY_SUFFIXES = frozenset(
    {".png", ".jpg", ".jpeg", ".gif", ".ico", ".pdf", ".zip", ".gz", ".woff",
     ".woff2", ".ttf", ".eot", ".webp"}
)


def _is_probably_binary(path: Path) -> bool:
    if path.suffix.lower() in _BINARY_SUFFIXES:
        return True
    try:
        chunk = path.read_bytes()[:4096]
    except OSError:
        return True
    return b"\x00" in chunk


def copy_tree_substituted(
    src: Path,
    dest: Path,
    mapping: dict[str, str],
    *,
    overwrite: bool = False,
    exclude: frozenset[str] = frozenset(),
) -> list[Path]:
    """Copy the template tree ``src`` to ``dest``.

    For every file:
      - ``.tmpl`` files have their contents passed through :func:`substitute`
        and the trailing ``.tmpl`` is stripped from the destination filename;
      - every other file (text or binary) is copied verbatim.

    ``exclude`` is a set of POSIX-style relative paths (relative to ``src``) to
    skip entirely — used to keep template meta-files (the template's own
    ``README.md``, the example manifest) out of a provisioned brain.

    ``.gitkeep`` files and empty directories are preserved so the tree shape is
    faithful. Returns the list of destination files written, relative to
    ``dest``.
    """
    src = Path(src)
    dest = Path(dest)
    if not src.is_dir():
        raise NotADirectoryError(f"Template source not found: {src}")

    written: list[Path] = []
    for entry in sorted(src.rglob("*")):
        rel = entry.relative_to(src)
        if entry.is_dir():
            (dest / rel).mkdir(parents=True, exist_ok=True)
            continue

        if rel.as_posix() in exclude:
            continue

        # Strip .tmpl from the final path component only.
        is_tmpl = entry.name.endswith(".tmpl")
        rel_out = rel.with_name(strip_tmpl_suffix(rel.name))
        out_path = dest / rel_out
        out_path.parent.mkdir(parents=True, exist_ok=True)

        if out_path.exists() and not overwrite:
            raise FileExistsError(f"Refusing to overwrite existing file: {out_path}")

        if is_tmpl and not _is_probably_binary(entry):
            content = entry.read_text(encoding="utf-8")
            out_path.write_text(substitute(content, mapping), encoding="utf-8")
        else:
            # Non-template file: copy verbatim (no substitution).
            shutil.copyfile(entry, out_path)
        written.append(rel_out)

    return written
