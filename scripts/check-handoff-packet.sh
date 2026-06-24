#!/usr/bin/env bash
set -euo pipefail

# Enforce ADR 0015 handoff packet completeness checks.
# See docs/adr/0015-handoff-packet-enforcement.md

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

inventory_file="docs/multi-agent-handoff-playbook.md"
coverage_heading="## Handoff packet coverage"

required_fields=(
  "Objective"
  "Context"
  "Constraints"
  "Acceptance criteria"
  "Validation expectations"
  "Related artifacts"
  "Next owner"
  "Status"
  "Unresolved risks"
)

expected_entries=()
skip_entries=()
pending_entries=()
errors=()

trim() {
  sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//' <<<"$1"
}

line_no=0
in_coverage_section=0
table_found=0
table_header_found=0

while IFS= read -r line; do
  line_no=$((line_no + 1))

  if [ "$in_coverage_section" -eq 0 ]; then
    if [[ "$line" == "$coverage_heading" ]]; then
      in_coverage_section=1
    fi
    continue
  fi

  if [[ "$line" =~ ^##[[:space:]]+ ]] && [[ "$line" != "$coverage_heading" ]]; then
    break
  fi

  if [[ ! "$line" =~ ^\| ]]; then
    continue
  fi

  table_found=1

  if [[ "$line" == *"Doc path"* ]] && [[ "$line" == *"Status"* ]] && [[ "$line" == *"Notes"* ]]; then
    table_header_found=1
    continue
  fi

  if [[ "$line" =~ ^\|[[:space:]\-:|]+\|$ ]]; then
    continue
  fi

  IFS='|' read -r _ raw_path raw_status raw_notes _ <<<"$line"

  raw_path="${raw_path//\`/}"
  doc_path="$(trim "$raw_path")"
  status="$(trim "$raw_status")"

  if [[ "$doc_path" =~ ^:?-+:?$ ]] && [[ "$status" =~ ^:?-+:?$ ]]; then
    continue
  fi

  if [ -z "$doc_path" ] || [ -z "$status" ]; then
    errors+=("${inventory_file}:${line_no}: invalid inventory row (missing Doc path or Status)")
    continue
  fi

  case "$status" in
    Expected) expected_entries+=("${line_no}:${doc_path}") ;;
    Skip) skip_entries+=("${line_no}:${doc_path}") ;;
    Pending) pending_entries+=("${line_no}:${doc_path}") ;;
    *) errors+=("${inventory_file}:${line_no}: unsupported Status '${status}' (expected: Expected, Skip, Pending)") ;;
  esac
done <"$inventory_file"

if [ "$in_coverage_section" -eq 0 ]; then
  errors+=("${inventory_file}: missing '${coverage_heading}' section")
fi
if [ "$table_found" -eq 0 ]; then
  errors+=("${inventory_file}: missing coverage table under '${coverage_heading}'")
fi
if [ "$table_header_found" -eq 0 ]; then
  errors+=("${inventory_file}: coverage table header must include 'Doc path | Status | Notes'")
fi
if [ "${#expected_entries[@]}" -eq 0 ]; then
  errors+=("${inventory_file}: coverage table has no Expected rows")
fi

if [ "${#pending_entries[@]}" -gt 0 ]; then
  for entry in "${pending_entries[@]}"; do
    IFS=':' read -r entry_line pending_path <<<"$entry"
    errors+=("${inventory_file}:${entry_line}: Pending entry '${pending_path}' must be resolved before merge")
  done
fi

assert_required_fields() {
  local file="$1"
  local inventory_line="$2"
  local field
  for field in "${required_fields[@]}"; do
    if ! grep -qiE "^##[[:space:]]+${field}" "$file"; then
      errors+=("${inventory_file}:${inventory_line}: '${file}' is missing required handoff field heading '${field}'")
    fi
  done
}

process_expected_entry() {
  local entry_line="$1"
  local entry_path="$2"

  if [ ! -f "$entry_path" ]; then
    errors+=("${inventory_file}:${entry_line}: Expected path '${entry_path}' does not exist")
    return
  fi

  assert_required_fields "$entry_path" "$entry_line"
}

process_skip_entry() {
  local entry_line="$1"
  local entry_path="$2"

  if [ ! -f "$entry_path" ]; then
    errors+=("${inventory_file}:${entry_line}: Skip path '${entry_path}' does not exist")
  fi
}

for entry in "${expected_entries[@]}"; do
  IFS=':' read -r entry_line entry_path <<<"$entry"
  process_expected_entry "$entry_line" "$entry_path"
done

for entry in "${skip_entries[@]}"; do
  IFS=':' read -r entry_line entry_path <<<"$entry"
  process_skip_entry "$entry_line" "$entry_path"
done

if [ "${#errors[@]}" -gt 0 ]; then
  echo "Handoff packet check failed:"
  printf '  - %s\n' "${errors[@]}"
  exit 1
fi

echo "OK: handoff packet check passed (${#expected_entries[@]} Expected rows, ${#skip_entries[@]} Skip rows, 0 Pending rows)."
