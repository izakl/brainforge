#!/usr/bin/env python3
"""SessionStart / SessionEnd continuity hook for a framework brain.

Cross-platform (Python) so it runs identically on Linux, macOS, and Windows.
Generalized from the donor autonomy system's context hook.

Guarded: it only emits inside a brain (a directory tree containing a
``brain.manifest.json`` at or above the current working directory). It is silent
elsewhere, so it is safe to install globally.

Modes (selected by the first CLI arg, defaulting to ``SessionStart``):

- ``SessionStart``  -> print the open-ritual reminder + brain context.
- ``SessionEnd``    -> print the close-ritual reminder (the mechanical safety-net
                       sync is a separate ops task; this only reminds).
- ``PreCompact``    -> remind to flush continuity before compaction.

The hook prints to stdout; Claude Code injects that as additional context.
"""
from __future__ import annotations

import json
import os
import sys
from pathlib import Path


def find_brain_root(start: Path) -> Path | None:
    """Walk up from ``start`` looking for a brain.manifest.json."""
    for d in [start, *start.parents]:
        if (d / "brain.manifest.json").is_file():
            return d
    return None


def load_manifest(root: Path) -> dict:
    try:
        return json.loads((root / "brain.manifest.json").read_text(encoding="utf-8"))
    except Exception:
        return {}


def latest_log(root: Path) -> str | None:
    logs = root / "05-logs"
    if not logs.is_dir():
        return None
    entries = sorted(
        (p for p in logs.glob("*.md") if not p.name.startswith("00-")),
        key=lambda p: p.name,
    )
    return entries[-1].name if entries else None


def emit_start(root: Path, manifest: dict) -> None:
    name = manifest.get("project", {}).get("name", root.name)
    fw = manifest.get("framework_version", "unknown")
    last = latest_log(root) or "(no prior session log)"
    print(f"[{name} brain] framework_version={fw}")
    print("Open ritual:")
    print("  1. Read 00-governance/OPERATING-CONTRACT.md + the latest 05-logs entry.")
    print(f"     Latest continuity entry: {last}")
    print("  2. git fetch --prune; check open issues/PRs/active-agents for overlap.")
    print("  3. Set model + effort to fit the activity.")
    print("  4. State the objective; claim the issue (assign + push branch early).")
    print("Core rules: GitHub Flow, one branch per issue, push after every commit,")
    print("            secrets/live-config never staged, GitHub is the durable sync.")


def emit_end(root: Path, manifest: dict) -> None:
    name = manifest.get("project", {}).get("name", root.name)
    print(f"[{name} brain] Close ritual:")
    print("  1. Append a continuity entry to 05-logs/<date>-<topic>.md (what, why, evidence).")
    print("  2. Update the decision board if any decision changed.")
    print("  3. Run the anti-drift sweep: regenerate CAPABILITIES.md + validate docs mesh.")
    print("  4. Update board/issue/PR state; push everything (the durable sync).")
    print("A SessionEnd ops task performs the mechanical sync as a safety net.")


def emit_precompact(root: Path, manifest: dict) -> None:
    prefix = manifest.get("command_prefix", "<prefix>")
    print(f"[brain] Flush continuity before compaction: run {prefix}-sync so the 05-logs")
    print("        entry and capabilities map reflect this session before context is lost.")


def main() -> int:
    mode = sys.argv[1] if len(sys.argv) > 1 else "SessionStart"
    root = find_brain_root(Path(os.getcwd()).resolve())
    if root is None:
        return 0  # not in a brain; stay silent
    manifest = load_manifest(root)
    if mode == "SessionEnd":
        emit_end(root, manifest)
    elif mode == "PreCompact":
        emit_precompact(root, manifest)
    else:
        emit_start(root, manifest)
    return 0


if __name__ == "__main__":
    sys.exit(main())
