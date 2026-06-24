#!/usr/bin/env bash
set -euo pipefail

# Version parity: assert the framework version is consistent across its sources
# of truth, so a release can't be cut with the pieces out of sync:
#   - CHANGELOG.md             — latest `## [X.Y.Z]` heading + `[X.Y.Z]:` link
#   - registry/framework-version.json — `framework_version`
#   - registry/releases/<X.Y.Z>.md     — release-notes file for that version
#
# The git tag (vX.Y.Z) is validated separately by .github/workflows/release.yml
# when the tag is pushed — it cannot be required here, because the version is set
# in the repo (this check) before the tag is cut.

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

fv_json="brain-factory/registry/framework-version.json"

changelog_version="$(grep -oE '^## \[[0-9]+\.[0-9]+\.[0-9]+\]' CHANGELOG.md 2>/dev/null \
  | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || true)"
registry_version="$(grep -oE '"framework_version"[[:space:]]*:[[:space:]]*"[0-9]+\.[0-9]+\.[0-9]+"' "$fv_json" 2>/dev/null \
  | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1 || true)"

errors=()
[ -n "$changelog_version" ] || errors+=("could not parse a version from CHANGELOG.md (expected a '## [X.Y.Z]' heading)")
[ -n "$registry_version" ]  || errors+=("could not parse framework_version from ${fv_json}")

if [ -n "$changelog_version" ] && [ -n "$registry_version" ] \
   && [ "$changelog_version" != "$registry_version" ]; then
  errors+=("version mismatch: CHANGELOG.md=${changelog_version} != ${fv_json}=${registry_version}")
fi

if [ -n "$registry_version" ]; then
  notes="brain-factory/registry/releases/${registry_version}.md"
  [ -f "$notes" ] || errors+=("missing release notes for ${registry_version}: ${notes}")
  if ! grep -qE "^\[${registry_version//./\\.}\]:" CHANGELOG.md; then
    errors+=("CHANGELOG.md is missing the reference link line: [${registry_version}]: <url>")
  fi
fi

if [ "${#errors[@]}" -gt 0 ]; then
  echo "Version parity check failed:"
  printf '  - %s\n' "${errors[@]}"
  exit 1
fi

echo "OK: version parity — CHANGELOG ${changelog_version} == framework-version.json ${registry_version}; release notes and changelog link present."
