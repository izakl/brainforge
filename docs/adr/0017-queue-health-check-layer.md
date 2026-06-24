# ADR 0017: Queue health check and drift-detection layer

- Status: Accepted
- Date: 2026-05-25

## Context

The framework has a queue schema validator (`scripts/check-framework-task-queue.sh`) that
verifies structural correctness: required fields, allowed status values, dependency
references, and uniqueness of task IDs. It also enforces the deterministic-preparation
rule that at most one dependency-ready `pending` task exists at a time.

However, schema correctness does not guarantee that queue state accurately reflects
repository reality. Several failure modes can cause the queue to drift silently:

1. **Stale `related_docs` references** — a queue entry references a doc that has been
   renamed, moved, or deleted. The schema validator does not check whether referenced
   files exist in the repository.

2. **Missed state transitions after merge** — a task's implementation PR is merged but
   the queue entry is not updated from `in_progress` to `done`. The queue then has an
   `in_progress` item with no corresponding active PR.

3. **Missed `blocked → pending` promotion** — a task remains `blocked` after all its
   dependencies reach `done`, preventing merge-triggered preparation from selecting it.

4. **Premature `pending` marking** — a task is marked `pending` before its dependencies
   are `done`, which can cause merge-triggered preparation to select the wrong task.

5. **Superseded-dependency traps** — a non-terminal task depends on a task that has been
   marked `superseded`. Since only `done` satisfies the dependency model, the blocked
   task can never become dependency-ready.

6. **Multiple concurrent `in_progress` entries** — more than one task in `in_progress`
   simultaneously, which may indicate a missed state transition.

None of these drift patterns are caught by `check-framework-task-queue.sh` because they
require semantic awareness of state consistency, not just schema validity.

## Decision

Introduce a dedicated lightweight queue health and drift-detection layer alongside the
existing schema validator, following the same pattern as prior check additions (ADR 0015,
ADR 0016).

### 1. `scripts/check-queue-health.sh`

A new script that checks semantic drift signals not covered by the schema validator:

- **Check 1: related_docs existence** — every file path in every `related_docs` array
  must resolve to an actual file in the repository. Stale references are errors.

- **Check 2: blocked tasks with all deps done** — tasks in `blocked` status whose entire
  `depends_on` list is `done` must be promoted to `pending`. Remaining `blocked` is an
  error.

- **Check 3: pending tasks with unresolved deps** — tasks in `pending` status that have
  dependencies not yet `done` have drifted; they must be `blocked` or the dependencies
  must be resolved first.

- **Check 4: superseded-dependency traps** — non-terminal tasks (`blocked`, `pending`,
  `in_progress`) that depend on `superseded` tasks can never become dependency-ready.
  The dependency reference must be updated or replaced.

- **Check 5: multiple in_progress simultaneously** — more than one `in_progress` task
  at a time is reported as a warning. This may be intentional in some cases, but is
  unusual and worth human review.

The script follows the existing framework check pattern: `set -euo pipefail`, repo-root
detection via `BASH_SOURCE`, and an embedded Python block for JSON processing.

### 2. `docs/runbooks/run-queue-health-check.md`

A new operator runbook that provides:

- When to run the queue health check.
- Step-by-step procedure (automated + manual verification).
- A drift signal matrix mapping each failure mode to its recovery action.
- Mobile quick action guidance.

### 3. Integration into `framework-audit.yml`

The new script is added as a parallel `queue-health` job in the consolidated
`framework-audit.yml` workflow, so it runs:

- On the monthly scheduled audit (first of each month).
- On manual `workflow_dispatch`.
- On pull requests that touch the queue file, the new script, or the workflow itself.

## Alternatives considered

- **Expand `check-framework-task-queue.sh` with drift checks:** rejected because the
  existing script has a focused single responsibility (schema validation). Mixing
  structural validation with semantic drift detection would make both harder to maintain
  and debug. Keeping them separate follows the principle of one job per script.

- **GitHub API-based drift checking (check open issues/PRs against queue state):**
  rejected because it requires a GitHub token with Issues read scope, introduces
  network dependencies, and couples the check to the GitHub API surface. Structural
  drift signals detectable from the queue file itself are sufficient for most drift
  patterns and are simpler, faster, and reusable in other repos.

- **Human-only drift detection (no script):** rejected because the governance checklist
  already identifies queue drift as a recurring concern. Without a repeatable automated
  signal, drift accumulates silently between manual audits.

## Consequences

Positive:

- Semantic drift in queue state is caught automatically at CI time and during monthly
  audits, not only during manual walkthrough.
- Four common drift patterns become errors rather than advisory notes.
- Multiple-in_progress is surfaced as a warning without blocking merge.
- The new runbook gives operators a structured walkthrough for cases that require
  human verification beyond what the script checks.
- The check is lightweight and reusable: any repo adopting this queue model can
  copy the script without additional dependencies.

Negative:

- Authors making queue state changes must ensure the file remains health-check-clean,
  not just schema-valid.

Follow-ups:

- Update `docs/framework-health.md` to reflect the new automated check.
- Update `docs/governance-checklist.md` to reference the queue health check.
- Update `docs/framework-queued-execution-memory.md` to link to the new runbook and
  expand drift guidance with the full signal matrix.
- Update `AGENTS.md` validation commands to include `check-queue-health.sh`.

## References

- [`scripts/check-queue-health.sh`](https://github.com/izakl/brainforge/blob/main/scripts/check-queue-health.sh)
- [`scripts/check-framework-task-queue.sh`](https://github.com/izakl/brainforge/blob/main/scripts/check-framework-task-queue.sh)
- [`docs/runbooks/run-queue-health-check.md`](../runbooks/run-queue-health-check.md)
- [`.github/workflows/framework-audit.yml`](https://github.com/izakl/brainforge/blob/main/.github/workflows/framework-audit.yml)
- [`docs/framework-queued-execution-memory.md`](../framework-queued-execution-memory.md)
- [ADR 0015: Handoff packet enforcement](./0015-handoff-packet-enforcement.md)
- [ADR 0016: Continuous checks and recurring framework audit layer](./0016-continuous-checks-layer.md)
