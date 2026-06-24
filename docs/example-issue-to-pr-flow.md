# Example Issue-to-PR Flow (Worked Flows)

Four worked examples that trace a piece of work end to end — from first idea to
merged pull request — across mobile, desktop, cloud agents, the CLI, and external
AI tools. Use them as concrete reference flows when you are unsure how a handoff
should look. New to the project? See
[How Brain Factory works](how-brain-factory-works.md) first.

## Shared rule for all examples

GitHub is the single source of record. If context starts somewhere else (local
notes, Google Drive, OneDrive, connector-accessed files, or external AI output),
turn it into GitHub artifacts — an issue, discussion, or ADR — before
implementation starts. The docs call this "normalizing" the context.

---

## Example 1: Feature delivery flow (idea → issue → plan → implement → review → merge → follow-up)

### Scenario

A team wants to add a "CSV export by date range" feature.

1. **Idea capture (GitHub Mobile)**
   - PM opens an **Enhancement** issue from mobile.
   - Adds objective, user impact, constraints, and acceptance criteria.
2. **Planning (GitHub Copilot Chat on github.com)**
   - Maintainer asks Copilot Chat to draft implementation plan from issue.
   - Plan is pasted back into issue comments; constraints are refined.
3. **Implementation (choose one surface)**
   - Path A: Engineer uses **VS Code Copilot (local)** for coding/debugging.
   - Path B: Maintainer uses **GitHub Copilot Coding Agent** for bounded repo task.
4. **PR creation**
   - PR links issue (`Closes #123`) and states execution surface.
   - PR includes validation evidence and non-goals.
5. **Review + approval (desktop + mobile)**
   - Reviewer checks acceptance criteria and constraint preservation.
   - Approver gives final approval from mobile.
6. **Merge + follow-up**
   - Branch deleted.
   - Any deferred edge-case work is captured as an **Improvement** issue.

---

## Example 2: Support-to-product improvement flow (support ticket → triage → enhancement/ADR → implementation → release → closure)

### Scenario (support-to-product)

Support reports repeated confusion in onboarding email copy.

1. **Support intake**
   - Support lead creates **Support Intake** issue with severity and customer impact.
2. **Triage (GH CLI + project routing)**
   - Labels: `support`, `triage`, severity.
   - Project status set to `Triage`, owner assigned.
   - Status update is backed by durable issue comments/links, not chat-only notes.
3. **Conversion**
   - Triage determines it is product + docs work.
   - Linked **Enhancement** issue created for behavior change.
   - Linked **Docs** issue created for user-facing wording updates.
4. **Decision checkpoint (ADR if needed)**
   - If changing onboarding policy, create **ADR Proposal** issue first.
5. **Implementation + release**
   - Coding agent or local VS Code Copilot executes enhancement issue.
   - Docs issue completed in parallel or same PR when tightly coupled.
6. **Loop closure**
   - PR merged and linked issues closed.
   - Support issue updated with release note and communication sent.
   - Recurring pattern logged as **Improvement** item for future prevention.

---

## Example 3: Redevelopment/discovery flow (discovery issue → ADR → phased implementation issues → project tracking)

### Scenario (redevelopment/discovery)

Legacy reporting workflow needs modernization.

1. **Discovery intake**
   - Create **Redevelopment/Discovery** issue with source material references.
2. **External synthesis**
   - External AI agent summarizes legacy docs and interviews.
   - Output is normalized into issue + discussion with assumptions/questions.
3. **ADR proposal**
   - Team creates **ADR Proposal** issue for target architecture decision.
4. **Phased decomposition**
   - Create phased issues: data model migration, API compatibility, UI transition.
   - Add all to GitHub Project with status and dependency fields.
5. **Phased implementation**
   - Each phase executes on separate branch/PR with explicit validation gates.
6. **Governed closure**
   - ADR accepted/superseded status updated.
   - Project view confirms all phases complete and follow-up debt captured.

---

## Example 4: Mobile follow-up flow (mobile signal → handoff → completion)

### Scenario (mobile follow-up)

Approver on mobile notices PR lacks constraint reference.

1. Approver leaves mobile comment requesting missing constraint traceability.
2. Approver opens a linked **Improvement** issue from mobile.
3. Assignee picks issue on desktop and updates PR description + docs.
4. Reviewer confirms governance checklist items are now complete.
5. Approval is granted on mobile, PR merges, branch deletes.
6. Follow-up issue closes with note: "constraint traceability pattern added to template."

---

## Why these examples matter

These flows make handoffs explicit, keep constraints durable, and stop implementation from starting on context that has not yet been normalized into GitHub.

## Mobile quick action

- **Use when:** you need a fast, concrete flow reference from mobile to unblock routing or review.
- **Do from mobile:**
  - Pick the closest worked example and cite it in the active issue or PR comment.
  - Confirm the current stage ordering and capture any missing step as a follow-up.
  - Update project status/owner fields to match the selected flow.
- **Do not do from mobile:**
  - Treat an example as a full implementation spec for complex edge cases.
  - Rewrite multi-stage flow definitions from phone.
- **Escalate to desktop/cloud when:**
  - Real-world workflow deviates materially and needs a new or revised worked example.
  - Validation evidence is missing across multiple lifecycle stages.
- **Primary artifact to update:**
  - The issue or pull request comment documenting which example flow is being followed.

## Related docs

- [How Brain Factory works](how-brain-factory-works.md) — five-minute tour for newcomers.
- [Operating model](operating-model.md) — how the framework runs day-to-day.
- [Product support and improvement loop](product-support-and-improvement-loop.md) — how signals flow back into the framework.
- [Framework continuity and memory](framework-continuity-and-memory.md) — what the framework remembers across sessions.
- [Branching and cleanup](branching-and-cleanup.md) — branch lifecycle and stale-branch handling.
- [Governance checklist](governance-checklist.md) — periodic audit items.
