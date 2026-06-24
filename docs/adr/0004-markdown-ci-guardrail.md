# ADR 0004: Markdown CI guardrail

- Status: Accepted
- Date: 2026-05-24

## Context

This repository is docs-first, so documentation quality is a production concern rather than a secondary concern. The framework continuity model treats cross-link integrity and durable discoverability as non-negotiable operating principles.

Before PR #17, markdown quality checks depended on manual discipline and ad hoc review. That left room for link rot and structural drift to accumulate between reviews.

## Decision

Adopt a markdown CI guardrail using:

- `DavidAnson/markdownlint-cli2-action@v16`
- `gaurav-nelson/github-action-markdown-link-check@v1`

The guardrail is configured through:

- `.markdownlint.jsonc`
- `.github/markdown-link-check.json`

The workflow runs:

- On pull requests that touch `**/*.md`
- On pushes to `main`

## Consequences

- Catches broken links and markdown structure drift early in the pull request flow.
- Improves confidence that repository documentation remains navigable and durable.
- Preserves a practical compromise between strict linting and current prose style by intentionally disabling MD013 and MD033 for now.
- Leaves explicit follow-up work to re-enable MD001, MD022, MD024, MD031, and MD032 once existing content is aligned.

## Alternatives considered

- **No CI guardrail:** rejected because it relies on manual discipline and allows regressions to escape.
- **Pre-commit hooks only:** rejected because they are not enforceable across all hybrid execution surfaces and contributor environments.
- **Custom markdown validation script:** rejected due to maintenance burden versus mature, maintained GitHub Actions.

## References

- PR #17
- `.github/workflows/markdown.yml`
