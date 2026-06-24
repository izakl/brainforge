"""Build and validate a ``brain.manifest.json``.

The manifest is the boundary between hub-owned core and project-owned
extensions. This module builds the dict from onboarding inputs and validates it
against ``brain-factory/brain-template/brain.manifest.schema.json``.

Validation uses ``jsonschema`` when importable; otherwise it falls back to a
lightweight structural check of the required keys and the most load-bearing
constraints (enough to catch a malformed manifest in a standard-library-only
environment).
"""

from __future__ import annotations

import json
import re
from pathlib import Path
from typing import Any

MANIFEST_VERSION = "1.0.0"

# Module ids the framework knows about (mirrors registry/framework-version.json).
CORE_MODULE_IDS: tuple[str, ...] = (
    "operating-contract",
    "session-ritual-hooks",
    "continuity-log",
    "capabilities-map",
    "docs-mesh",
    "decision-board",
    "core-commands",
)

VALID_PLATFORMS = frozenset({"bash", "powershell", "python"})
VALID_PROFILES = frozenset(
    {"small-repo", "product-team", "platform-team", "support-heavy", "governance-heavy"}
)
VALID_MODES = frozenset({"provision-new", "adopt-existing"})
VALID_AGENT_RUNTIMES = frozenset({"none", "claude", "copilot", "codex", "aider"})

_SEMVER_RE = re.compile(r"^\d+\.\d+\.\d+$")
_SLUG_RE = re.compile(r"^[a-z0-9][a-z0-9_-]*$")
_PREFIX_RE = re.compile(r"^[a-z][a-z0-9]{1,7}$")


def _hub_root_from_here() -> Path:
    """Locate the brain-factory root relative to this file.

    .../brain-factory/adapters/python/brainfactory/manifest.py
    -> .../brain-factory
    """
    return Path(__file__).resolve().parents[3]


def read_framework_version(hub_root: Path | None = None) -> str:
    """Read the current framework version from the hub registry."""
    root = Path(hub_root) if hub_root else _hub_root_from_here()
    reg = root / "registry" / "framework-version.json"
    data = json.loads(reg.read_text(encoding="utf-8"))
    return data["framework_version"]


def schema_path(hub_root: Path | None = None) -> Path:
    """Path to the manifest schema inside the brain-template."""
    root = Path(hub_root) if hub_root else _hub_root_from_here()
    return root / "brain-template" / "brain.manifest.schema.json"


def build_manifest(
    *,
    project_name: str,
    project_slug: str,
    brain_repo: str,
    command_prefix: str,
    platforms: list[str],
    agent_runtimes: list[str] | None = None,
    mode: str,
    profile: str | None = None,
    framework_version: str | None = None,
    core_modules: dict[str, dict[str, Any]] | None = None,
    app_repos: list[dict[str, Any]] | None = None,
    summary: str | None = None,
    onboarded_at: str | None = None,
    gap_report: str | None = None,
    hub_root: Path | None = None,
) -> dict[str, Any]:
    """Assemble a brain.manifest.json dict from onboarding inputs.

    ``core_modules`` may be a partial map; any unspecified core module defaults
    to enabled+adopted-by-hub. Each entry is normalised to the schema shape
    (``enabled`` / ``synced_from`` / ``adopted``).
    """
    if mode not in VALID_MODES:
        raise ValueError(f"mode must be one of {sorted(VALID_MODES)}, got {mode!r}")

    fw = framework_version or read_framework_version(hub_root)

    modules: dict[str, dict[str, Any]] = {}
    supplied = core_modules or {}
    # adopt-existing defaults modules to hub-installed unless overridden; the
    # inspector decides per-module whether something is pre-existing (kept).
    for module_id in CORE_MODULE_IDS:
        entry = dict(supplied.get(module_id, {}))
        entry.setdefault("enabled", True)
        entry.setdefault("synced_from", fw)
        entry.setdefault("adopted", True)
        modules[module_id] = entry
    # Carry through any non-core ids the caller deliberately supplied.
    for module_id, entry in supplied.items():
        if module_id not in modules:
            norm = dict(entry)
            norm.setdefault("enabled", True)
            modules[module_id] = norm

    manifest: dict[str, Any] = {
        "manifest_version": MANIFEST_VERSION,
        "project": {
            "name": project_name,
            "slug": project_slug,
            "brain_repo": brain_repo,
        },
        "framework_version": fw,
        "command_prefix": command_prefix,
        "platforms": list(platforms),
        "agent_runtimes": list(agent_runtimes) if agent_runtimes else ["none"],
        "core_modules": modules,
    }
    if summary:
        manifest["project"]["summary"] = summary
    if profile:
        manifest["profile"] = profile
    if app_repos:
        manifest["app_repos"] = app_repos

    onboarding: dict[str, Any] = {"mode": mode}
    if onboarded_at:
        onboarding["onboarded_at"] = onboarded_at
    if gap_report:
        onboarding["gap_report"] = gap_report
    manifest["onboarding"] = onboarding

    return manifest


def validate_manifest(
    manifest: dict[str, Any], hub_root: Path | None = None
) -> list[str]:
    """Validate ``manifest`` against the schema.

    Returns a list of human-readable error strings; empty means valid. Uses
    ``jsonschema`` if importable, otherwise a structural fallback.
    """
    try:
        import jsonschema  # type: ignore
    except ImportError:
        return _structural_validate(manifest)

    schema = json.loads(schema_path(hub_root).read_text(encoding="utf-8"))
    validator = jsonschema.Draft202012Validator(schema)
    errors = sorted(validator.iter_errors(manifest), key=lambda e: list(e.path))
    return [
        f"{'/'.join(str(p) for p in err.path) or '<root>'}: {err.message}"
        for err in errors
    ]


def _structural_validate(manifest: dict[str, Any]) -> list[str]:
    """Standard-library-only structural validation of the load-bearing rules."""
    errors: list[str] = []

    def require(cond: bool, msg: str) -> None:
        if not cond:
            errors.append(msg)

    require(isinstance(manifest, dict), "manifest must be an object")
    if not isinstance(manifest, dict):
        return errors

    for key in ("manifest_version", "project", "framework_version",
                "command_prefix", "platforms", "core_modules"):
        require(key in manifest, f"missing required key: {key}")

    mv = manifest.get("manifest_version")
    require(isinstance(mv, str) and bool(_SEMVER_RE.match(mv)),
            "manifest_version must be a semver string")

    fw = manifest.get("framework_version")
    require(isinstance(fw, str) and bool(_SEMVER_RE.match(fw)),
            "framework_version must be a semver string")

    prefix = manifest.get("command_prefix")
    require(isinstance(prefix, str) and bool(_PREFIX_RE.match(prefix)),
            "command_prefix must match ^[a-z][a-z0-9]{1,7}$")

    project = manifest.get("project")
    if isinstance(project, dict):
        require("name" in project, "project.name is required")
        require("brain_repo" in project, "project.brain_repo is required")
        slug = project.get("slug")
        if slug is not None:
            require(isinstance(slug, str) and bool(_SLUG_RE.match(slug)),
                    "project.slug must match ^[a-z0-9][a-z0-9_-]*$")
    else:
        errors.append("project must be an object")

    platforms = manifest.get("platforms")
    if isinstance(platforms, list):
        require(len(platforms) >= 1, "platforms must have at least one entry")
        for p in platforms:
            require(p in VALID_PLATFORMS, f"invalid platform: {p!r}")
    else:
        errors.append("platforms must be an array")

    runtimes = manifest.get("agent_runtimes")
    if runtimes is not None:
        if isinstance(runtimes, list):
            require(len(runtimes) >= 1, "agent_runtimes must have at least one entry")
            for r in runtimes:
                require(r in VALID_AGENT_RUNTIMES, f"invalid agent_runtime: {r!r}")
        else:
            errors.append("agent_runtimes must be an array")

    modules = manifest.get("core_modules")
    if isinstance(modules, dict):
        for mid, entry in modules.items():
            if not isinstance(entry, dict):
                errors.append(f"core_modules.{mid} must be an object")
                continue
            require("enabled" in entry, f"core_modules.{mid}.enabled is required")
            require(isinstance(entry.get("enabled"), bool),
                    f"core_modules.{mid}.enabled must be a boolean")
    else:
        errors.append("core_modules must be an object")

    profile = manifest.get("profile")
    if profile is not None:
        require(profile in VALID_PROFILES, f"invalid profile: {profile!r}")

    onboarding = manifest.get("onboarding")
    if isinstance(onboarding, dict):
        mode = onboarding.get("mode")
        if mode is not None:
            require(mode in VALID_MODES, f"invalid onboarding.mode: {mode!r}")

    return errors


def write_manifest(manifest: dict[str, Any], path: Path) -> None:
    """Write a manifest to ``path`` as pretty JSON with a trailing newline."""
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
