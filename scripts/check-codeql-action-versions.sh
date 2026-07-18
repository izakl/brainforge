#!/usr/bin/env bash
set -euo pipefail

repo_root="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

if ! command -v ruby >/dev/null 2>&1; then
  echo "CodeQL action version alignment check failed:"
  echo "  - ruby is required to parse workflow YAML safely"
  exit 1
fi

exec ruby - "$repo_root" <<'RUBY'
require "yaml"

repo_root = File.expand_path(ARGV.fetch(0))
workflow_dir = File.join(repo_root, ".github", "workflows")
errors = []
codeql_uses = []

unless Dir.exist?(workflow_dir)
  warn "CodeQL action version alignment check failed:"
  warn "  - missing workflow directory: .github/workflows"
  exit 1
end

def mapping_path(parent, key)
  if key.is_a?(String) && key.match?(/\A[A-Za-z_][A-Za-z0-9_-]*\z/)
    "#{parent}.#{key}"
  else
    "#{parent}[#{key.inspect}]"
  end
end

def inspect_uses(value, file, path, codeql_uses, errors)
  unless value.is_a?(String)
    errors << "#{file}:#{path}: uses value must be a string, got #{value.class}"
    return
  end

  prefix = "github/codeql-action"
  return unless value == prefix || value.start_with?("#{prefix}/")

  if value.include?("${{")
    errors << "#{file}:#{path}: dynamic CodeQL uses value is not allowed: #{value.inspect}"
    return
  end

  match = value.match(%r{\Agithub/codeql-action/([A-Za-z0-9][A-Za-z0-9_-]*)@(\S+)\z})
  unless match
    errors << "#{file}:#{path}: malformed CodeQL uses value: #{value.inspect}"
    return
  end

  codeql_uses << {
    file: file,
    path: path,
    component: match[1],
    ref: match[2],
  }
end

def walk_yaml(node, file, path, codeql_uses, errors, active_containers)
  added_guard = false
  container = node.is_a?(Hash) || node.is_a?(Array)
  if container
    object_id = node.object_id
    if active_containers[object_id]
      errors << "#{file}:#{path}: recursive YAML alias is not supported"
      return
    end
    active_containers[object_id] = true
    added_guard = true
  end

  case node
  when Hash
    node.each do |key, value|
      child_path = mapping_path(path, key)
      inspect_uses(value, file, child_path, codeql_uses, errors) if key == "uses"
      walk_yaml(value, file, child_path, codeql_uses, errors, active_containers)
    end
  when Array
    node.each_with_index do |value, index|
      child_path = "#{path}[#{index}]"
      walk_yaml(value, file, child_path, codeql_uses, errors, active_containers)
    end
  end
ensure
  active_containers.delete(node.object_id) if added_guard
end

workflow_files = Dir.glob(File.join(workflow_dir, "*.{yml,yaml}")).sort
if workflow_files.empty?
  errors << "no workflow YAML files found in .github/workflows"
end

workflow_files.each do |absolute_file|
  relative_file = absolute_file.delete_prefix("#{repo_root}/")
  begin
    document = Psych.safe_load(
      File.read(absolute_file, encoding: "UTF-8"),
      permitted_classes: [],
      permitted_symbols: [],
      aliases: true,
      filename: relative_file,
    )
  rescue Psych::Exception, ArgumentError => error
    detail = error.message.lines.first.to_s.strip
    errors << "#{relative_file}: could not parse YAML safely: #{detail}"
    next
  end

  walk_yaml(document, relative_file, "$", codeql_uses, errors, {})
end

components = codeql_uses.group_by { |entry| entry[:component] }
%w[init analyze].each do |required_component|
  unless components.key?(required_component)
    errors << "missing required CodeQL component: #{required_component}"
  end
end

refs = codeql_uses.map { |entry| entry[:ref] }.uniq
if refs.length > 1
  errors << "all github/codeql-action components must use one ref"
  codeql_uses.each do |entry|
    errors << "#{entry[:file]}:#{entry[:path]}: #{entry[:component]}@#{entry[:ref]}"
  end
end

unless errors.empty?
  warn "CodeQL action version alignment check failed:"
  errors.each { |error| warn "  - #{error}" }
  exit 1
end

puts "OK: #{codeql_uses.length} github/codeql-action components use the same ref (#{refs.fetch(0)})."
RUBY
