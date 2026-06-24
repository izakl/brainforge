#!/usr/bin/env node
'use strict';

// Brain Factory CLI launcher for the npm/npx ecosystem.
//
// Brain Factory's engine is a Python package (`brainfactory`). This thin Node
// launcher forwards to it so `npx brainfactory ...` works for JS-ecosystem
// users — it runs no logic of its own. Resolution order:
//   1. an installed `brainfactory` console script (pipx / pip),
//   2. `python3 -m brainfactory` when the module is importable,
//   3. `pipx run brainfactory ...` (ephemeral; needs pipx),
//   4. otherwise, print install guidance and exit non-zero.
//
// Requires Python 3.10+ on PATH (the engine is Python; this is only a launcher).

const { spawnSync } = require('child_process');

const args = process.argv.slice(2);

// Run a command, inheriting stdio. Returns the exit code, or null if the
// command itself could not be spawned (e.g. not on PATH).
function tryRun(cmd, cmdArgs) {
  const r = spawnSync(cmd, cmdArgs, { stdio: 'inherit' });
  if (r.error) return null;
  return r.status === null ? 1 : r.status;
}

function probe(cmd, cmdArgs) {
  const r = spawnSync(cmd, cmdArgs, { stdio: 'ignore' });
  return !r.error && r.status === 0;
}

// 1. Installed console script — if present, this run IS the invocation.
let code = tryRun('brainfactory', args);
if (code !== null) process.exit(code);

// 2. The module under a Python on PATH (guarded by an import probe so we never
//    hand the user a confusing "No module named brainfactory" traceback).
for (const py of ['python3', 'python']) {
  if (probe(py, ['-c', 'import brainfactory'])) {
    code = tryRun(py, ['-m', 'brainfactory', ...args]);
    if (code !== null) process.exit(code);
  }
}

// 3. Ephemeral run via pipx.
if (probe('pipx', ['--version'])) {
  code = tryRun('pipx', ['run', 'brainfactory', ...args]);
  if (code !== null) process.exit(code);
}

// 4. Nothing available — guide the user to install the Python engine.
process.stderr.write(
  'Brain Factory could not find its Python engine.\n\n' +
  'Install it (Python 3.10+ required):\n' +
  '  pipx install brainfactory\n' +
  '  # or, before the PyPI publish:\n' +
  '  pipx install "git+https://github.com/izakl/brainforge' +
  '#subdirectory=brain-factory/adapters/python"\n\n' +
  'Then re-run `npx brainfactory ...`, or call `brainfactory` directly.\n'
);
process.exit(127);
