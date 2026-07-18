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
required_scopes = %w[version-updates security-updates].freeze
codeql_pattern = "github/codeql-action/*"

def glob_closure(pattern, states)
  closure = states.dup
  pending = states.dup
  until pending.empty?
    state = pending.pop
    next unless state < pattern.length && pattern[state] == "*"

    following = state + 1
    next if closure.include?(following)

    closure << following
    pending << following
  end
  closure.sort.freeze
end

def glob_step(pattern, states, character)
  following = []
  states.each do |state|
    next if state >= pattern.length

    token = pattern[state]
    following << state if token == "*"
    following << state + 1 if token == character
  end
  glob_closure(pattern, following.uniq)
end

def glob_alphabet(patterns)
  literals = patterns.join.each_char.reject { |character| character == "*" }.uniq
  other = "\0"
  other = other.next while literals.include?(other)
  (literals + [other]).freeze
end

def glob_intersection_has_unexcluded?(target, include_pattern, exclude_patterns)
  target = target.downcase
  include_pattern = include_pattern.downcase
  exclude_patterns = exclude_patterns.map(&:downcase)
  patterns = [target, include_pattern, *exclude_patterns]
  alphabet = glob_alphabet(patterns)
  initial = patterns.map { |pattern| glob_closure(pattern, [0]) }.freeze
  pending = [initial]
  visited = { initial => true }

  until pending.empty?
    states = pending.shift
    target_matches = states[0].include?(target.length)
    include_matches = states[1].include?(include_pattern.length)
    exclusions_match = exclude_patterns.each_index.any? do |index|
      states[index + 2].include?(exclude_patterns[index].length)
    end
    return true if target_matches && include_matches && !exclusions_match

    alphabet.each do |character|
      following = patterns.each_index.map do |index|
        glob_step(patterns[index], states[index], character)
      end.freeze
      next if following[0].empty? || following[1].empty? || visited.key?(following)

      visited[following] = true
      pending << following
    end
  end

  false
end

def glob_patterns_intersect?(left, right)
  glob_intersection_has_unexcluded?(left, right, [])
end

def string_array(value, path, errors)
  unless value.is_a?(Array)
    errors << "#{path} must be an array"
    return []
  end

  strings = []
  value.each_with_index do |entry, index|
    if entry.is_a?(String) && !entry.empty?
      strings << entry
    else
      errors << "#{path}[#{index}] must be a non-empty string"
    end
  end
  strings
end

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

parsed_groups = []
groups.each do |name, spec|
  group_path = "#{relative_config}: groups.#{name}"
  unless spec.is_a?(Hash)
    errors << "#{group_path} must be a mapping"
    next
  end

  explicit_scope = spec["applies-to"]
  scope = explicit_scope.nil? ? "version-updates" : explicit_scope
  patterns = if spec.key?("patterns")
               string_array(spec["patterns"], "#{group_path}.patterns", errors)
             else
               ["*"]
             end
  exclusions = if spec.key?("exclude-patterns")
                 string_array(spec["exclude-patterns"], "#{group_path}.exclude-patterns", errors)
               else
                 []
               end
  parsed_groups << {
    name: name,
    path: group_path,
    explicit_scope: explicit_scope,
    scope: scope,
    patterns: patterns,
    exclusions: exclusions,
  }
end

required_scopes.each do |scope|
  candidates = parsed_groups.select do |group|
    group[:explicit_scope] == scope && group[:patterns] == [codeql_pattern]
  end
  if candidates.empty?
    errors << "#{relative_config}: missing CodeQL group for #{scope}"
    next
  end
  if candidates.length > 1
    errors << "#{relative_config}: multiple exact CodeQL groups cover #{scope}"
    next
  end

  required_group = candidates.fetch(0)
  required_index = parsed_groups.index(required_group)

  required_group[:exclusions].each do |exclusion|
    next unless glob_patterns_intersect?(codeql_pattern, exclusion)

    errors << "#{required_group[:path]}.exclude-patterns entry #{exclusion.inspect} overlaps CodeQL actions"
  end

  parsed_groups[0...required_index].each do |earlier_group|
    next unless earlier_group[:scope] == scope

    capturing_pattern = earlier_group[:patterns].find do |pattern|
      glob_intersection_has_unexcluded?(
        codeql_pattern,
        pattern,
        earlier_group[:exclusions],
      )
    end
    next unless capturing_pattern

    errors << "#{earlier_group[:path]} precedes the required #{scope} CodeQL group and captures CodeQL actions via #{capturing_pattern.inspect}"
  end
end

unless errors.empty?
  warn "Dependabot CodeQL group check failed:"
  errors.each { |error| warn "  - #{error}" }
  exit 1
end

puts "OK: Dependabot groups #{codeql_pattern} identically for version-updates and security-updates."
RUBY
