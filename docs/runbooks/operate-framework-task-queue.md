# Operate the Framework Task Queue

Maintain the framework task queue and, when the automation slips, recover the
preparation of the next task by hand. Use it after merges, when a task changes
state, or when the automation prepares the wrong item.

The *framework task queue* is an ordered, version-controlled backlog of framework
work, stored in
[`.github/framework-task-queue.json`](../../.github/framework-task-queue.json).
After each merge to `main`, a GitHub Actions workflow reads the queue and
*prepares* the next ready task by opening a tracking issue for it. This runbook
keeps that queue honest and recovers the preparation step when it goes wrong. New
to the project? See [How Brain Factory works](../how-brain-factory-works.md) for
the five-minute tour.

## When to use this runbook

- After a merge to `main`, to confirm the next task was prepared as expected.
- When a task's state changes (`blocked`, `pending`, `in_progress`, `done`, `superseded`).
- When the next-task preparation workflow fails or prepares the wrong item.

## Primary artifacts

- Queue source of truth: [`.github/framework-task-queue.json`](../../.github/framework-task-queue.json)
- Canonical queue schema/governance model: [`../framework-queued-execution-memory.md`](../framework-queued-execution-memory.md)
- Merge-triggered preparation workflow: [`.github/workflows/prepare-next-framework-task.yml`](../../.github/workflows/prepare-next-framework-task.yml)
- Human-readable queue narrative: [`../framework-roadmap-next-prompts.md`](../framework-roadmap-next-prompts.md)

## Procedure

1. Open [`.github/framework-task-queue.json`](../../.github/framework-task-queue.json).
2. Confirm every entry uses the status model consistently:
   - `blocked` = dependencies are not yet complete
   - `pending` = ready to be picked once dependencies are satisfied
   - `in_progress` = currently being executed
   - `done` = merged and complete
   - `superseded` = replaced or retired, with durable rationale and a link to its replacement
3. Confirm the links between queue, issue, and PR hold:
   - the prepared issue carries the queue marker `<!-- framework-task-queue-id:<task-id> -->` (the marker format is defined by `issue_backed_queue_model.prepared_issue_marker_prefix` in the queue file)
   - the implementation PR uses `Closes #...` for the one canonical queue-linked issue, and `Relates-to #...` for any other, non-closing links
   - queue state matches what the issues and PRs actually show
4. Confirm which statuses require a tracking issue:
   - `blocked` and `pending` may exist without one
   - `in_progress` must have exactly one open, canonical queue-linked issue
   - `done` and `superseded` must stay traceable to their issue and PR history
5. Edit only the minimum task rows the current transition needs.
6. Validate queue integrity before opening a PR:
   - `bash scripts/check-framework-task-queue.sh`
   - `bash scripts/check-queue-health.sh`
7. Open a bounded PR that states:
   - what changed in queue state
   - why you made the transition
   - any related issue or PR links
8. After merge, confirm that the latest run of
   [Prepare Next Framework Task](../../.github/workflows/prepare-next-framework-task.yml) either:
   - created exactly one next-task issue when appropriate, or
   - found an already-open prepared issue and skipped creation.

## Post-merge closure and linkage checklist

Run this whenever a queue-backed implementation PR merges:

1. Confirm the merged PR used `Closes #...` for the canonical queue-linked issue. If the close keyword was missed and the issue is still open, close it manually and leave a reconciliation comment citing the merged PR.
2. Reconcile queue status in `.github/framework-task-queue.json`:
   - move the item from `in_progress` to `done` once the objective is merged
   - use `superseded` only when the replacement rationale and successor link are durable
3. Run both validations:
   - `bash scripts/check-framework-task-queue.sh`
   - `bash scripts/check-queue-health.sh`
4. Open a bounded queue-maintenance PR documenting:
   - the queue status transition you made
   - the issue and PR links you treated as the source of truth
   - any manual closure or reconciliation that was required
5. After that PR merges, verify the latest
   [Prepare Next Framework Task](../../.github/workflows/prepare-next-framework-task.yml) run prepared (or intentionally skipped) the correct next item.

## Issue-backed state mapping quick reference

| Queue status | Issue expectation | Operator action |
| --- | --- | --- |
| `blocked` | Issue optional | Keep dependency/unblock condition visible in queue entry and linked artifacts if issue exists. |
| `pending` | Issue optional until prepared | Ensure at most one dependency-ready `pending` item remains for deterministic prep. |
| `in_progress` | One canonical open queue-linked issue required | Confirm marker, assignee, and active execution links are current. |
| `done` | Historical issue + merged PR linkage required (issue should be closed) | Preserve merge evidence and close/reconcile issue writeback if auto-close was missed. |
| `superseded` | Historical issue + replacement rationale required | Record successor linkage and why original queue intent was replaced. |

## Recovery playbook

If next-task preparation did not run as expected:

1. Trigger [Prepare Next Framework Task](../../.github/workflows/prepare-next-framework-task.yml)
   manually with `workflow_dispatch`.
2. If the wrong task was selected:
   - fix task states/dependencies in `.github/framework-task-queue.json`
   - run `bash scripts/check-framework-task-queue.sh`
   - merge the queue correction PR
   - re-run the workflow manually
3. If a duplicate prepared issue exists:
   - keep one canonical issue open
   - close duplicates with a link to the canonical issue
   - do not manually edit workflow history
4. If queue state drifts from issue/PR reality:
   - reconcile the queue item to durable artifact truth (`in_progress`, `done`, or `superseded`)
   - if the implementation PR merged without closing the canonical queue-linked issue, close the issue manually with a comment linking the merged PR
   - include rationale and replacement linkage in PR notes
   - run `bash scripts/check-framework-task-queue.sh`
   - merge bounded queue-correction PR and re-run preparation workflow if needed

### Copilot coding agent firewall and API-access limits

Some queue scripts can optionally call the GitHub API (`api.github.com`) to check
for closure and linkage drift. Inside GitHub-hosted Copilot coding agent runs, a
firewall may block those calls unless the host is allowlisted.

When firewall warnings appear:

1. Decide how to proceed:
   - if you need live API checks inside the agent, ask an admin to allowlist `api.github.com`
   - if the need is setup, auth, or bootstrap, move it into Actions setup steps that run before the firewall applies
2. Keep closeout reliable without the API:
   - run the local, structural checks (`check-framework-task-queue.sh`, `check-queue-health.sh`)
   - reconcile issue and PR closure manually, using merged-PR evidence
3. Always write durable post-merge state:
   - set the queue item to `done` or `superseded` in `.github/framework-task-queue.json`
   - never rely on chat memory to remember a completed transition

### Decomposed or split execution recovery

If one queue item is intentionally decomposed into multiple implementation slices:

1. Keep one canonical issue carrying the queue-id marker as the parent execution source.
2. Link child issues/PRs back to the canonical issue with explicit decomposition notes.
3. Keep queue state on the parent queue id (`in_progress`, then `done` or `superseded`) based on merged outcome.
4. If decomposition materially changes the original objective, move queue item to `superseded` with replacement rationale.

## Automation boundary (safety)

Automated:

- Select next dependency-ready `pending` task from `.github/framework-task-queue.json`.
- Prepare one GitHub issue packet with prompt and dependency context.
- Avoid duplicate preparation when an open issue for that queue id already exists.

Human-in-the-loop:

- Decide queue state transitions (`blocked`/`pending`/`in_progress`/`done`).
- Review and refine prepared issue packets before execution.
- Approve implementation PRs and merges.
- Close/reconcile duplicate or stale prepared issues.

This boundary keeps orchestration lightweight while preserving bounded PR review and governance controls.

## Mobile quick action

- **Use when:** you need to confirm next-task preparation status or check for queue drift from mobile.
- **Do from mobile:**
  - Check the latest `Prepare Next Framework Task` workflow run status.
  - Confirm a prepared issue exists for the next dependency-ready task.
  - Leave a queue-recovery note on the relevant issue or PR.
- **Do not do from mobile:**
  - Rewrite multiple queue items at once.
  - Reconcile complex dependency or state transitions without desktop validation.
- **Escalate to desktop/cloud when:**
  - Queue schema or state corrections are required.
  - A workflow failure needs a rerun and artifact reconciliation.
- **Primary artifact to update:**
  - The queue-maintenance PR, or the prepared next-task issue.

## Related docs

- [Operator onboarding pack](../operator-onboarding-pack.md) — first-use checklist for queue-aware continuation and bounded execution.
- [Framework roadmap: next GitHub agent prompts](../framework-roadmap-next-prompts.md) — queue narrative and prompt catalog.
- [GH agents and automation](../gh-agents-and-automation.md) — Copilot coding agent firewall/API-access constraints and mitigation decision flow.
- [Framework queued execution memory](../framework-queued-execution-memory.md) — canonical queue schema, linkage model, state semantics, and governance.
- [Open an issue](open-an-issue.md) — issue template selection and required packet fields.
- [Start a framework change](start-a-framework-change.md) — bounded scope and validation expectations.
- [Framework continuity and memory](../framework-continuity-and-memory.md) — durable continuity rules and writeback expectations.
- [Framework health](../framework-health.md) — charter-to-artifact map and operational hygiene checks.
