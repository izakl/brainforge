<!-- markdownlint-disable-file MD060 -->

# Framework Quarterly Adoption & Portability Summary Template

This is a reusable template. Copy it and fill in the fields once a quarter to
record how adoption and portability are tracking — how widely the framework is
taken up, and how cleanly it moves across repositories and teams. A review owner
fills it in and writes the result back (the **writeback**) into a durable GitHub
artifact such as an issue, pull request, or discussion. Keep one **packet** (a
single self-contained summary record) per quarter.

For how this fits the hub-and-brain model — the central hub and the per-project
repos (or **brains**) it provisions — see
[`docs/how-brain-factory-works.md`](how-brain-factory-works.md). Leave the field
labels, table columns, and example rows below exactly as written so downstream
checks and copy/paste continue to work.

## Summary metadata

- Quarter:
- Review owner:
- Repositories/teams reviewed:
- Related issue/PR/discussion:

## Adoption and portability snapshot

| Dimension | Current state | Evidence link | Gap (if any) | Follow-up issue |
| --- | --- | --- | --- | --- |
| Maturity level progression |  |  |  |  |
| Invariant preservation |  |  |  |  |
| Essential baseline coverage |  |  |  |  |
| Recommended/optional portability fit |  |  |  |  |
| Reusable guidance/template gaps |  |  |  |  |

## Top findings (max 3)

1.
2.
3.

## Next-quarter actions (2-3 bounded items)

| Action | Artifact type (Issue / PR / ADR / Doc update) | Owner | Target date | Link |
| --- | --- | --- | --- | --- |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |

## Completed packet location (required)

- **Default location:** quarterly adoption review issue with this packet in the
  issue body (or in a dated comment if the issue is rolling).
- **If changes are already packaged in one bounded PR:** include the packet in
  the PR description/comment and link all follow-up issues.
- **If early multi-team synthesis is needed:** use a discussion first, then
  normalize outcomes into issue(s)/PR(s)/ADR(s) before closure.

## Closure check

- [ ] Lowest-level maturity gaps are named and linked.
- [ ] Invariant/portability findings have explicit owners.
- [ ] 2-3 bounded next actions are captured with durable artifacts.

## Related docs

- [Framework reporting and review cadence](framework-reporting-and-review-cadence.md)
- [Framework metrics and feedback loop](framework-metrics-and-feedback.md)
- [Framework portability and adoption](framework-portability-and-adoption.md)
- [Framework adoption maturity model](framework-adoption-maturity-model.md)
