"""Tests for brainfactory.emit (multi-target command emission)."""

import shutil
import tempfile
import unittest
from pathlib import Path

from brainfactory import apply as a
from brainfactory import emit as e


class EmitTest(unittest.TestCase):
    def _provision(self, root: str) -> Path:
        dest = Path(root) / "brain"
        a.provision(dest=dest, project_name="Acme", project_slug="acme",
                    brain_repo="acme/acme-autonomy-system", command_prefix="ac")
        return dest

    def test_emits_three_targets_equally(self):
        with tempfile.TemporaryDirectory() as d:
            dest = self._provision(d)
            res = e.emit_targets(dest)
            self.assertTrue(res.ok)
            n = len(res.commands)
            self.assertGreater(n, 0)
            self.assertEqual(len(list((dest / ".claude" / "skills").rglob("SKILL.md"))), n)
            self.assertEqual(len(list((dest / ".github" / "skills").rglob("SKILL.md"))), n)
            self.assertEqual(len(list((dest / ".github" / "agents").glob("*.agent.md"))), n)
            agent = (dest / ".github" / "agents" / "ac-status.agent.md").read_text(
                encoding="utf-8")
            self.assertTrue(agent.startswith("---"))
            self.assertIn("name: ac-status", agent)

    def test_idempotent_and_prunes_stale(self):
        with tempfile.TemporaryDirectory() as d:
            dest = self._provision(d)
            first = len(e.emit_targets(dest).commands)
            self.assertEqual(len(e.emit_targets(dest).commands), first)
            shutil.rmtree(dest / "03-templates" / "agent-commands" / "core" / "status")
            res = e.emit_targets(dest)
            self.assertEqual(len(res.commands), first - 1)
            self.assertFalse(
                (dest / ".github" / "agents" / "ac-status.agent.md").exists())


if __name__ == "__main__":
    unittest.main()
