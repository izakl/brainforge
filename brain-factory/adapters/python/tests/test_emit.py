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

    def test_agent_md_omits_undeclared_tools_and_model(self):
        front = e._agent_md("n", "desc", "the body").split("---")[1]
        self.assertIn("name: n", front)
        self.assertNotIn("tools:", front)
        self.assertNotIn("model:", front)

    def test_agent_md_carries_declared_tools_and_model(self):
        with tempfile.TemporaryDirectory() as d:
            dest = self._provision(d)
            skill = (dest / "03-templates" / "agent-commands" / "core"
                     / "status" / "SKILL.md")
            lines = skill.read_text(encoding="utf-8").splitlines()
            close = next(i for i in range(1, len(lines))
                         if lines[i].strip() == "---")
            lines[close:close] = ["tools: [read, edit]", "model: example-model"]
            skill.write_text("\n".join(lines) + "\n", encoding="utf-8")

            e.emit_targets(dest)
            agents = dest / ".github" / "agents"
            declared = (agents / "ac-status.agent.md").read_text(encoding="utf-8")
            self.assertIn("tools: [read, edit]", declared)
            self.assertIn("model: example-model", declared)

            # An undeclared command keeps a clean frontmatter (no empty fields).
            other = next(p for p in sorted(agents.glob("*.agent.md"))
                         if p.name != "ac-status.agent.md")
            other_front = other.read_text(encoding="utf-8").split("---")[1]
            self.assertNotIn("tools:", other_front)
            self.assertNotIn("model:", other_front)


if __name__ == "__main__":
    unittest.main()
