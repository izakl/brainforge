# Down-sync propagation contract

How `<prefix>-upgrade` moves approved framework improvements from the hub into a brain
without disturbing project-owned work.

## Inputs

- The hub's `brain-factory/registry/framework-version.json` (latest version + core modules).
- The hub's `brain-factory/registry/releases/` notes between the brain's current
  version and latest.
- The brain's `brain.manifest.json` (`framework_version`, `core_modules`, `extensions`).

## Algorithm

1. **Resolve the gap.** `latest = framework-version.json.framework_version`;
   `current = manifest.framework_version`. If equal, report "up to date" and stop.
2. **Collect deltas.** Read each release note from `current` (exclusive) to
   `latest` (inclusive). Each note lists changed core modules with a change kind:
   `added`, `changed`, `deprecated`, `removed`.
3. **Build the plan.** For each changed core module:
   - Skip if the brain has the module disabled in `core_modules`.
   - For `adopted: false` modules (a pre-existing project artifact kept during
     inspect-first onboarding), surface as a **manual-review** item rather than
     overwriting.
   - Otherwise stage the update from the hub brain template.
4. **Protect extensions.** Never modify anything under the brain's `extensions`
   paths or namespaces. If a release would collide with an extension path,
   surface a conflict for operator review.
5. **Apply.** Write staged core changes, update each touched module's
   `synced_from` to `latest`, and set the manifest `framework_version = latest`.
   For operating-contract updates, propagate cross-tool instruction surfaces
   (`AGENTS.md`, `.github/copilot-instructions.md`, `CLAUDE.md`) so permanent
   standards (including continuity-capture writeback) are inherited in every
   lane.
   For `operating-contract` updates, this includes the cross-tool instruction
   surface (`AGENTS.md`, `.github/copilot-instructions.md`, `CLAUDE.md`) so
   permanent operating standards propagate to every lane.
6. **Record.** Append a continuity entry to the brain's `05-logs/` describing the
   upgrade, and open the change as a PR in the brain repo (PR is the control gate).

## Invariants

- Down-sync is **idempotent**: re-running with no version gap is a no-op.
- Down-sync **never** edits project extensions or app-repo code.
- Every applied upgrade lands via a PR in the brain repo with validation evidence.
- A brain may pin a `framework_version` and decline upgrades; the gap is then
  reported by `<prefix>-status` until resolved.

## Implementation

Down-sync execution is implemented as the `upgrade` CLI subcommand
(`brainfactory upgrade`) and the `upgrade-brain` adapter task, callable from a
brain via `<prefix>-upgrade` or `run.sh upgrade-brain`. It is **dry-run by
default**; `--apply` writes, and `--force` re-materialises the core even with no
version gap (drift repair).

The hub keeps a single `brain-template` representing the *latest* core, so the
engine reconciles a brain **forward to that template** rather than replaying
per-release deltas: it refreshes every enabled, hub-adopted core module from the
template, bumps `framework_version` plus each refreshed module's `synced_from`,
and writes a record under the brain's `05-logs/upgrades/`. `adopted: false`
modules are surfaced as manual-review and disabled modules are skipped (steps 3
and 4); extensions are never written.

Follow-ups (not yet built):

- **Per-release delta narrowing.** Parse the intervening release notes (step 2)
  to touch only the modules a release actually changed, instead of refreshing
  all enabled core modules. The end state is identical for an unmodified core;
  this is an optimisation and a finer manual-review signal.
- **`removed` handling.** Delete core modules retired upstream — the engine
  currently refreshes and adds, but never deletes.
- **Auto-open the PR.** The engine stages the change in the working tree; the
  operator opens the PR today (step 6). Opening it automatically is a follow-up.
