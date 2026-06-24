# ADR 0011: Documentation navigation

- Status: Accepted
- Date: 2026-05-24

## Context

Framework documentation has expanded across `docs/`, `docs/runbooks/`, `examples/`, and `docs/adr/`.

Cross-links were previously ad-hoc, and there was no single entry page for readers to navigate the full documentation set.

Recent bulk PRs addressed this by adding a standardized `## Related docs` footer to content docs and by establishing `docs/README.md` as an index and navigation hub.

This ADR formalizes both conventions so future documentation follows them by default.

## Decision

Adopt the following documentation navigation conventions:

- **Related docs footer.** Every content doc under `docs/` (excluding ADRs, index pages, and pure-reference files such as the glossary), every runbook under `docs/runbooks/`, and every example under `examples/` ends with a `## Related docs` section listing relevant siblings via relative links, with the self-link omitted. Core docs cross-link the other five core docs. Runbooks cross-link relevant core docs plus peer runbooks. Examples cross-link relevant core docs plus peer examples.
- **Documentation index.** `docs/README.md` is the canonical entry point, organized into five sections: Core docs, Runbooks, Examples, Architecture decisions, Reference. Each section is populated from the current state of the corresponding directory; new docs added to those directories must also be linked from `docs/README.md`.

## Consequences

Positive:

- Predictable lateral navigation across documentation surfaces.
- A single discoverable documentation entry point for onboarding.
- Lower navigation overhead for contributors and operators.
- Conventions that are straightforward to lint structurally.

Negative:

- Adding a new doc requires two edits: the doc itself and `docs/README.md`.
- Governance checks may need an explicit row verifying every doc is reachable from `docs/README.md`.

Follow-ups:

- Root `README.md` and `CONTRIBUTING.md` link to `docs/README.md` as the documentation hub (delivered in this PR).

## References

- `../README.md`
- `./0010-diagrams-convention.md`
