# ADR 0016: Continuous checks and recurring framework audit layer

- Status: Accepted
- Date: 2026-05-25

## Context

The framework accumulated a rich set of PR-time CI checks over time:

- Markdown linting and link-check (`markdown.yml`)
- SVG companion parity (`check-svg-companions.sh` / `check-svg-companions.yml`)
- Mobile quick-action coverage (`check-mobile-quick-action.sh` / `markdown.yml`)
- Handoff packet completeness (`check-handoff-packet.sh` / `check-handoff-packet.yml`)
- Security guardrail anchors (`check-security-guardrails.sh` / `check-security-guardrails.yml`)

However, several hygiene rules listed in `docs/framework-health.md` as recurring audit
items had no repeatable automation:

1. **ADR index parity** — no check that every `docs/adr/NNNN-*.md` file was listed
   in `docs/adr/README.md`.
2. **Runbooks index parity** — no check that every runbook file was listed in
   `docs/runbooks/README.md`.
3. **Examples index parity** — no check that every example file was listed in
   `examples/README.md`.
4. **Consolidated scheduled audit** — no single workflow that re-ran all framework
   health checks on a recurring cadence. The only scheduled workflow was the
   stale-branch cleanup (`stale-branches.yml`), which handles hygiene but not
   framework coherence.

The absence of an index-parity check meant that adding a new ADR, runbook, or example
without updating the corresponding index would pass all CI gates silently. The gap was
identified only during manual framework health audits.

## Decision

Close the recurring gaps with two lightweight additions:

### 1. `scripts/check-index-parity.sh`

A new script that verifies three index files stay in sync with the files they
document:

- Every `docs/adr/NNNN-*.md` is referenced in `docs/adr/README.md`.
- Every `docs/runbooks/*.md` (except `README.md`) is referenced in
  `docs/runbooks/README.md`.
- Every `examples/*.md` (except `README.md`) is referenced in `examples/README.md`.

The script follows the same pattern as the other framework check scripts: `set -euo pipefail`,
repo-root detection, error accumulation with `errors+=()`, and a clear pass/fail summary line.

### 2. `.github/workflows/framework-audit.yml`

A new consolidated framework-audit workflow that:

- Runs on a monthly schedule (`0 6 1 * *` — first of each month at 06:00 UTC).
- Can be triggered manually via `workflow_dispatch`.
- Also runs on pull requests that touch any of the check scripts or the workflow file itself.
- Runs all five framework check scripts as parallel jobs: index parity, security
  guardrails, handoff packet, SVG companions, and mobile quick-action coverage.

This gives the framework a durable, re-runnable scheduled audit surface — not just PR-gated
checks — so drift that occurs outside of PRs (for example, files added without index
updates, or scripts that diverge from what they check) is surfaced automatically.

## Alternatives considered

- **Expand existing PR workflows only:** rejected because PR-time checks do not catch drift
  that accumulates between PRs or during manual file operations. A scheduled workflow is
  the only mechanism that detects accumulated drift.

- **Single omnibus job instead of parallel jobs:** rejected because parallel jobs produce
  clearer per-check status in the Actions UI and match the repo's existing per-check
  workflow pattern.

- **Check `docs/README.md` index parity as well:** deferred. `docs/README.md` is a curated
  navigation document, not a mechanical file-system mirror. Automating its parity would
  require accepting false positives for intentionally omitted files. Manual audit during
  framework health checks is the appropriate control for this index.

## Consequences

Positive:

- Three recurring manual audit items are now CI-enforced: ADR index, runbooks index,
  and examples index.
- A single `workflow_dispatch`-triggerable workflow runs all framework health checks,
  making a full framework audit a one-click operation.
- Contributors adding new ADRs, runbooks, or examples without updating the index will
  see a CI failure immediately.
- The monthly schedule ensures accumulated drift is caught even between active development
  periods.

Negative:

- Authors of new ADRs, runbooks, and examples must update the corresponding index file
  in the same PR, or CI will fail.

Follow-ups:

- Update `docs/framework-health.md` to reflect the automated vs manual distinction.
- Update `docs/governance-checklist.md` to reference the new index-parity check.
- Update `AGENTS.md` validation commands to include `check-index-parity.sh`.

## References

- [`scripts/check-index-parity.sh`](../../scripts/check-index-parity.sh)
- [`.github/workflows/framework-audit.yml`](../../.github/workflows/framework-audit.yml)
- [`docs/framework-health.md`](../framework-health.md)
- [ADR 0012: SVG companions for diagrams](./0012-svg-companions-for-diagrams.md)
- [ADR 0013: Mobile quick action section convention](./0013-mobile-quick-action-convention.md)
- [ADR 0015: Handoff packet enforcement](./0015-handoff-packet-enforcement.md)
