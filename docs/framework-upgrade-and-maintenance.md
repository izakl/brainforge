# Framework Upgrade and Adoption Maintenance

This guide is for teams that have adopted Brain Factory and want to stay aligned
with it over time, without taking on heavy release-management overhead. It also
covers how to leave clean closure artifacts when finishing queued work, so the
record of what was done is not lost. New to the project? See
[How Brain Factory works](how-brain-factory-works.md) first.

Use this guide when:

- You want to review framework changes and decide what to absorb.
- You are reconciling your local repo adaptations with upstream evolution.
- You need to decide whether to adopt, defer, or intentionally diverge from a change.
- A merged PR did not automatically close its source issue and you need to clean up.

For the step-by-step operator procedure, use
[`runbooks/maintain-framework-alignment.md`](runbooks/maintain-framework-alignment.md).

## The maintenance challenge

After initial adoption, framework evolution continues. Guidance is added, templates
are refined, scripts are updated, and deprecations occur. Without a lightweight review
process, adopters face two failure modes:

- **Silent drift**: local copies fall behind and adopters do not know what changed.
- **Over-adoption**: absorbing every framework change regardless of profile or maturity fit.

This guide avoids both by making upgrade decisions explicit, bounded, and durable.

## How to track what changed

The canonical source for framework changes is the GitHub release history and linked
release notes. See
[`framework-release-versioning-and-deprecation.md`](framework-release-versioning-and-deprecation.md)
for the full release communication model.
Use [`framework-release-notes.md`](framework-release-notes.md) as the quick index
for recent summaries and
[`framework-release-notes-and-upgrade-summaries.md`](framework-release-notes-and-upgrade-summaries.md)
for summary classification rules.

For each meaningful framework update (`MINOR` or `MAJOR`), a release artifact exists
(GitHub Release, release-summary issue, or release-summary discussion). Look for:

- `MAJOR` — required adopter action; must be reconciled before claiming continued
  compatible adoption.
- `MINOR` — selective adoption encouraged; review and decide for your context.
- `PATCH` — no adopter action required; absorb opportunistically.

For repos with limited formalism, any framework PR merged to `main` can serve as the
checkpoint. The PR body carries change classification under "Type of change" and
"Work packet carry-forward."

## Change classification for your repo

When reviewing a framework change, classify it against your repo's context:

| Classification | Meaning | Decision |
| --- | --- | --- |
| Essential / required | Breaks a core invariant if not absorbed | Must adopt immediately; open a bounded upgrade issue and PR. |
| Recommended / additive | New guidance, runbook, or template that improves your adoption | Adopt at next review cycle; defer with an explicit follow-up issue if not immediately. |
| Optional / profile-specific | Relevant only for certain profiles (e.g., multi-agent, ops-heavy) | Adopt if your profile matches; otherwise skip with a documented decision. |
| Maturity-gated | Suitable only at maturity Level 3–4 | Defer until your team reaches the right maturity level. |
| Intentional divergence | You have deliberately adapted this artifact for your repo | Document the divergence; review whether upstream changes affect your adaptation logic. |

## Deciding whether to adopt, defer, or diverge

Use this decision path for each framework change:

1. **Does the change affect a core invariant?** (bounded PRs, normalized context,
   durable artifact linkage, handoff packet fields, required validation)
   - Yes → adopt immediately; this is not optional.
   - No → continue.

2. **Does the change affect an artifact you copied or adapted?**
   - Yes → review whether your adaptation is still valid; adopt or reconcile.
   - No → continue.

3. **Does the change address friction your team has experienced?**
   - Yes → adopt it now.
   - No → continue.

4. **Is the change relevant to your profile or maturity level?**
   - Yes → adopt at the next convenient PR.
   - No → skip and document the decision explicitly (a one-line note in the upgrade
     issue is sufficient).

## Upgrade checklist

Use this checklist when processing a framework change release:

- [ ] Identified the change classification (`PATCH`, `MINOR`, `MAJOR`).
- [ ] Captured adopter action level (`Informational`, `Recommended`, `Required`).
- [ ] Captured applicability scope (`Universal`, `Profile-specific`, `Maturity-gated`, `Optional`).
- [ ] Checked whether the change affects any of the five core invariants.
- [ ] Identified which local artifacts (if any) are affected.
- [ ] Classified each affected artifact as: adopt, defer, or intentional divergence.
- [ ] Opened a bounded upgrade issue capturing: impacted artifacts, required/optional
  changes, validation expectations, deferred items.
- [ ] Applied changes in bounded PRs (one PR per logical update).
- [ ] Preserved all invariant checks after applying changes.
- [ ] Recorded deferred lifecycle work as explicit follow-up issues (not chat notes).
- [ ] Updated your repo's framework version snapshot marker to the new baseline.

## Reconciling local customizations with upstream evolution

Framework artifacts are designed for adaptation. Some changes you have made locally may
conflict with upstream evolution. Handle conflicts as follows.

### When upstream changes your invariants

If the framework changes a required field, required check, or required template section,
you must absorb it. Invariant changes are flagged as `MAJOR` in the release communication.

### When upstream improves something you have adapted

Compare the upstream improvement to your local adaptation:

- If the upstream version is better, adopt it and drop your local override.
- If your local adaptation is context-specific and still valid, document why in the
  upgrade issue.
- If the upstream change makes your local adaptation invalid, fix the conflict and record
  the resolution.

### When you have intentionally diverged

Document intentional divergences explicitly. A brief note in the artifact or upgrade
issue is sufficient. This prevents future maintainers from accidentally reverting
intentional divergences.

## Staged upgrades by maturity and profile

Not every adopter needs every feature immediately. Use the maturity model and profile
packs to gate upgrades:

| Maturity level | Upgrade focus |
| --- | --- |
| Level 1 (Initial) | Core invariants and essential artifacts only. Do not absorb optional guidance. |
| Level 2 (Structured) | Essential + recommended artifacts. Begin adopting recurring checks. |
| Level 3 (Integrated) | Essential + recommended + most optional. Begin tuning based on evidence. |
| Level 4 (Optimized) | All relevant artifacts; actively feed back adoption learnings. |

Use [`framework-profile-packs.md`](framework-profile-packs.md) to determine which
guidance applies to your operating profile before absorbing optional changes.

## Queue closure and linkage hygiene

Every queued task that is implemented via a PR should close its source issue cleanly
using `Closes #<issue-number>` in the PR body. When this does not happen automatically,
the queue record can drift from reality.

### Preventing closure drift

- Use `Closes #<issue-number>` in the PR body's "Linked source artifact" section for the
  canonical source issue.
- Use `Relates-to #<issue-number>` for non-closing references.
- Verify before merge that the queue-linked issue number appears in a close keyword.

### Recovering when auto-close was missed

If a merged PR did not automatically close its source issue:

1. Open the source issue.
2. Leave a comment: "Closed by PR #`<number>` (merged `<date>`). Issue was not
   auto-closed; manually closing now."
3. Close the issue.
4. Update the queue entry to `done` if it has not already been updated.
5. Run `bash scripts/check-queue-health.sh` to confirm no residual drift.

### Audit trigger

Run `bash scripts/check-queue-health.sh` after any merge involving a queue-backed task.
The script's GitHub API mode (when `GITHUB_TOKEN` and `GITHUB_REPOSITORY` are set)
surfaces queue-linked open issues that have merged PR references. Any flagged issue
should be resolved using the recovery steps above.

## Lightweight maintenance cadence

Keep upgrade maintenance lightweight. A suggested cadence:

- **After each `MAJOR` framework release**: review and open a bounded upgrade issue
  immediately.
- **Monthly**: during the framework health audit, check for `MINOR` releases since the
  last review. Batch into one upgrade issue if multiple minor changes apply.
- **Quarterly**: walk the full framework health audit (`docs/framework-health.md`) to
  catch any drift that release-level reviews missed.

This cadence aligns with the recurring review patterns in
[`framework-reporting-and-review-cadence.md`](framework-reporting-and-review-cadence.md).

## Mobile quick action

- **Use when:** you need to decide whether a framework change needs immediate absorption
  or can be deferred, from mobile.
- **Do from mobile:**
  - Confirm the change classification (`PATCH`, `MINOR`, `MAJOR`) from the release note
    or PR body.
  - Confirm whether any core invariant is affected.
  - Leave a comment in the upgrade issue noting the decision (adopt, defer, diverge).
- **Do not do from mobile:**
  - Perform multi-artifact upgrade reconciliation or apply template/script changes.
  - Resolve queue closure drift involving script runs or queue-file edits.
- **Escalate to desktop/cloud when:**
  - The upgrade involves docs, template, or script changes across multiple files.
  - Queue closure recovery requires running `check-queue-health.sh` or editing
    `.github/framework-task-queue.json`.
- **Primary artifact to update:**
  - The bounded upgrade issue capturing adoption decisions and deferred items.

## Related docs

- [How Brain Factory works](how-brain-factory-works.md) — five-minute tour for newcomers.
- [Framework release/versioning/deprecation model](framework-release-versioning-and-deprecation.md) — change classification, release notes, and deprecation lifecycle.
- [Framework release notes and upgrade summaries](framework-release-notes-and-upgrade-summaries.md) — lightweight summary model with action-level and applicability guidance.
- [Framework release notes index](framework-release-notes.md) — quick-scan source for current framework change summaries.
- [Framework portability and adoption](framework-portability-and-adoption.md) — essential/recommended/optional component inventory and adoption invariants.
- [Framework starter kit / bootstrap pack](framework-starter-kit.md) — copy/adapt/customize matrix and minimum viable adoption path.
- [Framework adoption maturity model](framework-adoption-maturity-model.md) — maturity levels and dimension assessment.
- [Framework profile packs](framework-profile-packs.md) — profile-specific guidance to gate optional features.
- [Operator onboarding pack](operator-onboarding-pack.md) — first-use checklist.
- [Framework health](framework-health.md) — charter-to-artifact map and audit checklist.
- [Governance checklist](governance-checklist.md) — recurring audit items.
- [Maintain framework alignment](runbooks/maintain-framework-alignment.md) — step-by-step runbook for running an upgrade review cycle.
- [Operate the framework task queue](runbooks/operate-framework-task-queue.md) — queue state transitions and recovery.
- [Run the queue health check](runbooks/run-queue-health-check.md) — drift detection and closure hygiene.
