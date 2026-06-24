#!/usr/bin/env bash
# Thin wrapper: locate python3 and run `python -m brainfactory intent-gate ...`.
# All arguments are passed through unchanged.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PYDIR="$(cd "${SCRIPT_DIR}/../python" && pwd)"

PYTHON_BIN="${PYTHON_BIN:-}"
if [[ -z "${PYTHON_BIN}" ]]; then
  if command -v python3 >/dev/null 2>&1; then
    PYTHON_BIN="python3"
  elif command -v python >/dev/null 2>&1; then
    PYTHON_BIN="python"
  else
    echo "error: python3 not found on PATH" >&2
    exit 127
  fi
fi

export PYTHONPATH="${PYDIR}${PYTHONPATH:+:${PYTHONPATH}}"
exec "${PYTHON_BIN}" -m brainfactory intent-gate "$@"
