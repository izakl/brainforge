#!/usr/bin/env bash
set -euo pipefail

repo_root="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
cd "$repo_root"

workflow_dir=".github/workflows"
if [ ! -d "$workflow_dir" ]; then
  echo "CodeQL action version alignment check failed:"
  echo "  - missing workflow directory: ${workflow_dir}"
  exit 1
fi

locations=()
refs=()

while IFS= read -r match; do
  [ -n "$match" ] || continue

  file="${match%%:*}"
  remainder="${match#*:}"
  line="${remainder%%:*}"
  usage="${remainder#*:}"
  action="${usage#*github/codeql-action/}"
  component="${action%%@*}"
  ref="${action#*@}"
  ref="${ref%%[[:space:]#]*}"
  ref="${ref%%\"*}"
  ref="${ref%%\'*}"

  locations+=("${file}:${line} (${component}@${ref})")
  refs+=("$ref")
done < <(
  find "$workflow_dir" -type f \( -name '*.yml' -o -name '*.yaml' \) \
    -exec grep -HnE "^[[:space:]]*(-[[:space:]]*)?uses:[[:space:]]*['\"]?github/codeql-action/[^@[:space:]#'\"]+@[^[:space:]#'\"]+" {} + \
    || true
)

if [ "${#refs[@]}" -eq 0 ]; then
  echo "CodeQL action version alignment check failed:"
  echo "  - no github/codeql-action component references found in ${workflow_dir}"
  exit 1
fi

expected_ref="${refs[0]}"
for ref in "${refs[@]}"; do
  if [ "$ref" != "$expected_ref" ]; then
    echo "CodeQL action version alignment check failed:"
    echo "  - all github/codeql-action components must use the same ref"
    printf '  - %s\n' "${locations[@]}"
    exit 1
  fi
done

echo "OK: ${#refs[@]} github/codeql-action components use the same ref (${expected_ref})."
