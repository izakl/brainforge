# Agent commands

The `<prefix>-*` command set for this brain. Each command exists in two synchronized
forms so it works across surfaces:

- **Claude Code skill** — `<scope>/<name>/SKILL.md`
- **GitHub Copilot prompt** — `<scope>/<name>/<name>.prompt.md`

Both forms bake the open/close session ritual (see the operating contract §4) so
continuity happens automatically.

## Scopes

```text
03-templates/agent-commands/
  core/         # hub-owned commands, upgraded via <prefix>-upgrade. See the hub core-commands/CATALOG.md.
  extensions/   # project-owned commands, declared in brain.manifest.json. Never overwritten by the hub.
  hooks/        # SessionStart / SessionEnd hooks (cross-platform).
```

## Adding a project command

1. Create `extensions/<name>/SKILL.md` and `extensions/<name>/<name>.prompt.md`.
2. Declare it in `brain.manifest.json` under `extensions`.
3. Register it in `01-docs/CAPABILITIES.md` (the CI intent gate requires this).

Do not place project commands under `core/` — that namespace is managed by the
hub and overwritten on upgrade.
