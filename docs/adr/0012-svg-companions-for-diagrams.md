# ADR 0012: SVG companions for diagrams

- Status: Superseded by [ADR 0024](./0024-retire-svg-companions.md)
- Date: 2026-05-24

> **Superseded (2026-06-24):** the SVG-companion convention has been retired —
> GitHub and the docs site now render Mermaid live, so the companions were
> redundant maintenance. See [ADR 0024](./0024-retire-svg-companions.md). The
> record below is kept for history.

## Context

Mermaid diagrams render well on github.com but degrade on mobile, in PDF exports, and in tools that do not render Mermaid live.

The recent pilot (4 core docs) and follow-up rollout (all remaining diagrammed docs) added SVG companions under `docs/diagrams/`, with a "Hi-res view" link beneath each Mermaid block.

This ADR formalizes that pattern so the behavior is consistent for all current and future diagrammed docs.

## Decision

Every doc that contains a `## Diagram` Mermaid block also has a matching SVG companion under `docs/diagrams/<slug>.svg`, where `<slug>` is the source doc filename minus extension.

SVG companions must be self-contained (no external fonts, scripts, or `<foreignObject>`), use default Mermaid theme colors, and faithfully mirror the source Mermaid block's nodes, edges, and labels.

When a Mermaid diagram changes, its SVG companion must be regenerated in the same PR. `docs/diagrams/README.md` is the index of all companions.

## Consequences

Positive:

- Crisp diagrams on mobile, PDF exports, and external tools.
- Portable artifacts independent of Mermaid renderers.
- Clear convention for new docs with diagrams.

Negative:

- Every diagram change is now a two-step edit (Mermaid + SVG).
- Risk of drift if contributors forget the SVG update.
- Drift risk is mitigated by the governance checklist "SVG companions" item and the framework-health "SVG companions in sync" row.

Follow-ups:

- This PR added CI enforcement in [`../../.github/workflows/check-svg-companions.yml`](https://github.com/izakl/brainforge/blob/main/.github/workflows/check-svg-companions.yml), which flags Mermaid blocks missing matching SVG companions and orphaned SVG companions.

## References

- `../diagrams/README.md`
- `./0010-diagrams-convention.md`
- `./0011-documentation-navigation.md`
