#!/usr/bin/env bash
set -euo pipefail

# Check that index files stay in sync with the files they document.
# Specifically:
#   - Every docs/adr/NNNN-*.md is referenced in docs/adr/README.md
#   - Every docs/runbooks/*.md (except README.md) is referenced in docs/runbooks/README.md
#   - Every examples/*.md (except README.md) is referenced in examples/README.md
#
# This closes the recurring manual audit item from docs/framework-health.md:
#   "ADR index in docs/adr/README.md lists every ADR file in docs/adr/"
#   "docs/README.md index reflects the current state of docs/runbooks/ and examples/"

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

errors=()

check_file_indexed() {
  local index_file="$1"
  local file="$2"
  local slug
  slug="$(basename "$file")"

  if ! grep -qF "$slug" "$index_file"; then
    errors+=("${index_file}: '${file}' is not referenced (expected to find '${slug}')")
  fi
}

# ── ADR index parity ────────────────────────────────────────────────────────
adr_index="docs/adr/README.md"
if [ ! -f "$adr_index" ]; then
  errors+=("missing required index: ${adr_index}")
else
  while IFS= read -r adr_file; do
    check_file_indexed "$adr_index" "$adr_file"
  done < <(find docs/adr -maxdepth 1 -name "[0-9]*.md" | sort)
fi

# ── Runbooks index parity ────────────────────────────────────────────────────
runbooks_index="docs/runbooks/README.md"
if [ ! -f "$runbooks_index" ]; then
  errors+=("missing required index: ${runbooks_index}")
else
  while IFS= read -r rb_file; do
    check_file_indexed "$runbooks_index" "$rb_file"
  done < <(find docs/runbooks -maxdepth 1 -name "*.md" ! -name "README.md" | sort)
fi

# ── Examples index parity ────────────────────────────────────────────────────
examples_index="examples/README.md"
if [ ! -f "$examples_index" ]; then
  errors+=("missing required index: ${examples_index}")
else
  while IFS= read -r ex_file; do
    check_file_indexed "$examples_index" "$ex_file"
  done < <(find examples -maxdepth 1 -name "*.md" ! -name "README.md" | sort)
fi

if [ "${#errors[@]}" -gt 0 ]; then
  echo "Index parity check failed:"
  printf '  - %s\n' "${errors[@]}"
  exit 1
fi

echo "OK: index parity check passed (ADR index, runbooks index, and examples index are all in sync)."
