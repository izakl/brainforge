# Framework Roadmap: Next GitHub Agent Prompts

This roadmap lists the next bounded tasks for building out Brain Factory's shared framework, each with a ready-to-paste prompt for a GitHub coding agent. It is the human-readable companion to the machine-readable task queue at
[`.github/framework-task-queue.json`](../.github/framework-task-queue.json); read both to choose the next piece of work without relying on chat history or private notes. New to the project? Start with [Brain Factory: how it works](how-brain-factory-works.md).

## How to use this roadmap

- Treat `.github/framework-task-queue.json` as the canonical machine-readable task state and dependency source.
- Execute tasks in order unless a documented dependency exception is approved in an issue.
- Keep one queue item per PR; do not combine multiple roadmap items in one change.
- Copy the suggested prompt into a new GitHub issue or agent run, then adapt only repo-specific details.
- Preserve framework invariants from [`framework-continuity-and-memory.md`](framework-continuity-and-memory.md) for every item.
- Record outcomes through durable writeback (issue updates, PR notes, docs updates, optional ADR).
- Use [`runbooks/operate-framework-task-queue.md`](runbooks/operate-framework-task-queue.md) for queue state transitions and recovery.

## Queue schema and status model (durable source)

Queue file: [`.github/framework-task-queue.json`](../.github/framework-task-queue.json)
Canonical schema/governance reference:
[`docs/framework-queued-execution-memory.md`](framework-queued-execution-memory.md)

- **Task states**
  - `blocked`: dependencies not complete
  - `pending`: eligible for selection when dependencies are satisfied
  - `in_progress`: currently being executed
  - `done`: completed and merged
  - `superseded`: replaced/retired with durable rationale
- **Dependency model**
  - `depends_on` lists prerequisite task ids.
  - Merge-triggered prep only selects dependency-ready `pending` tasks.
- **Issue/PR linkage model**
  - queue-level issue linkage rules are defined in `.github/framework-task-queue.json` → `issue_backed_queue_model`
  - `blocked`/`pending` may be issue-less; `in_progress`/`done`/`superseded` should remain issue-backed and traceable
  - prepared issues carry queue-id marker `<!-- framework-task-queue-id:<id> -->`
  - implementation PRs should use `Closes #...` for the canonical queue-linked issue and `Relates-to #...` for additional non-closing links
- **Prompt source**
  - `suggested_prompt` is the reusable prompt body for issue/agent kickoff.
- **Writeback expectation**
  - `continuity_writeback_expected` uses `yes` / `likely` / `no`.
- **Validation guardrail**
  - `bash scripts/check-framework-task-queue.sh` validates queue integrity in CI and locally.

## Merge-triggered next-task preparation

- Workflow: [`.github/workflows/prepare-next-framework-task.yml`](../.github/workflows/prepare-next-framework-task.yml)
- Trigger: push to `main` (including merges) and manual `workflow_dispatch`.
- Behavior:
  - identify the next dependency-ready `pending` task
  - prepare one `agent-task` issue packet with dependencies and prompt
  - skip creation when that queue task already has an open prepared issue
- Safety boundary:
  - automation prepares work packets only
  - humans still decide queue transitions, review prepared issues, execute implementation, and approve merges
  - no autonomous PR creation/merge chaining

## Ordered queue summary

| Order | Queue id | Task | Status | Why now | Primary dependencies | Continuity writeback expected |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | `template-harmonization-pass` | Template harmonization pass | `done` | Aligns issue/PR/handoff/review packets to one contract. | `starter-kit-bootstrap-pack` | `likely` |
| 2 | `reporting-summary-templates` | Reporting summary templates | `done` | Standardizes weekly/monthly/quarterly writeback outputs. | `template-harmonization-pass` | `likely` |
| 3 | `automation-bundles-by-profile` | Automation bundles by profile | `done` | Turns guidance into runnable profile-based automation packs. | `template-harmonization-pass` | `yes` |
| 4 | `adoption-examples-expansion` | Adoption examples expansion | `done` | Provides concrete traces for common onboarding paths. | `template-harmonization-pass` | `likely` |
| 5 | `repo-transplant-checklist` | Repo transplant checklist | `done` | Reduces migration risk when porting to new repositories. | `adoption-examples-expansion` | `likely` |
| 6 | `operator-onboarding-pack` | Operator onboarding pack | `done` | Speeds contributor/operator ramp-up with bounded first tasks. | `repo-transplant-checklist` | `likely` |
| 7 | `framework-change-governance-deprecation-policy` | Framework change governance / deprecation policy | `done` | Prevents drift and unmanaged retirement of framework components. | `template-harmonization-pass`, `automation-bundles-by-profile` | `yes` |
| 8 | `framework-release-versioning-guidance` | Framework release/versioning guidance | `done` | Enables predictable release snapshots and consumer upgrade paths. | `framework-change-governance-deprecation-policy` | `yes` |

## Completed milestone

### Starter kit / bootstrap pack (completed)

This milestone is now represented by
[`docs/framework-starter-kit.md`](framework-starter-kit.md) with discoverability
links in entrypoint docs and continuity/health writeback updates.

Keep the remaining queue items bounded and execute in order.

### 1) Template harmonization pass

- **Why it matters:** Framework quality depends on consistent work-packet fields and reviewer expectations across issue/PR/handoff/review templates.
- **Suggested GitHub agent prompt:**  
  "Run a bounded harmonization pass across issue templates, PR template, handoff packet template, and review packet templates so required fields and terminology are consistent with the continuity charter."
- **Expected deliverables:**
  - aligned required fields and wording across templates
  - explicit cross-links to continuity, work-type, and validation references
  - follow-up note for intentionally deferred template changes
- **Dependencies / prerequisites:** Starter-kit baseline to avoid harmonizing pre-starter assumptions.
- **Continuity/health/writeback likely required:** **Likely** — update continuity resume notes and health references if template inventory/expectations change.
- **Scope boundaries for reviewable PR:**
  - template and related docs only
  - no workflow/script behavior changes unless strictly required for template validity

### 2) Reporting summary templates

- **Why it matters:** Recurring reviews are defined, but operators still benefit from compact, reusable summary formats for weekly hygiene and quarterly adoption reviews.
- **Suggested GitHub agent prompt:**  
  "Add concise reporting summary templates that operationalize weekly hygiene and quarterly adoption/portability writebacks, aligned with existing metrics and cadence guidance."
- **Expected deliverables:**
  - reusable summary templates for weekly hygiene and quarterly adoption reviews
  - guidance on where to store completed packets (issue/PR/discussion conventions)
  - links from cadence and metrics docs
- **Dependencies / prerequisites:** Existing cadence/metrics guides and template harmonization outputs.
- **Continuity/health/writeback likely required:** **Likely** — health checklist and continuity writeback expectations may need link updates.
- **Scope boundaries for reviewable PR:**
  - add templates and linkage only
  - do not redesign metrics model or automate reporting generation

### 3) Automation bundles by profile

- **Why it matters:** Profile packs describe adaptation strategy, but practical profile-ready automation bundles will reduce adoption inconsistency.
- **Suggested GitHub agent prompt:**  
  "Create bounded automation bundle guidance by framework profile (lighter/heavier settings), defining what to enable first and what to defer while preserving invariants."
- **Expected deliverables:**
  - profile-oriented automation bundle matrix (baseline, recommended, deferred)
  - clear guardrails for least privilege and rollout sequencing
  - runbook or checklist references for operating each bundle
- **Dependencies / prerequisites:** Profile packs and harmonized template expectations.
- **Continuity/health/writeback likely required:** **Yes** if new automation artifacts/workflows are added.
- **Scope boundaries for reviewable PR:**
  - focus on bundle definitions and references
  - avoid broad net-new workflow implementation unless explicitly scoped

### 4) Adoption examples expansion

- **Why it matters:** More worked examples lower onboarding cost and show how to apply the framework in realistic bounded arcs.
- **Suggested GitHub agent prompt:**  
  "Add a small set of high-signal worked examples that demonstrate starter-kit onboarding and profile-based adoption in bounded issue→PR flows."
- **Expected deliverables:**
  - 1-2 worked examples targeting highest-value adoption scenarios
  - explicit artifact trace (issue, PR, validation, writeback)
  - updated examples index and relevant cross-links
- **Dependencies / prerequisites:** Starter-kit guidance and template harmonization decisions.
- **Continuity/health/writeback likely required:** **Likely** — update health snapshot/index references if new examples are introduced.
- **Scope boundaries for reviewable PR:**
  - examples + index updates only
  - no changes to core governance policy beyond references needed by examples

### 5) Repo transplant checklist

- **Why it matters:** Teams adopting in new repositories need a strict transplant checklist that avoids partial or unsafe migrations.
- **Suggested GitHub agent prompt:**  
  "Create a durable repo-transplant checklist that converts portability guidance into a step-by-step migration control list with explicit invariants and validation gates."
- **Expected deliverables:**
  - transplant checklist with phase gates and required evidence
  - clear repo-specific assumption capture points
  - linkage to starter kit, portability guide, and validation commands
- **Dependencies / prerequisites:** Starter kit and practical lessons from adoption examples.
- **Continuity/health/writeback likely required:** **Likely** — portability and health docs may need cross-reference updates.
- **Scope boundaries for reviewable PR:**
  - checklist and references only
  - no direct modifications to external repos or migration scripts

### 6) Operator onboarding pack

- **Why it matters:** New operators need a guided first-week path through core docs, runbooks, and validation routines.
- **Suggested GitHub agent prompt:**  
  "Add an operator onboarding pack that provides a bounded first-week path for new maintainers/agents, including required reading order, first tasks, and validation expectations."
- **Expected deliverables:**
  - onboarding pack doc with first-read path and first bounded tasks
  - links to runbooks/examples aligned to role and profile
  - discoverability updates in AGENTS/README/docs index
- **Dependencies / prerequisites:** Starter-kit and example coverage.
- **Continuity/health/writeback likely required:** **Likely** — continuity and health docs should reference onboarding if treated as durable core artifact.
- **Scope boundaries for reviewable PR:**
  - onboarding guidance only
  - no broad restructuring of existing runbooks beyond minimal cross-linking

### 7) Framework change governance / deprecation policy

- **Why it matters:** As framework surface area grows, maintainers need explicit rules for introducing, changing, and retiring framework components.
- **Suggested GitHub agent prompt:**  
  "Define framework change governance and deprecation policy for docs/templates/scripts/workflows, including required notice, replacement path, and writeback expectations."
- **Expected deliverables:**
  - governance/deprecation policy doc (and ADR if policy-level decision is needed)
  - required deprecation lifecycle states and owner responsibilities
  - checklist updates for governance and review cadence references
- **Dependencies / prerequisites:** Stable template and cadence layers to govern.
- **Continuity/health/writeback likely required:** **Yes** — continuity charter alignment and health/governance checklist updates are expected.
- **Scope boundaries for reviewable PR:**
  - policy definition and cross-links only
  - do not perform large concurrent deprecations of existing artifacts

### 8) Framework release/versioning guidance

- **Why it matters:** Adopters need predictable version snapshots and upgrade signals when framework behavior or required controls change.
- **Current anchor:** [`docs/framework-release-versioning-and-deprecation.md`](framework-release-versioning-and-deprecation.md)
- **Suggested GitHub agent prompt:**  
  "Add framework release/versioning guidance for this repository, including version increment rules, release note expectations, and consumer upgrade communication paths."
- **Expected deliverables:**
  - release/versioning guidance doc
  - rule set for version increments tied to change type and impact
  - release-note and upgrade communication template references
- **Dependencies / prerequisites:** Governance/deprecation policy to define change-impact semantics.
- **Continuity/health/writeback likely required:** **Yes** — continuity and health artifacts should reference release/versioning as a durable operating control.
- **Scope boundaries for reviewable PR:**
  - guidance and templates only
  - no retroactive re-tagging or backfill of historical releases in the same PR

## Execution guardrails for every queued task

- Keep each roadmap item in its own issue and PR.
- Include objective, context, constraints, acceptance criteria, and validation in the issue packet.
- Capture validation evidence in PRs and link any deferred scope as follow-up issues.
- Update `.github/framework-task-queue.json` when task state/dependencies change.
- If a task introduces durable framework policy, create/update an ADR.
- Update discoverability (`README.md`, `docs/README.md`, `AGENTS.md`) and continuity/health artifacts when new durable docs are added.
- Keep merge-driven prep lightweight; do not add autonomous PR creation/merge chaining without explicit governance approval.

## Mobile quick action

- **Use when:** you need to pick the next bounded framework-completion task from mobile without reopening broad planning discussions.
- **Do from mobile:**
  - confirm the next queued item is still dependency-ready
  - open one issue for the selected item and copy the suggested prompt
  - assign owner and link the roadmap item in the issue body
- **Do not do from mobile:**
  - reorder multiple roadmap items without durable rationale in an issue/PR
  - combine multiple queued items into one implementation PR
- **Escalate to desktop/cloud when:**
  - dependencies are ambiguous or cross-document updates are required
  - selecting the next item requires broad framework scope negotiation
- **Primary artifact to update:**
  - the issue or pull request that claims the next roadmap queue item

## Related docs

- [Framework continuity and memory](framework-continuity-and-memory.md)
- [Framework prompt library and execution queue](framework-prompt-library.md)
- [Framework queued execution memory](framework-queued-execution-memory.md)
- [Framework health](framework-health.md)
- [Framework portability and adoption](framework-portability-and-adoption.md)
- [Framework release/versioning/deprecation model](framework-release-versioning-and-deprecation.md)
- [Framework profile packs](framework-profile-packs.md)
- [Framework reporting and review cadence](framework-reporting-and-review-cadence.md)
- [Operate the framework task queue](runbooks/operate-framework-task-queue.md)
