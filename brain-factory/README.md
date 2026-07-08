<!-- mobile-quick-action: Start here for the executable brain-factory: how the hub provisions and improves per-project brains. -->

# Brain Factory: the executable layer

This directory is the **executable layer** of the framework. It lets the hub
*do the setup* for a new or existing project, give that project its own living
**brain**, and run a **two-way improvement loop** between every brain and the
hub.

New to the model? Read [how it works](../docs/how-brain-factory-works.md) and
the [architecture](../docs/framework-brain-factory-architecture.md), backed by
[ADR 0019](../docs/adr/0019-project-brain-factory-and-improvement-loop.md).

## Layout

| Path | What it is |
| --- | --- |
| `brain-template/` | The canonical brain instance: the `00–08` numbered structure plus templated core files. New brains are built from here. |
| `brain-template/brain.manifest.schema.json` | The manifest contract — the boundary between hub-owned core and project-owned extensions. |
| `core-commands/CATALOG.md` | The authoritative list of core `<prefix>-*` commands every brain inherits. |
| `onboard/` | The onboarding engine: provision (new) and inspect-first adopt (existing). |
| `registry/` | Framework version, releases, learnings inbox, and the down-sync propagation contract. |
| `adapters/` | The cross-platform seam: each ops task implemented per runtime (bash, PowerShell, Python), extensible to more. |

## The model in brief

- **Hub** = this repo (canonical source). **Brain** = one repo per project,
  instantiated from `brain-template/`.
- A brain carries a hub-owned **core layer** (upgradeable) and a project-owned
  **extension layer** (never overwritten). `brain.manifest.json` is the boundary.
- **Up:** brains emit learnings to the registry (`<prefix>-learn`). **Down:**
  brains pull approved improvements (`<prefix>-upgrade`).

## Try it

All ops tasks run through one dispatcher. List them, then run the read-only
inspector against any repo:

```bash
# from the hub repo root
bash brain-factory/adapters/run.sh tasks
bash brain-factory/adapters/run.sh inspect-repo --repo /path/to/a/project
```

`inspect-repo` is read-only — it produces a gap report and changes nothing. The
Python package (`adapters/python/brainfactory`) is the source of truth; the
bash and PowerShell entrypoints are thin wrappers that delegate to it.

## Status

The engine and framework core, runnable today:

- **Onboarding engine** — read-only inspector, plus provision (new) and
  inspect-first adopt (existing, dry-run by default).
- **Manifest contract** — `brain.manifest.schema.json` with schema validation.
- **Brain template** — the `00–08` structure, core module templates, the core
  command set, and the session-ritual hook.
- **Registry** — `framework-version.json`, release notes, the learnings inbox,
  and the idempotent, extension-preserving down-sync contract in
  `registry/propagation.md`.
- **Adapter seam** — `run.sh`/`run.ps1` dispatchers over a shared `tasks.json`,
  with bash, PowerShell, and Python implementations.

Further capabilities arrive through the hub's normal governance (ADR + task
queue). See the [framework task queue](../.github/framework-task-queue.json) for
active items.
