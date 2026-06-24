# ADR 0003: Pull requests as primary control gate

- Status: Accepted
- Date: 2026-05-24

## Context

In a multi-surface framework, implementation quality and governance depend on bounded, reviewable change units. Branching discipline is needed so work packets remain scoped, validation evidence is visible, and stale context is cleaned up after completion.

## Decision

All implementation and automation changes should flow through bounded, reviewable pull requests as the primary control gate. Branches should map to a single issue or work packet and should be cleaned up quickly after merge.

PRs should preserve objective, constraints, and validation context, and linked issue/project artifacts should be updated at closure.

## Consequences

- Creates clear review and approval checkpoints.
- Preserves traceability from issue to PR to merged outcome.
- Requires contributors and agents to keep scope bounded per branch.
- Adds lightweight operational overhead for branch hygiene and post-merge cleanup.

## Alternatives considered

- **Frequent direct-to-main changes:** rejected due to reduced reviewability and higher governance risk.
- **Long-lived multi-scope branches:** rejected because they increase stale context and merge complexity.
- **Unlinked PRs without issue/work packet traceability:** rejected because they weaken operational continuity.

## References

- `docs/branching-and-cleanup.md`
