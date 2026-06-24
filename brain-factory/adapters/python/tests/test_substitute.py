"""Tests for brainfactory.substitute (token replacement + tree copy)."""

import tempfile
import unittest
from pathlib import Path

from brainfactory import substitute as s


class SubstituteTest(unittest.TestCase):
    def test_replaces_known_tokens(self):
        out = s.substitute("Hi {{PROJECT_NAME}} ({{CMD_PREFIX}})",
                           {"PROJECT_NAME": "Acme", "CMD_PREFIX": "ac"})
        self.assertEqual(out, "Hi Acme (ac)")

    def test_leaves_unknown_token(self):
        self.assertEqual(s.substitute("{{FOO}}", {}), "{{FOO}}")

    def test_rejects_unknown_mapping_key(self):
        with self.assertRaises(ValueError):
            s.substitute("x", {"NOPE": "1"})

    def test_strip_tmpl_suffix(self):
        self.assertEqual(s.strip_tmpl_suffix("A.md.tmpl"), "A.md")
        self.assertEqual(s.strip_tmpl_suffix("A.md"), "A.md")

    def test_find_unsubstituted(self):
        self.assertEqual(s.find_unsubstituted("{{A}} {{B}}"), {"A", "B"})

    def test_copy_tree_substituted(self):
        with tempfile.TemporaryDirectory() as d:
            src, dest = Path(d) / "src", Path(d) / "dest"
            (src / "sub").mkdir(parents=True)
            (src / "x.md.tmpl").write_text("Hi {{PROJECT_NAME}}", encoding="utf-8")
            (src / "plain.txt").write_text("{{PROJECT_NAME}}", encoding="utf-8")
            (src / "README.md").write_text("meta", encoding="utf-8")
            s.copy_tree_substituted(src, dest, {"PROJECT_NAME": "Acme"},
                                    exclude=frozenset({"README.md"}))
            # .tmpl is substituted and the suffix stripped
            self.assertEqual((dest / "x.md").read_text(encoding="utf-8"), "Hi Acme")
            # non-template files are copied verbatim (no substitution)
            self.assertEqual((dest / "plain.txt").read_text(encoding="utf-8"),
                             "{{PROJECT_NAME}}")
            # excluded files are skipped
            self.assertFalse((dest / "README.md").exists())


if __name__ == "__main__":
    unittest.main()
