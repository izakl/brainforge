"""brainfactory — the executable onboarding engine for the brain-factory.

This package is the cross-platform source of truth for onboarding a project
brain. It provides:

- substitute : placeholder substitution + template-tree instantiation
- manifest   : build and validate a brain.manifest.json
- inspect    : the read-only repo inspector (Mode B, inspect-first)
- apply      : the applier (provision-new / adopt-existing)
- cli        : the argparse command-line interface

The bash/ and powershell/ wrappers in the parent directory are thin shells over
``python -m brainfactory`` so behaviour stays identical across runtimes.
"""

from __future__ import annotations

__all__ = [
    "substitute",
    "manifest",
    "inspect",
    "apply",
]

__version__ = "0.1.1"
