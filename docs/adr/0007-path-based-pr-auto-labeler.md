# ADR 0007: Path-based PR auto-labeler

- Status: Accepted
- Date: 2026-05-24

## Context

As the framework grew across runbooks, examples, ADRs, governance, and CI assets, filtering pull requests and GitHub Projects items by area became increasingly difficult.

`CODEOWNERS` already encodes path-to-owner routing, but it does not create labels. Without consistent labels, GitHub Projects boards and filters cannot reliably segment work by area, and the support/improvement loop loses practical visibility.

The continuity charter also treats GitHub Projects as an operational layer, which depends on stable labeling discipline.

## Decision

Adopt `actions/labeler@v5` driven by `../../.github/labeler.yml`, executed by `../../.github/workflows/labeler.yml` on `pull_request_target`.

Configure least-privilege permissions:

- `contents: read`
- `pull-requests: write`

Enable `sync-labels: true` and define labels mirroring CODEOWNERS-oriented areas:

- `docs`
- `adr`
- `runbooks`
- `examples`
- `governance`
- `ci`
- `automation`
- `templates`

## Consequences

- Every pull request is auto-labeled by changed paths.
- GitHub Projects boards and filters become materially more useful for triage and reporting.
- Labels stay aligned as files move because matching remains path-based and synchronized.
- Manual label hygiene is no longer required.
- One lightweight workflow run is added per pull request.
- Labels are created automatically on first use by the action.

## Alternatives considered

- **Manual labeling:** rejected because it does not scale and drifts over time.
- **Custom GitHub Script implementation:** rejected because `actions/labeler` is the GitHub-maintained standard and simpler to operate.
- **Replacing CODEOWNERS with labels:** rejected because routing ownership and classification serve different purposes.

## References

- `../../.github/labeler.yml`
- `../../.github/workflows/labeler.yml`
- `../../.github/CODEOWNERS`
- `../gh-agents-and-automation.md`
- `../product-support-and-improvement-loop.md`
