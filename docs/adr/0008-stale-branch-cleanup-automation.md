# ADR 0008: Stale branch cleanup automation

- Status: Accepted
- Date: 2026-05-24

## Context

`docs/branching-and-cleanup.md` codifies that branches and pull requests should remain bounded and be cleaned up after completion, but enforcement had been entirely manual.

Agent-authored `copilot/*` branches and Dependabot `dependabot/*` branches accumulated after merge, cluttering the branch list and weakening the charter expectation that operating patterns remain explicit and maintained rather than drifting.

## Decision

Adopt a weekly scheduled workflow at `../../.github/workflows/stale-branches.yml` using `phpdocker-io/github-actions-delete-abandoned-branches@v2`.

The workflow has two steps:

1. Delete merged `copilot/*` and `dependabot/*` branches whose last commit is older than 7 days.
2. Run a dry-run report for any other branch with no open pull request and no activity in 60 days, surfacing output for maintainer review.

Triggers:

- Weekly cron schedule
- `workflow_dispatch`

Least-privilege permissions:

- `contents: write`
- `pull-requests: read`

## Consequences

- Branch lists stay cleaner automatically.
- Agent and Dependabot branches no longer linger after merge.
- Long-lived feature branches are surfaced but not silently deleted, preserving maintainer judgment.
- One scheduled workflow run is added per week.
- Future maintainers should periodically review the dry-run report output.

## Alternatives considered

- **Manual cleanup:** rejected because it does not scale and drifts.
- **Repository setting to auto-delete head branches on merge:** rejected because it only handles merge events and misses closed-without-merge PRs and previously stale branches.
- **Aggressive 30-day deletion of all branches:** rejected due to risk of deleting legitimate long-lived work.

## References

- `../../.github/workflows/stale-branches.yml`
- `../branching-and-cleanup.md`
- `./0001-github-as-durable-control-plane.md`
