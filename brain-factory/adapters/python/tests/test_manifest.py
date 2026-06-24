"""Tests for brainfactory.manifest (build + validate, incl. agent_runtimes)."""

import json
import unittest
from pathlib import Path

from brainfactory import manifest as m

HUB = Path(__file__).resolve().parents[3]
EXAMPLE = HUB / "brain-template" / "brain.manifest.example.json"


class ManifestTest(unittest.TestCase):
    def test_example_validates(self):
        data = json.loads(EXAMPLE.read_text(encoding="utf-8"))
        self.assertEqual(m.validate_manifest(data, None), [])

    def test_build_defaults_runtime_none(self):
        man = m.build_manifest(
            project_name="Acme", project_slug="acme",
            brain_repo="acme/acme-autonomy-system", command_prefix="ac",
            platforms=["bash", "python"], mode="provision-new")
        self.assertEqual(man["agent_runtimes"], ["none"])
        self.assertEqual(m.validate_manifest(man, None), [])

    def test_build_preserves_runtimes(self):
        man = m.build_manifest(
            project_name="Acme", project_slug="acme",
            brain_repo="acme/acme-autonomy-system", command_prefix="ac",
            platforms=["bash"], agent_runtimes=["claude", "copilot"],
            mode="provision-new")
        self.assertEqual(man["agent_runtimes"], ["claude", "copilot"])

    def test_structural_rejects_bad_runtime(self):
        data = json.loads(EXAMPLE.read_text(encoding="utf-8"))
        data["agent_runtimes"] = ["none", "gpt5"]
        self.assertTrue(any("agent_runtime" in e for e in m._structural_validate(data)))

    def test_structural_rejects_bad_platform(self):
        data = json.loads(EXAMPLE.read_text(encoding="utf-8"))
        data["platforms"] = ["bash", "cobol"]
        self.assertTrue(any("platform" in e for e in m._structural_validate(data)))

    def test_structural_requires_core_keys(self):
        errs = m._structural_validate({"manifest_version": "1.0.0"})
        self.assertTrue(any("project" in e for e in errs))

    def test_invalid_mode_raises(self):
        with self.assertRaises(ValueError):
            m.build_manifest(
                project_name="A", project_slug="a", brain_repo="a/a",
                command_prefix="ac", platforms=["bash"], mode="bogus")


if __name__ == "__main__":
    unittest.main()
