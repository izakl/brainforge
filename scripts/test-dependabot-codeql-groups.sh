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
run_case "implicit-version-scope.yml" "fail" "must explicitly set applies-to"
run_case "mismatched-patterns.yml" "fail" "security-updates CodeQL coverage must be exactly"

echo "OK: ${passed} Dependabot CodeQL group fixtures passed."
