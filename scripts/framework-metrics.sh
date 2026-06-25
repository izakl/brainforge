#!/usr/bin/env bash
set -euo pipefail

# Framework metrics snapshot — a lightweight, READ-ONLY "status at a glance".
#
# Per docs/framework-metrics-and-feedback.md this deliberately does NOT build a
# data-collection system, track trends, or chase vanity totals. It reuses
# existing repository artifacts to print a point-in-time structural baseline that
# supports the framework health audit (docs/runbooks/run-the-framework-health-audit.md)
# and the monthly effectiveness review cadence. It mutates nothing.
#
# Usage:
#   bash scripts/framework-metrics.sh            # markdown snapshot to stdout
#   bash scripts/framework-metrics.sh --json     # JSON object to stdout
#
# Pure bash + coreutils + python3 (stdlib), matching the other scripts here.

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

mode="markdown"
[ "${1:-}" = "--json" ] && mode="json"

count_glob() {  # count files matching a find expression; never fails the script
  find "$@" 2>/dev/null | wc -l | tr -d ' '
}

fv_json="brain-factory/registry/framework-version.json"
version="$(grep -oE '"framework_version"[[:space:]]*:[[:space:]]*"[0-9]+\.[0-9]+\.[0-9]+"' "$fv_json" 2>/dev/null \
  | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1 || true)"
released="$(grep -oE '"released"[[:space:]]*:[[:space:]]*"[0-9-]+"' "$fv_json" 2>/dev/null \
  | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' | head -1 || true)"

commands="$(grep -cE '^\| `[a-z]' brain-factory/core-commands/CATALOG.md 2>/dev/null || true)"
commands="${commands:-0}"
adrs="$(count_glob docs/adr -maxdepth 1 -name '[0-9]*.md')"
runbooks="$(count_glob docs/runbooks -maxdepth 1 -name '*.md' ! -name 'README.md')"
examples="$(count_glob examples -maxdepth 1 -name '*.md' ! -name 'README.md')"
guardrails="$(count_glob scripts -maxdepth 1 -name 'check-*.sh')"
tests="$(count_glob brain-factory/adapters/python/tests -name 'test_*.py')"
tasks="$(python3 - "$repo_root/brain-factory/adapters/tasks.json" <<'PY' 2>/dev/null || echo 0
import json, sys
try:
    print(len(json.load(open(sys.argv[1])).get("tasks", {})))
except Exception:
    print(0)
PY
)"

if [ "$mode" = "json" ]; then
  python3 - <<PY
import json
print(json.dumps({
    "framework_version": "${version}",
    "released": "${released}",
    "core_commands": ${commands:-0},
    "adrs": ${adrs:-0},
    "runbooks": ${runbooks:-0},
    "examples": ${examples:-0},
    "guardrail_scripts": ${guardrails:-0},
    "adapter_tasks": ${tasks:-0},
    "python_test_modules": ${tests:-0},
}, indent=2))
PY
  exit 0
fi

cat <<EOF
# Framework metrics snapshot

- Framework version: \`${version:-?}\`${released:+ (released ${released})}
- Scope: read-only structural baseline derived from committed artifacts. Not a
  data system or trend tracker — see \`docs/framework-metrics-and-feedback.md\`
  for the signal model and review cadence this supports.

## Structure

| Signal | Count |
| --- | --- |
| Core commands (catalog) | ${commands} |
| Architecture decisions (ADRs) | ${adrs} |
| Operator runbooks | ${runbooks} |
| Worked examples | ${examples} |
| CI guardrail scripts | ${guardrails} |
| Adapter tasks | ${tasks} |
| Python test modules | ${tests} |

## Guardrails enforced in CI

$(for f in scripts/check-*.sh; do [ -e "$f" ] && echo "- \`$(basename "$f")\`"; done)

> This snapshot supports — it does not replace — the manual health audit
> (\`docs/runbooks/run-the-framework-health-audit.md\`) and the
> charter-to-artifact map in \`docs/framework-health.md\`.
EOF
