# Multi-Agent Handoff Playbook

A *handoff* is the moment work passes from one contributor to another — for example from a human to an agent, or from one surface to another. This playbook standardizes handoffs so work can move without losing continuity, quality, or governance. It is for anyone passing or receiving work in a brain (a per-project repository); for the bigger picture, see [how Brain Factory works](how-brain-factory-works.md).

## Purpose

Use this guide whenever work moves between:

- human contributors
- VS Code Copilot (local)
- GitHub Copilot and other GitHub-hosted or cloud workflows
- GitHub CLI workflows
- GitHub Mobile
- external AI agents such as Claude Code

The goal is to leave a durable handoff packet in GitHub artifacts so the next owner can continue without relying on chat memory alone.

## Handoff minimum

Every handoff should preserve at least:

- **Objective** — what must happen next
- **Context** — business, technical, or support background
- **Constraints** — limits, guardrails, non-goals, or required standards
- **Acceptance criteria** — what makes the work complete
- **Validation expectations** — checks, evidence, or review expectations
- **Related artifacts** — linked issues, PRs, ADRs, docs, discussions, or project items
- **Next owner** — who or what surface is expected to act next
- **Status / current state** — where the work stopped and what is already done
- **Unresolved risks / questions** — open decisions, ambiguities, or blockers

If the context started outside GitHub, *normalize* it first — distill it into a durable GitHub artifact (issue, PR, ADR, or discussion) — before implementation or approval continues.

Use these reusable sources for the structure above:

- Canonical template: [`docs/handoff-packet-template.md`](handoff-packet-template.md).
- GitHub Issues form: [`.github/ISSUE_TEMPLATE/handoff-packet.yml`](../.github/ISSUE_TEMPLATE/handoff-packet.yml).
- Completeness is enforced by [`scripts/check-handoff-packet.sh`](../scripts/check-handoff-packet.sh), per [ADR 0015](adr/0015-handoff-packet-enforcement.md).

For a handoff someone will later resume, also fill the resume fields in [`docs/handoff-packet-template.md`](handoff-packet-template.md): lifecycle stage, active work item, setup/readiness posture, blockers and deferred posture, the order to review artifacts in, the recommended next safe action, and resume verification steps.

## Common handoff patterns

### Human discovery → external AI synthesis → GitHub issue normalization

Use when source material lives outside the repository.

1. Human gathers notes, screenshots, interviews, tickets, or legacy references.
2. External AI agent synthesizes findings into candidate tasks, assumptions, and risks.
3. Human normalizes the result into a GitHub issue or discussion.
4. Implementation starts only from the normalized GitHub artifact.

### Human planning → GitHub Copilot Coding Agent implementation

Use when the task is repository-bounded and ready for execution.

1. Human prepares issue with objective, constraints, acceptance criteria, and validation.
2. Human selects GitHub Copilot Coding Agent for bounded implementation.
3. Agent implements from the issue packet and preserves validation evidence in the PR.
4. Reviewer checks that the issue packet survived the handoff.

### Mobile triage → desktop planning

Use when fast capture happens on GitHub Mobile but deeper planning needs desktop context.

1. Reviewer or maintainer captures triage notes, labels, and status from mobile.
2. Mobile update leaves a durable issue, PR comment, or project note with the handoff minimum.
3. Desktop owner expands the packet, resolves open questions, and chooses execution mode.

### Local implementation → PR review → mobile approval

Use for normal implementation loops.

1. Engineer implements locally with VS Code Copilot or local CLI workflows.
2. PR preserves objective, constraints, validation evidence, and out-of-scope notes.
3. Reviewer performs desktop review with linked issue and validation context visible.
4. Final approval or follow-up capture can happen from GitHub Mobile.

### Support intake → triage → enhancement/docs/redevelopment/ADR routing

Use when incoming work is ambiguous and must be classified before execution.

1. Support or operations input is captured in an issue.
2. Triage assigns labels, project status, severity, and work type.
3. Work routes into the right durable artifact:
   - enhancement issue
   - docs issue
   - redevelopment/discovery issue
   - ADR proposal issue
4. Execution begins from the routed artifact, not from the raw intake alone.

## Artifact expectations

Choose the artifact that best matches the handoff stage:

- **Issue** — default handoff artifact for executable work, triage, scope, routing, and acceptance criteria
- **Pull request** — implementation handoff artifact for changes, validation evidence, and review decisions
- **ADR** — architecture or process decision handoff artifact when tradeoffs or durable decisions matter
- **Discussion** — early discovery or synthesis artifact when the work is not yet ready to become a bounded issue
- **Project item/comment** — status, routing, owner, blocked state, or lightweight follow-up notes tied to the operational board

Rule: do not force deep implementation context to live only in project comments or mobile notes. Promote it into an issue, PR, ADR, or discussion when it becomes execution-relevant.

## Project state updates during handoff

When a handoff changes ownership or execution surface, keep the linked project item aligned:

- update `Next owner` / assignee field at handoff acceptance
- keep status synchronized with artifact state (`Ready`, `In Progress`, `In Review`, `Blocked`, or `Follow-up / Deferred`)
- document blocker/unblock condition in durable artifact before setting `Blocked`
- do not move to `Done` until closure evidence is present in linked issue/PR

Use [GitHub Projects setup](github-projects-setup.md) as the source for status definitions and artifact-state mapping.

## Anti-patterns

Avoid:

- handoff by chat memory only
- hidden constraints that are not copied into repository artifacts
- implementation without normalized external context
- review without validation evidence
- mobile trying to carry deep implementation context alone

These patterns create rework, weak reviews, and governance drift.

## Worked examples

### Example 1: discovery to issue

**Artifact chain:** local notes → external AI summary → GitHub issue → PR

1. Product lead gathers customer interview notes locally.
2. External AI agent produces a structured synthesis with themes and candidate actions.
3. Maintainer converts that synthesis into an **Enhancement** issue with constraints and acceptance criteria.
4. Coding work starts from the issue and lands in a linked PR with validation evidence.

### Example 2: planning to coding agent

**Artifact chain:** GitHub issue → GitHub Copilot Coding Agent prompt → PR → mobile approval

1. Human planner refines a bounded issue and sets project status to `Ready`.
2. GitHub Copilot Coding Agent implements from the issue packet.
3. PR links the issue and records validation performed.
4. Reviewer checks details on desktop and approver finishes on mobile.

### Example 3: support routing to durable decision

**Artifact chain:** support intake issue → triage/project update → ADR proposal issue → implementation issue → PR

1. Support lead opens a **Support Intake** issue describing repeated friction.
2. Triage classifies the problem as needing a workflow decision, updates the project item, and opens an ADR proposal issue.
3. After decision, maintainer opens a bounded implementation or docs issue.
4. Work completes in a linked PR, and follow-up notes close the loop on the original intake.

## Mobile quick action

- **Use when:** you need to acknowledge a handoff packet and keep next-owner momentum from mobile.
- **Do from mobile:**
  - Confirm the handoff minimum (objective, constraints, acceptance, validation) is visible in the linked artifact.
  - Assign or confirm the next owner and execution surface.
  - Leave a short handoff-acceptance comment that names any missing context.
- **Do not do from mobile:**
  - Author or rewrite a full handoff packet.
  - Resolve complex scope disputes across multiple artifacts.
- **Escalate to desktop/cloud when:**
  - The packet is missing core execution fields and needs deep reconstruction.
  - Multiple issues, PRs, or docs must be updated together to preserve continuity.
- **Primary artifact to update:**
  - The active handoff issue or pull request comment thread.

## Handoff packet coverage

ADR 0015 defines this convention: [ADR 0015: Handoff packet enforcement](adr/0015-handoff-packet-enforcement.md).

| Doc path | Status | Notes |
| --- | --- | --- |
| `docs/handoff-packet-template.md` | Expected | Canonical template — must contain all nine required fields. |

## Related docs

- [Operating model](operating-model.md) — core lifecycle and execution surfaces.
- [GitHub agents and automation](gh-agents-and-automation.md) — agent execution guardrails and routing.
- [GitHub mobile guide](github-mobile-guide.md) — mobile-safe decision boundaries and handoff practice.
- [Context synchronization](context-synchronization.md) — durable cross-surface context transfer patterns.
- [GitHub Projects setup](github-projects-setup.md) — minimum viable setup and status/artifact synchronization rules.
- [Example issue-to-PR flow](example-issue-to-pr-flow.md) — worked lifecycle transitions and artifact flow.
- [Handoff packet template](handoff-packet-template.md) — canonical reusable template for all nine required fields.
- [Resume from a handoff packet](runbooks/resume-from-handoff-packet.md) — ordered resume procedure and verification checklist.
- [ADR 0015: Handoff packet enforcement](adr/0015-handoff-packet-enforcement.md) — decision record for this convention.
