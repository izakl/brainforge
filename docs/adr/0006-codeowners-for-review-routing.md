# ADR 0006: CODEOWNERS for review routing

- Status: Accepted
- Date: 2026-05-24

## Context

ADR 0003 established pull requests as the primary control gate for all changes. The governance charter (`docs/governance-checklist.md`) and the continuity anchor (`docs/framework-continuity-and-memory.md`) both treat PRs as the mechanism for human review and approval. Without explicit ownership declared in the repository, review routing relied on convention; this risked unreviewed merges, especially as agent-authored PRs increased in volume and frequency.

## Decision

Adopt `.github/CODEOWNERS` declaring `@izakl` as the default owner for all paths (`*`), with explicit entries for the highest-sensitivity areas:

- `/docs/` — framework documentation
- `/docs/adr/` — architecture decision records
- `/docs/framework-continuity-and-memory.md` — continuity anchor
- `/.github/` — repository automation and configuration
- `/.github/workflows/` — CI workflow definitions

The file is structured to be extensible: adding a new path entry with a different owner is sufficient to route reviews as the contributor base grows.

## Consequences

- Every pull request automatically requests review from the correct owner based on which paths it touches.
- The `PRs as control gate` charter principle is enforced by tooling rather than convention.
- Future contributors or teams can extend ownership by path without restructuring the file.
- Works in concert with the SECURITY.md private vulnerability reporting path and the markdown CI guardrail from ADR 0004.

## Alternatives considered

- **Branch protection rules alone:** rejected — enforces a review requirement but does not provide path-based review routing.
- **No CODEOWNERS:** rejected — leaves review routing implicit, which violates the "PRs as control gate" principle in the governance charter.
- **Team-based ownership:** deferred — premature for a single-maintainer repository; the file is structured to accommodate team entries when that changes.

## References

- PR #21
- `../../.github/CODEOWNERS`
- `../governance-checklist.md`
