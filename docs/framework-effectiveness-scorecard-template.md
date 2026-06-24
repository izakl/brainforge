<!-- markdownlint-disable-file MD060 -->

# Framework Effectiveness Scorecard Template

This is a reusable template. Copy it and fill in the fields to run a lightweight
monthly or quarterly review of how well the framework is working in a given
repository or team. An operator or maintainer fills it in on the review cadence;
its findings feed back into the framework so it keeps improving. Keep one review
**packet** (a single self-contained review record, stored in a durable GitHub
artifact such as an issue, pull request, or discussion) per timeframe.

For how reviews fit the wider improvement loop across the hub and each
per-project repo (or **brain**), see
[`docs/how-brain-factory-works.md`](how-brain-factory-works.md). Leave the field
labels, table columns, and example rows below exactly as written so downstream
checks and copy/paste continue to work.

## Work packet contract (required)

Preserve this packet contract in each review artifact:

- Review objective
- Review context and scope boundaries (constraints and non-goals)
- Acceptance criteria for review closure
- Validation expectations and evidence links
- Related artifacts (issues, PRs, ADRs, docs, discussions, project items)
- Deferred follow-up changes with linked owner issue(s), if any

## Review metadata

- Review objective:
- Review context:
- Review constraints and non-goals:
- Review period:
- Repository/team:
- Review owner:
- Review date:
- Related project view(s):
- Related issue/PR:

## Evidence links

- Framework health audit artifact:
- Relevant workflow run links:
- Support/improvement issue set:
- Project board/view snapshot:
- Portability/adoption artifact(s), if applicable:

## Signal scorecard

| Goal area | Signal(s) reviewed | Direction (`Improving` / `Flat` / `Regressing`) | Evidence link(s) | Notes |
| --- | --- | --- | --- | --- |
| Issue quality and normalization |  |  |  |  |
| Handoff completeness and constraint preservation |  |  |  |  |
| PR boundedness and reviewability |  |  |  |  |
| Stale-branch hygiene |  |  |  |  |
| Check pass/fail trends |  |  |  |  |
| Security intake/remediation responsiveness |  |  |  |  |
| Project routing/state flow |  |  |  |  |
| Audit cadence and closure |  |  |  |  |
| Portability/adoption outcomes |  |  |  |  |
| Guidance adherence |  |  |  |  |

## Top findings (max 3)

1.
2.
3.

## Actions agreed

| Action | Artifact type (Issue / PR / ADR / Doc update) | Owner | Due/target | Link |
| --- | --- | --- | --- | --- |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |

## Follow-on recommendations

- Reporting automation to consider:
- Project analytics refinements to consider:
- Adoption maturity model refinements to consider:
- Deferred template/process changes and follow-up issue links:

## Sanity check (avoid over-measurement)

- [ ] Every reviewed signal has a clear action path.
- [ ] No vanity metrics were added without decision value.
- [ ] New measurement work is bounded and low overhead.
- [ ] Follow-up items are captured in durable GitHub artifacts.

## Related docs

- [Framework continuity and memory](framework-continuity-and-memory.md)
- [Work-type matrix](work-type-matrix.md)
- [Open an issue runbook](runbooks/open-an-issue.md)
- [Framework metrics and feedback loop](framework-metrics-and-feedback.md)
- [Framework weekly hygiene summary template](framework-weekly-hygiene-summary-template.md)
- [Framework quarterly adoption and portability summary template](framework-quarterly-adoption-portability-summary-template.md)
- [Framework health](framework-health.md)
- [Product support and improvement loop](product-support-and-improvement-loop.md)
- [Framework portability and adoption](framework-portability-and-adoption.md)
