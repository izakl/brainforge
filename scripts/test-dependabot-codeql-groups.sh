#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
checker="$repo_root/scripts/check-dependabot-codeql-groups.sh"
fixtures="$repo_root/tests/fixtures/dependabot-codeql-groups"
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

passed=0

run_case() {
  local fixture="$1"
  local expected_status="$2"
  local expected_output="$3"
  local case_root="$tmpdir/${fixture%.yml}"
  local output

  mkdir -p "$case_root/.github"
  cp "$fixtures/$fixture" "$case_root/.github/dependabot.yml"

  if output="$("$checker" "$case_root" 2>&1)"; then
    if [ "$expected_status" != "pass" ]; then
      echo "Dependabot CodeQL group test failed: ${fixture} should fail"
      exit 1
    fi
  elif [ "$expected_status" = "pass" ]; then
    echo "Dependabot CodeQL group test failed: ${fixture} should pass"
    printf '%s\n' "$output"
    exit 1
  fi

  if [[ "$output" != *"$expected_output"* ]]; then
    echo "Dependabot CodeQL group test failed: ${fixture} output did not contain '$expected_output'"
    printf '%s\n' "$output"
    exit 1
  fi
  passed=$((passed + 1))
}

run_case "valid.yml" "pass" "identically for version-updates and security-updates"
run_case "missing-security.yml" "fail" "missing CodeQL group for security-updates"
run_case "implicit-version-scope.yml" "fail" "missing CodeQL group for version-updates"
run_case "mismatched-patterns.yml" "fail" "missing CodeQL group for security-updates"
run_case "required-analyze-exclusion.yml" "fail" "exclude-patterns entry \"github/codeql-action/analyze\" overlaps CodeQL actions"
run_case "required-update-types.yml" "fail" "must not set \"update-types\""
run_case "required-dependency-type.yml" "fail" "must not set \"dependency-type\""
run_case "earlier-github-wildcard.yml" "fail" "captures CodeQL actions via \"github/*\""
run_case "earlier-star.yml" "fail" "captures CodeQL actions via \"*\""
run_case "later-broad-group.yml" "pass" "identically for version-updates and security-updates"
run_case "earlier-benign-group.yml" "pass" "identically for version-updates and security-updates"
run_case "earlier-broad-excluded.yml" "pass" "identically for version-updates and security-updates"

echo "OK: ${passed} Dependabot CodeQL group fixtures passed."
