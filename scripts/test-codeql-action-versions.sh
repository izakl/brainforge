#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
checker="$repo_root/scripts/check-codeql-action-versions.sh"
fixtures="$repo_root/tests/fixtures/codeql-action-versions"
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

passed=0

run_pass_case() {
  local fixture="$1"
  local expected="$2"
  local case_root="$tmpdir/${fixture%.yml}"
  local output

  mkdir -p "$case_root/.github/workflows"
  cp "$fixtures/$fixture" "$case_root/.github/workflows/codeql.yml"

  if ! output="$("$checker" "$case_root" 2>&1)"; then
    echo "CodeQL action version test failed: ${fixture} should pass"
    printf '%s\n' "$output"
    exit 1
  fi
  if [[ "$output" != *"$expected"* ]]; then
    echo "CodeQL action version test failed: ${fixture} output did not contain '$expected'"
    printf '%s\n' "$output"
    exit 1
  fi
  passed=$((passed + 1))
}

run_fail_case() {
  local fixture="$1"
  local expected="$2"
  local expected_detail="${3:-}"
  local case_root="$tmpdir/${fixture%.yml}"
  local output

  mkdir -p "$case_root/.github/workflows"
  cp "$fixtures/$fixture" "$case_root/.github/workflows/codeql.yml"

  if output="$("$checker" "$case_root" 2>&1)"; then
    echo "CodeQL action version test failed: ${fixture} should fail"
    printf '%s\n' "$output"
    exit 1
  fi
  if [[ "$output" != *"$expected"* ]]; then
    echo "CodeQL action version test failed: ${fixture} output did not contain '$expected'"
    printf '%s\n' "$output"
    exit 1
  fi
  if [ -n "$expected_detail" ] && [[ "$output" != *"$expected_detail"* ]]; then
    echo "CodeQL action version test failed: ${fixture} output did not contain '$expected_detail'"
    printf '%s\n' "$output"
    exit 1
  fi
  passed=$((passed + 1))
}

run_pass_case "normal-block.yml" "2 github/codeql-action components"
run_pass_case "quoted-uses-key.yml" "2 github/codeql-action components"
run_pass_case "flow-mapping.yml" "2 github/codeql-action components"
run_pass_case "reusable-job.yml" "2 github/codeql-action components"
run_pass_case "scalar-comment-false-positives.yml" "2 github/codeql-action components"
run_pass_case "anchor-alias.yml" "2 github/codeql-action components"
run_pass_case "duplicate-refs.yml" "3 github/codeql-action components"
run_fail_case "malformed-yaml.yml" "could not parse YAML safely"
run_fail_case "unsafe-yaml-tag.yml" "could not parse YAML safely"
run_fail_case "recursive-alias.yml" "recursive YAML alias is not supported"
run_fail_case "dynamic-ref.yml" "dynamic CodeQL uses value is not allowed" \
  '$.jobs.analyze.steps[0].uses'
run_fail_case "different-refs.yml" "must use one ref" \
  '$.jobs.analyze.steps[0].uses: init@99df26d4f13ea111d4ec1a7dddef6063f76b97e9'
run_fail_case "commit-tag-mismatch.yml" "must use one ref"
run_fail_case "no-codeql-uses.yml" "missing required CodeQL component"
run_fail_case "malformed-codeql-use.yml" "malformed CodeQL uses value"
run_fail_case "non-string-uses.yml" "uses value must be a string"

echo "OK: ${passed} adversarial CodeQL action version fixtures passed."
