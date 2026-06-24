#!/usr/bin/env bash
set -euo pipefail

# Enforce ADR 0013 mobile quick-action coverage/shape checks.

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

inventory_file="docs/github-mobile-guide.md"
coverage_heading="## Mobile quick action coverage"
mobile_heading_regex='^## Mobile quick action[[:space:]]*$'
related_heading_regex='^## Related docs[[:space:]]*$'

required_labels=(
  "Use when:"
  "Do from mobile:"
  "Do not do from mobile:"
  "Escalate to desktop/cloud when:"
  "Primary artifact to update:"
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
    if [[ "$line" =~ ^${coverage_heading}$ ]]; then
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

expand_entry_paths() {
  local entry_path="$1"
  if [[ "$entry_path" == *"*"* ]] || [[ "$entry_path" == *"?"* ]] || [[ "$entry_path" == *"["* ]]; then
    local expanded=()
    while IFS= read -r found; do
      if [ -f "$found" ]; then
        expanded+=("$found")
      fi
    done < <(compgen -G "$entry_path" | sort)
    if [ "${#expanded[@]}" -eq 0 ]; then
      return 1
    fi
    printf '%s\n' "${expanded[@]}"
    return
  fi

  if [ ! -f "$entry_path" ]; then
    return 1
  fi
  printf '%s\n' "$entry_path"
}

find_heading_line() {
  local file="$1"
  local pattern="$2"
  awk -v pattern="$pattern" '
    $0 ~ pattern { print NR; exit }
  ' "$file"
}

find_section_end_line() {
  local file="$1"
  local start_line="$2"
  awk -v start="$start_line" '
    NR > start && /^##[[:space:]]+/ { print NR - 1; found=1; exit }
    END {
      if (!found) {
        print NR
      }
    }
  ' "$file"
}

assert_required_labels() {
  local file="$1"
  local section_start="$2"
  local section_end="$3"
  local label
  for label in "${required_labels[@]}"; do
    if ! awk -v start="$section_start" -v end="$section_end" -v label="$label" '
      NR > start && NR <= end && index($0, label) > 0 { found=1; exit }
      END { exit(found ? 0 : 1) }
    ' "$file"; then
      errors+=("${file}:${section_start}: missing required mobile quick-action label '${label}' (section lines ${section_start}-${section_end})")
    fi
  done
}

check_expected_file() {
  local file="$1"
  local inventory_line="$2"

  local mobile_line
  mobile_line="$(find_heading_line "$file" "$mobile_heading_regex")"
  if [ -z "$mobile_line" ]; then
    errors+=("${inventory_file}:${inventory_line}: '${file}' is Expected but missing '## Mobile quick action'")
    return
  fi

  local section_end
  section_end="$(find_section_end_line "$file" "$mobile_line")"
  assert_required_labels "$file" "$mobile_line" "$section_end"

  local related_line
  related_line="$(find_heading_line "$file" "$related_heading_regex")"
  if [ -n "$related_line" ] && [ "$mobile_line" -gt "$related_line" ]; then
    errors+=("${file}:${mobile_line}: '## Mobile quick action' must appear before '## Related docs' (line ${related_line})")
  fi
}

check_skip_file() {
  local file="$1"
  local inventory_line="$2"

  local mobile_line
  mobile_line="$(find_heading_line "$file" "$mobile_heading_regex")"
  if [ -n "$mobile_line" ]; then
    errors+=("${inventory_file}:${inventory_line}: '${file}' is Skip but contains '## Mobile quick action' at ${file}:${mobile_line}")
  fi
}

process_inventory_entry() {
  local mode="$1"
  local entry_line="$2"
  local entry_path="$3"

  local expanded_paths=()
  if ! mapfile -t expanded_paths < <(expand_entry_paths "$entry_path"); then
    errors+=("${inventory_file}:${entry_line}: ${mode} path '${entry_path}' does not resolve to existing file(s)")
    return
  fi
  if [ "${#expanded_paths[@]}" -eq 0 ]; then
    errors+=("${inventory_file}:${entry_line}: ${mode} path '${entry_path}' does not resolve to existing file(s)")
    return
  fi

  for path in "${expanded_paths[@]}"; do
    if [ "$mode" = "expected" ]; then
      check_expected_file "$path" "$entry_line"
    else
      check_skip_file "$path" "$entry_line"
    fi
  done
}

for entry in "${expected_entries[@]}"; do
  IFS=':' read -r entry_line entry_path <<<"$entry"
  process_inventory_entry "expected" "$entry_line" "$entry_path"
done

for entry in "${skip_entries[@]}"; do
  IFS=':' read -r entry_line entry_path <<<"$entry"
  process_inventory_entry "skip" "$entry_line" "$entry_path"
done

if [ "${#errors[@]}" -gt 0 ]; then
  echo "Mobile quick-action convention check failed:"
  printf '  - %s\n' "${errors[@]}"
  exit 1
fi

echo "OK: mobile quick-action coverage check passed (${#expected_entries[@]} Expected rows, ${#skip_entries[@]} Skip rows, 0 Pending rows)."
