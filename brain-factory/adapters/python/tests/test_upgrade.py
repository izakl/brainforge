"""Tests for brainfactory.upgrade (down-sync execution)."""

import json
import tempfile
import unittest
from pathlib import Path

from brainfactory import apply as a
from brainfactory import manifest as m
from brainfactory import upgrade as u


def _provision(root: str) -> Path:
    dest = Path(root) / "brain"
    a.provision(dest=dest, project_name="Acme", project_slug="acme",
                brain_repo="acme/acme-autonomy-system", command_prefix="ac")
    return dest


def _load(brain: Path) -> dict:
    return json.loads((brain / "brain.manifest.json").read_text(encoding="utf-8"))


def _save(brain: Path, man: dict) -> None:
    (brain / "brain.manifest.json").write_text(
        json.dumps(man, indent=2) + "\n", encoding="utf-8")


def _set_gap(brain: Path, old: str = "0.0.1") -> dict:
    man = _load(brain)
    man["framework_version"] = old
    _save(brain, man)
    return man


class UpgradeTest(unittest.TestCase):
    def test_up_to_date_is_noop(self):
        with tempfile.TemporaryDirectory() as d:
            brain = _provision(d)  # provisioned at the latest version
            res = u.upgrade(brain=brain)
            self.assertTrue(res.up_to_date)
            self.assertEqual(res.planned, [])
            self.assertEqual(res.written, [])
            # apply at latest is also a no-op (no log, manifest untouched).
            res2 = u.upgrade(brain=brain, apply=True)
            self.assertEqual(res2.written, [])
            self.assertIsNone(res2.log_path)

    def test_dry_run_plans_but_writes_nothing(self):
        with tempfile.TemporaryDirectory() as d:
            brain = _provision(d)
            _set_gap(brain)
            res = u.upgrade(brain=brain)
            self.assertTrue(res.dry_run)
            self.assertFalse(res.up_to_date)
            self.assertGreater(len(res.planned), 0)
            self.assertEqual(res.written, [])
            # manifest is untouched on a dry-run.
            self.assertEqual(_load(brain)["framework_version"], "0.0.1")

    def test_apply_refreshes_bumps_and_is_idempotent(self):
        with tempfile.TemporaryDirectory() as d:
            brain = _provision(d)
            latest = m.read_framework_version(None)
            _set_gap(brain)
            # Corrupt a hub-owned core file: apply must restore it from template.
            contract = brain / "00-governance" / "OPERATING-CONTRACT.md"
            self.assertTrue(contract.is_file())
            contract.write_text("DRIFT", encoding="utf-8")

            res = u.upgrade(brain=brain, apply=True)
            self.assertGreater(len(res.written), 0)
            self.assertIn("00-governance/OPERATING-CONTRACT.md", res.written)
            self.assertNotEqual(contract.read_text(encoding="utf-8"), "DRIFT")

            after = _load(brain)
            self.assertEqual(after["framework_version"], latest)
            self.assertEqual(
                after["core_modules"]["operating-contract"]["synced_from"], latest)
            self.assertIn("operating-contract", res.synced_modules)
            self.assertIsNotNone(res.log_path)
            self.assertTrue((brain / res.log_path).is_file())

            # Re-running apply with no gap is now a no-op.
            res2 = u.upgrade(brain=brain, apply=True)
            self.assertTrue(res2.up_to_date)
            self.assertEqual(res2.written, [])

    def test_force_repairs_drift_at_latest(self):
        with tempfile.TemporaryDirectory() as d:
            brain = _provision(d)  # already at latest
            agents = brain / "AGENTS.md"
            agents.write_text("DRIFT", encoding="utf-8")
            # No version gap: a plain apply does nothing, leaving the drift.
            noop = u.upgrade(brain=brain, apply=True)
            self.assertEqual(noop.written, [])
            self.assertEqual(agents.read_text(encoding="utf-8"), "DRIFT")
            # --force re-materialises the hub-owned core and repairs it.
            forced = u.upgrade(brain=brain, apply=True, force=True)
            self.assertGreater(len(forced.written), 0)
            self.assertNotEqual(agents.read_text(encoding="utf-8"), "DRIFT")

    def test_manual_review_modules_are_not_overwritten(self):
        with tempfile.TemporaryDirectory() as d:
            brain = _provision(d)
            man = _set_gap(brain)
            man["core_modules"]["decision-board"]["adopted"] = False
            _save(brain, man)
            db = brain / "00-governance" / "consensus" / "decision-board.md"
            db.parent.mkdir(parents=True, exist_ok=True)
            db.write_text("PROJECT OWNED", encoding="utf-8")

            res = u.upgrade(brain=brain, apply=True)
            self.assertIn("decision-board", res.manual_review)
            self.assertNotIn("decision-board", res.synced_modules)
            self.assertFalse(any(p.module == "decision-board" for p in res.planned))
            self.assertEqual(db.read_text(encoding="utf-8"), "PROJECT OWNED")

    def test_disabled_module_is_skipped(self):
        with tempfile.TemporaryDirectory() as d:
            brain = _provision(d)
            man = _set_gap(brain)
            man["core_modules"]["docs-mesh"]["enabled"] = False
            _save(brain, man)
            res = u.upgrade(brain=brain)
            self.assertIn("docs-mesh", res.disabled)
            self.assertFalse(any(p.module == "docs-mesh" for p in res.planned))

    def test_project_extensions_are_preserved(self):
        with tempfile.TemporaryDirectory() as d:
            brain = _provision(d)
            _set_gap(brain)
            ext = (brain / "03-templates" / "agent-commands" / "extensions"
                   / "ac-deploy" / "SKILL.md")
            ext.parent.mkdir(parents=True, exist_ok=True)
            ext.write_text("PROJECT EXTENSION", encoding="utf-8")
            res = u.upgrade(brain=brain, apply=True)
            self.assertEqual(ext.read_text(encoding="utf-8"), "PROJECT EXTENSION")
            self.assertFalse(any("extensions" in w.split("/") for w in res.written))

    def test_missing_manifest_raises(self):
        with tempfile.TemporaryDirectory() as d:
            empty = Path(d) / "not-a-brain"
            empty.mkdir()
            with self.assertRaises(FileNotFoundError):
                u.upgrade(brain=empty)


if __name__ == "__main__":
    unittest.main()
