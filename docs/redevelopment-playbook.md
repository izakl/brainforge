# Redevelopment Playbook

This playbook is for teams using Brain Factory to redevelop, modernize, or replace
a legacy system. It lays out a phased approach for turning a poorly understood
codebase into bounded, reviewable work. New to the project? See
[How Brain Factory works](how-brain-factory-works.md) first.

Two kinds of AI assistant appear throughout. An **external AI agent** works outside
the repository (summarizing documents, drafting requirements); a **GitHub-native
agent** writes code directly in the repository through a branch and pull request.
The doc uses both deliberately.

## Purpose

Redevelopment work is different from ordinary feature delivery. Teams often begin with:

- incomplete architecture knowledge
- undocumented workflows
- mixed-quality source material
- hidden business rules
- unclear migration boundaries

This framework helps convert that uncertainty into structured, reviewable work.

## Redevelopment Principles

- Discover before redesigning.
- Preserve business outcomes, not accidental legacy behavior.
- Capture prompts and findings in durable artifacts.
- Use external AI agents for synthesis and GitHub-native agents for repository execution.
- Break modernization into bounded, testable increments.
- Keep a visible chain from discovery to delivery.

## Recommended Phases

### 1. Discovery

Goal: understand the current system and the business processes it supports.

Inputs may include:

- source repositories
- screenshots
- notes from workshops
- user guides
- support tickets
- database schemas
- logs and exports

Outputs should include:

- domain glossary
- system context summary
- current-state capability map
- risk register
- candidate bounded work streams

External AI agents are especially useful here for turning fragmented material into structured summaries.

### 2. Framing

Goal: define what redevelopment means and what is explicitly out of scope.

Create artifacts for:

- modernization objectives
- constraints and guardrails
- target users and workflows
- non-goals
- migration assumptions
- sequencing options

This phase should reduce ambiguity before repository implementation begins.

### 3. Decomposition

Goal: turn discovery outputs into execution-ready work packets.

Each work packet should contain:

- objective
- context
- legacy references
- constraints
- acceptance criteria
- validation method
- dependencies
- suggested delivery mode

Well-formed work packets are what make GH agent execution reliable.

### 4. Pilot Delivery

Goal: validate the framework on a bounded slice of the legacy domain.

Good pilot candidates:

- one workflow with clear success criteria
- one integration seam
- one self-contained admin function
- one read-heavy domain area with low operational risk

Use PR-based delivery and branch cleanup discipline from the start.

### 5. Progressive Replacement

Goal: replace legacy capability in increments while keeping traceability.

Approaches may include:

- parallel run
- strangler pattern
- API facade replacement
- phased user migration
- data migration by bounded domain

Each increment should have explicit rollback and validation criteria.

## Role of GH Agents

Use a GitHub-native agent during redevelopment when:

- the repository and target architecture are known
- a work packet is bounded and testable
- acceptance criteria are explicit
- the output should be a branch or pull request

Examples:

- scaffold a bounded module following existing repo patterns
- implement a migration adapter with tests
- update architecture docs after a pilot lands
- convert a decomposed issue into a PR-ready change

## Role of External AI Agents

Use an external AI agent before or alongside implementation for:

- summarizing legacy system behavior
- extracting structured requirements from messy material
- drafting migration hypotheses
- identifying candidate seams and bounded contexts
- producing prompt packs for the GitHub-native agent

External AI output must be normalized into repository artifacts before implementation.

## Prompt Template for Redevelopment Tasks

```text
Objective:
Rebuild or replace <legacy capability> for <user group/outcome>.

Current-state context:
<what exists today, including known pain points and dependencies>

Target-state intent:
<what the replacement should achieve>

Constraints:
<technology, migration, regulatory, timeline, and integration constraints>

Acceptance criteria:
<observable outcomes>

Validation:
<tests, demo scenarios, migration checks, reviewer expectations>

Non-goals:
<what is intentionally excluded>
```

## Artifacts to Maintain

A redevelopment effort should maintain:

- architecture overview
- domain glossary
- current-state findings
- target-state decisions
- work packets with prompts
- migration logs
- PRs with evidence
- post-merge follow-up tasks

## Branching Guidance

For redevelopment implementation work:

- use short-lived branches
- open pull requests for all code changes
- preserve prompt and constraint context in PR descriptions
- delete branches after merge

For redevelopment documentation:

- direct-to-main can be acceptable for low-risk docs updates
- larger changes should still use PR flow if they affect shared understanding significantly

## Anti-Patterns in Redevelopment

Avoid:

- jumping to solutioning before discovery
- copying legacy behavior without understanding business intent
- keeping prompts only in chat threads
- long-lived migration branches with drifting scope
- letting external AI output bypass human review and repository controls
- redefining the target architecture without updating shared artifacts

## Success Indicators

A redevelopment effort is on track when:

- legacy knowledge is becoming structured and reusable
- work packets are easier to assign to humans or GH agents
- pilot deliveries are small, reviewable, and validated
- prompts and decisions are preserved in repository artifacts
- merged work leaves a clear trail for the next increment

## Mobile quick action

- **Use when:** you need a fast redevelopment-readiness check or risk capture update from mobile.
- **Do from mobile:**
  - Confirm discovery/framing/decomposition artifacts are linked in the active issue.
  - Capture missing-risk or migration-gap findings as focused follow-up issues.
  - Confirm the next owner and execution mode for the next phase.
- **Do not do from mobile:**
  - Draft detailed migration strategy or phase decomposition.
  - Rewrite core redevelopment scope or architecture intent.
- **Escalate to desktop/cloud when:**
  - Sequencing or migration boundaries are disputed.
  - Architecture tradeoffs require ADR-level decision work.
- **Primary artifact to update:**
  - The redevelopment issue tracking the current phase and next action.

## Related docs

- [How Brain Factory works](how-brain-factory-works.md) — five-minute tour for newcomers.
- [Operating model](operating-model.md) — how the framework runs day-to-day.
- [Product support and improvement loop](product-support-and-improvement-loop.md) — how signals flow back into the framework.
- [Framework continuity and memory](framework-continuity-and-memory.md) — what the framework remembers across sessions.
- [Branching and cleanup](branching-and-cleanup.md) — branch lifecycle and stale-branch handling.
- [Governance checklist](governance-checklist.md) — periodic audit items.
