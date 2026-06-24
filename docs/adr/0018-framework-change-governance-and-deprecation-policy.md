# ADR 0018: Framework change governance and deprecation policy

- Status: Accepted
- Date: 2026-05-25

## Context

The framework already had lifecycle semantics in
`docs/framework-release-versioning-and-deprecation.md`, plus recurring governance and health audit documents.

However, maintainers still lacked one explicit policy surface focused on operational governance for component lifecycle events across docs/templates/scripts/workflows:

- how new framework components are introduced coherently
- what notice/replacement requirements apply for deprecations/removals
- what lifecycle states owners must use and maintain
- what writeback is required so governance events remain durable

Without this, lifecycle handling risks becoming inconsistent across PRs and hard to audit.

## Decision

Create a dedicated policy doc:

- `docs/framework-change-governance-and-deprecation-policy.md`

and treat it as the canonical governance policy for framework component lifecycle events.

The policy defines:

1. component-introduction requirements (owner, discoverability, validation, coherence),
2. required notice and replacement-path expectations for changes/retirements,
3. deprecation lifecycle states (`Active`, `Deprecated (notice issued)`, `Removal scheduled`, `Removed`),
4. owner responsibilities, and
5. writeback expectations for governance-significant events.

## Consequences

Positive:

- Governance expectations for docs/templates/scripts/workflows become explicit and auditable.
- Deprecation handling has a consistent state model and required replacement/notice semantics.
- Writeback requirements are clear and aligned with issue/PR/ADR/release-note artifacts.
- Discoverability and review cadence docs can point to one governance policy source.

Trade-offs:

- Maintainers must keep one additional policy document current.
- Framework-change PRs now have clearer, but slightly stricter, lifecycle writeback expectations.

## Follow-ups

- Cross-link the new policy from governance checklist and reporting/review cadence docs.
- Update discoverability entrypoints (`README.md`, `docs/README.md`, `AGENTS.md`) and continuity/health references.
- Keep lifecycle and release model docs aligned with this policy.

## References

- [`docs/framework-change-governance-and-deprecation-policy.md`](../framework-change-governance-and-deprecation-policy.md)
- [`docs/framework-release-versioning-and-deprecation.md`](../framework-release-versioning-and-deprecation.md)
- [`docs/governance-checklist.md`](../governance-checklist.md)
- [`docs/framework-reporting-and-review-cadence.md`](../framework-reporting-and-review-cadence.md)
- [`docs/framework-continuity-and-memory.md`](../framework-continuity-and-memory.md)
- [`docs/framework-health.md`](../framework-health.md)
