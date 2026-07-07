"""Tests for the capabilities generator's command-dir naming guard.

The generator derives a command's invocation as ``<prefix>-<base>``. A command
directory whose base already starts with ``<prefix>-`` doubles the prefix (the
``ap-ap-*`` bug that bit the Contoso brain). :func:`build_model` must refuse such
a brain so ``--check``, ``--write`` and the intent gate all fail rather than
silently emitting a doubled invocation. These tests prove the guard catches the
offense, stays silent on correctly bare directories, and that the hub's own
shipped ``brain-template`` command dirs are clean.
"""

from __future__ import annotations

import json
import os
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

from brainfactory import capabilities as cap

ADAPTERS = Path(__file__).resolve().parents[2]        # .../brain-factory/adapters
PYDIR = ADAPTERS / "python"
BRAIN_TEMPLATE = ADAPTERS.parent / "brain-template"   # .../brain-factory/brain-template


def _make_brain(root: Path, prefix: str,
                dirs: list[tuple[str, str]], *, manifest: bool = True) -> Path:
    """Build a minimal brain: a manifest plus one SKILL.md per command dir."""
    brain = root / "brain"
    brain.mkdir()
    if manifest:
        (brain / "brain.manifest.json").write_text(
            json.dumps({"command_prefix": prefix, "project": {"name": "T"}}),
            encoding="utf-8")
    for layer, name in dirs:
        cmd = brain / "03-templates" / "agent-commands" / layer / name
        cmd.mkdir(parents=True)
        (cmd / "SKILL.md").write_text(
            "---\ndescription: demo\n---\nbody\n", encoding="utf-8")
    return brain


def _run_cli(args: list[str], cwd: str) -> subprocess.CompletedProcess:
    env = dict(os.environ)
    prev = env.get("PYTHONPATH")
    env["PYTHONPATH"] = str(PYDIR) + (os.pathsep + prev if prev else "")
    return subprocess.run(
        [sys.executable, "-m", "brainfactory", *args],
        capture_output=True, text=True, env=env, cwd=cwd)


class NamingGuardModelTest(unittest.TestCase):
    def test_build_model_raises_on_prefixed_core_dir(self):
        with tempfile.TemporaryDirectory() as d:
            brain = _make_brain(Path(d), "ap",
                                [("core", "ap-foo"), ("core", "bar")])
            with self.assertRaises(cap.CommandNamingError) as ctx:
                cap.build_model(brain)
            msg = str(ctx.exception)
            self.assertIn("ap-foo", msg)
            self.assertIn("ap-ap-foo", msg)       # names the doubled invocation
            self.assertIn("core/foo", msg)        # actionable bare rename
            self.assertEqual([c.base for c in ctx.exception.offenders], ["ap-foo"])
            self.assertEqual(ctx.exception.prefix, "ap")

    def test_build_model_raises_on_prefixed_extension_dir(self):
        with tempfile.TemporaryDirectory() as d:
            brain = _make_brain(Path(d), "ap", [("extensions", "ap-deploy")])
            with self.assertRaises(cap.CommandNamingError):
                cap.build_model(brain)

    def test_build_model_passes_on_bare_dirs(self):
        with tempfile.TemporaryDirectory() as d:
            brain = _make_brain(Path(d), "ap",
                                [("core", "foo"), ("extensions", "bar")])
            model = cap.build_model(brain)
            invs = [c.invocation("ap")
                    for c in model.core_commands + model.extension_commands]
            self.assertEqual(sorted(invs), ["ap-bar", "ap-foo"])

    def test_substring_prefix_is_not_flagged(self):
        # Only a leading "<prefix>-" is the bug; a base that merely starts with
        # the prefix letters (or contains them) must be allowed.
        with tempfile.TemporaryDirectory() as d:
            brain = _make_brain(Path(d), "ap",
                                [("core", "apply"), ("core", "map-ap")])
            model = cap.build_model(brain)        # must NOT raise
            self.assertEqual(len(model.core_commands), 2)


class NamingGuardCheckWriteTest(unittest.TestCase):
    def test_check_raises_and_write_refuses_to_emit(self):
        with tempfile.TemporaryDirectory() as d:
            brain = _make_brain(Path(d), "ap", [("core", "ap-foo")])
            with self.assertRaises(cap.CommandNamingError):
                cap.check(brain)
            with self.assertRaises(cap.CommandNamingError):
                cap.write(brain)
            # write must NOT have produced the (doubled) map.
            self.assertFalse((brain / "01-docs" / "CAPABILITIES.md").exists())

    def test_intent_gate_raises_on_prefixed_dir(self):
        with tempfile.TemporaryDirectory() as d:
            brain = _make_brain(Path(d), "ap", [("core", "ap-foo")])
            with self.assertRaises(cap.CommandNamingError):
                cap.intent_gate(brain)


class FindPrefixedCommandDirsTest(unittest.TestCase):
    def test_reports_all_offenders_without_raising(self):
        with tempfile.TemporaryDirectory() as d:
            brain = _make_brain(Path(d), "ap",
                                [("core", "ap-foo"), ("extensions", "ap-bar"),
                                 ("core", "ok")])
            offenders = cap.find_prefixed_command_dirs(brain)  # prefix from manifest
            self.assertEqual(sorted(c.base for c in offenders),
                             ["ap-bar", "ap-foo"])

    def test_explicit_prefix_overrides_manifest(self):
        with tempfile.TemporaryDirectory() as d:
            brain = _make_brain(Path(d), "ap", [("core", "zz-foo")])
            self.assertEqual(cap.find_prefixed_command_dirs(brain), [])
            hits = cap.find_prefixed_command_dirs(brain, prefix="zz")
            self.assertEqual([c.base for c in hits], ["zz-foo"])


class HubTemplateCleanTest(unittest.TestCase):
    def test_brain_template_command_dirs_are_bare(self):
        # Hub self-guard: the shipped brain-template command dirs must be bare
        # against the example manifest's command_prefix (same check CI runs).
        example = BRAIN_TEMPLATE / "brain.manifest.example.json"
        prefix = json.loads(example.read_text(encoding="utf-8")).get("command_prefix")
        self.assertTrue(prefix, "example manifest is missing command_prefix")
        offenders = cap.find_prefixed_command_dirs(BRAIN_TEMPLATE, prefix)
        self.assertEqual(
            offenders, [],
            "brain-template command dirs must be bare, found: "
            + ", ".join(f"{c.layer}/{c.base}" for c in offenders))


class NamingGuardCliTest(unittest.TestCase):
    def test_cli_check_exits_1_with_clean_message(self):
        with tempfile.TemporaryDirectory() as d:
            brain = _make_brain(Path(d), "ap", [("core", "ap-foo")])
            r = _run_cli(["capabilities", "--brain", str(brain), "--check"], cwd=d)
            self.assertEqual(r.returncode, 1, r.stderr)
            self.assertIn("naming error", r.stdout.lower())
            self.assertIn("ap-ap-foo", r.stdout)
            self.assertNotIn("Traceback", r.stderr)   # clean failure, not a crash

    def test_cli_write_then_check_exit_0_on_bare(self):
        with tempfile.TemporaryDirectory() as d:
            brain = _make_brain(Path(d), "ap", [("core", "foo")])
            w = _run_cli(["capabilities", "--brain", str(brain), "--write"], cwd=d)
            self.assertEqual(w.returncode, 0, w.stderr)
            self.assertTrue((brain / "01-docs" / "CAPABILITIES.md").is_file())
            r = _run_cli(["capabilities", "--brain", str(brain), "--check"], cwd=d)
            self.assertEqual(r.returncode, 0, r.stdout + r.stderr)


if __name__ == "__main__":
    unittest.main()
