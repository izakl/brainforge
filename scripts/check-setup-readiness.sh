#!/usr/bin/env bash
set -euo pipefail

# check-setup-readiness.sh — Validate that the framework is in a coherent
# "ready to work" state after a setup intent has been applied.
#
# Reads from the canonical setup intent path:
#   .github/framework-setup-intent.json
#
# Checks each readiness dimension defined in:
#   docs/framework-setup-intent-schema-and-application-model.md
#
# Exit codes:
#   0 - Readiness check passed (intent exists and schema-valid)
#   1 - Readiness check failed (missing intent or schema errors)
#
# See docs/runbooks/apply-setup.md for the full setup and readiness runbook.

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
canonical_intent="${repo_root}/.github/framework-setup-intent.json"

python3 - "$canonical_intent" "$repo_root" <<'PY'
import json
import sys
from pathlib import Path

canonical_path = Path(sys.argv[1])
repo_root = Path(sys.argv[2])

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

KNOWN_PROFILE_IDS = {
    "solo_prototype",
    "solo_production_app",
    "small_saas_team",
    "internal_platform_service_team",
    "regulated_high_governance_service",
}

bar = "=" * 62
checks = []   # list of (label, status, detail)
errors = []

def check(label, passed, detail=""):
    status = "PASS" if passed else "FAIL"
    checks.append((label, status, detail))
    if not passed:
        errors.append(f"{label}: {detail}" if detail else label)

# ── Dimension 1: Intent file exists ───────────────────────────────────────────
if not canonical_path.exists():
    print(bar)
    print(" Framework Setup Readiness Check")
    print(bar)
    print()
    print(f" Intent path: {canonical_path.relative_to(repo_root)}")
    print()
    print(" [FAIL] Setup intent file not found.")
    print()
    print(" Run the apply-setup flow first:")
    print("   bash scripts/apply-setup.sh --intent <your-intent.json>")
    print()
    print(" Or create .github/framework-setup-intent.json manually.")
    print(" See docs/runbooks/apply-setup.md for the full runbook.")
    print()
    print(bar)
    raise SystemExit(1)

# ── Dimension 2: Intent is valid JSON ─────────────────────────────────────────
try:
    with canonical_path.open("r", encoding="utf-8") as f:
        intent = json.load(f)
    check("Intent is valid JSON", True)
except json.JSONDecodeError as exc:
    check("Intent is valid JSON", False, str(exc))
    intent = None

if intent is None or not isinstance(intent, dict):
    check("Intent is a JSON object", False, "Root value must be a JSON object.")
    intent = {}

# ── Dimension 3: Required top-level fields present ────────────────────────────
required_top = ["schema_version", "setup_id", "setup_mode", "project", "team",
                "deployment", "governance", "automation", "execution_surfaces", "security"]
missing_top = [f for f in required_top if intent.get(f) is None]
check(
    "Required top-level fields present",
    not missing_top,
    f"Missing: {', '.join(missing_top)}" if missing_top else "",
)

# ── Dimension 4: Enum values are valid ────────────────────────────────────────
enum_errors = []

setup_mode = intent.get("setup_mode")
if setup_mode and setup_mode not in VALID_SETUP_MODES:
    enum_errors.append(f"setup_mode='{setup_mode}'")

project = intent.get("project") or {}
repo_shape = project.get("repo_shape") if isinstance(project, dict) else None
if repo_shape and repo_shape not in VALID_REPO_SHAPES:
    enum_errors.append(f"project.repo_shape='{repo_shape}'")

team = intent.get("team") or {}
team_profile = team.get("primary_profile") if isinstance(team, dict) else None
if team_profile and team_profile not in VALID_TEAM_PROFILES:
    enum_errors.append(f"team.primary_profile='{team_profile}'")

deployment = intent.get("deployment") or {}
dep_model = deployment.get("model") if isinstance(deployment, dict) else None
if dep_model and dep_model not in VALID_DEPLOYMENT_MODELS:
    enum_errors.append(f"deployment.model='{dep_model}'")

governance = intent.get("governance") or {}
evidence = governance.get("evidence_level") if isinstance(governance, dict) else None
if evidence and evidence not in VALID_EVIDENCE_LEVELS:
    enum_errors.append(f"governance.evidence_level='{evidence}'")

automation = intent.get("automation") or {}
bundle = automation.get("bundle") if isinstance(automation, dict) else None
stage = automation.get("stage") if isinstance(automation, dict) else None
if bundle and bundle not in VALID_BUNDLES:
    enum_errors.append(f"automation.bundle='{bundle}'")
if stage and stage not in VALID_STAGES:
    enum_errors.append(f"automation.stage='{stage}'")

security = intent.get("security") or {}
posture = security.get("posture") if isinstance(security, dict) else None
if posture and posture not in VALID_SECURITY_POSTURES:
    enum_errors.append(f"security.posture='{posture}'")

surfaces = intent.get("execution_surfaces") or []
bad_surfaces = [s for s in surfaces if isinstance(s, str) and s not in VALID_EXECUTION_SURFACES]
if bad_surfaces:
    enum_errors.append(f"execution_surfaces contains unknown value(s): {', '.join(bad_surfaces)}")

check(
    "All enum values valid",
    not enum_errors,
    "; ".join(enum_errors) if enum_errors else "",
)

# ── Dimension 5: Profile and bundle selections explicit and traceable ──────────
profile_ok = bool(bundle) and bool(stage) and bool(evidence) and bool(posture)
check(
    "Profile and bundle selections explicit",
    profile_ok,
    "automation.bundle, automation.stage, governance.evidence_level, and security.posture must all be set.",
)

preferences = intent.get("preferences") or {}
setup_profile_id = preferences.get("setup_profile") if isinstance(preferences, dict) else None
if setup_profile_id and setup_profile_id not in KNOWN_PROFILE_IDS:
    check(
        "Setup profile ID is in catalog",
        False,
        f"preferences.setup_profile='{setup_profile_id}' is not in the known profile catalog. "
        f"See docs/framework-setup-profiles-and-intent-examples.md.",
    )
else:
    check(
        "Setup profile ID is in catalog",
        True,
        f"({setup_profile_id})" if setup_profile_id else "(not set — explicit fields used)",
    )

# ── Dimension 6: Deferred items have required fields ──────────────────────────
deferred = intent.get("deferred") or []
deferred_issues = []
for i, item in enumerate(deferred):
    if not isinstance(item, dict):
        deferred_issues.append(f"deferred[{i}] is not an object")
        continue
    for required_field in ("item", "reason", "owner", "enablement_criteria"):
        if not item.get(required_field):
            deferred_issues.append(
                f"deferred[{i}] ('{item.get('item', '?')}'): missing '{required_field}'"
            )
check(
    "Deferred items have required fields",
    not deferred_issues,
    "; ".join(deferred_issues) if deferred_issues else f"({len(deferred)} item(s))" if deferred else "(none)",
)

# ── Dimension 7: At least one owner set ───────────────────────────────────────
owners = team.get("owners") if isinstance(team, dict) else []
has_owner = isinstance(owners, list) and len(owners) > 0
check("At least one owner is set", has_owner, "team.owners must include at least one entry.")

# ── Summary ────────────────────────────────────────────────────────────────────
intent_display = canonical_path.relative_to(repo_root)
project_name = project.get("name", "?") if isinstance(project, dict) else "?"
bundle_summary = f"{bundle}/{stage}" if bundle and stage else "?"

print(bar)
print(" Framework Setup Readiness Check")
print(bar)
print()
print(f" Intent:    {intent_display}")
print(f" Project:   {project_name}")
print(f" Profile:   {setup_profile_id or '(none — explicit fields)'}")
print(f" Bundle:    {bundle_summary}")
print()
print(" Readiness dimensions:")
for label, status, detail in checks:
    suffix = f" — {detail}" if detail else ""
    print(f"   [{status}] {label}{suffix}")

print()

if not errors:
    print(" Baseline validation commands to confirm full readiness:")
    print()
    print('   npx -y markdownlint-cli2 "**/*.md"')
    print("   bash scripts/check-framework-task-queue.sh")
    print("   bash scripts/check-queue-health.sh")
    print("   bash scripts/check-security-guardrails.sh")
    print("   bash scripts/check-handoff-packet.sh")
    print("   bash scripts/check-mobile-quick-action.sh")
    print("   bash scripts/check-index-parity.sh")
    print()
    print(" For automation bundle and enablement order, see:")
    print("   docs/framework-automation-bundles-by-profile.md")
    print()
    print(bar)
    print(f" Result: READY — intent valid, {len(checks)} dimension(s) checked, 0 error(s).")
    print(bar)
else:
    print(" Resolve the issues above, then re-run:")
    print("   bash scripts/check-setup-readiness.sh")
    print()
    print(" See docs/runbooks/apply-setup.md for the full setup runbook.")
    print()
    print(bar)
    error_count = len(errors)
    print(f" Result: NOT READY — {error_count} readiness error(s) found.")
    print(bar)
    raise SystemExit(1)
PY
