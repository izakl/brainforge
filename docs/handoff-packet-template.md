# Handoff Packet Template

A **handoff packet** is the durable summary that lets the next person, agent, or
surface resume work without losing context. Use this template whenever work moves
between humans, agents, or execution surfaces. Copy the full structure into a
GitHub issue, pull request body, ADR, or discussion comment. New to the project?
Start with [how it works](how-brain-factory-works.md).

The nine fields below are the **required minimum** defined in
[`docs/multi-agent-handoff-playbook.md`](multi-agent-handoff-playbook.md) and
enforced by [`scripts/check-handoff-packet.sh`](../scripts/check-handoff-packet.sh).

See [`docs/adr/0015-handoff-packet-enforcement.md`](adr/0015-handoff-packet-enforcement.md)
for the decision record.

For terminology and rigor alignment, also reference
[`docs/framework-continuity-and-memory.md`](framework-continuity-and-memory.md),
[`docs/work-type-matrix.md`](work-type-matrix.md), and
[`docs/runbooks/open-an-issue.md`](runbooks/open-an-issue.md).

## Objective

<!-- What must happen next. Be specific: one sentence or a tight bullet list. -->

## Context

<!-- Business, technical, or support background needed to act on this packet.
     Normalize any non-GitHub context here before implementation starts. -->

## Constraints

<!-- Hard limits, guardrails, non-goals, and required standards.
     Include security, scope, or platform restrictions. -->

## Acceptance criteria

<!-- What makes the work complete. Use a bullet list of verifiable conditions. -->

- [ ]

## Validation expectations

<!-- Checks, evidence, or review expectations the next owner must satisfy.
     Include CI gates, manual tests, or review sign-offs. -->

## Related artifacts

<!-- Links to issues, PRs, ADRs, discussions, or project items that carry
     additional context. Use relative repo paths where possible. -->

## Next owner

<!-- Who or what surface is expected to act next.
     Examples: @username, "GitHub Copilot Coding Agent", "Reviewer on desktop". -->

## Status / current state

<!-- Where the work stopped and what is already done.
     This section is the resume point for the next owner. -->

## Unresolved risks / questions

<!-- Open decisions, ambiguities, or blockers that the next owner must address.
     List anything that could cause rework if left undecided. -->

## Resume packet refinement (required for resumable handoff)

Fill this section so the next operator can restart quickly without rereading every
artifact from scratch.

| Field | Value |
| --- | --- |
| Current lifecycle stage (1-8) | |
| Current objective / active work item | |
| Setup posture (profile + setup-intent status) | |
| Readiness posture (valid / stale / unknown) + evidence links | |
| Milestone acknowledgments status (`setup_selected` / `setup_applied` / `readiness_verified` / `active_work_started` / `handoff_created` / `resume_completed`) | |
| Blockers / risks | |
| Deferred or queued work | |
| Canonical continuity artifact index link | |
| Latest continuity snapshot link + timestamp | |
| Latest readiness evidence link + timestamp | |
| Required artifacts to review first (ordered list) | |
| Recommended next safe action | |
| Resume verification steps (commands/checks/evidence) | |

## Resume handoff quality checklist

- [ ] Lifecycle stage and active objective are explicit.
- [ ] Setup and readiness posture are explicit, with evidence links if available.
- [ ] Milestone acknowledgment status is explicit and evidence-backed.
- [ ] Blockers/risks and deferred/queued work are explicit (or marked not applicable).
- [ ] Required artifacts are listed in review order for the resuming operator.
- [ ] One recommended next safe action is explicit.
- [ ] Resume verification steps are explicit and bounded.
- [ ] Canonical continuity artifact index and latest snapshot/readiness links are explicit.
- [ ] Continuity snapshot link is included in related artifacts.

## Mobile quick action

- **Use when:** you need to create or accept a handoff packet from GitHub Mobile.
- **Do from mobile:**
  - Copy this template structure into the active issue or PR body.
  - Confirm the next owner and status fields are current before handing off.
  - Post a brief acknowledgment comment naming any field that is still incomplete.
- **Do not do from mobile:**
  - Author complex context or constraints sections that require cross-artifact research.
  - Accept a handoff packet with missing required fields as complete.
- **Escalate to desktop/cloud when:**
  - Multiple related artifacts need to be updated together for the packet to be coherent.
  - Unresolved risks require architecture or design research to resolve.
- **Primary artifact to update:**
  - The active handoff issue or pull request body.

## Related docs

- [Multi-agent handoff playbook](multi-agent-handoff-playbook.md) — full handoff
  patterns, anti-patterns, and artifact expectations.
- [Framework continuity and memory](framework-continuity-and-memory.md) — continuity
  contract and durable artifact expectations.
- [Framework state milestones](framework-state-milestones.md) — event-style
  milestone definitions, evidence expectations, and next-step implications.
- [Searchable continuity and artifact indexing guidance](framework-continuity-artifact-indexing.md) —
  lightweight naming/linking/indexing conventions for latest-artifact lookup.
- [Work-type matrix](work-type-matrix.md) — work-type-specific rigor and stricter-path
  precedence guidance.
- [Prompt cookbook](prompt-cookbook.md) — reusable prompt structures for handoff initiation.
- [Open an issue runbook](runbooks/open-an-issue.md) — issue packet readiness and
  required field checklist.
- [Governance checklist](governance-checklist.md) — checklist for constraint preservation
  and artifact readiness across handoffs.
- [ADR 0015: Handoff packet enforcement](adr/0015-handoff-packet-enforcement.md) — the
  decision record for this convention.
