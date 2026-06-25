# ADR 0024: Retire SVG companions for diagrams

- Status: Accepted
- Date: 2026-06-24

## Context

[ADR 0012](./0012-svg-companions-for-diagrams.md) required every doc with a
`## Diagram` Mermaid block to also carry a hand-maintained SVG companion under
`docs/diagrams/<slug>.svg` plus a "Hi-res view" link, enforced by
`scripts/check-svg-companions.sh`. The motivation was that Mermaid rendered
poorly outside github.com (mobile, PDF, tools that do not render Mermaid live).

That motivation has largely lapsed:

- **GitHub renders Mermaid natively** in Markdown, including on mobile.
- **The documentation site renders Mermaid live** — `mkdocs.yml` configures
  Material's `pymdownx.superfences` with a `mermaid` custom fence, so every
  `## Diagram` block renders in the browser.

With both primary surfaces rendering Mermaid, the companions added recurring
two-step maintenance (every diagram change required regenerating an SVG) plus a
CI guardrail, for a hi-res/offline fallback that is rarely used — and they drift
from their source unless carefully kept in sync.

## Decision

Retire the SVG-companion convention:

- Delete the `docs/diagrams/*.svg` companion files and the per-diagram
  "Hi-res view" links.
- Remove the `check-svg-companions.sh` guardrail and its
  `check-svg-companions.yml` workflow, and unwire it from the CI gate and the
  framework audit.
- Supersede [ADR 0012](./0012-svg-companions-for-diagrams.md).

The Mermaid `## Diagram` convention itself is unchanged: diagrams remain authored
inline as Mermaid ([ADR 0009](./0009-mermaid-as-primary-diagram-format.md),
[ADR 0010](./0010-diagrams-convention.md)) and render natively on GitHub and on
the docs site.

## Consequences

Positive:

- One source of truth per diagram (the Mermaid block); no regeneration step.
- One fewer guardrail to run and maintain, and no companion drift.

Trade-offs:

- No bundled hi-res/offline SVG. Anyone needing one can export the Mermaid block
  on demand (e.g. the Mermaid Live Editor); it is no longer a committed,
  enforced artifact.

## References

- [ADR 0012: SVG companions for diagrams](./0012-svg-companions-for-diagrams.md) (superseded)
- [ADR 0009: Mermaid as the primary diagram format](./0009-mermaid-as-primary-diagram-format.md)
- [ADR 0010: Diagrams convention](./0010-diagrams-convention.md)
- [`docs/diagrams/README.md`](../diagrams/README.md)
