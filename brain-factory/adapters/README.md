<!-- mobile-quick-action: The cross-platform seam — each ops capability defined once, implemented per runtime. -->

# Platform adapters

Automation targets **multiple platforms** and must be extensible to more. Each
ops capability is defined once as a **task** with per-platform implementations
here. Callers (core commands, hooks, onboarding) invoke the task; the dispatcher
selects the implementation by platform and the brain manifest's `platforms`.

```text
brain-factory/adapters/
  python/        # platform-neutral logic; the source of truth where feasible
  bash/          # Linux / macOS / Codespaces / web sessions
  powershell/    # Windows-first operators
  run.sh         # POSIX dispatcher
  run.ps1        # Windows dispatcher
  tasks.json     # task registry: id -> per-platform entrypoints
```

## Why this shape

- The operator runs Windows locally (PowerShell) and uses Linux/web sessions.
  Neither can be the only target.
- Future projects "will use something additional" — a new runtime is added by
  creating its directory and adding entrypoints to `tasks.json`, with no change
  to the commands that call the task.

## Task contract

A task is a named unit (e.g. `generate-capabilities`, `session-close-sync`,
`inspect-repo`). `tasks.json` maps each task id to an entrypoint per platform.
The dispatcher resolves: caller → task id → platform (from `--platform` or the
manifest) → entrypoint. Where logic is non-trivial, `bash` and `powershell`
entrypoints are thin wrappers over a shared `python` implementation so behavior
stays identical across platforms.

## Built tasks

The onboarding engine (inspector + applier) is implemented here. The Python
package `python/brainfactory/` is the source of truth; `bash/` and
`powershell/` are thin wrappers over `python -m brainfactory`.

| Task id | Capability | Entrypoints |
| --- | --- | --- |
| `inspect-repo` | Read-only audit of a target repo → gap report (md) + JSON | `bash/inspect.sh`, `powershell/inspect.ps1`, `python -m brainfactory inspect` |
| `apply-brain` | `provision` a new brain, or `adopt` into an existing repo | `bash/apply.sh`, `powershell/apply.ps1`, `python -m brainfactory <provision\|adopt>` |
| `generate-capabilities` | Regenerate (or `--check`) a brain's `01-docs/CAPABILITIES.md` from code so it cannot drift | `bash/capabilities.sh`, `powershell/capabilities.ps1`, `python -m brainfactory capabilities` |
| `docs-mesh` | Read-only docs anti-drift: link/wikilink resolution, mermaid balance/safety, freshness stamps | `bash/docs-mesh.sh`, `powershell/docs-mesh.ps1`, `python -m brainfactory docs-mesh` |
| `intent-gate` | Fail if a command dir has no row in the committed `CAPABILITIES.md` (a feature cannot land without the brain growing) | `bash/intent-gate.sh`, `powershell/intent-gate.ps1`, `python -m brainfactory intent-gate` |
| `emit-commands` | Emit each authored command to `.claude/skills`, `.github/skills`, and `.github/agents` so one source works across Claude and Copilot | `bash/emit-commands.sh`, `powershell/emit-commands.ps1`, `python -m brainfactory emit-commands` |

### CLI

```bash
# Add the package to PYTHONPATH (or install it):
export PYTHONPATH=brain-factory/adapters/python

# Inspect (read-only; never modifies the target):
python -m brainfactory inspect --repo PATH [--out gap-report.md] [--json summary.json]

# Provision a brand-new brain into an EMPTY directory:
python -m brainfactory provision --dest DIR \
  --name "Acme" --slug acme --brain-repo izakl/acme-autonomy-system \
  --prefix wg [--platforms bash,powershell,python] [--profile platform-team]

# Adopt into an existing repo. DEFAULTS TO DRY-RUN (prints the plan, writes nothing).
python -m brainfactory adopt --repo PATH \
  [--name ... --slug ... --brain-repo ... --prefix ...] \
  [--gap-report PATH] [--apply] [--force]

# Regenerate / check a brain's capabilities map (the derived layer):
python -m brainfactory capabilities --brain DIR --write   # regenerate + write
python -m brainfactory capabilities --brain DIR --check   # diff vs disk; non-zero on drift

# Docs anti-drift (the validated layer); non-zero on a hard failure:
python -m brainfactory docs-mesh --brain DIR

# Intent gate (the enforced layer); non-zero if a command has no capabilities row:
python -m brainfactory intent-gate --brain DIR
```

`adopt` copies only the modules the inspector marks `add`/`augment`; modules it
marks `keep` are recorded in the manifest as pre-existing (`adopted: false`) and
left untouched. `--apply` is required to write; existing files are never
overwritten unless `--force`.

### Dispatchers

```bash
./run.sh  inspect-repo --repo PATH            # POSIX; PLATFORM=bash by default
./run.sh  apply-brain  adopt --repo PATH      # first arg selects provision|adopt
pwsh ./run.ps1 inspect-repo --repo PATH       # Windows; PLATFORM=powershell by default
```

The dispatcher resolves task id → platform (env `PLATFORM` or default) →
entrypoint via `tasks.json`, then execs it with the remaining args.

## Model Context Protocol (MCP) server

Any MCP-capable agent (Claude, Copilot, Codex, …) can use the registry and the
read-only onboarding engine directly — no bash wrappers, no vendor lock-in (see
[ADR 0021](../../docs/adr/0021-expose-brain-factory-over-mcp.md)). The server is
standard-library only and speaks JSON-RPC over stdio:

```bash
python -m brainfactory mcp
```

Point an MCP client's server config at that command, for example:

```json
{
  "mcpServers": {
    "brain-factory": {
      "command": "python",
      "args": ["-m", "brainfactory", "mcp"],
      "env": { "PYTHONPATH": "brain-factory/adapters/python" }
    }
  }
}
```

Tools (all read-only and deterministic; the judgment stays with the agent):

| Tool | Purpose |
| --- | --- |
| `framework_version` | Current hub framework version and the core modules it ships. |
| `inspect_repo` | Read-only gap report for a target repo (`repo`, optional `format`). |
| `version_status` | Compare a brain's `framework_version` against the hub's latest. |

## Adding a runtime

Create the runtime's directory, add `inspect`/`apply` wrappers over
`python -m brainfactory`, and add the runtime key to each task in `tasks.json`.
Callers do not change.
