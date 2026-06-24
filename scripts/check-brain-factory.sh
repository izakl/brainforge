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

# ── Report ───────────────────────────────────────────────────────────────────
if [ "${#errors[@]}" -gt 0 ]; then
  echo "Brain-factory check failed:"
  printf '  - %s\n' "${errors[@]}"
  exit 1
fi

echo "OK: brain-factory check passed (manifest example valid; ${#catalog_bases[@]} core commands in sync with catalog; tasks.json valid)."
