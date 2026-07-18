#!/usr/bin/env bash
set -euo pipefail

repo_root="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

if ! command -v ruby >/dev/null 2>&1; then
  echo "CodeQL action version alignment check failed:"
  echo "  - ruby is required to parse workflow YAML safely"
  exit 1
fi

exec ruby - "$repo_root" <<'RUBY'
require "psych"
require "timeout"
require "fiddle/import"

module Posix
  extend Fiddle::Importer
  dlload Fiddle.dlopen(nil)
  extern "int openat(int, const char*, int, int)"
end

DEFAULT_LIMITS = {
  bytes: 256 * 1024,
  ast_nodes: 10_000,
  depth: 100,
  anchors: 128,
  aliases: 256,
  traversal_work: 20_000,
  seconds: 5,
}.freeze

LIMIT_ENV = {
  bytes: "CODEQL_YAML_MAX_BYTES",
  ast_nodes: "CODEQL_YAML_MAX_AST_NODES",
  depth: "CODEQL_YAML_MAX_DEPTH",
  anchors: "CODEQL_YAML_MAX_ANCHORS",
  aliases: "CODEQL_YAML_MAX_ALIASES",
  traversal_work: "CODEQL_YAML_MAX_TRAVERSAL_WORK",
  seconds: "CODEQL_YAML_MAX_SECONDS",
}.freeze

EXPLICIT_STRING_TAG = "tag:yaml.org,2002:str"

def read_limits
  DEFAULT_LIMITS.each_with_object({}) do |(name, default), limits|
    env_name = LIMIT_ENV.fetch(name)
    value = Integer(ENV.fetch(env_name, default.to_s), 10)
    raise ArgumentError, "#{env_name} must be greater than zero" unless value.positive?
    limits[name] = value
  end
end

def node_location(file, node)
  "#{file}:#{node.start_line + 1}:#{node.start_column + 1}"
end

def ast_children(node)
  children = node.respond_to?(:children) ? node.children : nil
  children || []
end

def allowed_tag?(node)
  # GitHub workflow YAML needs no explicit collection tags. The only explicit
  # scalar tag accepted here is the standard YAML string tag.
  return true if node.tag.nil?
  node.is_a?(Psych::Nodes::Scalar) && node.tag == EXPLICIT_STRING_TAG
end

def container_node?(node)
  node.is_a?(Psych::Nodes::Mapping) || node.is_a?(Psych::Nodes::Sequence)
end

def same_identity?(left, right)
  left.dev == right.dev && left.ino == right.ino
end

def direct_child?(path, directory)
  File.dirname(path) == directory
end

def descriptor_count
  descriptor_directory = Dir.exist?("/proc/self/fd") ? "/proc/self/fd" : "/dev/fd"
  Dir.children(descriptor_directory).length
end

def verify_directory_identity(workflow_dir, canonical_directory, descriptor_stat, phase, errors)
  path_stat_before = File.lstat(workflow_dir)
  unless same_identity?(descriptor_stat, path_stat_before)
    errors << ".github/workflows: workflow directory identity changed #{phase}"
    return false
  end

  current_canonical = File.realpath(workflow_dir)
  unless current_canonical == canonical_directory
    errors << ".github/workflows: canonical workflow directory changed #{phase}"
    return false
  end

  path_stat_after = File.lstat(workflow_dir)
  unless same_identity?(descriptor_stat, path_stat_after)
    errors << ".github/workflows: workflow directory identity changed #{phase}"
    return false
  end

  true
rescue SystemCallError => error
  errors << ".github/workflows: could not verify workflow directory #{phase}: #{error.message}"
  false
end

def pause_for_test(marker_env, limits)
  return unless ENV["CODEQL_YAML_TEST_MODE"] == "1"

  marker = ENV[marker_env]
  return unless marker

  File.open(marker, File::WRONLY | File::CREAT | File::EXCL, 0o600) { |file| file.write("ready\n") }
  continue_marker = "#{marker}.continue"
  Timeout.timeout(limits[:seconds]) do
    sleep 0.01 until File.exist?(continue_marker)
  end
end

def with_validated_workflow_directory(repo_root, workflow_dir, limits, errors)
  canonical_repo = File.realpath(repo_root)
  current = repo_root

  [".github", "workflows"].each do |component|
    current = File.join(current, component)
    stat = File.lstat(current)
    if stat.symlink?
      errors << "#{current.delete_prefix("#{repo_root}/")}: workflow path component must not be a symlink"
      return
    end
    unless stat.directory?
      errors << "#{current.delete_prefix("#{repo_root}/")}: workflow path component must be a directory"
      return
    end
  end

  canonical_directory = File.realpath(workflow_dir)
  unless canonical_directory.start_with?("#{canonical_repo}#{File::SEPARATOR}")
    errors << ".github/workflows: canonical workflow directory escapes repository root"
    return
  end

  before = File.lstat(workflow_dir)
  Dir.open(workflow_dir) do |directory|
    descriptor_stat = IO.new(directory.fileno, autoclose: false).stat
    after = File.lstat(workflow_dir)
    unless same_identity?(before, descriptor_stat) && same_identity?(descriptor_stat, after)
      errors << ".github/workflows: workflow directory identity changed during enumeration"
      return
    end

    entries = directory.children.select { |name| name.end_with?(".yml", ".yaml") }.sort
    pause_for_test("CODEQL_YAML_TEST_AFTER_DIRECTORY_ENUM_MARKER", limits)
    return unless verify_directory_identity(
      workflow_dir,
      canonical_directory,
      descriptor_stat,
      "after enumeration",
      errors,
    )

    yield directory, descriptor_stat, canonical_directory, entries

    verify_directory_identity(
      workflow_dir,
      canonical_directory,
      descriptor_stat,
      "after workflow reads",
      errors,
    )
  end
rescue SystemCallError, Timeout::Error => error
  errors << ".github/workflows: could not validate workflow directory: #{error.message}"
end

def pause_after_lstat_for_test(limits)
  pause_for_test("CODEQL_YAML_TEST_AFTER_LSTAT_MARKER", limits)
end

def openat_readonly(directory_fd, entry, flags)
  fd = Posix.openat(directory_fd, entry, flags, 0)
  if fd.negative?
    errno = Fiddle.last_error
    raise SystemCallError.new("openat #{entry}", errno)
  end
  IO.new(fd, "rb")
end

def read_workflow_file(
  directory,
  directory_stat,
  workflow_dir,
  path,
  entry,
  relative_file,
  canonical_directory,
  limits,
  errors
)
  unless File.const_defined?(:NOFOLLOW)
    errors << "#{relative_file}: O_NOFOLLOW is unavailable on this platform"
    return
  end

  return unless verify_directory_identity(
    workflow_dir,
    canonical_directory,
    directory_stat,
    "before file open",
    errors,
  )

  before = File.lstat(path)
  if before.symlink?
    errors << "#{relative_file}: workflow file must not be a symlink"
    return
  end
  unless before.file?
    errors << "#{relative_file}: workflow file must be a regular file"
    return
  end

  canonical_before = File.realpath(path)
  unless direct_child?(canonical_before, canonical_directory)
    errors << "#{relative_file}: canonical workflow file escapes .github/workflows"
    return
  end

  pause_after_lstat_for_test(limits)

  flags = File::RDONLY | File::NOFOLLOW
  flags |= File::NONBLOCK if File.const_defined?(:NONBLOCK)
  file = openat_readonly(directory.fileno, entry, flags)
  begin
    descriptor_stat = file.stat
    unless descriptor_stat.file?
      errors << "#{relative_file}: opened workflow descriptor is not a regular file"
      return
    end
    unless same_identity?(before, descriptor_stat)
      errors << "#{relative_file}: workflow file identity changed before descriptor open"
      return
    end

    return unless verify_directory_identity(
      workflow_dir,
      canonical_directory,
      directory_stat,
      "after descriptor open",
      errors,
    )

    during = File.lstat(path)
    canonical_during = File.realpath(path)
    unless same_identity?(descriptor_stat, during)
      errors << "#{relative_file}: workflow file identity changed after descriptor open"
      return
    end
    unless direct_child?(canonical_during, canonical_directory)
      errors << "#{relative_file}: canonical workflow file escaped .github/workflows after open"
      return
    end

    content = file.read(limits[:bytes] + 1)

    after = File.lstat(path)
    canonical_after = File.realpath(path)
    unless same_identity?(descriptor_stat, after)
      errors << "#{relative_file}: workflow file identity changed during read"
      return
    end
    unless direct_child?(canonical_after, canonical_directory)
      errors << "#{relative_file}: canonical workflow file escaped .github/workflows during read"
      return
    end

    return unless verify_directory_identity(
      workflow_dir,
      canonical_directory,
      directory_stat,
      "after file read",
      errors,
    )
    content
  ensure
    file.close unless file.closed?
  end
rescue SystemCallError => error
  errors << "#{relative_file}: could not safely open workflow file: #{error.message}"
  nil
end

def preflight_ast(root, file, limits, errors)
  anchors = {}
  node_count = 0
  anchor_count = 0
  alias_count = 0
  stack = [[root, 1]]

  until stack.empty?
    node, depth = stack.pop
    node_count += 1
    if node_count > limits[:ast_nodes]
      errors << "#{file}: AST node limit exceeded (limit #{limits[:ast_nodes]})"
      break
    end
    if depth > limits[:depth]
      errors << "#{node_location(file, node)}: AST depth limit exceeded (limit #{limits[:depth]})"
      next
    end

    if node.respond_to?(:tag) && !allowed_tag?(node)
      errors << "#{node_location(file, node)}: explicit YAML tag is not allowed: #{node.tag.inspect}"
    end

    anchor = node.respond_to?(:anchor) ? node.anchor : nil
    if node.is_a?(Psych::Nodes::Alias)
      alias_count += 1
      if alias_count > limits[:aliases]
        errors << "#{node_location(file, node)}: YAML alias limit exceeded (limit #{limits[:aliases]})"
        break
      end
      unless anchors.key?(anchor)
        errors << "#{node_location(file, node)}: undefined YAML alias '*#{anchor}'"
      end
    elsif anchor
      anchor_count += 1
      if anchor_count > limits[:anchors]
        errors << "#{node_location(file, node)}: YAML anchor limit exceeded (limit #{limits[:anchors]})"
        break
      end
      if anchors.key?(anchor)
        errors << "#{node_location(file, node)}: duplicate YAML anchor '&#{anchor}'"
      else
        anchors[anchor] = node
      end
    end

    ast_children(node).reverse_each { |child| stack << [child, depth + 1] }
  end

  anchors
end

def resolve_alias(node, anchors)
  node.is_a?(Psych::Nodes::Alias) ? anchors[node.anchor] : node
end

def mapping_key_value(node, anchors)
  resolved = resolve_alias(node, anchors)
  resolved.value if resolved.is_a?(Psych::Nodes::Scalar)
end

def mapping_path(parent, key)
  if key && key.match?(/\A[A-Za-z_][A-Za-z0-9_-]*\z/)
    "#{parent}.#{key}"
  else
    "#{parent}[#{key.inspect}]"
  end
end

def string_scalar?(node)
  return true if node.tag == EXPLICIT_STRING_TAG
  return true unless node.plain

  loader = Psych::ClassLoader::Restricted.new([], [])
  Psych::ScalarScanner.new(loader).tokenize(node.value).is_a?(String)
rescue Psych::DisallowedClass
  false
end

def inspect_uses(node, file, path, anchors, codeql_uses, errors)
  resolved = resolve_alias(node, anchors)
  unless resolved.is_a?(Psych::Nodes::Scalar)
    type = resolved ? resolved.class.name.split("::").last : "undefined alias"
    errors << "#{file}:#{path}: uses value must be a string scalar, got #{type}"
    return
  end

  unless string_scalar?(resolved)
    errors << "#{file}:#{path}: uses value must resolve to a string scalar"
    return
  end

  value = resolved.value
  return unless value.match?(%r{\Agithub/codeql-action(?:/|\z)}i)

  if value.include?("${{")
    errors << "#{file}:#{path}: dynamic CodeQL uses value is not allowed: #{value.inspect}"
    return
  end

  match = value.match(%r{\Agithub/codeql-action/([A-Za-z0-9][A-Za-z0-9_-]*)@(\S+)\z}i)
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

def scan_ast(node, file, path, depth, anchors, limits, state, codeql_uses, errors)
  return if state[:work_exceeded]

  state[:work] += 1
  if state[:work] > limits[:traversal_work]
    errors << "#{file}:#{path}: traversal work limit exceeded (limit #{limits[:traversal_work]})"
    state[:work_exceeded] = true
    return
  end
  if depth > limits[:depth]
    errors << "#{file}:#{path}: traversal depth limit exceeded (limit #{limits[:depth]})"
    return
  end

  if node.is_a?(Psych::Nodes::Alias)
    target = anchors[node.anchor]
    unless target
      errors << "#{file}:#{path}: undefined YAML alias '*#{node.anchor}'"
      return
    end
    scan_ast(
      target,
      file,
      "#{path}->*#{node.anchor}",
      depth + 1,
      anchors,
      limits,
      state,
      codeql_uses,
      errors,
    )
    return
  end

  added_active = false
  if container_node?(node)
    object_id = node.object_id
    if state[:active][object_id]
      errors << "#{file}:#{path}: recursive YAML alias is not supported"
      return
    end
    return if state[:visited][object_id]

    state[:active][object_id] = true
    state[:visited][object_id] = true
    added_active = true
  end

  case node
  when Psych::Nodes::Mapping
    node.children.each_slice(2) do |key_node, value_node|
      key = mapping_key_value(key_node, anchors)
      child_path = mapping_path(path, key)
      inspect_uses(value_node, file, child_path, anchors, codeql_uses, errors) if key == "uses"
      scan_ast(key_node, file, "#{child_path}<key>", depth + 1, anchors, limits, state, codeql_uses, errors)
      scan_ast(value_node, file, child_path, depth + 1, anchors, limits, state, codeql_uses, errors)
    end
  when Psych::Nodes::Sequence
    node.children.each_with_index do |child, index|
      scan_ast(child, file, "#{path}[#{index}]", depth + 1, anchors, limits, state, codeql_uses, errors)
    end
  end
ensure
  state[:active].delete(node.object_id) if added_active
end

begin
  limits = read_limits
rescue ArgumentError => error
  warn "CodeQL action version alignment check failed:"
  warn "  - invalid parser limit: #{error.message}"
  exit 1
end

repo_root = File.expand_path(ARGV.fetch(0))
workflow_dir = File.join(repo_root, ".github", "workflows")
errors = []
codeql_uses = []

unless Dir.exist?(workflow_dir)
  warn "CodeQL action version alignment check failed:"
  warn "  - missing workflow directory: .github/workflows"
  exit 1
end

check_fd_cleanup = ENV["CODEQL_YAML_TEST_ASSERT_FD_CLEANUP"] == "1"
initial_fd_count = descriptor_count if check_fd_cleanup

with_validated_workflow_directory(repo_root, workflow_dir, limits, errors) do |
  directory,
  directory_stat,
  canonical_workflow_dir,
  workflow_entries
|
  errors << "no workflow YAML files found in .github/workflows" if workflow_entries.empty?

  workflow_entries.each do |entry|
    absolute_file = File.join(workflow_dir, entry)
    relative_file = File.join(".github", "workflows", entry)
    begin
      Timeout.timeout(limits[:seconds]) do
        content = read_workflow_file(
          directory,
          directory_stat,
          workflow_dir,
          absolute_file,
          entry,
          relative_file,
          canonical_workflow_dir,
          limits,
          errors,
        )
        next unless content

        if content.bytesize > limits[:bytes]
          errors << "#{relative_file}: byte limit exceeded (limit #{limits[:bytes]})"
          next
        end

        content.force_encoding(Encoding::UTF_8)
        unless content.valid_encoding?
          errors << "#{relative_file}: workflow YAML is not valid UTF-8"
          next
        end

        stream = Psych.parse_stream(content, filename: relative_file)
        document_count = stream.children.length
        unless document_count == 1
          errors << "#{relative_file}: expected exactly one YAML document, found #{document_count}"
          next
        end

        document = stream.children.fetch(0)
        root = document.children&.fetch(0, nil)
        unless root
          errors << "#{relative_file}: YAML document is empty"
          next
        end

        file_errors = []
        anchors = preflight_ast(root, relative_file, limits, file_errors)
        if file_errors.empty?
          state = {
            work: 0,
            work_exceeded: false,
            active: {},
            visited: {},
          }
          scan_ast(root, relative_file, "$", 1, anchors, limits, state, codeql_uses, file_errors)
        end
        errors.concat(file_errors)
      end
    rescue Psych::Exception => error
      detail = error.message.lines.first.to_s.strip
      errors << "#{relative_file}: could not parse YAML AST: #{detail}"
    rescue Timeout::Error
      errors << "#{relative_file}: YAML processing time limit exceeded (limit #{limits[:seconds]}s)"
    rescue SystemStackError
      errors << "#{relative_file}: YAML parser stack limit exceeded"
    end
  end
end

if check_fd_cleanup
  final_fd_count = descriptor_count
  if final_fd_count != initial_fd_count
    errors << "workflow descriptor cleanup failed: before=#{initial_fd_count}, after=#{final_fd_count}"
  end
end

components = codeql_uses.group_by { |entry| entry[:component] }
%w[init analyze].each do |required_component|
  errors << "missing required CodeQL component: #{required_component}" unless components.key?(required_component)
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
