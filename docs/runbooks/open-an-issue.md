# Open an Issue

Use this runbook to open a well-formed GitHub issue that is ready for triage and
execution. In Brain Factory, the issue is the durable record of a unit of work,
so getting it right up front keeps later steps fast and reviewable.

## When to use this runbook

Use when you need to:

- file a new work item of any type
- normalize an inbound signal into a durable GitHub artifact
- create an agent-ready work packet before assigning it for implementation

## Procedure

### 1. Identify the work type

Consult the [Issue taxonomy](../issue-taxonomy.md#when-to-use-which-type) to pick
the correct template. The taxonomy is canonical for which template to use and
which fields are required; this runbook is the step-by-step procedure for filing.

Common starting points:

- External or inbound signal needing triage → **Support Intake**
- Framework repo defects (broken links, failing CI, incorrect docs) → **Bug report (framework)**
- Product defects with reproducible steps → **Bug / Defect**
- Architecture or process decision required → **ADR Proposal**
- Legacy modernization or discovery-first work → **Redevelopment / Discovery**
- Framework doc/governance/automation change → **Framework Change**
- Framework operations quality improvement → **Improvement**
- Product capability improvement → **Enhancement**
- Documentation change → **Docs**
- Bounded work ready for agent execution → **Agent Execution Task**
- In-progress work transferring surfaces or owners → **Handoff Packet**
- Suspected vulnerability or sensitive security finding → **Private advisory** via `SECURITY.md` (not a public issue template)

### 2. Open the issue using the correct template

Navigate to the repository's New Issue chooser (the **Issues** tab → **New issue**) and select
the matching template.

### 3. Normalize external context first

If context originated outside GitHub (local notes, Google Drive, OneDrive, external AI output,
email thread, or support transcript):

- Summarize the relevant content into the issue body before filing.
- Include provenance: where it came from, when, and by whom.
- Do not reference private sources that reviewers or agents cannot access.
- Do not start implementation until context is normalized into this GitHub issue.
- If context includes vulnerability detail, secrets, or credentials, route privately first and publish only sanitized context publicly.

See [Context synchronization](../context-synchronization.md) for the full three-tier model.

### 4. Fill in all required fields

Check each item from the
[minimum quality checklist](../issue-taxonomy.md#minimum-quality-checklist):

- [ ] **Objective** — clear and specific statement of what needs to happen
- [ ] **Context** — why this matters and what the current state is
- [ ] **Constraints and non-goals** — what must not change or be out of scope
- [ ] **Acceptance criteria** — testable conditions confirming completion
- [ ] **Validation expectations** — how completion will be evidenced (tests, checks, review)
- [ ] **Execution surface** — which surface(s) will execute the work
- [ ] **Related artifacts** — linked issues, PRs, ADRs, or docs

For triage-first issue types (for example, Support Intake), route to a fully
scoped downstream issue before implementation starts.

### 5. Set labels and project fields

After filing:

- Confirm auto-applied labels match the expected label for this issue type
  (see [Label inventory](../issue-taxonomy.md#label-inventory)).
- Add the issue to the project board with status `Intake`.
- Set minimum project fields: Work Type, priority/severity, owner, execution mode.
- Initialize `Needs Follow-up` (usually `No` at intake) and leave `Linked PR` empty until implementation starts.

### 6. Link related artifacts

If this issue relates to an existing PR, ADR, discussion, or parent issue:

- Add cross-reference links in the issue body.
- Use `Closes #...` or `Relates-to #...` syntax when a linked PR is opened.

For queue-backed Agent Execution Task issues:

- Preserve or add queue marker `<!-- framework-task-queue-id:<task-id> -->`.
- Treat queue id as the durable linkage key; do not replace it with chat-only references.
- If the issue supersedes/replaces another queue-linked issue, link both issues and explain the transition.

### 7. Confirm execution readiness

Before assigning for implementation, verify the minimum quality checklist is fully satisfied.
If any required field is missing, update the issue before assigning an owner or agent.

**Next steps by issue type:**

- For Support Intake issues: follow the
  [Respond to support intake](respond-to-support-intake.md) runbook.
- For Framework Change issues: follow the
  [Start a framework change](start-a-framework-change.md) runbook.
- For Handoff Packet issues: the next owner uses the issue as their execution source; no
  separate runbook needed.

## Mobile quick action

- **Use when:** you need to open or complete a new issue from mobile.
- **Do from mobile:**
  - Use the issue type decision list to select the correct template.
  - Fill in objective, context, and acceptance criteria at minimum before submitting.
  - Set severity/priority and work type in the project item after filing.
- **Do not do from mobile:**
  - Complete deep normalization of complex external context on mobile.
  - Start implementation without verifying the full minimum quality checklist.
- **Escalate to desktop/cloud when:**
  - Context normalization requires reviewing large external documents.
  - Multiple linked artifacts need coordinated updates.
- **Primary artifact to update:**
  - The newly opened issue with all required fields and routing comment.

## Related docs

- [Issue taxonomy](../issue-taxonomy.md) — full reference for all issue types and when to use them.
- [Context synchronization](../context-synchronization.md) — normalize external context before implementation.
- [Security and secure delivery guardrails](../security-and-secure-delivery.md) — choose private vs public routing for security-sensitive work.
- [Operating model](../operating-model.md) — how work flows through the framework day-to-day.
- [Product support and improvement loop](../product-support-and-improvement-loop.md) — how inbound signals become routed work.
- [GitHub Projects setup](../github-projects-setup.md) — project field/view/routing model.
- [Framework queued execution memory](../framework-queued-execution-memory.md) — canonical queue-entry schema and issue/PR linkage model for queue-prepared tasks.
- [Respond to support intake](respond-to-support-intake.md) — next step for inbound support signals.
- [Start a framework change](start-a-framework-change.md) — next step for framework change issues.
