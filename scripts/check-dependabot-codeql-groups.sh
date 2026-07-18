#!/usr/bin/env bash
set -euo pipefail

repo_root="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
config=".github/dependabot.yml"

if ! command -v ruby >/dev/null 2>&1; then
  echo "Dependabot CodeQL group check failed:"
  echo "  - ruby is required to parse ${config}"
  exit 1
fi

exec ruby - "$repo_root" "$config" <<'RUBY'
require "psych"

repo_root = File.expand_path(ARGV.fetch(0))
relative_config = ARGV.fetch(1)
config_path = File.join(repo_root, relative_config)
errors = []

begin
  data = Psych.safe_load(
    File.read(config_path, encoding: "UTF-8"),
    permitted_classes: [],
    permitted_symbols: [],
    aliases: false,
    filename: relative_config,
  )
rescue Psych::Exception, SystemCallError, ArgumentError => error
  warn "Dependabot CodeQL group check failed:"
  warn "  - #{relative_config}: could not parse configuration: #{error.message.lines.first.to_s.strip}"
  exit 1
end

updates = data.is_a?(Hash) ? data["updates"] : nil
unless updates.is_a?(Array)
  errors << "#{relative_config}: updates must be an array"
  updates = []
end

action_updates = updates.select do |entry|
  entry.is_a?(Hash) &&
    entry["package-ecosystem"] == "github-actions" &&
    entry["directory"] == "/"
end

unless action_updates.length == 1
  errors << "#{relative_config}: expected exactly one github-actions update entry for '/', found #{action_updates.length}"
end

groups = action_updates.first&.fetch("groups", nil)
unless groups.is_a?(Hash)
  errors << "#{relative_config}: github-actions update entry must define groups"
  groups = {}
end

required_scopes = %w[version-updates security-updates]
codeql_pattern = "github/codeql-action/*"
coverage = {}

groups.each do |name, spec|
  next unless spec.is_a?(Hash)

  patterns = spec["patterns"]
  next unless patterns.is_a?(Array)

  codeql_patterns = patterns.select do |pattern|
    pattern.is_a?(String) && pattern.start_with?("github/codeql-action")
  end.sort
  next if codeql_patterns.empty?

  scope = spec["applies-to"]
  unless required_scopes.include?(scope)
    errors << "#{relative_config}: CodeQL group #{name.inspect} must explicitly set applies-to"
    next
  end
  if coverage.key?(scope)
    errors << "#{relative_config}: multiple CodeQL groups cover #{scope}"
    next
  end
  coverage[scope] = codeql_patterns
end

required_scopes.each do |scope|
  unless coverage.key?(scope)
    errors << "#{relative_config}: missing CodeQL group for #{scope}"
    next
  end
  unless coverage[scope] == [codeql_pattern]
    errors << "#{relative_config}: #{scope} CodeQL coverage must be exactly #{codeql_pattern.inspect}"
  end
end

if required_scopes.all? { |scope| coverage.key?(scope) } &&
   coverage["version-updates"] != coverage["security-updates"]
  errors << "#{relative_config}: version and security CodeQL pattern coverage must be identical"
end

unless errors.empty?
  warn "Dependabot CodeQL group check failed:"
  errors.each { |error| warn "  - #{error}" }
  exit 1
end

puts "OK: Dependabot groups #{codeql_pattern} identically for version-updates and security-updates."
RUBY
