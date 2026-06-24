# GitHub Projects Setup and Operating Model

This guide explains how to set up and run a GitHub Projects board as the shared place where a brain (a per-project repository) tracks work from intake through execution, review, and follow-up. It is for the person standing up the board and for anyone keeping it accurate day to day; for the bigger picture, see [how Brain Factory works](how-brain-factory-works.md).

## Purpose

Use GitHub Projects to make the real state of work visible across:

- product delivery
- support and incident follow-up
- framework and governance improvements
- redevelopment and discovery work
- security hardening and audit work

The board is the routing and visibility layer. The work itself still lives in issues, pull requests, ADRs, docs, discussions, and workflow history — the board points at that truth rather than replacing it.

## Durable-state rule (non-negotiable)

Project status must represent what is true in durable artifacts, not what is true only in private chat or local notes.

- ✅ Valid status source: issue body/comments, linked PR state, ADR/discussion links, explicit blocker note.
- ❌ Invalid status source: "agent said it's done" in private chat, unlinked local checklist, undocumented verbal handoff.

If the artifact is not updated, the project state is not updated.

## Minimum viable Projects setup (MVP for adopters)

Use one primary repository project with these required fields:

1. **Status** (single select)
2. **Work Type** (single select)
3. **Priority** (single select)
4. **Owner** (assignee)
5. **Execution Mode** (single select)
6. **Linked PR** (text/URL or built-in PR link)
7. **Needs Follow-up** (yes/no)

Recommended additional fields for richer routing:

- **Risk** (single select)
- **Blocked Reason** (text)
- **Next Owner** (person/text)
- **Support Source** (single select)
- **Needs ADR** (yes/no)
- **Area / Component** (single select)
- **Target iteration/milestone** (iteration or milestone field)

## Canonical status model

Use this default status set:

- Intake
- Triage
- Ready
- In Progress
- In Review
- Blocked
- Support Active
- Follow-up / Deferred
- Done

Optional extension statuses (use only if needed):

- Discovery
- Refine

### Status transition intent

- **Intake**: issue exists, initial signal captured.
- **Triage**: work type/priority/owner being decided.
- **Ready**: work packet complete and execution-approved.
- **In Progress**: implementation or decision work active.
- **In Review**: PR/review/checks in progress.
- **Blocked**: waiting on explicit unblock condition.
- **Support Active**: live support coordination underway.
- **Follow-up / Deferred**: intentionally postponed, split, or phase-next.
- **Done**: acceptance and validation complete; closure links preserved.

## Artifact-state synchronization matrix

Use this matrix to keep issue/project/PR/handoff state aligned.

| Project status | Issue state expectation | PR state expectation | Handoff expectation | Follow-up expectation |
| --- | --- | --- | --- | --- |
| Intake | New issue created, template fields started | No PR yet | N/A | N/A |
| Triage | Work type + priority + owner being set | No PR yet | Optional triage owner handoff note | N/A |
| Ready | Objective, context, constraints, acceptance, validation complete | No PR yet (or draft prep only) | Next owner/surface explicit | N/A |
| In Progress | Implementation/decision execution underway | Draft or active PR optional | Active owner confirmed | N/A |
| In Review | Issue references active PR and validation expectations | PR open; checks/review active | Reviewer/approver owner visible | N/A |
| Blocked | Block reason and unblock condition documented | PR may exist or be absent | Next action owner documented | Optional follow-up split |
| Support Active | Support loop comments and impact updates current | PR optional | Escalation ownership explicit | Potential routed issue pending |
| Follow-up / Deferred | Scope split/defer rationale documented | PR may be closed or scoped partial | Next owner and trigger condition documented | Follow-up issue exists and linked |
| Done | Resolution note + evidence links present | PR merged/closed as applicable | Handoff closure captured when used | Remaining work represented as linked follow-up issue(s) or explicitly none |

## Work-type routing model

Set `Work Type` during triage and route with consistent expectations:

| Work Type | Primary intake source | Primary execution artifact | Typical follow-up |
| --- | --- | --- | --- |
| Support | Support intake issue | Routed issue or direct support closure note | Defect/docs/improvement issue when recurring |
| Defect | Bug/defect issue | Fix PR | Regression test/docs gap issue |
| Enhancement | Enhancement issue | Feature PR | Improvement issue for rollout debt |
| Documentation | Docs issue | Docs PR | Support communication or FAQ update |
| Redevelopment | Redevelopment/discovery issue | Phased implementation issues + PRs | ADR or migration follow-up |
| Discovery | Discovery issue/discussion | Decision issue (often ADR proposal) | Bounded implementation issue |
| ADR Decision | ADR proposal issue | ADR file + downstream implementation issue/PR | Follow-up obligations as issues |
| Improvement | Framework/support retrospective issue | Framework PR | Metrics/automation issue |
| Security | Private advisory + sanitized public tracker when needed | Hardening/remediation PR | Governance/runbook/security follow-up |
| Audit/Governance | Health/governance findings issue | Docs/process/automation PR | Recurring audit task |

## Suggested views

At minimum, create:

1. **Intake & Triage (table)**
   - Filter: `Status` in `Intake`, `Triage`
   - Group: `Work Type`
2. **Execution Board (board)**
   - Columns: `Ready` → `In Progress` → `In Review` → `Done`
3. **Support & Incident (board/table)**
   - Filter: `Work Type` in `Support`, `Defect`, `Security`
   - Columns: `Intake`, `Support Active`, `Blocked`, `Follow-up / Deferred`, `Done`
4. **Blocked Radar (table)**
   - Filter: `Status = Blocked`
   - Columns include `Blocked Reason`, `Owner`, `Next Owner`
5. **Follow-up Queue (table)**
   - Filter: `Status = Follow-up / Deferred` OR `Needs Follow-up = Yes`
6. **Mobile Quick Triage (compact)**
   - Fields: title, status, work type, priority, owner

## Issue → Project → PR → writeback flow

```text
Issue filed with correct template
  ↓
Add to project, set Status=Intake + initial Work Type
  ↓
Triage updates owner/priority/risk and normalizes context
  ↓
Status=Ready (packet complete)
  ↓
Execution starts (Status=In Progress)
  ↓
PR opened and linked (Status=In Review)
  ↓
Merge/closure + validation evidence + resolution note
  ↓
Status=Done OR Status=Follow-up / Deferred + linked follow-up issue
```

## Queue-backed execution alignment

For work sourced from `.github/framework-task-queue.json`:

- Keep queue-id marker `<!-- framework-task-queue-id:<id> -->` in the prepared issue.
- Treat queue id as durable linkage key between queue entry, project item, issue, and PR.
- `blocked`/`pending` queue states may exist before active issue execution.
- `in_progress`/`done`/`superseded` queue states should map to project items with linked issue/PR evidence.
- Avoid duplicating mutable issue/PR numbers into queue entries; preserve linkage through issue/PR/project artifacts.

## Automation conventions (lightweight)

Prefer transparent, minimal automation:

- auto-add issues from templates to the primary project
- set default `Status = Intake`
- optionally map template label → initial `Work Type`
- remind owners on stale `Blocked` or `Support Active` items
- suggest `Done` transitions when linked PR merges (never hide missing writeback)

Avoid automation that silently changes status without durable artifact evidence.

## Portability and extension guidance

For adopters:

- start with the MVP fields and canonical statuses above
- map local labels/work types to your repo's taxonomy
- add advanced fields/views only after the baseline loop is stable
- keep the durable-state rule unchanged across repositories

See [Framework portability and adoption](framework-portability-and-adoption.md) for phased adoption guidance.
Use [Framework profile packs](framework-profile-packs.md) to scale project field
and view complexity based on team/repository context.

## Definition of Done (project level)

A project item is done when:

- acceptance criteria are met in the linked issue/PR
- validation evidence is recorded in durable artifacts
- PR is merged/closed as appropriate
- support communication and follow-up obligations are captured
- ADR-worthy decisions are documented when required
- project status is moved to `Done` with all links preserved

## Mobile quick action

- **Use when:** you need to perform quick project-board triage or status maintenance from mobile.
- **Do from mobile:**
  - Update status, owner, priority, and work type for actively triaged items.
  - Capture blocked reasons or deferred work as linked follow-up issues.
  - Confirm linked issue/PR context before moving items to `Done`.
- **Do not do from mobile:**
  - Redesign project field taxonomy or view architecture.
  - Reconfigure automation rules that move or classify project items.
- **Escalate to desktop/cloud when:**
  - Board structure, fields, or automation behavior must change.
  - Coordination requires bulk updates across many project items.
- **Primary artifact to update:**
  - The project item update comment with linked issue or pull request.

## Related docs

- [Operating model](operating-model.md) — how the framework runs day-to-day.
- [Work-type matrix](work-type-matrix.md) — practical work-type-specific routing, rigor, and follow-up expectations.
- [Product support and improvement loop](product-support-and-improvement-loop.md) — how signals flow back into the framework.
- [Framework metrics and feedback loop](framework-metrics-and-feedback.md) — how project-routing signals feed recurring effectiveness reviews.
- [Framework reporting and review cadence](framework-reporting-and-review-cadence.md) — practical review rhythms for weekly hygiene, monthly health/effectiveness, and quarterly adoption reviews.
- [Framework profile packs](framework-profile-packs.md) — profile-based guidance for scaling project operations without fragmenting framework invariants.
- [Framework continuity and memory](framework-continuity-and-memory.md) — what the framework remembers across sessions.
- [Branching and cleanup](branching-and-cleanup.md) — branch lifecycle and stale-branch handling.
- [Governance checklist](governance-checklist.md) — periodic audit items.
