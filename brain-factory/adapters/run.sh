#!/usr/bin/env bash
# POSIX dispatcher: run <task-id> [args...]
# Resolves the task id to its platform entrypoint via tasks.json and execs it.
#
#   ./run.sh inspect-repo --repo /path/to/repo --out gap.md
#   ./run.sh apply-brain provision --dest /tmp/new --name X --slug x ...
#   PLATFORM=powershell ./run.sh inspect-repo --repo ...   # force a platform
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TASKS_JSON="${SCRIPT_DIR}/tasks.json"

if [[ $# -lt 1 ]]; then
  echo "usage: run.sh <task-id> [args...]" >&2
  echo "tasks: $(grep -oE '\"[a-z-]+\": \{' "${TASKS_JSON}" | sed 's/.*"\(.*\)":.*/\1/' | tr '\n' ' ')" >&2
  exit 2
fi

TASK_ID="$1"
shift

PLATFORM="${PLATFORM:-bash}"

# Pick a python to parse tasks.json robustly.
PYTHON_BIN="${PYTHON_BIN:-}"
if [[ -z "${PYTHON_BIN}" ]]; then
  if command -v python3 >/dev/null 2>&1; then PYTHON_BIN="python3"
  elif command -v python >/dev/null 2>&1; then PYTHON_BIN="python"
  else echo "error: python3 not found on PATH" >&2; exit 127; fi
fi

ENTRY="$("${PYTHON_BIN}" - "$TASKS_JSON" "$TASK_ID" "$PLATFORM" <<'PY'
import json, sys
tasks_path, task_id, platform = sys.argv[1], sys.argv[2], sys.argv[3]
data = json.load(open(tasks_path, encoding="utf-8"))
tasks = data.get("tasks", {})
if task_id not in tasks:
    sys.stderr.write(f"unknown task: {task_id}\n")
    sys.exit(3)
entry = tasks[task_id].get(platform)
if not entry:
    sys.stderr.write(f"task {task_id} has no entrypoint for platform {platform}\n")
    sys.exit(4)
print(entry)
PY
)"

ENTRY_PATH="${SCRIPT_DIR}/${ENTRY}"
if [[ ! -f "${ENTRY_PATH}" ]]; then
  echo "error: entrypoint not found: ${ENTRY_PATH}" >&2
  exit 5
fi

case "${ENTRY_PATH}" in
  *.sh)  exec bash "${ENTRY_PATH}" "$@" ;;
  *.ps1) exec pwsh "${ENTRY_PATH}" "$@" ;;
  *)     exec "${ENTRY_PATH}" "$@" ;;
esac
