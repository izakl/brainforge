# Framework Continuity Snapshot Template

Use this template to create a durable, structured continuity snapshot that makes
handoff and resume fast, inspectable, and consistent.

Copy this structure into the active issue, PR, or discussion comment that carries
the current bounded work context.

For step-by-step usage guidance, see
[`docs/runbooks/create-continuity-snapshot.md`](runbooks/create-continuity-snapshot.md).

## Snapshot metadata

| Field | Value |
| --- | --- |
| Snapshot timestamp (UTC) | |
| Snapshot owner | |
| Scope | |
| Source objective artifact | |
| Canonical continuity artifact index link | |
| Related handoff packet (if any) | |
| Previous continuity snapshot link (if any) | |

## Lifecycle and setup posture

| Field | Value |
| --- | --- |
| Current lifecycle stage (1-8) | |
| Milestone acknowledgments status (`setup_selected` / `setup_applied` / `readiness_verified` / `active_work_started` / `handoff_created` / `resume_completed`) | |
| Setup profile | |
| Setup-intent artifact and status | |
| Readiness verification status | |
| Readiness evidence links | |

## Milestone acknowledgment log

Use this lightweight event log to make major state transitions explicit.

| Milestone | Status (`not_recorded` / `recorded`) | Timestamp (UTC) | Evidence/artifact link | Next implied action |
| --- | --- | --- | --- | --- |
| `setup_selected` | | | | |
| `setup_applied` | | | | |
| `readiness_verified` | | | | |
| `active_work_started` | | | | |
| `handoff_created` | | | | |
| `resume_completed` | | | | |

## Active work posture

| Field | Value |
| --- | --- |
| Active bounded objective | |
| Current execution status (`ready` / `in_progress` / `in_review` / `blocked` / `done`) | |
| Current owner / execution surface | |
| Blocking risks or decisions | |
| Current implementation artifacts (issue/PR/ADR) | |

## Queue and deferred-work posture

| Field | Value |
| --- | --- |
| Queue-backed execution in use? (`yes` / `no`) | |
| Queue status summary (if `yes`) | |
| Deferred work summary | |
| Deferred-work artifact links | |

## Handoff posture

| Field | Value |
| --- | --- |
| Handoff required now? (`yes` / `no`) | |
| Handoff status (`not_started` / `drafted` / `acknowledged` / `closed`) | |
| Next owner | |
| Handoff artifact link | |

## Recommended next action

| Field | Value |
| --- | --- |
| Next action | |
| Why this is next | |
| Preconditions | |
| Expected evidence after completion | |

## Handoff-resume linkage checks

| Field | Value |
| --- | --- |
| Handoff packet includes resume fields? (`yes` / `no`) | |
| Required artifacts to review first (from handoff packet) | |
| Resume verification status (`not_started` / `in_progress` / `verified`) | |
| Resume verification evidence links | |

## Priority artifact links

- Setup/readiness artifacts:
- Active work artifacts:
- Queue/deferred artifacts:
- Handoff/resume artifacts:

## Continuity artifact index block (optional but recommended)

Use this block when the snapshot also serves as the canonical continuity index for
the active workstream.

- Workstream:
- Current lifecycle stage:
- Milestone status reference:
- Read this first:
- Latest continuity snapshot:
- Latest handoff packet:
- Latest readiness evidence:
- Latest queue/deferred status:
- Blocked by / deferred summary:
- Next ready action:
- Last updated (UTC + owner):

## Snapshot quality checklist (good enough)

- [ ] Lifecycle stage is explicit and maps to
      [`runbooks/framework-lifecycle-map.md`](runbooks/framework-lifecycle-map.md).
- [ ] Setup profile/setup-intent and readiness status are explicit with evidence links.
- [ ] Milestone acknowledgments are explicit, with evidence links for recorded events.
- [ ] Active bounded work state is explicit and owner is named.
- [ ] Queue/deferred posture is explicit (or explicitly marked not applicable).
- [ ] Handoff state and next owner are explicit.
- [ ] One concrete recommended next action is explicit.
- [ ] Handoff packet resume fields and verification status are explicit.
- [ ] Canonical continuity artifact index link is present (or explicitly not used).
- [ ] Links point to durable repository artifacts, not chat-only context.

## Mobile quick action

- **Use when:** you need a fast continuity checkpoint from mobile before handing
  off or resuming.
- **Do from mobile:**
  - Update lifecycle stage, status, and next owner fields.
  - Add links to current issue/PR/handoff artifacts.
  - Leave a short note if any required field is still incomplete.
- **Do not do from mobile:**
  - Reconstruct missing context across many artifacts in one pass.
  - Mark a snapshot complete if readiness/handoff status is unknown.
- **Escalate to desktop/cloud when:**
  - You must run readiness or validation checks.
  - You must reconcile queue or handoff state across multiple artifacts.
- **Primary artifact to update:**
  - The active issue or PR comment carrying the continuity snapshot.

## Related docs

- [Create continuity snapshot runbook](runbooks/create-continuity-snapshot.md) —
  when/how to write and use this snapshot.
- [Framework lifecycle map and operator journey](runbooks/framework-lifecycle-map.md) —
  lifecycle stage definitions and stage transitions.
- [Framework state milestones](framework-state-milestones.md) —
  canonical event-style milestone definitions and evidence expectations.
- [Searchable continuity and artifact indexing guidance](framework-continuity-artifact-indexing.md) —
  lightweight naming/linking/indexing conventions for latest-artifact lookup.
- [Handoff packet template](handoff-packet-template.md) — handoff minimum fields.
- [Resume from a handoff packet](runbooks/resume-from-handoff-packet.md) —
  ordered resume review and verification flow.
- [Multi-agent handoff playbook](multi-agent-handoff-playbook.md) — handoff
  contract and patterns.
- [Framework continuity and memory](framework-continuity-and-memory.md) — durable
  continuity model and operating principles.
