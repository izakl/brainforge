# Documentation

Entry point for the framework's documentation. If you are a first-time maintainer/operator, start with the [Operator onboarding pack](operator-onboarding-pack.md), then continue to the [Operating model](operating-model.md) and branch out via the sections below.
For issue-template selection and intake field expectations, treat [Issue taxonomy](issue-taxonomy.md) as canonical and use [Open an issue](runbooks/open-an-issue.md) as the procedural companion.

For the minimum operating contract for agents and new contributors, see [`AGENTS.md`](https://github.com/izakl/brainforge/blob/main/AGENTS.md) at the repository root.

## Bootstrap path

To go from "just discovered the framework" to a ready-to-work setup state:

| Step | What to do | Key resource |
| --- | --- | --- |
| 1. Understand | Read `AGENTS.md` and the framework overview | [`../AGENTS.md`](https://github.com/izakl/brainforge/blob/main/AGENTS.md) |
| 2. Describe your needs | Write a natural-language setup description | [Prompt-to-setup bootstrap](runbooks/prompt-to-setup-bootstrap.md) |
| 3. Choose or adapt setup | Pick the nearest setup profile and adapt an intent example | [`framework-setup-profiles-and-intent-examples.md`](framework-setup-profiles-and-intent-examples.md) |
| 4. Apply setup | Run `apply-setup.sh` against your intent file | [`runbooks/apply-setup.md`](runbooks/apply-setup.md) |
| 5. Verify readiness | Run `check-setup-readiness.sh` and baseline checks | [`runbooks/apply-setup.md`](runbooks/apply-setup.md) |

The unified runbook covering all five steps:
[`runbooks/prompt-to-setup-bootstrap.md`](runbooks/prompt-to-setup-bootstrap.md)

## Core docs

- [Operating model](operating-model.md) — how the framework runs day-to-day.
- [GH agents and automation](gh-agents-and-automation.md) — multi-agent ecosystem, routing, handoffs, automation guardrails, and Copilot coding agent firewall/API-access mitigation guidance.
- [Multi-agent handoff playbook](multi-agent-handoff-playbook.md) — practical handoff contracts and anti-patterns.
- [Handoff packet template](handoff-packet-template.md) — canonical reusable template for structured handoffs with resumable packet fields and resume verification steps.
- [Context synchronization](context-synchronization.md) — normalize external context into durable GitHub artifacts.
- [Security and secure delivery guardrails](security-and-secure-delivery.md) — private/public security routing, sensitive context handling, and secure-delivery checks.
- [Product support and improvement loop](product-support-and-improvement-loop.md) — how signals flow back into the framework.
- [Issue taxonomy](issue-taxonomy.md) — all issue types, when to use each, required fields, label inventory, and routing to downstream artifacts.
- [Work-type matrix](work-type-matrix.md) — practical tailoring guide for artifacts, checks, routing, and follow-up by work category.
- [GitHub Projects setup](github-projects-setup.md) — minimum viable setup, durable state model, and routing for intake through follow-up.
- [Framework continuity and memory](framework-continuity-and-memory.md) — what the framework remembers across sessions.
- [Framework state milestones](framework-state-milestones.md) — bounded event-style model for explicit setup/readiness/work/handoff/resume transition acknowledgments.
- [Searchable continuity and artifact indexing guidance](framework-continuity-artifact-indexing.md) — lightweight naming/linking/indexing conventions for finding latest lifecycle, snapshot, handoff, readiness, and queue/deferred state quickly.
- [Framework continuity snapshot template](framework-continuity-snapshot-template.md) — structured continuity snapshot format for explicit lifecycle/setup/readiness/work/queue/handoff/next-action state.
- [Operator onboarding pack](operator-onboarding-pack.md) — practical first-day/first-week path for maintainers, contributors, and agent operators.
- [Framework portability and adoption](framework-portability-and-adoption.md) — how to reuse the framework across repositories and teams without losing core guarantees.
- [Framework starter kit / bootstrap pack](framework-starter-kit.md) — practical minimum viable adoption set with copy/adapt/customize guidance.
- [Framework repo-transplant checklist](framework-repo-transplant-checklist.md) — strict phase-gated migration control list with required evidence, invariants, assumption capture, and validation gates.
- [Framework adoption maturity model](framework-adoption-maturity-model.md) — staged adoption levels, dimensions, and lightweight self-assessment.
- [Framework readiness checklist](framework-readiness-checklist.md) — lightweight readiness/certification-style checklist for coherent adoption without forcing full-surface adoption.
- [Framework profile packs](framework-profile-packs.md) — practical profile layer for adapting one framework across different repository/team operating contexts.
- [Framework automation bundles by profile](framework-automation-bundles-by-profile.md) — practical staged bundles for checks/workflows/automation by profile and maturity.
- [Framework setup intent schema and application model](framework-setup-intent-schema-and-application-model.md) — durable setup contract defining setup inputs, profile/default mapping, expected setup outputs, and ready-to-work success criteria for future executable setup.
- [Framework setup profiles and intent examples](framework-setup-profiles-and-intent-examples.md) — concrete setup profile catalog and machine-readable setup-intent examples for immediate setup-contract testing.
- [Prompt-to-setup bootstrap runbook](runbooks/prompt-to-setup-bootstrap.md) — end-to-end path from natural-language setup needs to setup-intent/profile selection, setup application, and readiness verification.
- [Brain Factory: how it works](how-brain-factory-works.md) — a five-minute, plain-language overview of the hub, brains, the core/extension split, and the improvement loop.
- [Brain Factory — design overview](brain-factory-design-overview.md) — the whole target architecture on one page, with diagrams and a built-vs-planned status.
- [Framework brain factory architecture](framework-brain-factory-architecture.md) — the executable layer: how the hub provisions and continuously improves a per-project brain, with the core/extension split and the bidirectional improvement loop. See also [`brain-factory/`](https://github.com/izakl/brainforge/blob/main/brain-factory/README.md) and [ADR 0019](adr/0019-project-brain-factory-and-improvement-loop.md).
- [Framework change governance and deprecation policy](framework-change-governance-and-deprecation-policy.md) — operational policy for introducing, changing, deprecating, and removing framework docs/templates/scripts/workflows.
- [Framework release/versioning/deprecation model](framework-release-versioning-and-deprecation.md) — lightweight lifecycle semantics for major/minor/patch changes, compatibility signaling, migration burden, operator-action expectations, release communication, and deprecation handling.
- [Framework release notes and upgrade summaries](framework-release-notes-and-upgrade-summaries.md) — lightweight model for when/how to publish high-signal change summaries with clear adopter impact.
- [Framework release notes index](framework-release-notes.md) — durable quick-scan index of published framework change summaries (with linked packets under `docs/release-notes/`).
- [Framework roadmap: next GitHub agent prompts](framework-roadmap-next-prompts.md) — durable, execution-ordered queue of major bounded framework-completion tasks, with machine-readable state in `.github/framework-task-queue.json`.
- [Framework prompt library and execution queue](framework-prompt-library.md) — durable library of major reusable GitHub agent prompts with practical execution metadata and bounded-scope guidance.
- [Framework next monster prompts](framework-next-monster-prompts.md) — simple, durable Ready now/Later execution list of major prompts operators can reuse without chat history.
- [Framework queued execution memory](framework-queued-execution-memory.md) — canonical issue-backed queue schema, queue↔issue↔PR linkage model, queue-state governance, and drift-recovery guidance.
- [Framework metrics and feedback loop](framework-metrics-and-feedback.md) — lightweight model for measuring framework effectiveness over time.
- [Framework reporting and review cadence](framework-reporting-and-review-cadence.md) — practical recurring review rhythms, ownership, and writeback paths.
- [Framework weekly hygiene summary template](framework-weekly-hygiene-summary-template.md) — concise reusable packet for weekly hygiene writeback.
- [Framework quarterly adoption and portability summary template](framework-quarterly-adoption-portability-summary-template.md) — concise reusable packet for quarterly adoption/portability writeback.
- [Framework review cadence template](framework-review-cadence-template.md) — reusable template for weekly/monthly/quarterly/event-driven review packets.
- [Framework effectiveness scorecard template](framework-effectiveness-scorecard-template.md) — reusable template for periodic effectiveness reviews.
- [Framework upgrade and adoption maintenance](framework-upgrade-and-maintenance.md) — how downstream adopters review, absorb, and maintain alignment with framework updates; includes upgrade checklist and queue closure/linkage hygiene guidance.
- [Redevelopment playbook](redevelopment-playbook.md) — applying the framework to modernization and legacy redevelopment.
- [Prompt cookbook](prompt-cookbook.md) — reusable prompt structures for issue, PR, and agent execution.
- [Branching and cleanup](branching-and-cleanup.md) — branch lifecycle and stale-branch handling.
- [Contributor environment guide](contributor-environment-guide.md) — dev container, workspace, and editor setup.
- [GitHub Mobile guide](github-mobile-guide.md) — mobile-first triage, review, and follow-up.
- [Example issue to PR flow](example-issue-to-pr-flow.md) — end-to-end issue-to-PR workflow example.
- [Governance checklist](governance-checklist.md) — periodic audit items.
- [Framework health](framework-health.md) — current snapshot and charter-to-artifact map.

## Runbooks

- [Framework lifecycle map and operator journey](runbooks/framework-lifecycle-map.md) — durable end-to-end lifecycle guide covering all eight operating stages from bootstrap and orient through describe needs, choose/adapt setup, apply setup, verify readiness, execute work, create handoff/continuity state, and resume later; includes a quick-reference stage map and a "where am I?" self-check.
- [Create continuity snapshot](runbooks/create-continuity-snapshot.md) — create/update a structured continuity snapshot for explicit handoff/resume state and recommended next action.
- [Resume from a handoff packet](runbooks/resume-from-handoff-packet.md) — ordered resume path for reviewing packet artifacts, re-validating setup/readiness posture, and selecting the next safe action.
- [Surface-specific startup guides](runbooks/surface-specific-startup-guides.md) — choose the shortest startup path by execution surface (GitHub cloud agent, local VS Code/Copilot, or lightweight mobile/operator oversight), including limits and escalation guidance.
- [Local-first quickstart (solo developer)](runbooks/local-first-quickstart.md) — shortest path from a fresh clone to a ready-to-work solo setup: recommended default profile (`solo_prototype`), minimum field edits, exact command sequence, readiness confirmation, and safe deferrals.
- [Apply framework setup](runbooks/apply-framework-setup.md) — setup-productization entrypoint that routes to the executable setup flow and readiness checks.
- [Apply setup](runbooks/apply-setup.md) — full step-by-step procedure for applying a setup intent and confirming a coherent "ready to work" state using `scripts/apply-setup.sh` and `scripts/check-setup-readiness.sh`.
- [Prompt-to-setup bootstrap](runbooks/prompt-to-setup-bootstrap.md) — translate natural-language setup needs into setup intent/profile choices, then apply and verify readiness.
- [Close Out a Multi-Agent Handoff](runbooks/close-out-a-multi-agent-handoff.md) — confirm acknowledgement, update durable artifacts, and close handoff-related cleanup tasks.
- [Handle a Dependabot PR](runbooks/handle-a-dependabot-pr.md) — triage and merge scheduled GitHub Actions dependency updates.
- [Open an Issue](runbooks/open-an-issue.md) — choose the correct issue template, fill required fields, and confirm execution readiness.
- [Promote an External AI Artifact](runbooks/promote-external-ai-artifact.md) — turn external AI outputs into durable repository artifacts.
- [Respond to Support Intake](runbooks/respond-to-support-intake.md) — acknowledge, classify, and route new support-intake issues.
- [Handle Security-Sensitive Intake](runbooks/handle-security-sensitive-intake.md) — route sensitive findings safely using private advisory or sanitized public artifacts.
- [Run the Framework Health Audit](runbooks/run-the-framework-health-audit.md) — re-run and record the framework health audit.
- [Start a Framework Change](runbooks/start-a-framework-change.md) — kick off framework changes with issue context, scope, and validation.
- [Operate the framework task queue](runbooks/operate-framework-task-queue.md) — maintain queue state, run post-merge closeout checklist steps, recover merge-driven next-task preparation, and apply firewall-aware queue reconciliation fallback.
- [Run the queue health check](runbooks/run-queue-health-check.md) — run a bounded queue audit/reconciliation cycle across queue state, prepared issues, open/merged PR evidence, and merge-driven automation behavior.
- [Maintain framework alignment](runbooks/maintain-framework-alignment.md) — run an upgrade review cycle, classify framework changes, and recover from missed queue/issue closure after merge.
- [Triage the stale-branch report](runbooks/triage-stale-branch-report.md) — review weekly stale-branch findings and decide retention or cleanup.

## Examples

- [Worked example: handle a Dependabot pull request](https://github.com/izakl/brainforge/blob/main/examples/worked-example-dependabot-pr.md) — end-to-end walkthrough of triaging, validating, and merging a Dependabot PR.
- [Worked Example: Issue to PR to ADR (Markdown CI Guardrail)](https://github.com/izakl/brainforge/blob/main/examples/worked-example-issue-to-pr.md) — concrete walkthrough from issue intake through PR and ADR outcomes.
- [Worked Example: External context normalization flow](https://github.com/izakl/brainforge/blob/main/examples/worked-example-external-context-normalization.md) — end-to-end trace from local raw context through Tier 2 synthesis to normalized GitHub issue, implementation PR, and durable writeback.
- [Adoption example: solo maintainer / small repository](https://github.com/izakl/brainforge/blob/main/examples/adoption-example-solo-small-repo.md) — how a solo maintainer applies the essential baseline with Bundle A automation and explicit deferrals.
- [Adoption example: product delivery team](https://github.com/izakl/brainforge/blob/main/examples/adoption-example-product-delivery-team.md) — how a multi-contributor product team adopts the full issue/project/PR/handoff loop with Bundle B automation.
- [Adoption example: platform and infrastructure team](https://github.com/izakl/brainforge/blob/main/examples/adoption-example-platform-infra-team.md) — how a platform team adopts Bundle C automation, ADR discipline, and security-first controls from day one.
- [Adoption example: starter-kit bootstrap in one bounded issue → PR flow](https://github.com/izakl/brainforge/blob/main/examples/adoption-example-starter-kit-bootstrap-flow.md) — how a first-time adopter executes starter-kit onboarding in one bounded issue and one bounded PR.
- [Adoption example: profile upgrade from small-repo baseline to product team](https://github.com/izakl/brainforge/blob/main/examples/adoption-example-profile-upgrade-small-to-product.md) — how a repository scales profile/bundle through one bounded issue→PR transition.

## Architecture decisions

- [ADR index](adr/README.md) — overview of the architecture decision record log.
- [ADR 0001: GitHub as durable control plane](adr/0001-github-as-durable-control-plane.md)
- [ADR 0002: Multi-surface hybrid execution model](adr/0002-multi-surface-hybrid-execution-model.md)
- [ADR 0003: Pull requests as primary control gate](adr/0003-pull-requests-as-primary-control-gate.md)
- [ADR 0004: Markdown CI guardrail](adr/0004-markdown-ci-guardrail.md)
- [ADR 0005: Dependabot for GitHub Actions](adr/0005-dependabot-for-github-actions.md)
- [ADR 0006: CODEOWNERS for review routing](adr/0006-codeowners-for-review-routing.md)
- [ADR 0007: Path-based PR auto-labeler](adr/0007-path-based-pr-auto-labeler.md)
- [ADR 0008: Stale branch cleanup automation](adr/0008-stale-branch-cleanup-automation.md)
- [ADR 0009: Mermaid as primary diagram format](adr/0009-mermaid-as-primary-diagram-format.md)
- [ADR 0010: Diagrams convention](adr/0010-diagrams-convention.md)
- [ADR 0011: Documentation navigation](adr/0011-documentation-navigation.md)
- [ADR 0012: SVG companions for diagrams](adr/0012-svg-companions-for-diagrams.md)
- [ADR 0013: Mobile quick action section convention](adr/0013-mobile-quick-action-convention.md)
- [ADR 0014: Deployment and infrastructure scope](adr/0014-deployment-infrastructure-scope.md)
- [ADR 0015: Handoff packet enforcement](adr/0015-handoff-packet-enforcement.md)
- [ADR 0016: Continuous checks and recurring framework audit layer](adr/0016-continuous-checks-layer.md)
- [ADR 0017: Queue health check and drift-detection layer](adr/0017-queue-health-check-layer.md)
- [ADR 0018: Framework change governance and deprecation policy](adr/0018-framework-change-governance-and-deprecation-policy.md)
- [ADR 0019: Project Brain Factory and the improvement loop](adr/0019-project-brain-factory-and-improvement-loop.md)
- [ADR 0020: Portable core, additive enterprise layer](adr/0020-portable-core-additive-enterprise.md)
- [ADR 0021: Expose Brain Factory over MCP](adr/0021-expose-brain-factory-over-mcp.md)
- [ADR 0022: Multi-target command emission](adr/0022-multi-target-command-emission.md)
- [ADR 0023: Documentation site on GitHub Pages](adr/0023-docs-site-github-pages.md)

## Reference

- [Glossary](glossary.md) — shared vocabulary.
- [ADR template guide](adr-template-guide.md) — authoring structure for ADR proposals.
- [Diagrams (SVG companions)](diagrams/README.md) — companion inventory and source mapping.
- [Visual diagrams plan](visual-diagrams-plan.md) — rollout strategy for `## Diagram` sections.
