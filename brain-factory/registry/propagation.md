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
6. **Record.** Append a continuity entry to the brain's `05-logs/` describing the
   upgrade, and open the change as a PR in the brain repo (PR is the control gate).

## Invariants

- Down-sync is **idempotent**: re-running with no version gap is a no-op.
- Down-sync **never** edits project extensions or app-repo code.
- Every applied upgrade lands via a PR in the brain repo with validation evidence.
- A brain may pin a `framework_version` and decline upgrades; the gap is then
  reported by `<prefix>-status` until resolved.
