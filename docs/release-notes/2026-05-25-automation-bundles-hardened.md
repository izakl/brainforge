# Release Note: Automation Bundle Guidance Hardened

**Date:** 2026-05-25
**Lifecycle impact:** `MINOR`
**Adopter action level:** `Recommended`
**Applicability:** `Universal`

## Summary

The automation bundle guidance in
[`docs/framework-automation-bundles-by-profile.md`](../framework-automation-bundles-by-profile.md)
was hardened to make rollout sequencing, least-privilege guardrails, and deferred
automation tracking explicit and actionable. The bundle model, advance criteria, and
operator runbook linkage are now clearer for all five profile bundles.

## What changed

### Bundle model: minimum → recommended → deferred

- Renamed "later" to **deferred** across all bundles and the comparison matrix to
  make deferral intent explicit and consistent.
- Added **advance criteria** to each bundle (A through E): specific, observable
  conditions that indicate when to move from minimum to recommended, and from
  recommended to deferred.

### Per-bundle operator runbook linkage

- Each bundle now includes an inline **Operator runbooks** reference linking the
  specific runbooks needed to operate that bundle's components.
- Eliminates the need to cross-reference the general related docs section when
  operating a specific bundle.

### Least-privilege enablement guardrails (new section)

- Added a dedicated section with six explicit guardrails:
  1. Confirm prerequisite inventory before enabling any check.
  2. Prefer scoped triggers over repo-wide triggers.
  3. Do not enable queue automation before queue governance is operational.
  4. Enable one automation layer per bounded PR.
  5. Never bypass guardrails to accelerate enablement.
  6. Require a passing local dry-run before merging queue-operations automation.

### Deferred automation registry (new section)

- Added a bounded issue template format for capturing deferred automation items
  with: deferred item name, bundle stage, defer reason, enablement criteria,
  review trigger, and owner.
- Includes a suggested issue title format:
  `[Deferred automation] Enable <check/workflow> — enablement criteria: <brief criterion>`

### Profile + maturity chooser table

- Renamed "Delay until" column to "Defer until" for terminology consistency with
  the updated bundle model.
- Refined defer conditions to be more specific and observable.

### Queue state updates

- Marked `template-harmonization-pass` and `reporting-summary-templates` as `done`
  in `.github/framework-task-queue.json`.
- Marked `automation-bundles-by-profile` as `in_progress`.
- Unblocked `adoption-examples-expansion` to `pending`.

## Adopter impact

| Dimension | Impact |
| --- | --- |
| `docs/framework-automation-bundles-by-profile.md` | Updated — review updated bundle descriptions and new sections |
| Queue state | Updated — `template-harmonization-pass` and `reporting-summary-templates` are now `done` |
| Deferred automation items | New format available — migrate any existing implicit deferrals to the registry format |

## Adopter actions

1. **Review updated bundle descriptions** for your active profile and check whether the
   advance criteria apply to your current state.
2. **Use the deferred automation registry format** for any automation items not yet
   enabled — open one bounded issue per deferred item.
3. **Check per-bundle operator runbook links** when operating a specific bundle to find
   the relevant step-by-step procedures without searching the full runbooks directory.
4. **Confirm least-privilege guardrails** before enabling any new check or workflow.

## Primary links

- [`docs/framework-automation-bundles-by-profile.md`](../framework-automation-bundles-by-profile.md)
- [`docs/framework-profile-packs.md`](../framework-profile-packs.md)
- [`docs/framework-adoption-maturity-model.md`](../framework-adoption-maturity-model.md)
- [Operate the framework task queue](../runbooks/operate-framework-task-queue.md)
- [Run the queue health check](../runbooks/run-queue-health-check.md)
