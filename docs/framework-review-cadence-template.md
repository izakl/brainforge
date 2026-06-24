<!-- markdownlint-disable-file MD060 -->

# Framework Review Cadence Template

This is a reusable template. Copy it and fill in the fields to run a framework
review on whatever rhythm applies — weekly, monthly, quarterly, or event-driven.
An operator or maintainer fills it in for each review and links the result into a
durable GitHub artifact. Keep one **packet** (a single self-contained review
record stored in an issue, pull request, or discussion) per review event. Use
the cadence checklist below to pick only the sections that match the review you
are running.

For how recurring reviews feed the improvement loop across the hub and each
per-project repo (or **brain**), see
[`docs/how-brain-factory-works.md`](how-brain-factory-works.md). Leave the field
labels, checklist items, table columns, and example rows below exactly as written
so downstream checks and copy/paste continue to work.

## Work packet contract (required)

Preserve this packet contract in each review artifact:

- Review objective
- Review context and scope boundaries (constraints and non-goals)
- Acceptance criteria for review closure
- Validation expectations and evidence links
- Related artifacts (issues, PRs, ADRs, docs, discussions, project items)
- Deferred follow-up changes with linked owner issue(s), if any

## Review metadata

- Cadence type (`Per change` / `Weekly` / `Monthly` / `Quarterly` / `Event-driven`):
- Review objective:
- Review context:
- Review constraints and non-goals:
- Timeframe covered:
- Review owner:
- Contributors/reviewers:
- Related issue/PR/discussion:
- Related project view(s):

## Evidence links

- Relevant workflow runs:
- Related issue set:
- Related PR set:
- Health/governance artifacts:
- Metrics/adoption artifacts (if applicable):

## Cadence checklist (select what applies)

### Per change (PR)

- [ ] Issue and PR packet fields are complete.
- [ ] Scope is bounded and non-goals are explicit.
- [ ] Validation evidence is present and relevant checks passed.
- [ ] Deferred scope is captured as linked follow-up issue(s).

### Weekly hygiene

- [ ] Stale-branch findings reviewed and dispositioned.
- [ ] Aging open PRs have owner/status updates.
- [ ] Blocked and follow-up items have owner + unblock path.
- [ ] Support intake routing quality was spot-checked.

### Monthly health/effectiveness

- [ ] Framework health audit findings were reviewed.
- [ ] Governance checklist drift findings were reviewed.
- [ ] Signal directions were assessed (improving/flat/regressing).
- [ ] Prior-cycle actions were verified as closed or re-scoped.

### Quarterly adoption/portability

- [ ] Maturity dimensions were reassessed with evidence links.
- [ ] Lowest-level dimensions were identified.
- [ ] 2-3 bounded next actions were selected.
- [ ] Portability/invariant gaps were captured.

### Event-driven

- [ ] Trigger condition and impact were documented.
- [ ] Contributing process/control gaps were identified.
- [ ] Immediate containment/remediation actions were linked.
- [ ] Preventive follow-up actions were assigned with owners.

## Top findings (max 3)

1.
2.
3.

## Actions agreed

| Action | Artifact type (Issue / PR / ADR / Doc update) | Owner | Target date | Link |
| --- | --- | --- | --- | --- |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |

## Closure note

- What changed because of this review:
- What remains open and why:
- Next cadence touchpoint:

## Sanity check (keep overhead low)

- [ ] Findings are concrete and evidence-backed.
- [ ] Every actionable finding has exactly one durable owner.
- [ ] No vanity metrics or dashboard-only actions were added.
- [ ] Follow-up work is bounded and linked to durable artifacts.

## Related docs

- [Framework continuity and memory](framework-continuity-and-memory.md)
- [Work-type matrix](work-type-matrix.md)
- [Open an issue runbook](runbooks/open-an-issue.md)
- [Framework reporting and review cadence](framework-reporting-and-review-cadence.md)
- [Framework weekly hygiene summary template](framework-weekly-hygiene-summary-template.md)
- [Framework quarterly adoption and portability summary template](framework-quarterly-adoption-portability-summary-template.md)
- [Framework effectiveness scorecard template](framework-effectiveness-scorecard-template.md)
- [Framework metrics and feedback loop](framework-metrics-and-feedback.md)
