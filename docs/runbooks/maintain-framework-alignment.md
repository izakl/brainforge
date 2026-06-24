# Maintain Framework Alignment

Run a framework alignment review: see what changed in the shared core since your
brain last synced, decide which changes to adopt, and clean up any loose ends
where a merged PR did not close its tracking issue. Use it after upstream
releases and during routine maintenance.

In Brain Factory, each brain carries a shared, upgradeable *core* that the hub
maintains and ships as releases; "alignment" means keeping your brain's core
current and your project's intentional differences deliberate. If any of that is
new to you, read [How Brain Factory works](../how-brain-factory-works.md) first.
For the reasoning behind upgrade decisions and queue hygiene, see
[`../framework-upgrade-and-maintenance.md`](../framework-upgrade-and-maintenance.md).

## When to use this runbook

- After a `MAJOR` or `MINOR` upstream release of the core.
- During the monthly framework health audit.
- When you suspect your brain has drifted from the upstream core.
- After merging a queue-backed PR, to confirm the source issue actually closed.

## Primary artifacts

- Upgrade/maintenance doc: [`../framework-upgrade-and-maintenance.md`](../framework-upgrade-and-maintenance.md)
- Release/versioning model: [`../framework-release-versioning-and-deprecation.md`](../framework-release-versioning-and-deprecation.md)
- Release notes index: [`../framework-release-notes.md`](../framework-release-notes.md)
- Release summary model/template: [`../framework-release-notes-and-upgrade-summaries.md`](../framework-release-notes-and-upgrade-summaries.md), [`../framework-change-summary-template.md`](../framework-change-summary-template.md)
- Queue health check runbook: [`run-queue-health-check.md`](run-queue-health-check.md)
- Framework health: [`../framework-health.md`](../framework-health.md)
- Queue source of truth: [`.github/framework-task-queue.json`](https://github.com/izakl/brainforge/blob/main/.github/framework-task-queue.json)

## Procedure

### Step 1 — Identify your current baseline

Find the last core release (or PR merge point) your brain was aligned to. This is
your baseline.

If your brain tracks a version marker, locate it. If not, use the merge date of
the last framework change you reviewed.

### Step 2 — Review changes since your baseline

1. Open [`../framework-release-notes.md`](../framework-release-notes.md) first, then the upstream Releases page or the merged-PR list since your baseline.
2. For each release or merged PR since your baseline, note:
   - the change classification (`PATCH`, `MINOR`, `MAJOR`)
   - the adopter action level (`Informational`, `Recommended`, `Required`)
   - the applicability (`Universal`, `Profile-specific`, `Maturity-gated`, `Optional`)
   - which artifacts were added, changed, or deprecated
3. `PATCH` changes: no action required; note them for awareness.
4. `MINOR` changes: review for selective adoption, then go to Step 3.
5. `MAJOR` changes: adoption is required. Go to Step 3 right away.

### Step 3 — Classify each change for your brain

For each `MINOR` or `MAJOR` change, decide how it applies to your brain.
*Invariant* below means a rule the framework guarantees and never breaks; a
change that affects one is non-negotiable.

| Classification | Action |
| --- | --- |
| Required (invariant affected) | Open a bounded upgrade issue. Adopt in the next PR. |
| Recommended, no friction | Adopt at the next review cycle. |
| Recommended, deferred | Open a follow-up issue; never leave a deferred decision in chat only. |
| Optional, profile mismatch | Skip; record the decision in the upgrade issue. |
| Maturity-gated | Skip until your maturity level is right; record the decision. |
| Intentional divergence | Confirm the divergence is still intentional; update your local copy if needed. |

### Step 4 — Open a bounded upgrade issue

Open one upgrade issue per release, or per coherent batch of related changes.
Include:

- **Objective:** align this brain with core changes from `[version/date]` to `[version/date]`.
- **Context:** the list of changes reviewed and their classification.
- **Constraints:** preserve invariants; stay bounded to one logical upgrade batch.
- **Acceptance criteria:** all required changes adopted; deferred items are explicit follow-up issues, not chat notes.
- **Validation:** all CI checks pass after each upgrade PR; the queue health check passes.

### Step 5 — Apply changes in bounded PRs

For each change you adopt:

1. Open one bounded PR per logical update.
2. In the PR body, point "Linked source artifact" at the upgrade issue.
3. Use `Closes #<upgrade-issue>` only when the PR covers the full upgrade-issue scope. Use `Relates-to #<upgrade-issue>` when the PR is one slice of a larger batch.
4. Run all required checks before requesting review.
5. Confirm the PR's "Queue closure/linkage hygiene" checklist is complete.

### Step 6 — Verify queue closure hygiene

After each PR merge (especially queue-backed PRs):

1. Confirm the `Closes #...` keyword auto-closed the canonical source issue.
2. If the issue is still open after merge, follow the closure recovery steps below.
3. Run `bash scripts/check-queue-health.sh` to detect any residual drift.

### Step 7 — Update your baseline marker

After the upgrade cycle, update your version marker (in `README.md`, `AGENTS.md`,
or a dedicated tracking issue) to the current core version or date. This sets the
baseline for the next review cycle.

## Queue closure recovery guidance

### Detecting missed closures

Signs that an issue closure was missed:

- The source issue is still open after its PR merged.
- `check-queue-health.sh` reports an open queue-linked issue that already has merged-PR references.
- A queue entry's status is `done` but its linked issue is still open.

### Recovery steps

1. Locate the merged PR that should have closed the issue.
2. Verify the merge by checking the PR status.
3. Leave a reconciliation comment on the still-open issue:
   > Closed by PR #`<number>` (merged `<date>`). The issue was not auto-closed; closing manually now.
4. Close the issue manually.
5. If queue-backed, set the queue entry to `done` in `.github/framework-task-queue.json` (unless it already is).
6. Run `bash scripts/check-queue-health.sh` — it must pass with no errors.
7. If you changed the queue file, run `bash scripts/check-framework-task-queue.sh` and open a bounded queue-correction PR.
8. If missed closures look like a pattern (for example, always missing for a particular PR shape), note it in the upgrade issue so the process can be refined.

## Automation boundary

Automated (existing scripts):

- `check-queue-health.sh` — detects merged-PR/open-issue drift when `GITHUB_TOKEN`
  and `GITHUB_REPOSITORY` are set.
- `check-framework-task-queue.sh` — validates queue schema after any edits.

Human-in-the-loop:

- Classifying changes for your repo's context.
- Deciding adopt/defer/diverge for each change.
- Opening and merging bounded upgrade PRs.
- Manually closing issues when auto-close was missed.
- Updating the framework snapshot marker.
- Deciding whether a pattern of missed closures needs process or template changes.

## Mobile quick action

- **Use when:** you are doing a quick check on upgrade status or closure hygiene from mobile.
- **Do from mobile:**
  - Confirm whether an upgrade issue exists and is active.
  - Confirm whether any source issues remain open after recent merges.
  - Leave a comment naming the next required action.
- **Do not do from mobile:**
  - Run the queue health check scripts or edit queue JSON files.
  - Open multi-file upgrade PRs.
- **Escalate to desktop/cloud when:**
  - Changes require file edits, script runs, or queue corrections.
  - Multiple upgrade items need coordinated bounded PRs.
- **Primary artifact to update:**
  - The bounded upgrade issue capturing the current alignment review cycle.

## Related docs

- [Framework upgrade and adoption maintenance](../framework-upgrade-and-maintenance.md) — conceptual guidance for upgrade decisions and queue hygiene.
- [Operate the framework task queue](operate-framework-task-queue.md) — queue state transitions and merge-preparation recovery.
- [Run the queue health check](run-queue-health-check.md) — drift-detection script, manual checklist, and recovery matrix.
- [Framework release/versioning/deprecation model](../framework-release-versioning-and-deprecation.md) — change classification and release communication.
- [Framework release notes and upgrade summaries](../framework-release-notes-and-upgrade-summaries.md) — summary authoring and classification model.
- [Framework release notes index](../framework-release-notes.md) — durable quick-scan surface for framework evolution.
- [Framework portability and adoption](../framework-portability-and-adoption.md) — invariants, tiers, and adoption model.
- [Framework adoption maturity model](../framework-adoption-maturity-model.md) — maturity levels and dimension assessment.
- [Framework health](../framework-health.md) — charter-to-artifact map and audit checklist.
- [Start a framework change](start-a-framework-change.md) — bounded scope and validation expectations for PRs.
