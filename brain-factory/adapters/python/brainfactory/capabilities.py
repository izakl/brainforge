"""Capabilities generator + intent gate (the self-extending brain — derived layer).

The capabilities map (``01-docs/CAPABILITIES.md``) is a DERIVED artifact: it is
regenerated from code so it cannot drift. Truth comes from:

- the brain's command set under ``03-templates/agent-commands/core/<base>/`` and
  ``.../extensions/<base>/`` (a command is a directory containing a ``SKILL.md``
  or ``SKILL.md.tmpl``); the description is read from the SKILL frontmatter;
- the ``brain.manifest.json`` for the command prefix, platforms,
  framework_version, and the coordinated ``app_repos``.

Three modes:
- ``--write``  : regenerate and write the file (what the capabilities command runs).
- ``--check``  : regenerate in-memory and diff against the on-disk file; non-zero
                 exit if they differ (what CI runs to forbid drift).
- the intent gate (:func:`intent_gate`) FAILS if a command directory exists with
  no matching row in the committed ``CAPABILITIES.md`` — "a feature cannot land
  without the brain growing with it".

Command discovery is guarded: :func:`build_model` raises
:class:`CommandNamingError` if any command directory's base name already starts
with ``<prefix>-`` (the ``ap-ap-*`` double-prefix bug), so ``--write``,
``--check`` and the intent gate all fail rather than silently emitting a doubled
invocation. :func:`find_prefixed_command_dirs` is the read-only companion.

Standard library only. Typed. Same code style as ``inspect.py``.
"""

from __future__ import annotations

import difflib
import json
from dataclasses import dataclass, field
from datetime import date
from pathlib import Path
from typing import Any

# Where commands live inside a brain.
_CORE_REL = "03-templates/agent-commands/core"
_EXT_REL = "03-templates/agent-commands/extensions"
# The generated capabilities map, relative to the brain root.
_CAPABILITIES_REL = "01-docs/CAPABILITIES.md"
# The brain manifest, relative to the brain root.
_MANIFEST_REL = "brain.manifest.json"

# Banner that marks the file as generated. Used both when writing and as a
# sanity marker; kept short so it survives reflow.
_BANNER = "GENERATED — do not hand-edit"


@dataclass
class CommandInfo:
    """One command discovered under core/ or extensions/."""

    base: str            # directory name, e.g. "sync"
    layer: str           # "core" | "extensions"
    description: str     # from SKILL frontmatter (or "" if none)
    skill_path: str      # relative-to-brain path of the SKILL file

    def invocation(self, prefix: str) -> str:
        return f"{prefix}-{self.base}"

    def to_dict(self) -> dict[str, Any]:
        return {
            "base": self.base,
            "layer": self.layer,
            "description": self.description,
            "skill_path": self.skill_path,
        }


class CommandNamingError(ValueError):
    """A command directory base name redundantly starts with the command prefix.

    The generator derives a command's invocation as ``<prefix>-<base>`` (see
    :meth:`CommandInfo.invocation`). If the directory base *already* starts with
    ``<prefix>-`` the invocation doubles the prefix — e.g. prefix ``ap`` and a
    directory ``ap-foo`` yield ``ap-ap-foo``. Command directories must use BARE
    names; this error stops such a map from ever being generated (it fails
    ``--check``, ``--write`` and the intent gate) so the bug can never silently
    ship.
    """

    def __init__(self, offenders: list[CommandInfo], prefix: str) -> None:
        self.offenders = list(offenders)
        self.prefix = prefix
        super().__init__(self._render(self.offenders, prefix))

    @staticmethod
    def _render(offenders: list[CommandInfo], prefix: str) -> str:
        n = len(offenders)
        noun = "directory" if n == 1 else "directories"
        verb = "is" if n == 1 else "are"
        lines = [
            f"{n} command {noun} {verb} mis-named with a redundant "
            f"'{prefix}-' prefix.",
            "The generator invokes a command as '<prefix>-<base>', so a "
            f"directory whose name already starts with '{prefix}-' doubles the "
            f"prefix (e.g. '{prefix}-{prefix}-...').",
            "Rename each directory to a BARE name:",
        ]
        for c in sorted(offenders, key=lambda o: (o.layer, o.base)):
            bare = c.base[len(prefix) + 1:] or "<name>"
            lines.append(
                f"  - {c.layer}/{c.base} -> {c.layer}/{bare} "
                f"(now invokes '{prefix}-{c.base}'; should be '{prefix}-{bare}')"
            )
        return "\n".join(lines)


@dataclass
class AppRepo:
    """One coordinated app repo from the manifest."""

    name: str
    role: str = ""

    def to_dict(self) -> dict[str, Any]:
        return {"name": self.name, "role": self.role}


@dataclass
class CapabilitiesModel:
    """Everything the capabilities map is rendered from."""

    project_name: str
    command_prefix: str
    framework_version: str
    platforms: list[str]
    core_commands: list[CommandInfo]
    extension_commands: list[CommandInfo]
    app_repos: list[AppRepo] = field(default_factory=list)

    def to_dict(self) -> dict[str, Any]:
        return {
            "project_name": self.project_name,
            "command_prefix": self.command_prefix,
            "framework_version": self.framework_version,
            "platforms": self.platforms,
            "core_commands": [c.to_dict() for c in self.core_commands],
            "extension_commands": [c.to_dict() for c in self.extension_commands],
            "app_repos": [a.to_dict() for a in self.app_repos],
        }


# ---------------------------------------------------------------------------
# Discovery
# ---------------------------------------------------------------------------

def _read_manifest(brain: Path) -> dict[str, Any]:
    """Read brain.manifest.json if present; return {} otherwise."""
    path = brain / _MANIFEST_REL
    if not path.is_file():
        return {}
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except (OSError, ValueError):
        return {}


def _skill_file(cmd_dir: Path) -> Path | None:
    """Return the SKILL file for a command dir, preferring the rendered form.

    A command directory qualifies if it contains ``SKILL.md`` (a provisioned
    brain) or ``SKILL.md.tmpl`` (the un-rendered template).
    """
    rendered = cmd_dir / "SKILL.md"
    if rendered.is_file():
        return rendered
    tmpl = cmd_dir / "SKILL.md.tmpl"
    if tmpl.is_file():
        return tmpl
    return None


def _parse_frontmatter_description(skill_path: Path) -> str:
    """Extract the ``description:`` field from a SKILL file's YAML frontmatter.

    The frontmatter is a leading ``---`` fenced block. Only the single-line
    ``description:`` key is read (no third-party YAML parser). Returns "" if
    absent. Surrounding quotes are stripped.
    """
    try:
        text = skill_path.read_text(encoding="utf-8")
    except OSError:
        return ""
    lines = text.splitlines()
    if not lines or lines[0].strip() != "---":
        return ""
    for line in lines[1:]:
        stripped = line.strip()
        if stripped == "---":
            break
        if stripped.lower().startswith("description:"):
            value = stripped.split(":", 1)[1].strip()
            if len(value) >= 2 and value[0] in "\"'" and value[-1] == value[0]:
                value = value[1:-1]
            return value
    return ""


def _discover_commands(brain: Path, layer_rel: str, layer: str) -> list[CommandInfo]:
    """Discover commands under a layer dir. Sorted by base name for determinism."""
    layer_dir = brain / layer_rel
    if not layer_dir.is_dir():
        return []
    found: list[CommandInfo] = []
    for cmd_dir in sorted(layer_dir.iterdir(), key=lambda p: p.name):
        if not cmd_dir.is_dir():
            continue
        skill = _skill_file(cmd_dir)
        if skill is None:
            continue
        rel = skill.relative_to(brain).as_posix()
        found.append(CommandInfo(
            base=cmd_dir.name,
            layer=layer,
            description=_parse_frontmatter_description(skill),
            skill_path=rel,
        ))
    return found


def _prefixed_offenders(
    commands: list[CommandInfo], prefix: str,
) -> list[CommandInfo]:
    """Command dirs whose base name already starts with ``<prefix>-``.

    These are the double-prefix bug: the generator would render their invocation
    as ``<prefix>-<prefix>-...``. An empty prefix disables the check.
    """
    if not prefix:
        return []
    token = f"{prefix}-"
    return [c for c in commands if c.base.startswith(token)]


def find_prefixed_command_dirs(
    brain: str | Path, prefix: str | None = None,
) -> list[CommandInfo]:
    """Return command dirs whose base redundantly starts with ``<prefix>-``.

    Read-only companion to the guard baked into :func:`build_model`: it never
    raises, so callers (e.g. the hub self-check) can report *all* offenders at
    once. ``prefix`` defaults to the brain manifest's ``command_prefix`` (or
    ``"cmd"`` when unset), matching :func:`build_model`.
    """
    root = Path(brain).resolve()
    if prefix is None:
        prefix = _read_manifest(root).get("command_prefix") or "cmd"
    commands = [
        *_discover_commands(root, _CORE_REL, "core"),
        *_discover_commands(root, _EXT_REL, "extensions"),
    ]
    return _prefixed_offenders(commands, prefix)


def build_model(brain: str | Path) -> CapabilitiesModel:
    """Scan a brain directory and assemble the capabilities model from code."""
    root = Path(brain).resolve()
    if not root.is_dir():
        raise NotADirectoryError(f"Brain directory not found: {root}")

    manifest = _read_manifest(root)
    project = manifest.get("project", {}) if isinstance(manifest, dict) else {}
    project_name = project.get("name") or root.name
    command_prefix = manifest.get("command_prefix") or "cmd"
    framework_version = manifest.get("framework_version") or "unknown"
    platforms = list(manifest.get("platforms") or [])

    app_repos: list[AppRepo] = []
    for entry in manifest.get("app_repos", []) or []:
        if isinstance(entry, dict) and entry.get("name"):
            app_repos.append(AppRepo(name=entry["name"], role=entry.get("role", "")))

    core_commands = _discover_commands(root, _CORE_REL, "core")
    extension_commands = _discover_commands(root, _EXT_REL, "extensions")

    offenders = _prefixed_offenders(
        [*core_commands, *extension_commands], command_prefix)
    if offenders:
        raise CommandNamingError(offenders, command_prefix)

    return CapabilitiesModel(
        project_name=project_name,
        command_prefix=command_prefix,
        framework_version=framework_version,
        platforms=platforms,
        core_commands=core_commands,
        extension_commands=extension_commands,
        app_repos=app_repos,
    )


# ---------------------------------------------------------------------------
# Rendering
# ---------------------------------------------------------------------------

def _escape_cell(text: str) -> str:
    """Make a string safe inside a markdown table cell."""
    return text.replace("|", "\\|").replace("\n", " ").strip()


def _render_command_table(commands: list[CommandInfo], prefix: str) -> list[str]:
    lines = ["| Command | Description |", "| --- | --- |"]
    for cmd in commands:
        desc = _escape_cell(cmd.description) or "_(no description)_"
        lines.append(f"| `{cmd.invocation(prefix)}` | {desc} |")
    return lines


def render_markdown(model: CapabilitiesModel, generated_on: str | None = None) -> str:
    """Render a deterministic CAPABILITIES.md from the model.

    The only date is the ``Last generated`` line; everything else is derived
    purely from the scanned inputs so two runs over the same brain (on the same
    day) are byte-identical.
    """
    stamp = generated_on or date.today().isoformat()
    m = model
    lines: list[str] = []
    lines.append(f"<!-- {_BANNER}. Regenerate with `{m.command_prefix}-capabilities` "
                 "(brainfactory capabilities --write). -->")
    lines.append("")
    lines.append(f"# {m.project_name} — Capabilities map")
    lines.append("")
    lines.append(f"> {_BANNER}. Truth comes from code; this file is regenerated by "
                 f"`{m.command_prefix}-capabilities` and cannot drift. Hand edits are "
                 "overwritten.")
    lines.append(">")
    lines.append(f"> Last generated: {stamp}")
    lines.append("")
    lines.append(f"- Command prefix: `{m.command_prefix}`")
    lines.append(f"- Framework version: `{m.framework_version}`")
    plats = ", ".join(f"`{p}`" for p in m.platforms) if m.platforms else "_none declared_"
    lines.append(f"- Platforms: {plats}")
    lines.append(f"- Commands: {len(m.core_commands)} core, "
                 f"{len(m.extension_commands)} extension")
    lines.append("")

    lines.append("## Commands")
    lines.append("")
    lines.append("### Core (hub-owned)")
    lines.append("")
    if m.core_commands:
        lines.extend(_render_command_table(m.core_commands, m.command_prefix))
    else:
        lines.append("_No core commands found._")
    lines.append("")

    lines.append("### Extensions (project-owned)")
    lines.append("")
    if m.extension_commands:
        lines.extend(_render_command_table(m.extension_commands, m.command_prefix))
    else:
        lines.append("_No extension commands._")
    lines.append("")

    lines.append("## App repos")
    lines.append("")
    if m.app_repos:
        lines.append("| Repo | Role |")
        lines.append("| --- | --- |")
        for repo in m.app_repos:
            role = _escape_cell(repo.role) or "—"
            lines.append(f"| `{_escape_cell(repo.name)}` | {role} |")
    else:
        lines.append("_No app repos declared in `brain.manifest.json`._")
    lines.append("")
    return "\n".join(lines) + "\n"


def generate(brain: str | Path, generated_on: str | None = None) -> str:
    """Convenience: build the model and render the markdown."""
    return render_markdown(build_model(brain), generated_on=generated_on)


# ---------------------------------------------------------------------------
# Check (anti-drift diff)
# ---------------------------------------------------------------------------

@dataclass
class CheckResult:
    """Outcome of a ``--check`` (or intent-gate) run."""

    brain: str
    ok: bool
    missing_file: bool = False
    diff: str = ""
    # Intent-gate findings: command dirs with no row in the committed map.
    ungated: list[str] = field(default_factory=list)

    def to_dict(self) -> dict[str, Any]:
        return {
            "brain": self.brain,
            "ok": self.ok,
            "missing_file": self.missing_file,
            "diff": self.diff,
            "ungated": self.ungated,
        }


def _strip_generated_line(text: str) -> str:
    """Drop the ``Last generated:`` line so a stale date alone is not a diff.

    The capabilities command stamps the current date on write; we compare the
    substance, not the timestamp. CI still re-writes on a real change.
    """
    out = []
    for line in text.splitlines():
        if line.strip().lower().startswith("> last generated:"):
            continue
        out.append(line)
    return "\n".join(out)


def check(brain: str | Path) -> CheckResult:
    """Regenerate in-memory and diff against the on-disk CAPABILITIES.md."""
    root = Path(brain).resolve()
    cap_path = root / _CAPABILITIES_REL
    expected = generate(root)

    if not cap_path.is_file():
        return CheckResult(brain=str(root), ok=False, missing_file=True,
                           diff=f"{_CAPABILITIES_REL} does not exist")

    on_disk = cap_path.read_text(encoding="utf-8")
    exp_cmp = _strip_generated_line(expected)
    disk_cmp = _strip_generated_line(on_disk)
    if exp_cmp == disk_cmp:
        return CheckResult(brain=str(root), ok=True)

    diff = "\n".join(difflib.unified_diff(
        disk_cmp.splitlines(),
        exp_cmp.splitlines(),
        fromfile=f"a/{_CAPABILITIES_REL} (on disk)",
        tofile=f"b/{_CAPABILITIES_REL} (regenerated)",
        lineterm="",
    ))
    return CheckResult(brain=str(root), ok=False, diff=diff)


def write(brain: str | Path) -> Path:
    """Regenerate and write CAPABILITIES.md. Returns the path written."""
    root = Path(brain).resolve()
    cap_path = root / _CAPABILITIES_REL
    cap_path.parent.mkdir(parents=True, exist_ok=True)
    cap_path.write_text(generate(root), encoding="utf-8")
    return cap_path


# ---------------------------------------------------------------------------
# Intent gate
# ---------------------------------------------------------------------------

def intent_gate(brain: str | Path) -> CheckResult:
    """Fail if any command dir has no matching row in the committed map.

    This enforces the self-extending-brain rule: a feature cannot land without
    the brain growing with it. The gate reads the *committed* CAPABILITIES.md
    (not a regeneration) and verifies that every discovered command's
    invocation (``<prefix>-<base>``) appears in it. A missing map fails the gate.
    """
    root = Path(brain).resolve()
    model = build_model(root)
    cap_path = root / _CAPABILITIES_REL

    if not cap_path.is_file():
        all_cmds = [c.invocation(model.command_prefix)
                    for c in (*model.core_commands, *model.extension_commands)]
        return CheckResult(brain=str(root), ok=False, missing_file=True,
                           ungated=all_cmds,
                           diff=f"{_CAPABILITIES_REL} does not exist; "
                                f"{len(all_cmds)} command(s) ungated")

    committed = cap_path.read_text(encoding="utf-8")
    ungated: list[str] = []
    for cmd in (*model.core_commands, *model.extension_commands):
        token = f"`{cmd.invocation(model.command_prefix)}`"
        if token not in committed:
            ungated.append(cmd.invocation(model.command_prefix))

    if ungated:
        return CheckResult(
            brain=str(root), ok=False, ungated=ungated,
            diff="Command directories without a row in "
                 f"{_CAPABILITIES_REL}: " + ", ".join(ungated)
                 + f"\nRun the capabilities generator (--write) to grow the brain.",
        )
    return CheckResult(brain=str(root), ok=True)
