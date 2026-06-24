# Issue Taxonomy

This reference defines every GitHub issue type the framework uses: what each covers, when to
use it, the fields it requires, and where it routes next. It is for anyone filing or triaging
work — whether you are a contributor, a maintainer, or an AI agent.

GitHub Issues are the primary place where work enters the framework, gets normalized, and is
routed. Every meaningful unit of work should begin as a durable issue before implementation
starts. New to the project? See [How Brain Factory works](how-brain-factory-works.md) for the
bigger picture.

## Issue type overview

| Type | Template | Labels | Use when | Routes to |
| --- | --- | --- | --- | --- |
| Support Intake | `support-intake.yml` | `support-intake` | External or inbound signal needs triage before classifying work | Triage → routed work type |
| Bug report (framework) | `bug-report.yml` | `bug` | Broken link, failing CI, incorrect doc, or automation misbehaving in this repo | Framework fix PR |
| Bug / Defect | `bug-defect.yml` | `defect` | Reproducible product failure with clear expected vs actual behavior | Fix PR with validation evidence |
| Enhancement | `enhancement.yml` | `enhancement` | Incremental product capability improvement | Implementation PR |
| Framework Change | `framework-change.yml` | `framework-change` | Change to framework docs, runbooks, ADRs, automation, or governance | Framework PR |
| Docs | `docs.yml` | `documentation` | Documentation improvement with defined audience and scope | Docs PR |
| Improvement | `improvement.yml` | `improvement` | Framework operations, governance, prompt, template, or workflow quality | Framework PR |
| ADR Proposal | `adr.yml` | `decision`, `adr` | Architecture or process decision required before or during implementation | ADR file in `docs/adr/` + implementation issues |
| Redevelopment / Discovery | `redevelopment-discovery.yml` | `redevelopment`, `discovery` | Legacy modernization or unknown-heavy investigation requiring discovery before implementation | ADR, phased implementation issues |
| Agent Execution Task | `agent-execution-task.yml` | `agent-task` | Bounded implementation task fully scoped and ready for an approved agent surface | Implementation PR |
| Handoff Packet | `handoff-packet.yml` | `handoff` | Structured transfer of in-progress work between humans, agents, or execution surfaces | Next owner's work continuation |

## When to use which type

Work through these questions in order to select the right template:

1. **Is this an external or inbound signal that needs triage before you know what it is?**
   → Use **Support Intake**. Triage routing will determine the downstream work type.

2. **Is something failing that should work?**
   - Framework repo defects (broken links, failing CI, incorrect docs) → **Bug report (framework)**
   - Product defects with reproducible steps and clear expected vs actual behavior → **Bug / Defect**

3. **Does this require a durable architecture or process decision recorded before implementation?**
   → Use **ADR Proposal**.

4. **Is this legacy modernization or does scope require discovery before implementation?**
   → Use **Redevelopment / Discovery**.

5. **Is this a change to the framework itself?**
   - Changes to docs, runbooks, ADRs, or the operating model → **Framework Change**
   - Improvements to framework operations quality, templates, or workflow reliability → **Improvement**

6. **Is this a product behavior improvement (not a bug)?**
   → Use **Enhancement**.

7. **Is this a documentation-only change?**
   → Use **Docs**.

8. **Is the scope fully defined and ready for agent execution?**
   → Use **Agent Execution Task**.

9. **Is in-progress work transferring between surfaces or owners mid-execution?**
   → Use **Handoff Packet**.

> **Default starting point:** When in doubt, start with **Support Intake** for external signals
> or **Framework Change** for internal ideas. Triage will clarify the correct downstream type.
>
> **Security-sensitive exception:** suspected vulnerabilities, exploit paths, or secret exposures
> should be reported privately via `SECURITY.md`, not through public issue templates.

## Minimum quality checklist

An issue is ready for implementation when all of the following are true:

- [ ] **Objective** is clear and specific
- [ ] **Context** explains why this matters and what the current state is
- [ ] **Constraints and non-goals** state what must not change
- [ ] **Acceptance criteria** are testable conditions for completion
- [ ] **Validation expectations** describe how completion will be evidenced
- [ ] **Execution surface** is selected (VS Code Copilot local / GitHub Copilot Coding Agent /
      GH CLI / Human-led / Hybrid)
- [ ] **External context is normalized** — source material from outside GitHub (notes, Drive,
      OneDrive, external AI output) is summarized into this issue, not left in private chat or
      local files only
- [ ] **Related artifacts are linked** — ADRs, upstream issues, relevant docs, or project items

This checklist aligns with the [standard work packet](operating-model.md#standard-work-packet)
in the operating model and the [handoff packet minimum](handoff-packet-template.md).

Notes:

- Triage-first issue types (especially **Support Intake**) are intentionally lighter at intake.
- Implementation should begin from a routed downstream issue that satisfies this checklist.
- Any intentional template exceptions should be documented in the issue body and linked to
  a bounded follow-up issue when harmonization is deferred.

## Issue → Project → PR flow

```text
Issue opened (correct template)
  ↓ Project status: Intake
Triage: classify work type, set severity/priority, assign owner
  ↓ Normalize external context into issue
Project status: Ready
  ↓ Implementation starts
PR opened with "Closes #..." or "Relates-to #..."
  ↓ PR review confirms constraint preservation + includes validation evidence
Merge → project status: Done
  ↓ Deferred work → follow-up issue
Continuity artifacts updated (if framework-level change)
```

For detailed end-to-end examples, see [Example issue-to-PR flows](example-issue-to-pr-flow.md).
For project field and view setup, see [GitHub Projects setup](github-projects-setup.md).

## Label inventory

Labels applied by issue templates. Define these labels in the repository to enable consistent
auto-labeling and project routing:

| Label | Template(s) | Purpose |
| --- | --- | --- |
| `support-intake` | Support Intake | Marks inbound signals before triage classifies them |
| `bug` | Bug report (framework) | Lightweight marker for framework-internal defects |
| `defect` | Bug / Defect | Full work-packet marker for product defects |
| `enhancement` | Enhancement | Product capability improvement |
| `framework-change` | Framework Change | Framework doc/governance/automation change |
| `documentation` | Docs | Documentation improvement |
| `improvement` | Improvement | Framework operations or tooling quality |
| `decision`, `adr` | ADR Proposal | Architecture or process decision |
| `redevelopment`, `discovery` | Redevelopment / Discovery | Modernization or discovery-first work |
| `agent-task` | Agent Execution Task | Agent-executable bounded work packet |
| `handoff` | Handoff Packet | Cross-surface or cross-owner work transfer |

## Relationship to downstream artifacts

| Issue type | Typical downstream artifacts |
| --- | --- |
| Support Intake | Converted to Bug / Defect, Enhancement, Docs, or Improvement issue |
| Bug report (framework) | Fix PR; may spawn ADR if root cause reveals a governance gap |
| Bug / Defect | Fix PR with test evidence; may spawn follow-up Enhancement or Docs issue |
| Enhancement | Implementation PR; may require ADR first for significant decisions |
| Framework Change | Framework PR; update continuity artifacts in same PR where applicable |
| Docs | Docs PR; cross-link to related runbooks, ADRs, or examples |
| Improvement | Framework PR; consider whether an ADR is needed for the decision |
| ADR Proposal | `docs/adr/` file + implementation issues for follow-up obligations |
| Redevelopment / Discovery | ADR + phased implementation issues tracked in GitHub Projects |
| Agent Execution Task | Implementation PR; may close or relate to a parent issue; if queue-prepared, preserve `framework-task-queue-id` marker linkage |
| Handoff Packet | No new artifact; the next owner picks up the issue as their execution source |

## Queue-backed agent-task rules

The framework can prepare Agent Execution Task issues automatically from a durable task queue
(see [Framework queued execution memory](framework-queued-execution-memory.md) for the full
model). When an issue is prepared this way, follow these rules:

- Use queue-id marker format:
  `<!-- framework-task-queue-id:<task-id> -->`
- Keep exactly one canonical open queue-linked execution issue per queue id.
- Use `Closes #...` in the implementation PR for the canonical queue-linked issue; use `Relates-to #...` for additional non-closing linkage.
- Queue entries may be issue-less while `blocked` or `pending`.
- Queue entries should be issue-backed once `in_progress`, and remain traceable when `done` or `superseded`.
- Do not duplicate planning state by copying mutable issue/PR numbers into queue entries; keep queue ids stable and link through issue/PR artifacts.

Reference: [`framework-queued-execution-memory.md`](framework-queued-execution-memory.md) for canonical status/linkage governance.

## Mobile quick action

- **Use when:** you need to quickly select the right issue type and file a usable issue from mobile.
- **Do from mobile:**
  - Use the decision questions above to pick the correct template.
  - Fill in objective, context, and acceptance criteria at minimum before submitting.
  - Set severity/priority and work type in the project item after filing.
- **Do not do from mobile:**
  - Attempt deep normalization of complex external context from mobile alone.
  - Redefine the taxonomy or add new issue types without desktop review.
- **Escalate to desktop/cloud when:**
  - Issue type is genuinely unclear and the triage decision requires broad context review.
  - External context normalization requires reviewing large external documents.
- **Primary artifact to update:**
  - The newly filed issue with routing comment and next-step notes.

## Related docs

- [Operating model](operating-model.md) — how the framework runs day-to-day, including the standard work packet.
- [Work-type matrix](work-type-matrix.md) — practical tailoring guidance for required artifacts, validation depth, and follow-up by work category.
- [Product support and improvement loop](product-support-and-improvement-loop.md) — how signals flow back into the framework.
- [Context synchronization](context-synchronization.md) — normalize external context into durable GitHub artifacts.
- [GitHub Projects setup](github-projects-setup.md) — project field/view/routing model for intake through follow-up.
- [Example issue-to-PR flow](example-issue-to-pr-flow.md) — end-to-end worked examples across issue types.
- [Framework queued execution memory](framework-queued-execution-memory.md) — queue-entry schema, issue/PR linkage model, and queue-state governance for queued agent execution.
- [Governance checklist](governance-checklist.md) — periodic audit items including artifact readiness.
- [Handoff packet template](handoff-packet-template.md) — canonical reusable handoff structure.
- [Open an issue](runbooks/open-an-issue.md) — step-by-step runbook for filing a well-formed issue.
