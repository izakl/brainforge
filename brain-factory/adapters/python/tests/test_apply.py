"""Tests for brainfactory.apply (provision + adopt dry-run)."""

import json
import tempfile
import unittest
from pathlib import Path

from brainfactory import apply as a
from brainfactory import manifest as m


class ProvisionTest(unittest.TestCase):
    def test_provision_writes_valid_brain(self):
        with tempfile.TemporaryDirectory() as d:
            dest = Path(d) / "brain"
            a.provision(dest=dest, project_name="Acme", project_slug="acme",
                        brain_repo="acme/acme-autonomy-system", command_prefix="ac")
            man = json.loads((dest / "brain.manifest.json").read_text(encoding="utf-8"))
            self.assertEqual(m.validate_manifest(man, None), [])
            self.assertEqual(man["agent_runtimes"], ["none"])
            agents = (dest / "AGENTS.md").read_text(encoding="utf-8")
            self.assertIn("Acme brain", agents)
            self.assertNotIn("{{", agents)
            claude = (dest / "CLAUDE.md").read_text(encoding="utf-8")
            copilot = (dest / ".github" / "copilot-instructions.md").read_text(
                encoding="utf-8")
            self.assertIn("SYNC-LATEST-FIRST STANDARD", agents)
            self.assertIn("CLEANUP-NO-STALE-STATE STANDARD", agents)
            self.assertIn("SYNC-LATEST-FIRST STANDARD", claude)
            self.assertIn("CLEANUP-NO-STALE-STATE STANDARD", claude)
            self.assertIn("SYNC-LATEST-FIRST STANDARD", copilot)
            self.assertIn("CLEANUP-NO-STALE-STATE STANDARD", copilot)

    def test_provision_refuses_nonempty_dest(self):
        with tempfile.TemporaryDirectory() as d:
            dest = Path(d)
            (dest / "x").write_text("x", encoding="utf-8")
            with self.assertRaises(FileExistsError):
                a.provision(dest=dest, project_name="A", project_slug="a",
                            brain_repo="a/a", command_prefix="ac")


class AdoptTest(unittest.TestCase):
    def test_adopt_dry_run_writes_nothing(self):
        with tempfile.TemporaryDirectory() as d:
            target = Path(d) / "repo"
            target.mkdir()
            (target / "README.md").write_text("# repo", encoding="utf-8")
            res = a.adopt(target=target, project_name="Acme", project_slug="acme",
                          brain_repo="acme/acme-autonomy-system",
                          command_prefix="ac", apply=False)
            self.assertTrue(res.dry_run)
            self.assertFalse((target / "brain.manifest.json").exists())


if __name__ == "__main__":
    unittest.main()
