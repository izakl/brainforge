"""Down-sync execution — apply approved framework upgrades to a brain.

Implements the propagation contract (``brain-factory/registry/propagation.md``):
reconcile a brain's **enabled, hub-adopted** core modules to the hub's current
``brain-template``, bump the manifest ``framework_version`` and each refreshed
module's ``synced_from``, and **never** touch project extensions. Pre-existing
(``adopted: false``) modules are surfaced for manual review rather than
overwritten; disabled modules are skipped.

The hub keeps a single ``brain-template`` representing the *latest* core, so an
upgrade reconciles a brain forward to that template. Re-running with no version
gap is a no-op (idempotent); ``force`` re-materialises even at the latest
version to repair local drift in the hub-owned core layer.

DEFAULTS TO DRY-RUN — pass ``apply=True`` to write. Standard library only.
"""

from __future__ import annotations

import json
from dataclasses import dataclass, field
from datetime import date
from pathlib import Path
from typing import Any

from . import manifest as manifest_mod
from .apply import PlannedWrite, _plan_module_writes, template_root
from .substitute import substitute


@dataclass
class UpgradeResult:
    brain: str
    current_version: str
    latest_version: str
    up_to_date: bool
    dry_run: bool
    planned: list[PlannedWrite] = field(default_factory=list)
    written: list[str] = field(default_factory=list)
    synced_modules: list[str] = field(default_factory=list)
    manual_review: list[str] = field(default_factory=list)
    disabled: list[str] = field(default_factory=list)
    conflicts: list[str] = field(default_factory=list)
    manifest_path: str | None = None
    log_path: str | None = None
    notes: list[str] = field(default_factory=list)

    def to_dict(self) -> dict[str, Any]:
        return {
            "brain": self.brain,
            "current_version": self.current_version,
            "latest_version": self.latest_version,
            "up_to_date": self.up_to_date,
            "dry_run": self.dry_run,
            "planned": [p.to_dict() for p in self.planned],
            "written": self.written,
            "synced_modules": self.synced_modules,
            "manual_review": self.manual_review,
            "disabled": self.disabled,
            "conflicts": self.conflicts,
            "manifest_path": self.manifest_path,
            "log_path": self.log_path,
            "notes": self.notes,
        }


def _read_manifest(brain_path: Path) -> dict[str, Any]:
    mpath = brain_path / "brain.manifest.json"
    if not mpath.is_file():
        raise FileNotFoundError(
            f"no brain.manifest.json in {brain_path} — not a brain "
            "(run provision/adopt first)")
    return json.loads(mpath.read_text(encoding="utf-8"))


def _mapping_from_manifest(man: dict[str, Any]) -> dict[str, str]:
    """The placeholder map the brain was instantiated with, read back."""
    project = man.get("project", {})
    return {
        "PROJECT_NAME": project.get("name", ""),
        "PROJECT_SLUG": project.get("slug", ""),
        "BRAIN_REPO": project.get("brain_repo", ""),
        "CMD_PREFIX": man.get("command_prefix", ""),
    }


def _is_extension_path(dest: str) -> bool:
    """True if a planned write would land under a project extension path."""
    return "extensions" in dest.replace("\\", "/").split("/")


def upgrade(
    *,
    brain: str | Path,
    apply: bool = False,
    force: bool = False,
    hub_root: Path | None = None,
) -> UpgradeResult:
    """Reconcile a brain's core modules to the hub's current framework version.

    DRY-RUN by default. With ``apply=True`` writes refreshed core files, bumps
    the manifest (``framework_version`` + each refreshed module's
    ``synced_from``), and records a continuity log entry under ``05-logs/``.
    ``force`` re-materialises even when already at the latest version.
    """
    brain_path = Path(brain).resolve()
    man = _read_manifest(brain_path)
    current = str(man.get("framework_version", ""))
    latest = manifest_mod.read_framework_version(hub_root)
    mapping = _mapping_from_manifest(man)

    result = UpgradeResult(
        brain=str(brain_path),
        current_version=current,
        latest_version=latest,
        up_to_date=(current == latest),
        dry_run=not apply,
    )

    core_modules: dict[str, dict[str, Any]] = dict(man.get("core_modules", {}))

    # Classify each known core module by its manifest disposition.
    stage: list[str] = []
    for module in manifest_mod.CORE_MODULE_IDS:
        entry = core_modules.get(module, {})
        if not entry.get("enabled", True):
            result.disabled.append(module)
        elif not entry.get("adopted", True):
            # Pre-existing, project-owned artifact kept during inspect-first
            # onboarding — surface for manual review, never overwrite.
            result.manual_review.append(module)
        else:
            stage.append(module)

    # Up to date and not forced: idempotent no-op (contract step 1).
    if current == latest and not force:
        result.notes.append(
            f"Up to date: brain is already at framework_version {latest}. "
            "Nothing to upgrade.")
        _append_disposition_notes(result)
        return result

    tmpl = template_root(hub_root)
    for module in stage:
        for pw in _plan_module_writes(module, tmpl, brain_path, mapping):
            if _is_extension_path(pw.dest):
                result.conflicts.append(pw.dest)
            else:
                result.planned.append(pw)

    if not apply:
        modules = len({p.module for p in result.planned})
        result.notes.append(
            f"DRY-RUN: would upgrade {current or '?'} -> {latest}, refreshing "
            f"{len(result.planned)} core file(s) across {modules} module(s). "
            "Re-run with --apply to write. No files were modified.")
        _append_disposition_notes(result)
        return result

    # --- real apply: refresh the hub-owned core, then bump the manifest ---
    written_modules: set[str] = set()
    for pw in result.planned:
        dest_abs = brain_path / pw.dest
        src_abs = tmpl / pw.source
        dest_abs.parent.mkdir(parents=True, exist_ok=True)
        content = src_abs.read_text(encoding="utf-8")
        if pw.source.endswith(".tmpl"):
            content = substitute(content, mapping)
        dest_abs.write_text(content, encoding="utf-8")
        result.written.append(pw.dest)
        written_modules.add(pw.module)

    for module in sorted(written_modules):
        entry = dict(core_modules.get(module, {}))
        entry["synced_from"] = latest
        entry.setdefault("enabled", True)
        entry.setdefault("adopted", True)
        core_modules[module] = entry
        result.synced_modules.append(module)
    man["core_modules"] = core_modules
    man["framework_version"] = latest

    errors = manifest_mod.validate_manifest(man, hub_root)
    if errors:
        raise ValueError(
            "Upgraded manifest failed validation:\n  - " + "\n  - ".join(errors))
    manifest_path = brain_path / "brain.manifest.json"
    manifest_mod.write_manifest(man, manifest_path)
    result.manifest_path = str(manifest_path)

    result.log_path = _write_log(brain_path, current, latest, result)
    result.notes.append(
        f"Applied: upgraded {current or '?'} -> {latest}; refreshed "
        f"{len(result.written)} file(s) across {len(written_modules)} "
        "module(s); bumped framework_version and synced_from. Open the change "
        "as a PR in the brain repo (the PR is the control gate).")
    _append_disposition_notes(result)
    return result


def _append_disposition_notes(result: UpgradeResult) -> None:
    if result.manual_review:
        result.notes.append(
            "Manual review (pre-existing, not hub-synced): "
            + ", ".join(result.manual_review))
    if result.disabled:
        result.notes.append("Disabled (skipped): " + ", ".join(result.disabled))
    if result.conflicts:
        result.notes.append(
            "CONFLICT: planned core writes collide with extension paths "
            "(surfaced, not written): " + ", ".join(result.conflicts))


def _write_log(
    brain_path: Path, current: str, latest: str, result: UpgradeResult
) -> str:
    """Append a continuity record of the upgrade under ``05-logs/upgrades/``."""
    log_dir = brain_path / "05-logs" / "upgrades"
    log_dir.mkdir(parents=True, exist_ok=True)
    stamp = date.today().isoformat()
    log_file = log_dir / f"{stamp}-upgrade-{current or 'init'}-to-{latest}.md"
    lines = [
        f"# Down-sync upgrade: {current or '?'} -> {latest}",
        "",
        f"- Date: {stamp}",
        f"- Files refreshed: {len(result.written)}",
        f"- Modules synced: {', '.join(result.synced_modules) or 'none'}",
        f"- Manual review: {', '.join(result.manual_review) or 'none'}",
        f"- Disabled (skipped): {', '.join(result.disabled) or 'none'}",
        "",
        "## Refreshed files",
        "",
    ]
    lines += [f"- `{w}`" for w in result.written] or ["- (none)"]
    lines += [
        "",
        "Core layer reconciled to the hub framework template; project "
        "extensions were not touched.",
        "",
    ]
    log_file.write_text("\n".join(lines), encoding="utf-8")
    return str(log_file.relative_to(brain_path)).replace("\\", "/")


def render_upgrade_text(result: UpgradeResult) -> str:
    """Render a human-readable upgrade plan or report."""
    lines: list[str] = []
    header = "DRY-RUN PLAN" if result.dry_run else "UPGRADE REPORT"
    lines.append(f"=== {header}: down-sync -> {result.brain} ===")
    lines.append("")
    lines.append(
        f"current: {result.current_version or '?'}   "
        f"latest: {result.latest_version}")
    lines.append("")
    if result.planned:
        lines.append("Planned core refresh:")
        for pw in result.planned:
            flag = "" if pw.exists else " (new)"
            lines.append(f"  [{pw.module}] {pw.dest}{flag}")
        lines.append("")
    if result.written:
        lines.append("Refreshed:")
        for w in result.written:
            lines.append(f"  ~ {w}")
        lines.append("")
    if result.manual_review:
        lines.append("Manual review (pre-existing, not overwritten):")
        for m in result.manual_review:
            lines.append(f"  ! {m}")
        lines.append("")
    if result.conflicts:
        lines.append("Conflicts (extension collision, not written):")
        for c in result.conflicts:
            lines.append(f"  x {c}")
        lines.append("")
    if result.log_path:
        lines.append(f"Log: {result.log_path}")
        lines.append("")
    for note in result.notes:
        lines.append(note)
    return "\n".join(lines)
