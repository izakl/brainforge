#!/usr/bin/env bash
set -euo pipefail

# Lightweight guardrail check for security reporting and secure-delivery docs.

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

errors=()

require_file() {
  local file="$1"
  if [ ! -f "$file" ]; then
    errors+=("missing required file: ${file}")
  fi
}

require_pattern() {
  local file="$1"
  local pattern="$2"
  local message="$3"
  if ! grep -qiE "$pattern" "$file"; then
    errors+=("${file}: ${message}")
  fi
}

require_file "SECURITY.md"
require_file ".github/ISSUE_TEMPLATE/config.yml"
require_file "docs/security-and-secure-delivery.md"

if [ -f "SECURITY.md" ]; then
  require_pattern "SECURITY.md" "do not.*open a public issue" "must clearly block public vulnerability reporting"
  require_pattern "SECURITY.md" "private vulnerability reporting|report a vulnerability" "must include private reporting guidance"
fi

if [ -f ".github/ISSUE_TEMPLATE/config.yml" ]; then
  require_pattern ".github/ISSUE_TEMPLATE/config.yml" "security/advisories/new" "must include private security advisory contact link"
  require_pattern ".github/ISSUE_TEMPLATE/config.yml" "Do not open a public issue" "must warn against public vulnerability disclosure"
fi

if [ -f "docs/security-and-secure-delivery.md" ]; then
  require_pattern "docs/security-and-secure-delivery.md" "^## Reporting and intake guardrails" "must define reporting/intake guardrails"
  require_pattern "docs/security-and-secure-delivery.md" "^## Sensitive context handling by tier" "must define tier-based sensitive context handling"
  require_pattern "docs/security-and-secure-delivery.md" "^## Agent safety guardrails" "must define agent safety guidance"
  require_pattern "docs/security-and-secure-delivery.md" "^## Secure delivery checks" "must define secure-delivery checks"
fi

if [ "${#errors[@]}" -gt 0 ]; then
  echo "Security guardrail check failed:"
  printf '  - %s\n' "${errors[@]}"
  exit 1
fi

echo "OK: security guardrail check passed."
