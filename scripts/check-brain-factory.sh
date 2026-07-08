#!/usr/bin/env bash
set -euo pipefail

# Validate brain-factory invariants that must hold in the hub:
#   1. The example brain manifest validates against the manifest schema.
#   2. The core-commands catalog and the core command template directories are in
#      sync — every catalogued command has both skill + prompt forms, and every
#      command directory is listed in the catalog.
#   3. adapters/tasks.json is valid JSON and every task declares python/bash/
#      powershell entrypoints whose wrapper files exist.
#
# Pure stdlib: bash + python3 (no third-party deps required).

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

bf="brain-factory"
tmpl_core="$bf/brain-template/03-templates/agent-commands/core"
catalog="$bf/core-commands/CATALOG.md"
example="$bf/brain-template/brain.manifest.example.json"
adapters="$bf/adapters"
export PYTHONPATH="$adapters/python"

errors=()

# ── 1. Manifest example validates against schema ─────────────────────────────
if [ ! -f "$example" ]; then
  errors+=("missing example manifest: $example")
else
  man_errors="$(python3 - "$example" <<'PY' 2>&1 || true
import sys, json
from brainfactory import manifest as m
data = json.load(open(sys.argv[1]))
for e in m.validate_manifest(data, None):
    print(e)
PY
)"
  if [ -n "$man_errors" ]; then
    while IFS= read -r line; do
      [ -n "$line" ] && errors+=("manifest example: $line")
    done <<< "$man_errors"
  fi
fi

# ── 2. Catalog ↔ core command directory parity ───────────────────────────────
if [ ! -f "$catalog" ]; then
  errors+=("missing catalog: $catalog")
elif [ ! -d "$tmpl_core" ]; then
  errors+=("missing core command directory: $tmpl_core")
else
  mapfile -t catalog_bases < <(sed -nE 's/^\| `([a-z][a-z0-9-]*)`.*/\1/p' "$catalog" | sort -u)
  mapfile -t dir_bases < <(find "$tmpl_core" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort -u)

  for b in "${catalog_bases[@]}"; do
    d="$tmpl_core/$b"
    if [ ! -d "$d" ]; then
      errors+=("catalog lists '$b' but $d/ is missing")
    else
      [ -f "$d/SKILL.md.tmpl" ] || errors+=("$d: missing SKILL.md.tmpl")
      [ -f "$d/$b.prompt.md.tmpl" ] || errors+=("$d: missing $b.prompt.md.tmpl")
    fi
  done

  for b in "${dir_bases[@]}"; do
    if ! printf '%s\n' "${catalog_bases[@]}" | grep -qx "$b"; then
      errors+=("core command dir '$b' is not listed in $catalog")
    fi
  done
fi

# ── 3. adapters/tasks.json integrity ─────────────────────────────────────────
tasks_json="$adapters/tasks.json"
if [ ! -f "$tasks_json" ]; then
  errors+=("missing $tasks_json")
else
  task_errs="$(python3 - "$tasks_json" "$adapters" <<'PY' 2>&1 || true
import sys, json, os
tj = json.load(open(sys.argv[1]))
adapters = sys.argv[2]
tasks = tj.get("tasks", {})
if not tasks:
    print("no tasks defined")
for tid, spec in tasks.items():
    for plat in ("python", "bash", "powershell"):
        if plat not in spec:
            print(f"task '{tid}': missing '{plat}' entrypoint")
    for plat in ("bash", "powershell"):
        ep = spec.get(plat, "")
        # Wrapper entrypoints are relative paths (e.g. bash/inspect.sh); the
        # python entrypoint is a descriptive 'module: ...' string, skipped here.
        if ep and "/" in ep and not ep.endswith(")"):
            if not os.path.exists(os.path.join(adapters, ep)):
                print(f"task '{tid}': {plat} entrypoint not found: {ep}")
PY
)"
  if [ -n "$task_errs" ]; then
    while IFS= read -r line; do
      [ -n "$line" ] && errors+=("tasks.json: $line")
    done <<< "$task_errs"
  fi
fi

# ── 4. Command dirs must use BARE names (no redundant prefix) ────────────────
# Guard against the double-prefix bug: a command dir mis-named `<prefix>-foo`
# renders its invocation as `<prefix>-<prefix>-foo`. The generator raises on it
# (adapters/python/brainfactory/capabilities.py::build_model); here the hub
# self-guards its own brain-template command dirs against the example manifest's
# command_prefix, reusing the same discovery logic so the two never diverge.
tmpl_root="$bf/brain-template"
if [ ! -d "$tmpl_root" ]; then
  errors+=("missing brain-template: $tmpl_root")
else
  naming_errs="$(python3 - "$tmpl_root" "$example" <<'PY' 2>&1 || true
import sys, json
from pathlib import Path
from brainfactory import capabilities as cap
brain = Path(sys.argv[1])
prefix = None
try:
    prefix = json.load(open(sys.argv[2])).get("command_prefix")
except (OSError, ValueError):
    pass
if not prefix:
    prefix = "cmd"
for c in cap.find_prefixed_command_dirs(brain, prefix):
    bare = c.base[len(prefix) + 1:] or "<name>"
    print(f"command dir '{c.layer}/{c.base}' redundantly starts with '{prefix}-' "
          f"(would invoke '{c.invocation(prefix)}'); rename to bare '{bare}'")
PY
)"
  if [ -n "$naming_errs" ]; then
    while IFS= read -r line; do
      [ -n "$line" ] && errors+=("command naming: $line")
    done <<< "$naming_errs"
  fi
fi

# ── 5. Brain-template ships the inherited brain-checks CI gate ───────────────
# The brain-checks workflow is the inherited anti-drift + intent + docs-mesh gate
# every provisioned brain runs on pull_request + push-to-main (codified by
# 04-policies/ci-checks-standard.md and ADR 0027). Guard against silent removal:
# the template must ship the workflow AND still wire its two BLOCKING invariants —
# capabilities --check (no map drift) and intent-gate (no command without a
# capabilities row). grep-only, matching the run invocations (not the descriptive
# comments) so the hub and the standard cannot quietly diverge.
brain_checks_wf="$tmpl_root/.github/workflows/brain-checks.yml"
if [ ! -f "$brain_checks_wf" ]; then
  errors+=("missing inherited CI gate workflow: $brain_checks_wf")
else
  if ! grep -Eq 'brainfactory[[:space:]]+capabilities[[:space:]].*--check' "$brain_checks_wf"; then
    errors+=("$brain_checks_wf: missing blocking 'capabilities ... --check' invocation")
  fi
  if ! grep -Eq 'brainfactory[[:space:]]+intent-gate' "$brain_checks_wf"; then
    errors+=("$brain_checks_wf: missing blocking 'intent-gate' invocation")
  fi
fi

# ── Report ───────────────────────────────────────────────────────────────────
if [ "${#errors[@]}" -gt 0 ]; then
  echo "Brain-factory check failed:"
  printf '  - %s\n' "${errors[@]}"
  exit 1
fi

echo "OK: brain-factory check passed (manifest example valid; ${#catalog_bases[@]} core commands in sync with catalog; tasks.json valid; command dirs use bare names; brain-template ships the brain-checks CI gate)."
