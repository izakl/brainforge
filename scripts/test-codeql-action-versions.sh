#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
checker="$repo_root/scripts/check-codeql-action-versions.sh"
fixtures="$repo_root/tests/fixtures/codeql-action-versions"
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

passed=0

run_checker() {
  local case_root="$1"
  local limit_assignment="${2:-}"

  if [ -n "$limit_assignment" ]; then
    env "$limit_assignment" "$checker" "$case_root"
  else
    "$checker" "$case_root"
  fi
}

run_pass_case() {
  local fixture="$1"
  local expected="$2"
  local limit_assignment="${3:-}"
  local case_root="$tmpdir/${fixture%.*}"
  local output

  mkdir -p "$case_root/.github/workflows"
  cp "$fixtures/$fixture" "$case_root/.github/workflows/codeql.${fixture##*.}"

  if ! output="$(run_checker "$case_root" "$limit_assignment" 2>&1)"; then
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
  local limit_assignment="${4:-}"
  local case_root="$tmpdir/${fixture%.*}"
  local output

  mkdir -p "$case_root/.github/workflows"
  cp "$fixtures/$fixture" "$case_root/.github/workflows/codeql.${fixture##*.}"

  if output="$(run_checker "$case_root" "$limit_assignment" 2>&1)"; then
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
run_pass_case "explicit-string-tag.yml" "2 github/codeql-action components"
run_pass_case "repeated-shared-alias.yml" "2 github/codeql-action components"
run_pass_case "layered-alias-dag.yml" "2 github/codeql-action components" \
  "CODEQL_YAML_MAX_SECONDS=2"

run_fail_case "malformed-yaml.yml" "could not parse YAML AST"
run_fail_case "malformed-anchor.yml" "could not parse YAML AST"
run_fail_case "multi-document.yml" "expected exactly one YAML document, found 2"
run_fail_case "oversized-bytes.yml" "byte limit exceeded (limit 120)" "" \
  "CODEQL_YAML_MAX_BYTES=120"
run_fail_case "deep-nesting.yml" "AST depth limit exceeded (limit 8)" "" \
  "CODEQL_YAML_MAX_DEPTH=8"
run_fail_case "node-cap.yml" "AST node limit exceeded (limit 12)" "" \
  "CODEQL_YAML_MAX_AST_NODES=12"
run_fail_case "work-cap.yml" "traversal work limit exceeded (limit 12)" "" \
  "CODEQL_YAML_MAX_TRAVERSAL_WORK=12"
run_fail_case "anchor-cap.yml" "YAML anchor limit exceeded (limit 2)" "" \
  "CODEQL_YAML_MAX_ANCHORS=2"
run_fail_case "alias-cap.yml" "YAML alias limit exceeded (limit 2)" "" \
  "CODEQL_YAML_MAX_ALIASES=2"
run_fail_case "recursive-alias.yml" "recursive YAML alias is not supported"
run_fail_case "direct-cycle.yml" "recursive YAML alias is not supported"
run_fail_case "indirect-cycle.yml" "recursive YAML alias is not supported"
run_fail_case "custom-scalar-tag.yml" "explicit YAML tag is not allowed: \"!custom\""
run_fail_case "custom-sequence-tag.yml" "explicit YAML tag is not allowed: \"!custom-sequence\""
run_fail_case "custom-mapping-tag.yml" "explicit YAML tag is not allowed: \"!custom-mapping\""
run_fail_case "symbol-tag.yml" "explicit YAML tag is not allowed: \"!ruby/symbol\""
run_fail_case "unsafe-yaml-tag.yml" "explicit YAML tag is not allowed: \"!ruby/object:OpenStruct\""
run_fail_case "dynamic-ref.yml" "dynamic CodeQL uses value is not allowed" \
  '$.jobs.analyze.steps[0].uses'
run_fail_case "different-refs.yml" "must use one ref" \
  '$.jobs.analyze.steps[0].uses: init@99df26d4f13ea111d4ec1a7dddef6063f76b97e9'
run_fail_case "commit-tag-mismatch.yml" "must use one ref"
run_fail_case "no-codeql-uses.yml" "missing required CodeQL component"
run_fail_case "malformed-codeql-use.yml" "malformed CodeQL uses value"
run_fail_case "non-string-uses.yml" "uses value must be a string scalar"
run_fail_case "implicit-non-string-uses.yml" "uses value must resolve to a string scalar"

echo "OK: ${passed} adversarial CodeQL action version fixtures passed."
