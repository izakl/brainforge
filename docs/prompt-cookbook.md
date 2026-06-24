# Prompt Cookbook

A collection of ready-to-use prompts for working with AI agents across Brain Factory, organized by the surface you are working from. Copy, fill in, and paste them into durable GitHub artifacts so every handoff stays auditable. New to the project? See [how Brain Factory works](how-brain-factory-works.md) first.

The recurring rule throughout: GitHub stays the durable source of record, so external context must be normalized into GitHub issues, ADRs, discussions, or PRs before any implementation begins.

## Standard prompt frame (use everywhere)

```text
Objective:
Context:
Constraints:
Expected output:
Acceptance criteria:
Validation:
Non-goals:
```

## Canonical source map for reusable artifacts

Use these documents as source of truth when writing or reusing prompts:

- **Issue template/work-type selection and required intake fields:** [`issue-taxonomy.md`](issue-taxonomy.md)
- **Issue filing procedure:** [`runbooks/open-an-issue.md`](runbooks/open-an-issue.md)
- **Handoff packet structure:** [`handoff-packet-template.md`](handoff-packet-template.md)
- **PR continuity/validation framing:** [`.github/pull_request_template.md`](../.github/pull_request_template.md)
- **Security-sensitive routing and redaction:** [`security-and-secure-delivery.md`](security-and-secure-delivery.md) and [`../SECURITY.md`](../SECURITY.md)
- **Work-type rigor and stricter-path precedence:** [`work-type-matrix.md`](work-type-matrix.md)

Examples and runbooks are supporting surfaces; when wording differs, follow the canonical artifacts above.

## Execution surfaces and when to use them

- **VS Code Copilot (local)**: deep implementation, local debugging, refactors
- **GitHub Copilot Chat or coding agent (GitHub cloud)**: repository-bounded planning and execution
- **GitHub CLI (`gh`)**: scripted triage, labeling, project and PR maintenance
- **GitHub Mobile**: quick triage, approvals, follow-up capture
- **External AI agents (such as Claude Code)**: discovery and synthesis from context outside the repository

Rule: normalize external context into GitHub issues, ADRs, discussions, or PRs before implementation.

Security rule: never include secrets, credentials, or exploit payloads in prompts; route suspected vulnerabilities through private reporting in [`SECURITY.md`](../SECURITY.md).

## Prompts by execution surface

### 1) VS Code Copilot (local)

#### Discovery-to-implementation handoff

```text
Objective:
Implement issue #<id> locally with VS Code Copilot.

Context:
Issue #<id> contains normalized scope and constraints from discovery.

Constraints:
Do not use private notes as authoritative context. Follow issue acceptance criteria exactly.

Expected output:
Local branch with scoped code/docs/tests and PR-ready summary.

Acceptance criteria:
- Behavior matches issue requirements
- No unrelated refactors
- Validation evidence captured

Validation:
Run repository checks and summarize results for PR.

Non-goals:
Do not expand scope beyond linked issue.
```

#### Review/fix follow-up

```text
Use PR review comments to produce only the requested deltas and updated validation evidence.
```

### 2) GitHub Copilot Chat/Coding Agent (GitHub cloud)

#### Planning from issue

```text
Given issue #<id>, produce an implementation plan with:
- files likely touched
- constraints to preserve
- validation steps
- risks and rollback notes
Keep the plan bounded to issue acceptance criteria.
```

#### Implementation task

```text
Implement issue #<id> in this repository.
Preserve constraints from issue and ADR links.
Include tests/docs updates required for acceptance.
Summarize validation in the PR body.
```

#### ADR drafting

```text
Draft an ADR proposal from discussion #<id> and issue #<id>.
Separate context, decision, alternatives, and consequences.
Link required follow-up issues.
```

### 3) GitHub CLI

#### Support triage

```text
Using the gh CLI, triage new support issues:
- apply severity/work-type labels
- assign owner
- add to project with status=Triage
- link duplicates and missing context tasks
Return a triage summary table.
```

#### Approval/follow-up automation

```text
Using gh CLI, find recently merged PRs tagged 'needs-follow-up',
create linked follow-up issues from checklist items,
and update project status to Follow-up.
```

### 4) GitHub Mobile

#### Quick intake

```text
Create a Support Intake issue with:
- observed problem
- user impact
- origin surface
- external context links
- triage urgency
Then route to Triage in project.
```

#### Approval guardrail comment

```text
Before merge, confirm linked issue, constraints, and validation evidence.
If missing, leave a request-changes comment naming the exact gap.
```

### 5) External AI agents (Claude Code, etc.)

#### Discovery synthesis

```text
Objective:
Synthesize external material (Drive/OneDrive/local notes) into implementation-ready GitHub artifacts.

Context:
Inputs come from non-repository sources.

Constraints:
Do not produce implementation code. Do not assume unstated facts.

Expected output:
- issue draft(s) with objective/context/constraints/acceptance/validation
- ADR proposal draft when decision tradeoffs are material
- unresolved questions list

Acceptance criteria:
Output can be pasted into GitHub artifacts without losing provenance.

Validation:
Tag each claim as fact/assumption/open-question.
```

#### Normalization request

```text
Convert this external transcript into:
1) one triage-ready GitHub issue
2) one ADR proposal (if architecture/process decision exists)
3) a short project routing note (status, owner, next surface)
No implementation steps until normalization is complete.
```

## Workflow-stage prompt starters

### Handoff packet initiation

Use when handing off work to another human, agent, or execution surface.
Copy into the issue or PR body and fill in each field.

```text
Objective:
[What must happen next — one sentence or tight bullet list]

Context:
[Business, technical, or support background needed to act]

Constraints:
[Hard limits, guardrails, non-goals, required standards]

Acceptance criteria:
- [ ]

Validation expectations:
[CI gates, manual tests, or review sign-offs required]

Related artifacts:
[Linked issues, PRs, ADRs, docs, discussions]

Next owner:
[Who or what surface acts next]

Status / current state:
[Where the work stopped; what is already done]

Unresolved risks / questions:
[Open decisions, ambiguities, or blockers]
```

For a standalone reusable file, see
[`docs/handoff-packet-template.md`](handoff-packet-template.md).
For the GitHub Issues form, use the
[Handoff Packet issue template](../.github/ISSUE_TEMPLATE/handoff-packet.yml).

### Discovery and redevelopment

- "Summarize unknowns, dependencies, and risks from issue #<id> without proposing implementation."

### Planning

- "Convert issue #<id> into a bounded implementation plan with acceptance and validation checkpoints."

### Implementation

- "Implement only acceptance criteria A/B/C from issue #<id>; list anything deferred."

### Review

- "Compare PR changes to issue constraints and identify any scope drift."

### Approval

- "Provide an approval checklist confirming linked artifact integrity and validation evidence."

### Follow-up

- "Create follow-up issue drafts for deferred items and project routing updates."

### Support triage (prompt patterns)

- "Classify this intake as defect/enhancement/docs/redevelopment/ADR/improvement and justify labels."

### ADR drafting (prompt patterns)

- "Draft ADR sections (Context, Decision, Alternatives, Consequences) from linked issue/discussion."

### External-context normalization

- "Normalize this external context into a GitHub issue + ADR + project update note before any coding."

### Security-sensitive intake triage

- "Assess whether this finding requires private vulnerability reporting. Return only sanitized public-summary text and an explicit routing decision (private advisory vs public hardening issue)."

## Anti-patterns

Avoid prompts that:

- start implementation from private chat memory only
- omit constraints or validation
- combine discovery, approval, and implementation into one unbounded request
- skip artifact linkage (issue ↔ PR ↔ ADR ↔ project)
- request raw secret extraction, credential disclosure, or unredacted sensitive exports
- ask for public disclosure of suspected vulnerabilities before private triage

## Practical usage note

Copy prompts into durable GitHub artifacts (issue body, PR body, ADR draft, discussion) so handoffs remain auditable across humans and agents.

## Mobile quick action

- **Use when:** you need to quickly reuse an established prompt pattern from mobile without inventing new structure.
- **Do from mobile:**
  - Copy a relevant existing prompt block into the active issue, PR, or discussion.
  - Select the matching execution surface pattern before handing off.
  - Capture prompt gaps as a follow-up docs issue instead of improvising broad new templates.
- **Do not do from mobile:**
  - Author new prompt frameworks or major taxonomy changes.
  - Merge unreviewed prompt patterns based only on ad-hoc chat context.
- **Escalate to desktop/cloud when:**
  - A new prompt pattern is needed across multiple docs or workflows.
  - Prompt changes require validation against implementation outcomes.
- **Primary artifact to update:**
  - The issue or pull request comment containing the reused prompt and handoff intent.

## Related docs

- [Operating model](operating-model.md) — how the framework runs day-to-day.
- [Product support and improvement loop](product-support-and-improvement-loop.md) — how signals flow back into the framework.
- [Framework continuity and memory](framework-continuity-and-memory.md) — what the framework remembers across sessions.
- [Security and secure delivery guardrails](security-and-secure-delivery.md) — safe prompt and execution guardrails for security-sensitive work.
- [Branching and cleanup](branching-and-cleanup.md) — branch lifecycle and stale-branch handling.
- [Governance checklist](governance-checklist.md) — periodic audit items.
