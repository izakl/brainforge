# Brain template

The canonical brain instance. A project brain is built from this tree by the
onboarding engine. Files ending in `.tmpl` contain placeholders filled at
provision time:

| Placeholder | Filled with |
| --- | --- |
| `{{PROJECT_NAME}}` | Human project name (e.g. `Acme`). |
| `{{PROJECT_SLUG}}` | Lowercase identifier (e.g. `acme`). |
| `{{BRAIN_REPO}}` | `owner/repo` of the brain (e.g. `izakl/acme-autonomy-system`). |

## Structure

```text
brain.manifest.schema.json    # the manifest contract (validated in CI)
brain.manifest.example.json   # a worked example
AGENTS.md.tmpl                # standards-compliant agent entrypoint (becomes AGENTS.md)
CLAUDE.md.tmpl                # Claude Code instruction entrypoint (becomes CLAUDE.md)
.github/copilot-instructions.md.tmpl  # Copilot instruction entrypoint
00-governance/                # OPERATING-CONTRACT + consensus/decision-board
01-docs/                      # CAPABILITIES (generated) + diagrams
02-plans/                     # roadmaps and plans
03-templates/agent-commands/  # core/ + extensions/ + hooks/
04-policies/                  # continuity, QA, CI checks, security, cloud-agent policies
05-logs/                      # continuity record + master index
06-archive/                   # retired material
08-ops/                       # cross-platform ops via the adapters seam
```

Core content (under `core/`, the contract, hooks, generated map) is hub-owned and
upgraded by `<prefix>-upgrade`. Project content (under `extensions/`, declared in the
manifest) is project-owned and never overwritten.

Every brain is runtime-agnostic: the manifest's `agent_runtimes` declares which AI
agents it targets, and `none` (deterministic ops with no LLM) is always supported.
See [ADR 0020](../../docs/adr/0020-portable-core-additive-enterprise.md).
