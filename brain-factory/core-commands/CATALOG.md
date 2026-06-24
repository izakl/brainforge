<!-- mobile-quick-action: The authoritative list of core (hub-owned) commands every brain inherits, and how projects add their own. -->

# Core command catalog

This catalog is the authoritative list of **core** commands the hub ships to
every brain. Core commands are hub-owned and upgraded by the down-sync
(`<prefix>-upgrade`). Projects add their own **extension** commands, declared in
`brain.manifest.json` and stored under the brain's
`03-templates/agent-commands/extensions/` namespace — these are never touched by
the down-sync.

## Naming: base name + per-brain prefix

Commands are identified by a stable **base name** (`sync`, `status`,
`upgrade`, …). Each brain sets its own **`command_prefix`** in
`brain.manifest.json`, and the invocation is `<prefix>-<base>`.

- The prefix is **per project** — it is not baked into the framework. The donor
  Northwind system uses `xs` (Northwind System), so `xs-sync`; Acme uses `wg`,
  so `wg-sync`. A new project picks its own short prefix at provision time.
- The hub stores each command by base name under
  `brain-template/03-templates/agent-commands/core/<base>/`. At provision the
  engine stamps the brain's prefix into the skill/prompt name
  (`{{CMD_PREFIX}}` → the chosen prefix).

Each command exists in two synchronized forms so it is portable across surfaces:

- **Claude Code skill** — `core/<base>/SKILL.md`
- **GitHub Copilot prompt** — `core/<base>/<base>.prompt.md`

Both forms bake the open/close session ritual so continuity happens
automatically. Each command declares a default **model + effort** tier.

## Core commands

Listed by base name. Invoke as `<prefix>-<base>` for your brain.

### Governance and flow

| Base | Purpose | Default tier |
| --- | --- | --- |
| `continue` | Open ritual → pick the top unclaimed backlog item → branch → work → PR → close. | Sonnet / medium |
| `status` | Read-only state of everything: backlog, PRs/issues, CI, brain health, framework-version drift. | Haiku / low |
| `sync` | Run the close ritual on demand: continuity writeback + capabilities refresh + push. | Sonnet / medium |
| `review` | Pre-merge review of a PR or branch: diff, tests, contract compliance. | Sonnet / medium |
| `roadmap` | Reconcile the roadmap and backlog against what shipped. | Sonnet / medium |
| `bootstrap` | Configure a fresh machine/Codespace: toolchain, clone repos, install hooks. | Sonnet / medium |
| `new-repo` | Add/remove an app repo from the brain's coordination set (manifest + bootstrap). | Sonnet / medium |
| `onboard` | Onboard a person or agent into the brain's operating model. | Haiku / low |

### Quality and security

| Base | Purpose | Default tier |
| --- | --- | --- |
| `test` | Run the project's test suite the way the project runs it. | Sonnet / medium |
| `verify` | Verify a change actually works by running the app/feature. | Sonnet / medium |
| `doctor` | Diagnose the running app and environment; apply only safe fixes. | Sonnet / medium |
| `security` | Security sweep: scanners → issues → triage → patch. | Sonnet / high |
| `deps` | Dependency audit and bounded updates. | Sonnet / medium |

### Brain and framework loop

| Base | Purpose | Default tier |
| --- | --- | --- |
| `capabilities` | Regenerate `01-docs/CAPABILITIES.md` from code so docs cannot drift. | Sonnet / medium |
| `upgrade` | Query the hub registry, diff this brain's `framework_version` against the latest, produce an upgrade plan, and apply core-layer deltas (preserving extensions). | Sonnet / high |
| `learn` | Emit a structured learning from this brain and open it as a proposal against the hub's learnings inbox (the up-sync). | Sonnet / medium |

## Extension commands (project-owned)

Extension commands are **not** listed here. They are declared per project in
`brain.manifest.json` under `extensions` (by base name) and documented in the
brain's own `01-docs/CAPABILITIES.md`. They use the same per-brain prefix.
Examples:

- A data/intelligence platform: `connector`, `correlate`, `ingest`
  (invoked `wg-connector`, …).
- A trading app: `backtest`, `strategy`, `risk-audit` (invoked `xs-backtest`, …).

## Adding or changing a core command

Core commands change through the hub's normal governance (ADR + task queue + the
framework change governance policy). A change here is a framework release and
reaches brains via `<prefix>-upgrade`. The checklist:

1. Update both forms (SKILL.md + prompt) and this catalog.
2. Note the change in `brain-factory/registry/releases/`.
3. Bump `brain-factory/registry/framework-version.json`.
4. Keep the model/effort tier accurate.
