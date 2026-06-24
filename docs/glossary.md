# Glossary

This is the canonical, single-source definition list for the terminology used across Brain Factory docs, templates, and examples. Use it whenever you write or update an artifact so the same words mean the same thing everywhere.

New to the project? Start with [How Brain Factory works](how-brain-factory-works.md) for a five-minute tour, then return here for precise definitions.

A note on naming: **Brain Factory** is the product (the hub framework). **brain-factory** refers only to the repository, directory, or slug. A **brain** is the per-project repository that Brain Factory provisions.

## Acceptance criteria

Acceptance criteria define what makes work complete and reviewable, and are part of the standard issue/handoff packet used across surfaces. They should be explicit before implementation so agents and humans execute against the same completion target.

See: [Multi-Agent Handoff Playbook](./multi-agent-handoff-playbook.md), [Prompt Cookbook](./prompt-cookbook.md)

## ADR (Architecture Decision Record)

An ADR captures a significant architecture or process decision in a durable repository artifact, including context, decision, alternatives considered, and consequences. Use ADRs for decisions future contributors are likely to revisit.

See: [ADR Template Guide](./adr-template-guide.md)

## Auto-labeler

The auto-labeler is the GitHub Actions workflow at `.github/workflows/labeler.yml` driven by `.github/labeler.yml` that applies area labels (for example `docs`, `adr`, `runbooks`, and `ci`) to pull requests based on changed file paths. This behavior is recorded in ADR 0007.

See: [ADR 0007: Path-based PR auto-labeler](./adr/0007-path-based-pr-auto-labeler.md)

## Agent (coding agent / chat agent / external AI agent)

An agent is an AI-assisted participant that helps perform work, whether through GitHub-native coding and chat flows or external discovery and synthesis flows. Agents do not replace repository controls, human approval, or durable artifacts.

See: [GH Agents and Automation](./gh-agents-and-automation.md)

## Bounded PR / bounded work

Bounded work is short-lived, scoped to one issue or work packet, and constrained enough to review and validate cleanly. A bounded PR should avoid combining unrelated scopes and preserve prompt/constraint/validation context in linked artifacts.

See: [Branching and Cleanup](./branching-and-cleanup.md)

## Charter-to-artifact map

The charter-to-artifact map is the table in `docs/framework-health.md` that maps each continuity-charter expectation to the repository file path that satisfies it. It is used during framework health audits to detect continuity drift quickly.

See: [Framework Health Check](./framework-health.md)

## Continuity anchor

A continuity anchor is the durable document that preserves framework intent, non-negotiable principles, and contributor/agent rules across future updates. Here, `framework-continuity-and-memory.md` is that anchor.

See: [Framework Continuity and Memory](./framework-continuity-and-memory.md)

## Continuity artifact

A continuity artifact is any durable repository file the framework requires to remain present and current so the operating model survives across sessions, agents, and contributors. Typical examples include the continuity charter, framework health report, runbooks, ADRs, and governance checklist.

See: [Framework Continuity and Memory](./framework-continuity-and-memory.md)

## Continuity charter

Continuity charter is the plain-language name for `docs/framework-continuity-and-memory.md`, the anchor document that defines what must remain durable across sessions and how contributions are normalized into GitHub artifacts.

See: [Framework Continuity and Memory](./framework-continuity-and-memory.md)

## Control plane (GitHub as durable control plane)

The control plane is GitHub as the durable coordination and execution layer for issues, PRs, docs, ADRs, and history. Work may start elsewhere, but implementation and review must depend on GitHub artifacts.

See: [Framework Continuity and Memory](./framework-continuity-and-memory.md), [Operating Model](./operating-model.md)

## Diagram convention

The diagram convention is the framework's pattern for embedding diagrams in docs: one `## Diagram` section per doc, placed after the introductory prose and before the first deep-dive H2, containing a short caption and a single Mermaid fenced code block (≤ 12 nodes). Formalized in ADR 0010; rollout strategy lives in `docs/visual-diagrams-plan.md`.

See: [ADR 0010: Diagrams convention](./adr/0010-diagrams-convention.md), [Visual Diagrams Plan](./visual-diagrams-plan.md)

## Dry-run report

In stale-branch cleanup, the dry-run report is the non-destructive second step of the weekly `.github/workflows/stale-branches.yml` execution. It lists long-lived branches with no open pull request and no activity in 60 days for maintainer review instead of automatic deletion.

See: `docs/runbooks/triage-stale-branch-report.md`

## Execution surface / surface

An execution surface is the environment where work is performed or coordinated (for example local VS Code, GitHub cloud flows, GH CLI, or GitHub Mobile). Surface choice should match task shape, while durable context remains normalized into GitHub artifacts.

See: [GH Agents and Automation](./gh-agents-and-automation.md), [Operating Model](./operating-model.md)

## External AI agent

An external AI agent is used primarily for discovery, synthesis, and decomposition when key context lives outside repository artifacts. Its outputs must be normalized into GitHub issues/docs/ADRs before implementation starts.

See: [Context Synchronization and External Context Handling](./context-synchronization.md), [GH Agents and Automation](./gh-agents-and-automation.md)

## Framework health audit

A framework health audit is the procedure of walking through `docs/framework-health.md` to confirm every continuity artifact is present, current, and cross-linked. The repeatable operator procedure is documented as a runbook.

See: [Run the Framework Health Audit](./runbooks/run-the-framework-health-audit.md)

## GH CLI participation

GH CLI participation means using GitHub CLI flows for scripted triage, labeling, status updates, and repository maintenance operations. It is a coordination/operations surface, not a bypass of normal review and control gates.

See: [GH Agents and Automation](./gh-agents-and-automation.md)

## GitHub Copilot Chat / Coding Agent (cloud)

GitHub Copilot Chat/Coding Agent (cloud) is the GitHub-native execution mode for repository-bounded, artifact-ready work. It is best used when acceptance criteria are clear and outputs can be validated in normal PR flow.

See: [GH Agents and Automation](./gh-agents-and-automation.md)

## GitHub Mobile participation

GitHub Mobile participation is a high-leverage coordination mode for triage, approvals, follow-up capture, and status updates. It is intentionally not the primary surface for deep implementation or detailed local validation.

See: [Using the Framework with GitHub Mobile](./github-mobile-guide.md)

## Governance checklist

The governance checklist is the practical review list used to confirm human checkpoints, artifact readiness, constraint preservation, execution routing, validation gates, and closure quality. It helps keep hybrid human/agent delivery reviewable and GitHub-native.

See: [Governance Checklist](./governance-checklist.md)

## Handoff contract

The handoff contract is the minimum packet that must survive ownership changes: objective, context, constraints, acceptance criteria, validation expectations, related artifacts, next owner, current state, and open risks/questions. It prevents continuity loss across humans, agents, and surfaces.

See: [Multi-Agent Handoff Playbook](./multi-agent-handoff-playbook.md)

## Hybrid execution / multi-surface execution

Hybrid or multi-surface execution is coordinated delivery across multiple surfaces and roles (for example external synthesis, human normalization, local/cloud implementation, PR review, and mobile follow-up). The key rule is that cross-surface flow still anchors decisions and execution in durable GitHub artifacts.

See: [Operating Model](./operating-model.md), [GH Agents and Automation](./gh-agents-and-automation.md)

## Improvement loop / continuous improvement loop

The improvement loop is the recurring cycle that converts lessons from delivery, support, and operations into backlog, docs, template, governance, and process updates. It is used to reduce recurring friction and keep framework quality improving over time.

See: [Operating Model](./operating-model.md), [Product, Support, and Continuous Improvement Loop](./product-support-and-improvement-loop.md)

## Issue form

An issue form is a structured GitHub issue template defined in YAML under `.github/ISSUE_TEMPLATE/` with named fields, dropdowns, and required checkboxes. It replaces free-form issue bodies so intake is normalized for triage and execution.

See: [Product, Support, and Continuous Improvement Loop](./product-support-and-improvement-loop.md)

## Issue template

An issue template is the standardized intake structure that captures required execution context (objective, context, constraints, acceptance criteria, validation, and routing metadata) so work is triage-ready and executable. Templates help keep support-to-delivery routing consistent.

See: [Product, Support, and Continuous Improvement Loop](./product-support-and-improvement-loop.md)

## Mermaid diagram

A Mermaid diagram is a text-defined diagram (for example flowchart, sequence diagram, or state diagram) embedded in Markdown with a ` ```mermaid ` fenced code block and rendered natively on GitHub. The framework uses Mermaid as its primary diagram format.

See: [ADR Log](./adr/README.md), `docs/visual-diagrams-plan.md`, `docs/adr/0009-mermaid-as-primary-diagram-format.md`

## Mobile quick action

Mobile quick action is the standardized `## Mobile quick action` section shape used in operator-facing docs to define what to do from mobile, what not to do, and when to escalate to desktop or cloud execution. It keeps mobile participation fast, consistent, and reviewable across documentation surfaces.

See: [ADR 0013: Mobile quick action section convention](./adr/0013-mobile-quick-action-convention.md)

## Normalization (of external context into GitHub artifacts)

Normalization is converting external or private context into durable GitHub artifacts before implementation or approval proceeds. In practice, this means promoting objectives, constraints, acceptance criteria, validation expectations, and key decisions into issue/PR/ADR/doc records.

See: [Context Synchronization and External Context Handling](./context-synchronization.md)

## Operating model

The operating model is the day-to-day framework for how humans, agents, automation, and surfaces coordinate from intake through delivery, review, closure, and follow-up. It defines work modes, routing rules, packet structure, and improvement cadence.

See: [Operating Model](./operating-model.md)

## Project / GitHub Project (operational layer)

GitHub Projects is the shared operational layer for intake, triage, execution, blocked/support tracking, and continuous-improvement routing. It makes status, ownership, work type, and execution mode visible across surfaces.

See: [GitHub Projects Setup and Operating Model](./github-projects-setup.md)

## Prompt as artifact

A prompt as artifact means prompt intent and constraints are preserved in durable repository artifacts (issue bodies, PR descriptions, ADR drafts, discussions), not left only in private chat memory. This keeps handoffs auditable across contributors and agents.

See: [Prompt Cookbook](./prompt-cookbook.md), [Framework Continuity and Memory](./framework-continuity-and-memory.md)

## Pull request as control gate

A pull request is the main control gate for changes, where constraints, validation evidence, and review decisions are checked before merge. It is the primary governance checkpoint regardless of execution surface.

See: [Branching and Cleanup](./branching-and-cleanup.md), [Framework Continuity and Memory](./framework-continuity-and-memory.md)

## Redevelopment / modernization work

Redevelopment or modernization work covers legacy-heavy or unknown-heavy efforts that require discovery, decomposition, and phased delivery rather than immediate broad rewrites. It should preserve findings, decisions, and bounded implementation packets in durable artifacts.

See: [Redevelopment Playbook](./redevelopment-playbook.md)

## Runbook

A runbook is a short, scannable operator procedure stored in `docs/runbooks/` and indexed in `docs/runbooks/README.md`. Each runbook covers one task end-to-end so operators do not need to reconstruct procedures from prose-only guidance.

See: [Runbooks Index](./runbooks/README.md)

## Stale-branch cleanup

Stale-branch cleanup is the weekly workflow at `.github/workflows/stale-branches.yml` that deletes merged `copilot/*` and `dependabot/*` branches older than 7 days, then emits a dry-run report for other long-lived inactive branches. The automation decision is recorded in ADR 0008.

See: [ADR 0008: Stale branch cleanup automation](./adr/0008-stale-branch-cleanup-automation.md), [Branching and Cleanup](./branching-and-cleanup.md)

## Support-to-product loop

The support-to-product loop converts support signals into routed product, docs, redevelopment, ADR, and improvement work, then feeds closure learnings back into templates and backlog. It prevents support resolutions from staying isolated from framework evolution.

See: [Product, Support, and Continuous Improvement Loop](./product-support-and-improvement-loop.md)

## System of record

The system of record is the set of durable GitHub artifacts used for execution and review authority, rather than chat-only memory or private notes. Repository work should be reconstructable from issues, PRs, ADRs, docs, and linked project history.

See: [Framework Continuity and Memory](./framework-continuity-and-memory.md)

## VS Code Copilot (local)

VS Code Copilot (local) is the local implementation surface for deep coding, debugging, and local validation loops. It is preferred when task execution needs richer local tooling than cloud/mobile coordination surfaces.

See: [GH Agents and Automation](./gh-agents-and-automation.md), [Contributor Environment Guide](./contributor-environment-guide.md)

## Work packet

A work packet is the standard executable task packet containing objective, context, constraints, acceptance criteria, validation steps, execution mode, ownership, and related artifacts. It should be usable by any approved human or agent without hidden assumptions.

See: [Operating Model](./operating-model.md), [Prompt Cookbook](./prompt-cookbook.md)

## Worked example

A worked example is an end-to-end walkthrough in the `examples/` directory that shows a runbook applied to a realistic scenario. Worked examples are indexed in `examples/README.md` so contributors can quickly find concrete patterns.

See: [Examples Index](../examples/README.md)

## Maintaining this glossary

Add new terms here in the same pull request that introduces them; a rename must update every doc that refers to the old term. If parallel PR timing makes a same-PR update impossible, open and link a follow-up glossary update right away so terminology drift stays visible and short-lived.
