<!-- markdownlint-disable-file MD060 -->

# Framework Weekly Hygiene Summary Template

This is a reusable template. Copy it and fill in the fields each week to run the
weekly hygiene cadence — a short, recurring check that catches operational drift
early (stale branches, aging pull requests, blocked items, and intake routing).
An operator or maintainer on rotation fills it in and links the result into a
durable GitHub artifact. Keep one **packet** (a single self-contained weekly
record stored in an issue or discussion) per week.

For how this recurring check feeds the wider improvement loop across the hub and
each per-project repo (or **brain**), see
[`docs/how-brain-factory-works.md`](how-brain-factory-works.md). Leave the field
labels, table columns, and example rows below exactly as written so downstream
checks and copy/paste continue to work.

## Summary metadata

- Week ending (YYYY-MM-DD):
- Review owner:
- Related issue/PR/discussion:
- Related project view(s):

## Hygiene signals (top 5 only)

| Signal area | Status (`On track` / `Needs action`) | Evidence link | Owner | Follow-up issue |
| --- | --- | --- | --- | --- |
| Stale branches |  |  |  |  |
| Aging open PRs |  |  |  |  |
| Blocked project items |  |  |  |  |
| Follow-up queue aging |  |  |  |  |
| Support intake routing flow |  |  |  |  |

## Top findings (max 3)

1.
2.
3.

## Actions agreed this week

| Action | Artifact type (Issue / PR / Doc update) | Owner | Due date | Link |
| --- | --- | --- | --- | --- |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |

## Completed packet location (required)

- **Default location:** weekly hygiene issue (new or rolling) with this packet in
  the issue body or a dated comment.
- **If hygiene work is tied to one implementation change:** store the packet in
  the implementation PR description/comment and link a tracking issue.
- **If cross-repo or broad discussion is needed:** publish in a discussion, then
  link the resulting issue(s)/PR(s) for actionable follow-up.

## Closure check

- [ ] One issue per actionable finding is linked.
- [ ] Owners and due dates are explicit.
- [ ] Evidence links are present for every `Needs action` signal.

## Related docs

- [Framework reporting and review cadence](framework-reporting-and-review-cadence.md)
- [Framework metrics and feedback loop](framework-metrics-and-feedback.md)
- [Framework review cadence template](framework-review-cadence-template.md)
- [Open an issue runbook](runbooks/open-an-issue.md)
