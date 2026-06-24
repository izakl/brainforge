# Framework Queued Execution Memory

The framework keeps an ordered, durable list of upcoming work — a **task queue** — so the
next thing to build is recorded in the repository rather than only in someone's memory or a
chat transcript. This document is the canonical reference for that queue: how each entry is
represented, how entries link to issues and pull requests, how queue state is governed, and
how to recover when the queue drifts out of sync with what has actually merged.

It is for maintainers and agents who prepare, execute, or audit queued work. New to the
project? See [How Brain Factory works](how-brain-factory-works.md) first; for the issue types
the queue produces, see [Issue taxonomy](issue-taxonomy.md).

## Why this exists

Before this model was written down, queue behavior was only partly implied across several
files:

- `.github/framework-task-queue.json`
- `.github/workflows/prepare-next-framework-task.yml`
- `scripts/check-framework-task-queue.sh`
- `docs/framework-roadmap-next-prompts.md`
- `docs/runbooks/operate-framework-task-queue.md`

No single place owned the important details — schema ownership, issue/PR linkage, state
semantics, and drift-recovery expectations. This document now does.

## Scope and design goals

- Keep GitHub artifacts as the system of record.
- Keep queue operation lightweight and practical.
- Keep one bounded objective per queue item and per PR.
- Preserve deterministic next-task preparation.
- Avoid heavy orchestration or autonomous PR chaining.

## Canonical artifacts

- **Machine-readable queue:** [`.github/framework-task-queue.json`](https://github.com/izakl/brainforge/blob/main/.github/framework-task-queue.json)
- **Queue validator:** [`scripts/check-framework-task-queue.sh`](https://github.com/izakl/brainforge/blob/main/scripts/check-framework-task-queue.sh)
- **Merge-triggered preparation:** [`.github/workflows/prepare-next-framework-task.yml`](https://github.com/izakl/brainforge/blob/main/.github/workflows/prepare-next-framework-task.yml)
- **Queue operations runbook:** [`docs/runbooks/operate-framework-task-queue.md`](runbooks/operate-framework-task-queue.md)
- **Human-readable roadmap companion:** [`docs/framework-roadmap-next-prompts.md`](framework-roadmap-next-prompts.md)

## Canonical queue entry schema

Queue file version: `version: 1`

Queue-level issue linkage metadata should be present:

```json
{
  "issue_backed_queue_model": {
    "prepared_issue_marker_prefix": "framework-task-queue-id:",
    "prepared_issue_label": "agent-task",
    "prepared_issue_template": "agent-execution-task.yml",
    "issue_required_statuses": ["in_progress", "done", "superseded"],
    "allow_issueless_statuses": ["blocked", "pending"]
  }
}
```

Each task entry in `tasks[]` should follow this structure:

```json
{
  "id": "kebab-case-stable-id",
  "title": "Human-readable bounded objective title",
  "status": "blocked|pending|in_progress|done|superseded",
  "depends_on": ["upstream-task-id"],
  "why_now": "Why this item belongs in the ordered queue now",
  "suggested_prompt": "Prompt-ready task framing for issue/agent kickoff",
  "continuity_writeback_expected": "yes|likely|no",
  "labels": ["agent-task", "framework-change"],
  "related_docs": ["docs/path.md"]
}
```

### Field semantics

- `id`: immutable stable queue identifier used for issue marker linkage and dependency references.
- `title`: bounded objective label used in prepared issues.
- `status`: queue-level execution state.
- `depends_on`: task ids that must be `done` before this item can be dependency-ready.
- `why_now`: durable rationale for ordering and review context.
- `suggested_prompt`: prompt-ready body for queue-driven issue/agent kickoff.
- `continuity_writeback_expected`: whether continuity/health writeback is expected when merged.
- `labels`: labels applied to prepared issues.
- `related_docs`: durable references that define the work packet context.

## Prompt-ready task definition guidance

A queue entry should be prompt-ready without additional private chat context:

- objective is explicit and bounded
- context is summarized in `why_now`
- constraints remain enforceable through linked docs
- acceptance/validation expectations are available in prepared issue packet
- dependency prerequisites are explicit in `depends_on`

If a prompt cannot be executed from the queue entry + linked artifacts, refine the entry before
marking it `pending`.

## Queue state model

Queue status meanings:

- `blocked`: dependencies are not yet complete.
- `pending`: dependency-ready candidate for preparation and execution.
- `in_progress`: active implementation work is open.
- `done`: implementation is merged and queue objective is complete.
- `superseded`: no longer to be executed as defined; replaced by another durable artifact or task.

### Deterministic preparation rule

At most one dependency-ready `pending` task should exist at a time so merge-triggered preparation
stays deterministic.

### State transition guidance

- `blocked` → `pending`: all `depends_on` items are `done`.
- `pending` → `in_progress`: prepared issue is accepted and execution starts.
- `in_progress` → `done`: linked implementation PR is merged.
- `pending|in_progress` → `superseded`: scope replaced, retired, or absorbed elsewhere with durable rationale.
- `superseded` is terminal for that queue id; do not silently reuse it.

## Issue-backed queue linkage model

Queue linkage uses durable GitHub artifacts, not chat memory:

### Canonical linkage keys and boundaries

- Queue id (`tasks[].id`) is the stable durable key.
- Prepared issue marker (`<!-- framework-task-queue-id:<task-id> -->`) is the durable queue↔issue join key.
- Queue file does not store mutable issue numbers to avoid duplicate planning state.
- Issue numbers, PR numbers, and project state remain in GitHub artifacts.

### Status-to-issue requirements

| Queue status | Issue required? | Rationale |
| --- | --- | --- |
| `blocked` | Optional | Work may remain dependency-gated before active issue preparation. |
| `pending` | Optional (until prepared) | Merge-triggered preparation can open one prepared issue for the next dependency-ready task. |
| `in_progress` | Required | Active execution must have an open queue-linked issue to preserve continuity and handoff quality. |
| `done` | Required (historical) | Completed task must be traceable to its linked issue and merged PR evidence. |
| `superseded` | Required (historical) | Supersession must preserve durable rationale and successor linkage through issue/PR history. |

### Lifecycle pattern (queue → issue → PR)

1. **Queue entry → prepared issue**
   - `prepare-next-framework-task.yml` creates one prepared issue for the next dependency-ready `pending` item.
   - Prepared issue body includes marker `<!-- framework-task-queue-id:<task-id> -->`.
   - Issue remains human-reviewed before implementation starts.

2. **Prepared issue → active execution**
   - On accepted start, queue item transitions `pending` → `in_progress`.
   - If issue is replaced/split, keep one canonical parent issue with the queue marker and link child issues/PRs back to it with explicit decomposition notes.
   - Only one issue should be treated as the canonical execution source for a queue id at a time.

3. **Issue → implementation PR**
   - PR links the canonical queue-backed source issue using `Closes #...`.
   - Additional linkage uses non-closing references such as `Relates-to #...`.
   - PR carries objective, constraints, acceptance, and validation evidence from the issue packet.

4. **PR merge → queue update**
   - Canonical queue-linked issue is expected to be closed by merge automation (or closed manually with a reconciliation comment if close keywords were missed).
   - Queue item transitions to `done` (or `superseded`) in bounded queue-maintenance change.
   - Queue transitions must match durable issue/PR truth and preserve dependency correctness.

### Post-merge closure/linkage closeout sequence

Use this closeout order to keep queue state, issue state, and merged PR evidence aligned:

1. Verify merged PR linkage for the canonical queue-linked issue:
   - preferred: `Closes #...` in merged PR body
   - allowed fallback: manual issue closure with reconciliation comment linking merged PR
2. Reconcile queue entry transition in `.github/framework-task-queue.json` (`in_progress` → `done` or `superseded` with rationale).
3. Run both queue checks:
   - `bash scripts/check-queue-health.sh`
   - `bash scripts/check-framework-task-queue.sh`
4. Merge bounded queue-maintenance correction when needed.
5. Verify latest `prepare-next-framework-task.yml` run prepared (or intentionally skipped) the correct next item.

### Manual vs automated issue creation

- Automated: next-task prepared issue packet creation and duplicate avoidance using queue-id marker.
- Manual: issue refinement, decomposition decisions, supersession decisions, and queue state transitions.
- Safety rule: automation prepares work packets only; it does not autonomously execute, open PRs, or merge.

### Decomposition, blocking, and supersession handling

- **Blocked work:** keep queue status `blocked`; issue may be absent or open with explicit unblock condition.
- **Decomposed work:** keep original queue id as the canonical parent issue marker; represent child execution splits in linked issues/PRs with explicit scope split notes.
- **Superseded work:** transition queue entry to `superseded`; preserve replacement rationale and successor artifact links in issue/PR history.

## Governance rules for queue accuracy

- Keep queue state synchronized with durable artifact truth (issue/PR/merge outcomes).
- Keep one objective per queue item and one queue item per implementation PR.
- Keep issue-backed queue status semantics aligned with `issue_backed_queue_model` metadata in `.github/framework-task-queue.json`.
- Do not reorder queue items without durable rationale in issue/PR history.
- Do not change `id` values after publication; create a new item if semantics change.
- Use `superseded` instead of deleting historical items silently.
- Keep merge-triggered automation limited to issue preparation; humans own execution and merges.

## Drift detection and recovery

Drift exists when queue state and repository reality differ. Common patterns:

| Drift signal | Description | Automated? |
| --- | --- | --- |
| Stale `related_docs` path | A referenced doc no longer exists at that path | ✅ `check-queue-health.sh` |
| `blocked` with all deps `done` | Task should have been promoted to `pending` | ✅ `check-queue-health.sh` |
| `pending` with unresolved deps | Task should be `blocked` until deps reach `done` | ✅ `check-queue-health.sh` |
| Non-terminal task depending on `superseded` | Dependency can never be satisfied | ✅ `check-queue-health.sh` |
| Multiple `in_progress` simultaneously | Possible missed state transition after merge | ✅ `check-queue-health.sh` (warning) |
| Open queue-linked issue with merged PR but missing close keyword | PR merged without closing canonical source issue | ✅ `check-queue-health.sh` (when GitHub API token/repo context is available) |
| Open queue-linked issue while queue task is already `done` | Queue/issue closure drift after merge | ✅ `check-queue-health.sh` (when GitHub API token/repo context is available) |
| GitHub API drift checks skipped due firewall/API access restrictions | API-backed closure/linkage checks could not run in current execution surface | ✅ `check-queue-health.sh` (warning with manual closeout fallback) |
| `in_progress` with no open issue or PR | Missed status update after merge | 🔲 Manual |
| `done` with no merge evidence | Incorrect status or missing PR linkage | 🔲 Manual |
| Prepared issue queue-id marker mismatch | Linkage model broken | 🔲 Manual |
| Stale `why_now` or `suggested_prompt` text | Context no longer reflects repo reality | 🔲 Manual |

Run both scripts to detect the full range of drift:

```bash
bash scripts/check-queue-health.sh         # semantic drift signals
bash scripts/check-framework-task-queue.sh # schema/structural integrity
```

For the full queue health procedure, manual checklist, and recovery actions per
drift signal, see the dedicated runbook:
[`docs/runbooks/run-queue-health-check.md`](runbooks/run-queue-health-check.md).

### Firewall/API-access fallback rule

In some Copilot coding agent runs, outbound calls to `api.github.com` are blocked by
firewall policy. When this occurs:

- Treat API-backed closure/linkage checks as skipped warnings, not proof that closeout is complete.
- Reconcile canonical queue-linked issue state and `.github/framework-task-queue.json` state manually in a bounded maintenance PR.
- Preserve merged PR evidence in issue comments/PR descriptions so queue continuity remains durable without chat history.

Recovery steps summary:

1. Identify the drift signal from the script output or manual checklist.
2. Reconcile queue entry state to durable issue/PR truth.
3. Preserve replacement rationale when using `superseded`.
4. If a queue-linked issue stayed open after merge:
   - close it manually
   - leave a reconciliation comment with merged PR evidence
   - verify queue status still matches issue/PR truth
5. Run `bash scripts/check-queue-health.sh` and `bash scripts/check-framework-task-queue.sh`.
6. Open bounded queue-correction PR with rationale and linked artifacts.
7. Re-run prepare-next workflow if next-task preparation needs recovery.

## Automation boundary

Automated:

- queue integrity validation
- next dependency-ready `pending` selection
- issue preparation and duplicate-issue avoidance by queue-id marker

Human-in-the-loop:

- queue state transitions
- prepared issue refinement and assignment
- implementation, review, and merge decisions
- supersession decisions and drift recovery

## Mobile quick action

- **Use when:** you need to quickly verify queue linkage/state accuracy from mobile.
- **Do from mobile:**
  - Confirm prepared issue marker includes the expected queue id.
  - Confirm issue/PR links still match queue item status.
  - Leave a drift note and assign owner when mismatch is found.
- **Do not do from mobile:**
  - Perform multi-item queue schema or dependency rewrites.
  - Reconcile complex supersession decisions without desktop review.
- **Escalate to desktop/cloud when:**
  - Queue drift spans multiple entries or dependency chains.
  - Queue recovery requires script validation and workflow reruns.
- **Primary artifact to update:**
  - The queue-maintenance issue or PR that records reconciliation decisions.

## Related docs

- [Operator onboarding pack](operator-onboarding-pack.md) — practical first-use route for queue-aware continuation and handoffs.
- [GH agents and automation](gh-agents-and-automation.md) — execution-surface guidance, including Copilot coding agent firewall/API mitigation options.
- [Framework continuity and memory](framework-continuity-and-memory.md)
- [Framework roadmap: next GitHub agent prompts](framework-roadmap-next-prompts.md)
- [Framework prompt library and execution queue](framework-prompt-library.md)
- [Operate the framework task queue](runbooks/operate-framework-task-queue.md)
- [Run the queue health check](runbooks/run-queue-health-check.md)
- [Governance checklist](governance-checklist.md)
- [Framework health](framework-health.md)
