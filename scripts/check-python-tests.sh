#!/usr/bin/env bash
# Run the brainfactory Python unit tests (standard library only; no deps).
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root/brain-factory/adapters/python"

python3 -m unittest discover -s tests -p "test_*.py"
