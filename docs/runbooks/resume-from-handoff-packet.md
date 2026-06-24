# Resume from a Handoff Packet

Restart paused work from a handoff packet and continuity snapshot, then pick one
safe next action with minimal guesswork. Use it whenever you pick up work that
was paused or passed to you.

A *handoff packet* records what was being done and what the next owner needs; a
*continuity snapshot* captures the current state (lifecycle stage, blockers, next
action) so work can resume without the original chat. New to the project? See
[How Brain Factory works](../how-brain-factory-works.md) for the five-minute
tour, and the
[framework lifecycle map](framework-lifecycle-map.md) for the eight operating
stages this runbook references.

## When to use this runbook

- You are taking over work from another operator or agent.
- You are resuming your own paused work after a gap.
- A handoff exists, but the next safe action is not obvious yet.

## Primary artifacts

- Handoff packet template:
  [`../handoff-packet-template.md`](../handoff-packet-template.md)
- Continuity snapshot template:
  [`../framework-continuity-snapshot-template.md`](../framework-continuity-snapshot-template.md)
- Continuity snapshot runbook:
  [`create-continuity-snapshot.md`](create-continuity-snapshot.md)
- Lifecycle model:
  [`framework-lifecycle-map.md`](framework-lifecycle-map.md)

## Procedure

### Step 1 — Read in strict order before editing

Review these artifacts in order:

1. Canonical continuity artifact index block (if present in issue/PR).
2. Latest continuity snapshot.
3. Latest handoff packet.
4. Source objective artifact (issue/PR/ADR).
5. Linked queue/deferred artifacts (if queue-backed).

If any artifact is missing, stop and request/produce a refreshed packet before
implementation continues.

### Step 2 — Confirm current lifecycle and work posture

Confirm all are explicit:

- current lifecycle stage
- milestone acknowledgment status (using canonical names from
  [`../framework-state-milestones.md`](../framework-state-milestones.md))
- current objective / active work item
- current owner and execution surface
- current status (`ready` / `in_progress` / `in_review` / `blocked` / `done`)

If state is ambiguous, refresh the continuity snapshot first.

### Step 3 — Verify milestone evidence and implied next action

1. Confirm each recorded milestone has a durable evidence link.
2. Confirm milestone ordering is coherent with lifecycle stage.
3. Confirm the latest recorded milestone implies the selected next action.

If milestone state is missing or contradictory, update continuity and handoff
artifacts before coding.

### Step 4 — Validate setup and readiness posture

Determine whether the setup and readiness state still holds:

1. Confirm the setup profile and setup-intent artifact references are present.
2. Check whether the latest readiness evidence is recent and still applicable.
3. If it is stale or unknown, run:

   ```bash
   bash scripts/check-setup-readiness.sh
   npx -y markdownlint-cli2 "**/*.md"
   bash scripts/check-framework-task-queue.sh
   bash scripts/check-queue-health.sh
   ```

4. Record results in the active issue or PR before coding.

### Step 5 — Reconcile blockers, risks, and deferred/queued work

Confirm:

- blockers and unresolved decisions are listed
- deferred items are linked to durable artifacts
- queue state matches linked issue/PR state (if queue-backed)

If queue or deferred state diverges, reconcile it before implementation.

### Step 6 — Decide the next safe action

Choose one next action only when all are true:

- bounded objective is still valid
- readiness posture is valid or refreshed
- blockers are either resolved or explicitly accepted
- required artifacts have been reviewed

If these are not true, next safe action is to update artifacts, not code.

### Step 7 — Publish resume verification

Before implementation, add a short resume verification note in the active issue
or PR that includes:

- lifecycle stage
- setup/readiness status
- blockers/deferred posture
- selected next safe action
- continuity artifact index link and latest snapshot/handoff/readiness references

## Resume verification checklist

- [ ] Read continuity snapshot first, then handoff packet.
- [ ] Confirm lifecycle stage and active objective.
- [ ] Confirm milestone status is evidence-backed and coherent.
- [ ] Confirm setup-intent and readiness posture are still valid.
- [ ] Run readiness/baseline checks if posture is stale or unknown.
- [ ] Confirm blockers/risks and deferred or queued work.
- [ ] Identify one next safe action and record it in a durable artifact.

## Mobile quick action

- **Use when:** you need to assess resume readiness and assign the next action from mobile.
- **Do from mobile:**
  - Confirm the continuity snapshot and handoff links exist and are current.
  - Verify the lifecycle stage, blockers, and next-owner fields.
  - Leave a short "resume ready" or "not ready" comment with the next safe action.
- **Do not do from mobile:**
  - Mark readiness valid without evidence.
  - Reconcile multi-artifact queue drift from a phone.
- **Escalate to desktop/cloud when:**
  - You must run the readiness or baseline checks.
  - Handoff or snapshot artifacts are stale or contradictory.
- **Primary artifact to update:**
  - The active issue or PR comment thread for the resumed work.

## Related docs

- [Framework lifecycle map and operator journey](framework-lifecycle-map.md)
- [Create continuity snapshot](create-continuity-snapshot.md)
- [Close out a multi-agent handoff](close-out-a-multi-agent-handoff.md)
- [Operator onboarding pack](../operator-onboarding-pack.md)
- [Handoff packet template](../handoff-packet-template.md)
- [Framework continuity snapshot template](../framework-continuity-snapshot-template.md)
- [Framework state milestones](../framework-state-milestones.md)
- [Searchable continuity and artifact indexing guidance](../framework-continuity-artifact-indexing.md)
