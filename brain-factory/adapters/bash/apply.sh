#!/usr/bin/env bash
# Thin wrapper over `python -m brainfactory`. The first argument selects the
# subcommand (provision | adopt); the rest pass through unchanged.
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

if [[ $# -lt 1 ]]; then
  echo "usage: apply.sh <provision|adopt> [args...]" >&2
  exit 2
fi

export PYTHONPATH="${PYDIR}${PYTHONPATH:+:${PYTHONPATH}}"
exec "${PYTHON_BIN}" -m brainfactory "$@"
