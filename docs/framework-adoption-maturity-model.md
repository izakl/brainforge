# Framework Adoption Maturity Model

Use this model to adopt Brain Factory's framework incrementally: assess how
deeply you use it today, and choose the next high-value improvement without
implementing everything at once. It is for teams that have a working setup and
want a shared, lightweight way to talk about adoption depth.

New to the project? See [How Brain Factory works](how-brain-factory-works.md) and
[`framework-portability-and-adoption.md`](framework-portability-and-adoption.md)
before using this model.

## Purpose

This model adds a practical progression layer for teams that already use:

- the continuity contract
- context normalization rules
- handoff packet standards
- governance and recurring checks
- projects routing, support loops, and metrics guidance

It helps answer:

- where are we now?
- what does stronger adoption look like?
- what is the next reasonable step?

## Gaps this model closes

Before this model, the framework had phased rollout guidance, but teams could
still struggle with:

- mapping phase language to concrete operating capabilities
- distinguishing minimum viable usage from strong, integrated usage
- assessing adoption quality consistently across dimensions
- choosing next steps without creating heavy scoring overhead

## Maturity levels

Use four levels to keep progression clear and lightweight.

| Level | Name | Practical meaning |
| --- | --- | --- |
| 1 | Initial | Core artifacts exist, but usage is inconsistent and person-dependent. |
| 2 | Structured | Core practices are documented and used in most work, with basic repeatability. |
| 3 | Integrated | Practices are connected across issue/project/PR/handoff/validation loops. |
| 4 | Optimized | Teams run recurring improvement loops and tune adoption based on evidence. |

## Maturity dimensions

Assess each dimension independently. Teams can be at different levels in
different dimensions.

| Dimension | Level 1: Initial | Level 2: Structured | Level 3: Integrated | Level 4: Optimized |
| --- | --- | --- | --- | --- |
| Durable artifact discipline | Work sometimes starts from chat-only context. | Most work starts from issues/PRs with required packet fields. | Artifact linkage is consistent across issue ↔ PR ↔ ADR/discussion ↔ project. | Artifact quality is reviewed periodically and improved when drift appears. |
| Context normalization | External context normalization is ad hoc. | Normalization happens before most implementation work. | Normalization quality is expected and reviewed in triage/review. | Normalization patterns are refined using recurring findings. |
| Handoff quality | Handoffs rely on individuals and informal memory. | Required handoff fields are usually preserved. | Handoffs are consistently reusable across surfaces and owners. | Handoff failures are tracked and guidance/templates are tuned. |
| Issue and project routing | Status/work-type routing is partial or stale. | Core project fields/statuses are used for active work. | Work-type selection consistently follows matrix guidance and status transitions reflect durable artifact truth. | Routing quality is measured and improved through recurring reviews. |
| Validation and continuous checks | Validation is inconsistent or mostly manual. | Baseline checks are run and expected in PR flow. | Check outcomes are used to drive targeted fixes and docs updates. | Repeated failure modes trigger recurring automation and process tuning. |
| Security handling | Security-sensitive routing is understood but inconsistently applied. | Security routing follows `SECURITY.md` in most cases. | Secure-delivery guardrails are consistently reflected in artifacts and reviews. | Security handling trends are reviewed and ownership/escalation tuned. |
| Feedback and measurement loops | Improvement happens reactively. | Periodic effectiveness review begins with lightweight signals. | Findings regularly produce bounded follow-up issues/PRs. | Metrics and review cadence are tuned for signal quality and low overhead. |
| Portability and reuse | Adoption is local and hard to transplant. | Core invariants and customization boundaries are documented. | New repos adopt via phased rollout with preserved invariants. | Cross-repo adoption lessons are fed back into guides/templates. |
| Operational hygiene and cadence | Hygiene depends on one maintainer's memory. | Basic cadence exists for audits, cleanup, and follow-up. | Hygiene checks are routinely run and closure evidence is durable. | Cadence is stable, visible, and continuously improved from audit outcomes. |

## Minimum viable vs strong adoption

### Minimum viable adoption (practical baseline)

Treat adoption as viable when a team has:

- core contract in place (`AGENTS.md`, continuity anchor, operating model)
- issue + PR packet discipline for objective/context/constraints/acceptance/validation
- baseline markdown/check scripts running and expected before merge
- external context normalized before implementation

This usually maps to **Level 2 Structured** on most dimensions.

### Strong adoption (without heavy bureaucracy)

Treat adoption as strong when a team also has:

- consistent issue/project/PR/handoff synchronization
- recurring effectiveness and health reviews with durable writeback
- predictable follow-up issue creation from governance/metrics findings
- reusable portability pattern for additional repos/teams

This usually maps to **Level 3 Integrated** with selected **Level 4** practices.

## Lightweight self-assessment scorecard

Run this as a periodic check (monthly or quarterly).

| Dimension | Current level (1-4) | Evidence link(s) | Next-level gap | One bounded next action |
| --- | --- | --- | --- | --- |
| Durable artifact discipline | — | — | — | — |
| Context normalization | — | — | — | — |
| Handoff quality | — | — | — | — |
| Issue and project routing | — | — | — | — |
| Validation and continuous checks | — | — | — | — |
| Security handling | — | — | — | — |
| Feedback and measurement loops | — | — | — | — |
| Portability and reuse | — | — | — | — |
| Operational hygiene and cadence | — | — | — | — |

Keep it lightweight:

- do not average levels into one synthetic score
- do not block delivery waiting for all dimensions to level up
- pick 2-3 high-signal gaps per cycle

## How to move up one level

1. Identify the lowest two dimensions with the clearest impact on execution quality.
2. Define one bounded improvement issue per dimension.
3. Deliver each improvement in a small PR with validation evidence.
4. Re-assess at the next cadence and record what changed.

Do not attempt multi-level jumps in a single cycle.

## Suggested usage pattern

- **During adoption startup:** use this model after the initial portability bootstrap checklist.
- **During profile selection:** pair this model with framework profile packs to
  choose minimum viable setup depth for your operating context.
- **During automation selection:** use
  [`framework-automation-bundles-by-profile.md`](framework-automation-bundles-by-profile.md)
  to stage checks/workflows according to current profile and maturity.
- **During monthly effectiveness review:** add maturity notes to the review packet.
- **During quarterly portability review:** compare adoption maturity across consumer repos.
- **During lifecycle updates:** use release/versioning/deprecation guidance to classify impact and plan bounded upgrade actions.
- **During health/governance review:** capture maturity drift as bounded follow-up issues.

## Mobile quick action

- **Use when:** you need to quickly assess adoption depth from mobile.
- **Do from mobile:**
  - Identify likely current level for one or two dimensions with evidence links.
  - Capture one bounded follow-up issue for the highest-impact gap.
  - Flag where adoption is over-complicated relative to team size/workload.
- **Do not do from mobile:**
  - Run full multi-dimension scoring in one pass.
  - Redesign levels/dimensions without coordinated review.
- **Escalate to desktop/cloud when:**
  - Multiple dimensions require cross-artifact evidence review.
  - Findings require coordinated updates across docs/templates/workflows.
- **Primary artifact to update:**
  - The active adoption or effectiveness review issue/PR.

## Related docs

- [Framework portability and adoption](framework-portability-and-adoption.md)
- [Framework readiness checklist](framework-readiness-checklist.md)
- [Framework profile packs](framework-profile-packs.md)
- [Framework automation bundles by profile](framework-automation-bundles-by-profile.md)
- [Framework release/versioning/deprecation model](framework-release-versioning-and-deprecation.md)
- [Framework metrics and feedback loop](framework-metrics-and-feedback.md)
- [Framework reporting and review cadence](framework-reporting-and-review-cadence.md)
- [Work-type matrix](work-type-matrix.md)
- [Framework effectiveness scorecard template](framework-effectiveness-scorecard-template.md)
- [Framework health](framework-health.md)
- [Governance checklist](governance-checklist.md)
- [Operating model](operating-model.md)
