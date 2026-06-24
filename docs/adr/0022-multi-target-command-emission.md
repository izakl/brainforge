# ADR 0022: Multi-target command emission to standard agent discovery locations

- Status: Accepted
- Date: 2026-06-19

## Context

[ADR 0020](./0020-portable-core-additive-enterprise.md) committed to authoring a
command once and emitting it to the formats each agent reads, so no single vendor
is required. Commands are authored as Agent Skills `SKILL.md` files under a brain's
`03-templates/agent-commands/{core,extensions}/<base>/`.

That authoring location is not a discovery path any tool reads, however:

- **GitHub Copilot** discovers custom agents in `.github/agents/*.agent.md` and
  skills in `.github/skills/<name>/SKILL.md` (the Agent Skills specification).
- **Claude Code** discovers skills in `.claude/skills/<name>/SKILL.md`.

Without emission, a brain's commands are authored but not auto-discovered by the
agents an operator actually runs.

## Decision

Add an `emit-commands` task (`brainfactory.emit`, wired through the CLI and the
adapter seam) that treats each command's `SKILL.md` as the single source and
emits it to the standard discovery locations:

- `.claude/skills/<name>/SKILL.md` — Claude Code
- `.github/skills/<name>/SKILL.md` — GitHub Copilot (Agent Skills)
- `.github/agents/<name>.agent.md` — GitHub Copilot (custom agents)

Details:

- `SKILL.md` (the Agent Skills spec) is the canonical source; the `.agent.md` is a
  derived transform (frontmatter `name`/`description` plus the instruction body).
- Emitted files carry a marker comment and are regenerated idempotently. Stale
  generated files (for commands that no longer exist) are pruned by marker, so
  hand-authored agents/skills are never touched.
- Both core and project extension commands are emitted.

## Consequences

Positive:

- A brain is natively discovered by Claude Code and GitHub Copilot from one
  authored source — losing one runtime loses nothing.
- Re-running keeps the emitted artifacts in sync with the authored commands.

Trade-offs:

- Each command has three generated copies; they are marked generated and must not
  be hand-edited (edit the source `SKILL.md`).
- `.agent.md` is a lossy projection of the skill (no tools/model frontmatter yet).

## Follow-ups

- Run `emit-commands` as part of the close ritual / capabilities refresh so the
  emitted artifacts never drift from the authored source.
- Add `tools`/`model` frontmatter to emitted agents when commands declare them.
- Consider emitting per-command MCP tool definitions alongside the file targets.

## References

- [ADR 0020: Portable core, additive enterprise](./0020-portable-core-additive-enterprise.md)
- [`brain-factory/adapters/python/brainfactory/emit.py`](../../brain-factory/adapters/python/brainfactory/emit.py)
- [`brain-factory/adapters/README.md`](../../brain-factory/adapters/README.md)
- [AGENTS.md standard](https://agents.md)
