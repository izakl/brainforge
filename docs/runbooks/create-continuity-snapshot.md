# Create Continuity Snapshot

Use this runbook to create or refresh a *continuity snapshot* — a short,
structured status record stored in a GitHub issue or PR — so the next operator
(or your future self) can resume quickly without reconstructing context from
scattered notes. It is how Brain Factory keeps work resumable across sessions,
people, and agents. For the bigger picture, see
[How Brain Factory works](../how-brain-factory-works.md).

## When to use this runbook

- At the end of a bounded work session.
- Before handing work to another owner or surface.
- When resuming after a gap and continuity is unclear.
- After setup/readiness posture materially changes.
- After queue/deferred-work posture materially changes.

## Primary artifacts

- Snapshot template:
  [`../framework-continuity-snapshot-template.md`](../framework-continuity-snapshot-template.md)
- Lifecycle stage model:
  [`framework-lifecycle-map.md`](framework-lifecycle-map.md)
- Handoff template:
  [`../handoff-packet-template.md`](../handoff-packet-template.md)
- Handoff playbook:
  [`../multi-agent-handoff-playbook.md`](../multi-agent-handoff-playbook.md)
- Resume runbook:
  [`resume-from-handoff-packet.md`](resume-from-handoff-packet.md)

## Procedure

### Step 1 — Confirm the source objective and current stage

1. Identify the active bounded objective artifact (issue or PR).
2. Identify the current lifecycle stage using
   [`framework-lifecycle-map.md`](framework-lifecycle-map.md).

### Step 2 — Gather setup and readiness posture

Capture:

- setup profile in use
- setup-intent status
- latest readiness status and evidence links

If setup/readiness are unknown, mark status as unknown and add a concrete
follow-up action.

### Step 3 — Gather milestone acknowledgment posture

Capture the status of event-style framework milestones:

- `setup_selected`
- `setup_applied`
- `readiness_verified`
- `active_work_started`
- `handoff_created`
- `resume_completed`

For each recorded milestone, include timestamp and durable evidence link.

### Step 4 — Gather active work and queue/deferred posture

Capture:

- active work status and owner
- blocking risks/decisions
- queue posture (if queue-backed)
- deferred work summary and links

### Step 5 — Capture handoff posture

Capture:

- whether handoff is required now
- handoff status
- next owner
- handoff artifact link (if present)

### Step 6 — Name one recommended next action

Record one concrete next action with:

- reason this is next
- preconditions
- expected evidence after completion

### Step 7 — Update or add continuity artifact index pointers

Before publishing, ensure this snapshot can be found quickly:

- add or refresh the canonical `## Continuity artifact index` block in the active
  issue/PR (if used for this workstream)
- include link to this snapshot as `Latest continuity snapshot`
- include latest handoff/readiness/queue links and `Last updated (UTC + owner)`
- keep prior snapshot link so inspection can follow chronology

Use
[`../framework-continuity-artifact-indexing.md`](../framework-continuity-artifact-indexing.md)
for the lightweight naming/linking conventions.

### Step 8 — Publish snapshot in a durable artifact

Copy the template into the active issue, PR, or discussion comment and fill all
sections:

[`../framework-continuity-snapshot-template.md`](../framework-continuity-snapshot-template.md)

Do not keep the only snapshot in chat-only notes.

### Step 9 — Verify snapshot quality (good enough)

Treat the snapshot as good enough only when all are true:

- lifecycle stage is explicit
- setup/readiness posture is explicit with evidence links
- milestone acknowledgments are explicit and evidence-backed
- active work posture is explicit with owner
- queue/deferred posture is explicit (or explicitly not applicable)
- handoff posture is explicit
- one recommended next action is explicit
- links resolve to durable repository artifacts

## Handoff usage

- Include the continuity snapshot link in the handoff packet.
- Keep handoff packet intent/constraints aligned with snapshot status fields.
- Fill handoff resume fields: required artifact review order, recommended next
  safe action, and resume verification steps.
- At handoff acknowledgment, update snapshot handoff status and next owner.

## Resume usage

1. Read the latest continuity snapshot first.
2. Follow [`resume-from-handoff-packet.md`](resume-from-handoff-packet.md) for
   ordered artifact review and resume verification.
3. Validate lifecycle/setup/readiness posture against current repository state.
4. Confirm queue/deferred and handoff posture still match reality.
5. Continue the bounded objective, or open a follow-up issue if reality diverges.

## Mobile quick action

- **Use when:** you need to update continuity state quickly from mobile during
  handoff or resume.
- **Do from mobile:**
  - Update status fields, next owner, and recommended next action.
  - Add links to active issue/PR/handoff artifacts.
  - Flag unknown fields explicitly instead of guessing.
- **Do not do from mobile:**
  - Perform broad multi-artifact reconciliation before writing the snapshot.
  - Mark snapshot quality as good enough without evidence links.
- **Escalate to desktop/cloud when:**
  - Setup/readiness checks must be run.
  - Queue or handoff state needs coordinated updates across multiple artifacts.
- **Primary artifact to update:**
  - The active issue or PR comment carrying the continuity snapshot.

## Related docs

- [Framework lifecycle map and operator journey](framework-lifecycle-map.md) —
  stage definitions and transitions.
- [Framework state milestones](../framework-state-milestones.md) —
  canonical milestone definitions and recording expectations.
- [Searchable continuity and artifact indexing guidance](../framework-continuity-artifact-indexing.md) —
  lightweight naming/linking/indexing conventions for latest continuity artifacts.
- [Close out a multi-agent handoff](close-out-a-multi-agent-handoff.md) —
  handoff closure sequence.
- [Resume from a handoff packet](resume-from-handoff-packet.md) —
  ordered resume verification and next-safe-action selection.
- [Framework continuity snapshot template](../framework-continuity-snapshot-template.md) —
  canonical structured snapshot format.
- [Framework continuity and memory](../framework-continuity-and-memory.md) —
  durable continuity contract.
