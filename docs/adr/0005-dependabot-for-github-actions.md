# ADR 0005: Dependabot for GitHub Actions

- Status: Accepted
- Date: 2026-05-24

## Context

ADR 0004 adopted a markdown CI guardrail (PR #17) that relies on pinned GitHub Action versions: `actions/checkout`, `DavidAnson/markdownlint-cli2-action`, and `gaurav-nelson/github-action-markdown-link-check`. Without an automated update mechanism, those pinned versions would drift onto unsupported or insecure releases over time, undermining the supply-chain hygiene that the CI guardrail is meant to reinforce.

The continuity charter (`docs/framework-continuity-and-memory.md`) explicitly calls out continuous improvement loops as a non-negotiable operating principle. Relying on manual version tracking contradicts that principle.

## Decision

Adopt Dependabot configured for GitHub Actions dependency updates. The configuration is committed at `.github/dependabot.yml` with the following settings:

- `package-ecosystem: github-actions`
- Weekly schedule on Mondays
- Maximum 5 open PRs at a time
- Commit message prefix `ci` (with scope included)
- Labels: `dependencies` and `github-actions`

## Consequences

- Dependabot opens pull requests weekly when new action versions are available, creating a small but predictable review cadence.
- Supply-chain hygiene is maintained automatically without requiring manual tracking.
- The `Handle a Dependabot PR` runbook (`docs/runbooks/handle-a-dependabot-pr.md`) provides the triage and merge procedure for those PRs.
- Action version drift is eliminated as a category of silent risk.

## Alternatives considered

- **Manual quarterly updates:** rejected — easy to forget, provides no automated signal when a new version is released, and violates the continuous improvement principle.
- **Renovate:** rejected — Dependabot is GitHub-native, requires no additional app installation, and is fully sufficient for this single-ecosystem repository.
- **Pinning to a SHA without updates:** rejected — defeats the purpose of pinning by allowing indefinite drift onto an increasingly outdated commit.

## References

- PR #23
- `../../.github/dependabot.yml`
- `./0004-markdown-ci-guardrail.md`
