"""Parity/regression tests for the cross-platform adapter seam.

``adapters/tasks.json`` declares each ops capability once, with a per-platform
entrypoint. The ``python`` entrypoint is the source of truth; ``bash`` and
``powershell`` are thin wrappers that ``exec python -m brainfactory <subcmd>``.
These tests guard the seam: every task resolves through the dispatcher, every
declared entrypoint exists, and each wrapper delegates to the same CLI
subcommand identically (stdout + exit code) as calling python directly.

Every CLI subcommand exposes a deterministic, side-effect-free ``--help``, so we
compare ``run.sh <task> --help`` against ``python -m brainfactory <subcmd>
--help``. PowerShell assertions are skipped where ``pwsh`` is unavailable (e.g.
local dev) and run on CI (GitHub-hosted ubuntu ships pwsh).
"""

from __future__ import annotations

import json
import os
import shutil
import subprocess
import sys
import unittest
from pathlib import Path

ADAPTERS = Path(__file__).resolve().parents[2]  # .../brain-factory/adapters
PYDIR = ADAPTERS / "python"
RUN_SH = ADAPTERS / "run.sh"
RUN_PS1 = ADAPTERS / "run.ps1"
TASKS = json.loads((ADAPTERS / "tasks.json").read_text(encoding="utf-8"))["tasks"]

# task id -> (dispatcher args, equivalent `python -m brainfactory` args).
# `--help` short-circuits argparse before required-arg validation, so it is a
# safe, deterministic probe for every subcommand. `apply-brain` takes the
# subcommand (provision|adopt) as its first argument.
INVOCATIONS = {
    "inspect-repo": (["inspect-repo", "--help"], ["inspect", "--help"]),
    "apply-brain": (["apply-brain", "provision", "--help"], ["provision", "--help"]),
    "generate-capabilities": (["generate-capabilities", "--help"], ["capabilities", "--help"]),
    "docs-mesh": (["docs-mesh", "--help"], ["docs-mesh", "--help"]),
    "intent-gate": (["intent-gate", "--help"], ["intent-gate", "--help"]),
    "emit-commands": (["emit-commands", "--help"], ["emit-commands", "--help"]),
    "upgrade-brain": (["upgrade-brain", "--help"], ["upgrade", "--help"]),
}


def _env(platform: str | None = None) -> dict:
    env = dict(os.environ)
    prev = env.get("PYTHONPATH")
    env["PYTHONPATH"] = str(PYDIR) + (os.pathsep + prev if prev else "")
    if platform:
        env["PLATFORM"] = platform
    return env


def _py(args):
    return subprocess.run(
        [sys.executable, "-m", "brainfactory", *args],
        capture_output=True, text=True, env=_env(), cwd=str(PYDIR),
    )


def _run_sh(args, platform="bash"):
    return subprocess.run(
        ["bash", str(RUN_SH), *args],
        capture_output=True, text=True, env=_env(platform),
    )


class TestTasksJson(unittest.TestCase):
    def test_every_declared_entrypoint_exists(self):
        for tid, spec in TASKS.items():
            for plat in ("bash", "powershell"):
                rel = spec.get(plat)
                self.assertTrue(rel, f"{tid}: missing {plat} entrypoint in tasks.json")
                self.assertTrue(
                    (ADAPTERS / rel).is_file(),
                    f"{tid}: {plat} entrypoint does not exist: {rel}",
                )

    def test_invocation_table_covers_all_tasks(self):
        # Forces this test file to be updated whenever a task is added/removed.
        self.assertEqual(set(INVOCATIONS), set(TASKS))


class TestDispatcher(unittest.TestCase):
    def test_no_args_prints_usage(self):
        r = _run_sh([])
        self.assertEqual(r.returncode, 2)
        self.assertIn("usage", (r.stderr + r.stdout).lower())

    def test_unknown_task_exits_3(self):
        r = _run_sh(["no-such-task"])
        self.assertEqual(r.returncode, 3)
        self.assertIn("unknown task", r.stderr.lower())

    def test_unknown_platform_exits_4(self):
        # PLATFORM with no entrypoint in tasks.json -> dispatcher exit 4.
        # (The "python" entry is descriptive, not a runnable path: python is the
        # source of truth, invoked directly, not through the dispatcher.)
        r = _run_sh(["inspect-repo", "--help"], platform="no-such-platform")
        self.assertEqual(r.returncode, 4, r.stderr)


class TestBashParity(unittest.TestCase):
    """Filled dynamically below — one method per task."""


def _make_bash_test(tid, disp_args, py_args):
    def test(self):
        want = _py(py_args)
        got = _run_sh(disp_args, platform="bash")
        self.assertEqual(got.returncode, want.returncode,
                         f"{tid}: exit code mismatch (bash={got.returncode} py={want.returncode})\n{got.stderr}")
        self.assertEqual(got.stdout, want.stdout, f"{tid}: stdout differs from python source of truth")
    return test


@unittest.skipUnless(shutil.which("pwsh"), "pwsh not available (runs on CI)")
class TestPowerShellParity(unittest.TestCase):
    """Filled dynamically below — one method per task."""


def _make_ps_test(tid, disp_args, py_args):
    def test(self):
        want = _py(py_args)
        got = subprocess.run(
            ["pwsh", "-NoProfile", "-File", str(RUN_PS1), *disp_args],
            capture_output=True, text=True, env=_env(),
        )
        self.assertEqual(got.returncode, want.returncode,
                         f"{tid}: exit code mismatch (pwsh={got.returncode} py={want.returncode})\n{got.stderr}")
        self.assertEqual(got.stdout.replace("\r\n", "\n"), want.stdout,
                         f"{tid}: stdout differs from python source of truth")
    return test


for _tid, (_disp, _py_args) in INVOCATIONS.items():
    _name = _tid.replace("-", "_")
    setattr(TestBashParity, f"test_bash_parity_{_name}", _make_bash_test(_tid, _disp, _py_args))
    setattr(TestPowerShellParity, f"test_ps_parity_{_name}", _make_ps_test(_tid, _disp, _py_args))


if __name__ == "__main__":
    unittest.main()
