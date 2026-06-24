#!/usr/bin/env bash
set -euo pipefail

# apply-setup.sh — Apply a framework setup intent and emit a concise operator summary.
#
# Usage: bash scripts/apply-setup.sh [--intent <file>] [--output <file>] [--dry-run]
#
#   --intent <file>   Setup intent JSON to read. Defaults to the canonical path
#                     .github/framework-setup-intent.json.
#   --output <file>   Write the summary to a file instead of stdout.
#   --dry-run         Validate and preview without writing the canonical intent file.
#
# What this script does:
#   1. Validates the intent JSON against the setup schema
#      (docs/framework-setup-intent-schema-and-application-model.md).
#   2. Resolves profile defaults when preferences.setup_profile is set.
#   3. Writes the intent to the canonical path (.github/framework-setup-intent.json)
#      unless --dry-run is specified or the intent is already at the canonical path.
#   4. Outputs a concise setup application summary for the operator.
#
# See docs/runbooks/apply-setup.md for the full runbook.

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
canonical_intent="${repo_root}/.github/framework-setup-intent.json"

intent_file=""
output_file=""
dry_run="false"

usage() {
    echo "Usage: $0 [--intent <file>] [--output <file>] [--dry-run]"
    echo ""
    echo "  --intent <file>   Setup intent JSON (default: .github/framework-setup-intent.json)"
    echo "  --output <file>   Write summary to file instead of stdout"
    echo "  --dry-run         Validate and preview without writing the canonical intent file"
    echo ""
    echo "See docs/runbooks/apply-setup.md for the full setup runbook."
    exit 1
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --intent)
            intent_file="${2:-}"
            shift 2
            ;;
        --output)
            output_file="${2:-}"
            shift 2
            ;;
        --dry-run)
            dry_run="true"
            shift
            ;;
        -h | --help)
            usage
            ;;
        *)
            echo "Unknown argument: $1"
            usage
            ;;
    esac
done

if [[ -z "$intent_file" ]]; then
    intent_file="$canonical_intent"
fi

python3 - "$intent_file" "$canonical_intent" "$repo_root" "$output_file" "$dry_run" <<'PY'
import json
import sys
import os
from pathlib import Path
from datetime import datetime, timezone

intent_path = Path(sys.argv[1])
canonical_path = Path(sys.argv[2])
repo_root = Path(sys.argv[3])
output_file = sys.argv[4]
dry_run = sys.argv[5].lower() == "true"

# ── Profile defaults catalog ───────────────────────────────────────────────────
# Source: docs/framework-setup-profiles-and-intent-examples.md

PROFILE_DEFAULTS = {
    "solo_prototype": {
        "automation_bundle": "A",
        "automation_stage": "minimum",
        "deployment_model": "local_only",
        "evidence_level": "lightweight",
        "security_posture": "standard",
        "projects_enabled": False,
        "mobile_surface": False,
        "team_primary_profile": "small_repo_solo",
        "repo_shape": "small_repo",
    },
    "solo_production_app": {
        "automation_bundle": "A",
        "automation_stage": "recommended",
        "deployment_model": "cloud_hosted",
        "evidence_level": "standard",
        "security_posture": "elevated",
        "projects_enabled": False,
        "mobile_surface": False,
        "team_primary_profile": "small_repo_solo",
        "repo_shape": "product_delivery",
    },
    "small_saas_team": {
        "automation_bundle": "B",
        "automation_stage": "recommended",
        "deployment_model": "cloud_hosted",
        "evidence_level": "standard",
        "security_posture": "standard",
        "projects_enabled": True,
        "mobile_surface": True,
        "team_primary_profile": "product_delivery_team",
        "repo_shape": "product_delivery",
    },
    "internal_platform_service_team": {
        "automation_bundle": "C",
        "automation_stage": "recommended",
        "deployment_model": "platform_shared",
        "evidence_level": "strict",
        "security_posture": "elevated",
        "projects_enabled": True,
        "mobile_surface": False,
        "team_primary_profile": "platform_infra_team",
        "repo_shape": "platform_infra",
    },
    "regulated_high_governance_service": {
        "automation_bundle": "E",
        "automation_stage": "recommended",
        "deployment_model": "regulated",
        "evidence_level": "strict",
        "security_posture": "compliance_strict",
        "projects_enabled": True,
        "mobile_surface": True,
        "team_primary_profile": "governance_compliance_overlay",
        "repo_shape": "governance_heavy",
    },
}

# ── Valid enum values (from setup intent schema v1) ───────────────────────────
VALID_SETUP_MODES = {"new_adoption", "existing_repo_upgrade"}
VALID_REPO_SHAPES = {
    "small_repo", "product_delivery", "platform_infra",
    "support_heavy", "governance_heavy",
}
VALID_TEAM_PROFILES = {
    "small_repo_solo", "product_delivery_team", "platform_infra_team",
    "support_intake_team", "governance_compliance_overlay",
}
VALID_DEPLOYMENT_MODELS = {
    "local_only", "cloud_hosted", "hybrid", "platform_shared", "regulated",
}
VALID_EVIDENCE_LEVELS = {"lightweight", "standard", "strict"}
VALID_BUNDLES = {"A", "B", "C", "D", "E", "custom"}
VALID_STAGES = {"minimum", "recommended", "deferred"}
VALID_SECURITY_POSTURES = {"standard", "elevated", "compliance_strict"}
VALID_EXECUTION_SURFACES = {
    "vscode_local", "github_cloud_agent", "gh_cli",
    "github_mobile", "external_ai",
}

# ── Load intent ────────────────────────────────────────────────────────────────
if not intent_path.exists():
    raise SystemExit(
        f"Setup intent file not found: {intent_path}\n"
        "Provide a path with --intent or create .github/framework-setup-intent.json.\n"
        "See docs/runbooks/apply-setup.md for the full runbook."
    )

try:
    with intent_path.open("r", encoding="utf-8") as f:
        intent = json.load(f)
except json.JSONDecodeError as exc:
    raise SystemExit(f"Failed to parse setup intent JSON: {exc}") from exc

if not isinstance(intent, dict):
    raise SystemExit("Setup intent must be a JSON object.")

# ── Schema validation ──────────────────────────────────────────────────────────
errors = []

def require_field(obj, key, context):
    val = obj.get(key) if isinstance(obj, dict) else None
    if val is None:
        errors.append(f"{context}: required field '{key}' is missing.")
    return val

def require_enum(val, valid_set, field, context):
    if val is not None and val not in valid_set:
        errors.append(
            f"{context}: '{field}' value '{val}' is not valid. "
            f"Expected one of: {', '.join(sorted(valid_set))}."
        )

def require_non_empty_array(obj, key, context):
    val = obj.get(key) if isinstance(obj, dict) else None
    if not isinstance(val, list) or len(val) == 0:
        errors.append(f"{context}: '{key}' must be a non-empty array.")
    return val if isinstance(val, list) else []

schema_version = require_field(intent, "schema_version", "root")
setup_id = require_field(intent, "setup_id", "root")
setup_mode = require_field(intent, "setup_mode", "root")
require_enum(setup_mode, VALID_SETUP_MODES, "setup_mode", "root")

project = intent.get("project")
if not isinstance(project, dict):
    errors.append("root: 'project' must be an object.")
    project = {}

project_name = require_field(project, "name", "project")
project_work_types = require_non_empty_array(project, "primary_work_types", "project")
project_repo_shape = require_field(project, "repo_shape", "project")
require_enum(project_repo_shape, VALID_REPO_SHAPES, "repo_shape", "project")

team = intent.get("team")
if not isinstance(team, dict):
    errors.append("root: 'team' must be an object.")
    team = {}

team_profile = require_field(team, "primary_profile", "team")
require_enum(team_profile, VALID_TEAM_PROFILES, "primary_profile", "team")
team_owners = require_non_empty_array(team, "owners", "team")

deployment = intent.get("deployment")
if not isinstance(deployment, dict):
    errors.append("root: 'deployment' must be an object.")
    deployment = {}

deployment_model = require_field(deployment, "model", "deployment")
require_enum(deployment_model, VALID_DEPLOYMENT_MODELS, "model", "deployment")

governance = intent.get("governance")
if not isinstance(governance, dict):
    errors.append("root: 'governance' must be an object.")
    governance = {}

evidence_level = require_field(governance, "evidence_level", "governance")
require_enum(evidence_level, VALID_EVIDENCE_LEVELS, "evidence_level", "governance")

automation = intent.get("automation")
if not isinstance(automation, dict):
    errors.append("root: 'automation' must be an object.")
    automation = {}

auto_bundle = require_field(automation, "bundle", "automation")
require_enum(auto_bundle, VALID_BUNDLES, "bundle", "automation")
auto_stage = require_field(automation, "stage", "automation")
require_enum(auto_stage, VALID_STAGES, "stage", "automation")

exec_surfaces = require_non_empty_array(intent, "execution_surfaces", "root")
for surface in exec_surfaces:
    if surface not in VALID_EXECUTION_SURFACES:
        errors.append(
            f"root: execution_surfaces contains unknown value '{surface}'. "
            f"Expected values: {', '.join(sorted(VALID_EXECUTION_SURFACES))}."
        )

security = intent.get("security")
if not isinstance(security, dict):
    errors.append("root: 'security' must be an object.")
    security = {}

security_posture = require_field(security, "posture", "security")
require_enum(security_posture, VALID_SECURITY_POSTURES, "posture", "security")

if errors:
    print("Setup intent validation failed:")
    for err in errors:
        print(f"  - {err}")
    raise SystemExit(1)

# ── Resolve profile defaults ───────────────────────────────────────────────────
preferences = intent.get("preferences") or {}
setup_profile = preferences.get("setup_profile") if isinstance(preferences, dict) else None

resolved_defaults = {}
if setup_profile:
    if setup_profile in PROFILE_DEFAULTS:
        resolved_defaults = PROFILE_DEFAULTS[setup_profile]
    else:
        print(
            f"Warning: setup_profile '{setup_profile}' is not in the catalog. "
            "No profile defaults applied. Proceeding with explicit intent fields only."
        )

# ── Collect resolved values ────────────────────────────────────────────────────
def resolve_field(explicit_value, profile_key, defaults, fallback="?"):
    """Return explicit_value if truthy, else the profile default, else fallback."""
    return explicit_value or defaults.get(profile_key, fallback)

resolved_bundle = resolve_field(auto_bundle, "automation_bundle", resolved_defaults)
resolved_stage = resolve_field(auto_stage, "automation_stage", resolved_defaults)
resolved_evidence = resolve_field(evidence_level, "evidence_level", resolved_defaults)
resolved_posture = resolve_field(security_posture, "security_posture", resolved_defaults)
resolved_deployment = resolve_field(deployment_model, "deployment_model", resolved_defaults)

deployment_targets = deployment.get("targets") or []
deferred_items = intent.get("deferred") or []
notes = intent.get("notes") or ""

applied_at = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")

# ── Write canonical intent file ────────────────────────────────────────────────
wrote_canonical = False
if not dry_run and intent_path.resolve() != canonical_path.resolve():
    canonical_path.parent.mkdir(parents=True, exist_ok=True)
    with canonical_path.open("w", encoding="utf-8") as f:
        json.dump(intent, f, indent=2, ensure_ascii=False)
        f.write("\n")
    wrote_canonical = True

# ── Build summary ──────────────────────────────────────────────────────────────
bar = "=" * 62

lines = [
    bar,
    " Framework Setup Apply Summary",
    bar,
    "",
    f" Setup ID:     {setup_id}",
    f" Mode:         {setup_mode}",
    f" Applied at:   {applied_at}",
    f" Schema:       v{schema_version}",
    "",
    " Project",
    f"   Name:         {project_name}",
    f"   Repo shape:   {project_repo_shape}",
    f"   Work types:   {', '.join(project_work_types)}",
    "",
    " Team",
    f"   Profile:      {team_profile}",
    f"   Owners:       {', '.join(team_owners)}",
    "",
    " Profile and Bundle Resolution",
]
if setup_profile:
    lines.append(f"   Setup profile:    {setup_profile}")
else:
    lines.append("   Setup profile:    (not set — explicit fields used)")
lines += [
    f"   Bundle / Stage:   {resolved_bundle} / {resolved_stage}",
    f"   Evidence level:   {resolved_evidence}",
    f"   Security posture: {resolved_posture}",
    "",
    " Deployment",
    f"   Model:    {resolved_deployment}",
]
if deployment_targets:
    lines.append(f"   Targets:  {', '.join(deployment_targets)}")
lines += [
    "",
    f" Execution surfaces:  {', '.join(exec_surfaces)}",
    "",
]

if deferred_items:
    lines.append(f" Deferred items ({len(deferred_items)}):")
    for item in deferred_items:
        if not isinstance(item, dict):
            continue
        lines.append(f"   ┌─ {item.get('item', '(unnamed)')}")
        if item.get("reason"):
            lines.append(f"   │  Reason:      {item['reason']}")
        if item.get("owner"):
            lines.append(f"   │  Owner:       {item['owner']}")
        if item.get("enablement_criteria"):
            lines.append(f"   │  Enable when: {item['enablement_criteria']}")
    lines.append("")
else:
    lines.append(" Deferred items:  none")
    lines.append("")

if notes:
    lines += [f" Notes:  {notes}", ""]

lines += [bar]

if dry_run:
    lines += [" DRY RUN — no files were written.", bar, ""]
elif wrote_canonical:
    lines += [
        f" Setup intent written to: {canonical_path.relative_to(repo_root)}",
        bar,
        "",
    ]
else:
    lines += [
        f" Setup intent source:     {intent_path.relative_to(repo_root)}",
        " (Already at canonical path — no copy needed.)",
        bar,
        "",
    ]

lines += [
    " Next steps for operator:",
    "",
    f"   1. Review the applied intent: {canonical_path.relative_to(repo_root)}",
    "   2. Run setup readiness check:",
    "        bash scripts/check-setup-readiness.sh",
    "   3. Enable checks per your automation bundle:",
    "        docs/framework-automation-bundles-by-profile.md",
    "   4. Open a bootstrap issue capturing scope, constraints, and acceptance.",
    "   5. Capture all deferred items as follow-up issues with owner and review date.",
    "",
    bar,
]

summary = "\n".join(lines)

if output_file:
    with open(output_file, "w", encoding="utf-8") as f:
        f.write(summary)
        f.write("\n")
    print(f"Setup apply summary written to: {output_file}")
else:
    print(summary)
PY
