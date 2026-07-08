"""The applier — provision-new and adopt-existing.

provision:
    Instantiate the brain-template into a NEW/empty destination directory,
    substitute placeholders, strip ``.tmpl``, and write a brain.manifest.json
    with ``onboarding.mode = provision-new``.

adopt:
    Given a target repo plus an inspector summary, copy ONLY the modules whose
    recommended action is ``add`` or ``augment`` into the target. This DEFAULTS
    TO DRY-RUN: it prints the planned writes and changes nothing. Real writes
    require an explicit ``apply=True`` flag, and existing files are never
    overwritten unless ``force=True``. It writes/merges a brain.manifest.json
    with ``onboarding.mode = adopt-existing``, recording adopted vs pre-existing
    modules.
"""

from __future__ import annotations

import json
import shutil
from dataclasses import dataclass, field
from datetime import date
from pathlib import Path
from typing import Any

from . import inspect as inspect_mod
from . import manifest as manifest_mod
from .substitute import copy_tree_substituted, strip_tmpl_suffix, substitute

# Map each core module id to the template paths (relative to brain-template/)
# that materialise it. Used by adopt to copy only the relevant subtrees.
MODULE_TEMPLATE_PATHS: dict[str, tuple[str, ...]] = {
    "operating-contract": (
        "00-governance/OPERATING-CONTRACT.md.tmpl",
        "AGENTS.md.tmpl",
        "CLAUDE.md.tmpl",
        ".github/copilot-instructions.md.tmpl",
    ),
    "session-ritual-hooks": ("03-templates/agent-commands/hooks",),
    "continuity-log": (
        "04-policies/continuity-policy.md.tmpl",
        "05-logs/00-MASTER-SESSION-INDEX.md.tmpl",
    ),
    "capabilities-map": ("01-docs/CAPABILITIES.md.tmpl",),
    "docs-mesh": ("01-docs/diagrams",),
    "decision-board": ("00-governance/consensus/decision-board.md.tmpl",),
    "core-commands": ("03-templates/agent-commands/core",),
}


def _hub_root() -> Path:
    return Path(__file__).resolve().parents[3]


def template_root(hub_root: Path | None = None) -> Path:
    return (Path(hub_root) if hub_root else _hub_root()) / "brain-template"


@dataclass
class PlannedWrite:
    """A single file the applier would write."""

    module: str
    source: str  # relative to brain-template
    dest: str    # relative to destination
    exists: bool

    def to_dict(self) -> dict[str, Any]:
        return {
            "module": self.module,
            "source": self.source,
            "dest": self.dest,
            "exists": self.exists,
        }


@dataclass
class ApplyResult:
    mode: str
    destination: str
    dry_run: bool
    planned: list[PlannedWrite] = field(default_factory=list)
    written: list[str] = field(default_factory=list)
    skipped: list[str] = field(default_factory=list)
    manifest_path: str | None = None
    notes: list[str] = field(default_factory=list)

    def to_dict(self) -> dict[str, Any]:
        return {
            "mode": self.mode,
            "destination": self.destination,
            "dry_run": self.dry_run,
            "planned": [p.to_dict() for p in self.planned],
            "written": self.written,
            "skipped": self.skipped,
            "manifest_path": self.manifest_path,
            "notes": self.notes,
        }


# ---------------------------------------------------------------------------
# provision
# ---------------------------------------------------------------------------

def provision(
    *,
    dest: str | Path,
    project_name: str,
    project_slug: str,
    brain_repo: str,
    command_prefix: str,
    platforms: list[str] | None = None,
    profile: str | None = None,
    summary: str | None = None,
    app_repos: list[dict[str, Any]] | None = None,
    hub_root: Path | None = None,
) -> ApplyResult:
    """Instantiate the brain-template into an empty ``dest`` directory."""
    dest_path = Path(dest).resolve()
    if dest_path.exists() and any(dest_path.iterdir()):
        raise FileExistsError(
            f"provision requires an empty/new destination; {dest_path} is not empty")
    dest_path.mkdir(parents=True, exist_ok=True)

    platforms = platforms or ["bash", "powershell", "python"]
    mapping = {
        "PROJECT_NAME": project_name,
        "PROJECT_SLUG": project_slug,
        "BRAIN_REPO": brain_repo,
        "CMD_PREFIX": command_prefix,
    }

    tmpl = template_root(hub_root)
    # The template's own README and example manifest are documentation *about* the
    # template, not part of a brain instance, so exclude them. brain.manifest.schema.json
    # is kept (copied verbatim) as a validation reference. A real manifest is stamped below.
    written_rel = copy_tree_substituted(
        tmpl, dest_path, mapping,
        exclude=frozenset({"README.md", "brain.manifest.example.json"}),
    )
    man = manifest_mod.build_manifest(
        project_name=project_name,
        project_slug=project_slug,
        brain_repo=brain_repo,
        command_prefix=command_prefix,
        platforms=platforms,
        mode="provision-new",
        profile=profile,
        summary=summary,
        app_repos=app_repos,
        onboarded_at=date.today().isoformat(),
        hub_root=hub_root,
    )
    errors = manifest_mod.validate_manifest(man, hub_root)
    if errors:
        raise ValueError("Built manifest failed validation:\n  - "
                         + "\n  - ".join(errors))
    manifest_path = dest_path / "brain.manifest.json"
    manifest_mod.write_manifest(man, manifest_path)

    result = ApplyResult(
        mode="provision-new",
        destination=str(dest_path),
        dry_run=False,
        written=[str(p) for p in written_rel] + ["brain.manifest.json"],
        manifest_path=str(manifest_path),
    )
    result.notes.append(
        f"Instantiated {len(written_rel)} template files; wrote brain.manifest.json.")
    return result


# ---------------------------------------------------------------------------
# adopt
# ---------------------------------------------------------------------------

def _plan_module_writes(
    module: str, tmpl: Path, target: Path, mapping: dict[str, str],
) -> list[PlannedWrite]:
    """Compute the planned writes for one module's template subtree."""
    planned: list[PlannedWrite] = []
    for rel in MODULE_TEMPLATE_PATHS.get(module, ()):  # noqa: B007
        src = tmpl / rel
        if not src.exists():
            continue
        if src.is_dir():
            for entry in sorted(src.rglob("*")):
                if entry.is_dir():
                    continue
                rel_from_tmpl = entry.relative_to(tmpl)
                dest_rel = _dest_for(rel_from_tmpl)
                planned.append(PlannedWrite(
                    module=module,
                    source=str(rel_from_tmpl).replace("\\", "/"),
                    dest=str(dest_rel).replace("\\", "/"),
                    exists=(target / dest_rel).exists(),
                ))
        else:
            rel_from_tmpl = src.relative_to(tmpl)
            dest_rel = _dest_for(rel_from_tmpl)
            planned.append(PlannedWrite(
                module=module,
                source=str(rel_from_tmpl).replace("\\", "/"),
                dest=str(dest_rel).replace("\\", "/"),
                exists=(target / dest_rel).exists(),
            ))
    return planned


def _dest_for(rel_from_tmpl: Path) -> Path:
    """Destination path for a template file (strip .tmpl on the final name)."""
    return rel_from_tmpl.with_name(strip_tmpl_suffix(rel_from_tmpl.name))


def adopt(
    *,
    target: str | Path,
    summary: dict[str, Any] | inspect_mod.InspectionResult | None = None,
    project_name: str | None = None,
    project_slug: str | None = None,
    brain_repo: str | None = None,
    command_prefix: str | None = None,
    platforms: list[str] | None = None,
    profile: str | None = None,
    apply: bool = False,
    force: bool = False,
    gap_report: str | None = None,
    hub_root: Path | None = None,
) -> ApplyResult:
    """Adopt the brain into an existing repo. Defaults to DRY-RUN.

    Only modules whose inspector action is ``add`` or ``augment`` are copied.
    Modules that are ``keep`` (present) are recorded in the manifest as
    pre-existing (``adopted: false``).
    """
    target_path = Path(target).resolve()
    if not target_path.is_dir():
        raise NotADirectoryError(f"Target repo not found: {target_path}")

    # Obtain an inspection summary: use the provided one, else run the inspector.
    if summary is None:
        result = inspect_mod.inspect_repo(target_path)
        summary_dict = result.to_dict()
    elif isinstance(summary, inspect_mod.InspectionResult):
        summary_dict = summary.to_dict()
    else:
        summary_dict = summary

    by_module: dict[str, dict[str, Any]] = {
        m["module"]: m for m in summary_dict.get("modules", [])
    }

    # Defaults inferred from the target if not supplied.
    slug = project_slug or target_path.name.replace("_", "-")
    name = project_name or target_path.name.replace("_", " ").title()
    repo = brain_repo or f"izakl/{slug}-autonomy-system"
    prefix = command_prefix or _default_prefix(slug)
    plats = platforms or summary_dict.get(
        "platform_signals", {}).get("inferred_platforms", ["python"])

    mapping = {
        "PROJECT_NAME": name,
        "PROJECT_SLUG": slug,
        "BRAIN_REPO": repo,
        "CMD_PREFIX": prefix,
    }

    tmpl = template_root(hub_root)
    planned: list[PlannedWrite] = []
    for module in manifest_mod.CORE_MODULE_IDS:
        finding = by_module.get(module, {})
        action = finding.get("action", "add")
        if action in ("add", "augment"):
            planned.extend(_plan_module_writes(module, tmpl, target_path, mapping))

    result = ApplyResult(
        mode="adopt-existing",
        destination=str(target_path),
        dry_run=not apply,
        planned=planned,
    )

    # Build the manifest reflecting adopted (hub-installed) vs pre-existing.
    core_modules: dict[str, dict[str, Any]] = {}
    for module in manifest_mod.CORE_MODULE_IDS:
        finding = by_module.get(module, {})
        action = finding.get("action", "add")
        # 'keep' => pre-existing, project-owned (adopted=false).
        # 'add'/'augment' => hub-installed by this adopt (adopted=true).
        adopted = action != "keep"
        core_modules[module] = {
            "enabled": True,
            "synced_from": manifest_mod.read_framework_version(hub_root),
            "adopted": adopted,
        }

    man = manifest_mod.build_manifest(
        project_name=name,
        project_slug=slug,
        brain_repo=repo,
        command_prefix=prefix,
        platforms=plats,
        mode="adopt-existing",
        profile=profile,
        core_modules=core_modules,
        onboarded_at=date.today().isoformat(),
        gap_report=gap_report,
        hub_root=hub_root,
    )
    man_errors = manifest_mod.validate_manifest(man, hub_root)
    if man_errors:
        result.notes.append("WARNING: built manifest failed validation: "
                            + "; ".join(man_errors))

    if not apply:
        result.notes.append(
            f"DRY-RUN: {len(planned)} file(s) would be written. "
            "Re-run with --apply to write. No files were modified.")
        result.notes.append(
            "Manifest (mode=adopt-existing) would be written to "
            "brain.manifest.json on apply.")
        # Surface a preview of the manifest's adopted/pre-existing split.
        kept = [m for m, e in core_modules.items() if not e["adopted"]]
        added = [m for m, e in core_modules.items() if e["adopted"]]
        result.notes.append(f"Manifest split — keep (pre-existing): "
                            f"{', '.join(kept) or 'none'}")
        result.notes.append(f"Manifest split — add/augment (hub-owned): "
                            f"{', '.join(added) or 'none'}")
        return result

    # --- real apply ---
    for pw in planned:
        dest_abs = target_path / pw.dest
        src_abs = tmpl / pw.source
        if dest_abs.exists() and not force:
            result.skipped.append(pw.dest)
            continue
        dest_abs.parent.mkdir(parents=True, exist_ok=True)
        if pw.source.endswith(".tmpl"):
            content = src_abs.read_text(encoding="utf-8")
            dest_abs.write_text(substitute(content, mapping), encoding="utf-8")
        else:
            shutil.copyfile(src_abs, dest_abs)
        result.written.append(pw.dest)

    manifest_path = target_path / "brain.manifest.json"
    if manifest_path.exists() and not force:
        result.notes.append(
            "brain.manifest.json already exists; left untouched (use --force to "
            "overwrite). New manifest NOT written.")
    else:
        manifest_mod.write_manifest(man, manifest_path)
        result.manifest_path = str(manifest_path)
        result.written.append("brain.manifest.json")

    result.notes.append(
        f"Applied: {len(result.written)} written, {len(result.skipped)} skipped "
        "(existing, not forced).")
    return result


def _default_prefix(slug: str) -> str:
    """Derive a short command prefix from a slug (best-effort)."""
    letters = [c for c in slug if c.isalnum()]
    if not letters:
        return "br"
    # Use the first two alphanumerics, ensuring it starts with a letter.
    cand = "".join(letters[:2]).lower()
    if not cand[0].isalpha():
        cand = "b" + cand[0]
    return cand[:8]


def render_apply_text(result: ApplyResult) -> str:
    """Render a human-readable apply/adopt plan or report."""
    lines: list[str] = []
    header = "DRY-RUN PLAN" if result.dry_run else "APPLY REPORT"
    lines.append(f"=== {header}: {result.mode} -> {result.destination} ===")
    lines.append("")
    if result.planned:
        lines.append("Planned writes:")
        for pw in result.planned:
            flag = " (exists, would skip unless --force)" if pw.exists else ""
            lines.append(f"  [{pw.module}] {pw.dest}{flag}")
        lines.append("")
    if result.written:
        lines.append("Written:")
        for w in result.written:
            lines.append(f"  + {w}")
        lines.append("")
    if result.skipped:
        lines.append("Skipped (already present):")
        for s in result.skipped:
            lines.append(f"  = {s}")
        lines.append("")
    for note in result.notes:
        lines.append(note)
    return "\n".join(lines)
