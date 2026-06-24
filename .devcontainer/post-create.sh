#!/usr/bin/env bash
set -euo pipefail

echo "Bootstrapping Brain Factory environment..."
if command -v python3 >/dev/null 2>&1; then
  python3 --version
fi
if command -v node >/dev/null 2>&1; then
  node --version
fi
if command -v npm >/dev/null 2>&1; then
  npm --version
fi
if command -v gh >/dev/null 2>&1; then
  gh --version | head -n 1
fi
echo "Environment bootstrap complete."
