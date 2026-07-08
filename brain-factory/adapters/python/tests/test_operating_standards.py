"""Regression checks for permanent operating standards across toolchains."""

from __future__ import annotations

import unittest
from pathlib import Path

ANCHORS = (
    "SYNC-LATEST-FIRST STANDARD",
    "CLEANUP-NO-STALE-STATE STANDARD",
    "CONTINUITY-CAPTURE / BRAIN-MEMORY WRITEBACK STANDARD",
)

REQUIRED_FILES = (
    "AGENTS.md",
    ".github/copilot-instructions.md",
    "CLAUDE.md",
    "brain-factory/brain-template/AGENTS.md.tmpl",
    "brain-factory/brain-template/.github/copilot-instructions.md.tmpl",
    "brain-factory/brain-template/CLAUDE.md.tmpl",
)


class OperatingStandardsPresenceTest(unittest.TestCase):
    def test_anchors_exist_in_all_required_files(self):
        repo_root = Path(__file__).resolve().parents[4]
        for rel in REQUIRED_FILES:
            path = repo_root / rel
            self.assertTrue(path.is_file(), f"missing required file: {rel}")
            content = path.read_text(encoding="utf-8")
            for anchor in ANCHORS:
                self.assertIn(
                    anchor,
                    content,
                    f"{rel} missing required operating standard anchor: {anchor}",
                )


if __name__ == "__main__":
    unittest.main()
