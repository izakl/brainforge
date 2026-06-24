# ADR 0010: Diagrams convention

- Status: Accepted
- Date: 2026-05-24

## Context

Framework docs grew prose-heavy and were hard to scan on mobile devices.

`docs/visual-diagrams-plan.md` proposed a single-diagram-per-doc convention to address this. Ten rollouts across the highest-traffic docs — operating model, product support loop, continuity charter, branching guide, README, governance checklist, two runbooks, a worked example, and CONTRIBUTING — validated the pattern. Each diagram is mobile-legible, renders natively on github.com, and survives markdown CI unchanged.

Without a recorded placement and structure convention, future contributors would produce inconsistent results: multiple diagrams per section, ad-hoc heading names, captions missing, or node counts that break on mobile.

## Decision

Adopt the following convention for `## Diagram` sections in all framework docs:

- One `## Diagram` section per doc, placed after the introductory Purpose prose and before the first deep-dive H2.
- One short caption paragraph above the fenced block, describing what the diagram shows.
- One Mermaid fenced code block per section — no multiple diagrams in a single section.
- No more than 12 nodes, participants, or states per diagram.
- Use only `flowchart`, `sequenceDiagram`, or `stateDiagram-v2` — all natively supported on github.com.
- Relative repo-internal links only; no external image hosts.
- Blank lines around every heading and fenced block to satisfy MD022, MD031, and MD032.

## Consequences

Positive:

- Faster contributor onboarding — every priority doc has a scannable visual entry point.
- Better mobile readability — diagrams stay within the 12-node cap that renders well on small screens.
- Predictable doc shape — reviewers know where to look for the diagram in any file.
- Easy to lint — placement and structure rules are mechanical and can be checked automatically.

Negative:

- Diagrams require updating whenever underlying flows change, adding a small maintenance cost. This is mitigated by the `docs/framework-health.md` "Diagrams in sync" row, which surfaces drift during continuity re-syncs.

Follow-ups:

- New framework docs should ship with a `## Diagram` section from day one, not as a retrofit.
- The governance checklist can later add a row asking "does every priority doc still have a current diagram?".

## Alternatives considered

- **Ad-hoc diagram placement:** rejected because each author chooses a different heading name and position, making docs harder to scan and the convention impossible to lint.
- **Multiple diagrams per doc:** rejected because it increases mobile scroll burden and makes the 12-node cap harder to enforce; a single well-scoped diagram per doc encourages better scope decisions upstream.
- **External image hosts (Lucidchart, Miro, Imgur):** rejected because they add link fragility, auth requirements, and cannot be diffed in pull requests. This reiterates the rationale in ADR 0009.
- **No caption requirement:** rejected because captions carry context that the diagram alone cannot, especially for readers who use screen readers or encounter the diagram out of context.

## References

- `../visual-diagrams-plan.md`
- `../framework-health.md`
- `./0009-mermaid-as-primary-diagram-format.md`
