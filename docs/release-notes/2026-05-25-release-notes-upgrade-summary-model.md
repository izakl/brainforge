# Framework release notes / upgrade summary model introduced

- Date: 2026-05-25
- Lifecycle impact: `MINOR`
- Adopter action level: `Recommended`
- Applicability: `Universal`

## What changed

- Added a dedicated lightweight model for framework release notes and upgrade
  summaries: [`../framework-release-notes-and-upgrade-summaries.md`](../framework-release-notes-and-upgrade-summaries.md).
- Added a reusable summary packet template:
  [`../framework-change-summary-template.md`](../framework-change-summary-template.md).
- Added a durable quick-scan index:
  [`../framework-release-notes.md`](../framework-release-notes.md).
- Added PR-template prompts for lifecycle impact, adopter action level,
  applicability, and summary linkage:
  [`../../.github/pull_request_template.md`](https://github.com/izakl/brainforge/blob/main/.github/pull_request_template.md).

## Why this matters

Before this change, lifecycle communication rules existed, but there was no
single lightweight packet model for maintainers to summarize cross-artifact
framework updates or for adopters to triage upgrade impact quickly.

This fills that gap with a durable, low-overhead path that reduces dependency
on PR archaeology, chat recall, or implicit maintainer knowledge.

## Adopter impact and actions

### Required now

- [x] None.

### Recommended next

- [ ] Start upgrade reviews from [`../framework-release-notes.md`](../framework-release-notes.md)
  instead of scanning raw PR history.
- [ ] For each new summary, classify local response as adopt, defer, or
  intentional divergence in one bounded upgrade issue.

### Optional / context-specific

- [ ] Repackage summary packets into GitHub Releases if your repository uses
  release-oriented communication.
- [ ] Add profile-specific or maturity-specific local release views if your
  adoption context needs filtered summaries.

## Triggers for future summaries

Publish a new summary when one or more of the following occurs:

- required operating expectations, template fields, checks, or guardrails change
- deprecation state changes (`Active` → `Deprecated` or `Deprecated` → `Removed`)
- multi-file framework updates should be consumed as one coherent upgrade packet
- profile/maturity applicability or adopter action level is non-obvious from PR
  titles alone

## Follow-on opportunities

- Optionally automate release-index row generation from PR metadata once usage
  patterns stabilize.
- Optionally add profile-filtered summary views if adopter volume grows.
- Optionally add bundled "upgrade packs" that group related `Recommended`
  summaries into quarterly adoption slices.

## Related artifacts

- Source issue(s): N/A (task initiated from durable next-prompt packet)
- Pull request(s): This PR
- ADR(s): N/A
- Validation evidence: markdownlint + framework check scripts (recorded in PR)
