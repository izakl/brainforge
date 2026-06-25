# Architecture Decision Record (ADR) Log

This directory is the durable ADR log for framework-level architecture and operating decisions that affect how teams and agents execute work.

Use this log to preserve why decisions were made, what alternatives were considered, and what contributors should continue to follow over time.

Authoring guide:

- `docs/adr-template-guide.md`

## ADR index

- [ADR 0001: GitHub as durable control plane](./0001-github-as-durable-control-plane.md) — Accepted
- [ADR 0002: Multi-surface hybrid execution model](./0002-multi-surface-hybrid-execution-model.md) — Accepted
- [ADR 0003: Pull requests as primary control gate](./0003-pull-requests-as-primary-control-gate.md) — Accepted
- [ADR 0004: Markdown CI guardrail](./0004-markdown-ci-guardrail.md) — Accepted
- [ADR 0005: Dependabot for GitHub Actions](./0005-dependabot-for-github-actions.md) — Accepted
- [ADR 0006: CODEOWNERS for review routing](./0006-codeowners-for-review-routing.md) — Accepted
- [ADR 0007: Path-based PR auto-labeler](./0007-path-based-pr-auto-labeler.md) — Accepted
- [ADR 0008: Stale branch cleanup automation](./0008-stale-branch-cleanup-automation.md) — Accepted
- [ADR 0009: Mermaid as primary diagram format](./0009-mermaid-as-primary-diagram-format.md) — Accepted
- [ADR 0010: Diagrams convention](./0010-diagrams-convention.md) — Accepted
- [ADR 0011: Documentation navigation](./0011-documentation-navigation.md) — Accepted
- [ADR 0012: SVG companions for diagrams](./0012-svg-companions-for-diagrams.md) — Superseded by ADR 0024
- [ADR 0013: Mobile quick action section convention](./0013-mobile-quick-action-convention.md) — Accepted
- [ADR 0014: Deployment and infrastructure scope](./0014-deployment-infrastructure-scope.md) — Deferred
- [ADR 0015: Handoff packet enforcement](./0015-handoff-packet-enforcement.md) — Accepted
- [ADR 0016: Continuous checks and recurring framework audit layer](./0016-continuous-checks-layer.md) — Accepted
- [ADR 0017: Queue health check and drift-detection layer](./0017-queue-health-check-layer.md) — Accepted
- [ADR 0018: Framework change governance and deprecation policy](./0018-framework-change-governance-and-deprecation-policy.md) — Accepted
- [ADR 0019: Project brain factory and bidirectional improvement loop](./0019-project-brain-factory-and-improvement-loop.md) — Accepted
- [ADR 0020: Portable core, additive enterprise (runtime-agnostic brains)](./0020-portable-core-additive-enterprise.md) — Accepted
- [ADR 0021: Expose Brain Factory over MCP (standard-library stdio server)](./0021-expose-brain-factory-over-mcp.md) — Accepted
- [ADR 0022: Multi-target command emission to standard agent discovery locations](./0022-multi-target-command-emission.md) — Accepted
- [ADR 0023: Documentation site on GitHub Pages (MkDocs Material)](./0023-docs-site-github-pages.md) — Accepted
- [ADR 0024: Retire SVG companions for diagrams](./0024-retire-svg-companions.md) — Accepted
- [ADR 0025: CLI distribution via PyPI and npm](./0025-cli-distribution-via-pypi-and-npm.md) — Accepted

## Numbering convention

- Use sequential, zero-padded numbering: `0001`, `0002`, `0003`, ...
- File naming pattern: `NNNN-short-kebab-case-title.md`
- Never reuse a retired number; preserve historical continuity.

## Status convention

- Proposed — under discussion and not yet adopted.
- Accepted — approved and currently in force.
- Superseded — replaced by a newer ADR (link old and new ADRs).
- Deprecated — no longer recommended, retained for historical context.
