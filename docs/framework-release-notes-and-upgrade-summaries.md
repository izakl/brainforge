# Framework Release Notes and Upgrade Summaries

This guide shows maintainers how to write the change summaries that go out with each meaningful update to Brain Factory's shared framework — without heavy release-management ceremony. It pairs with the [release/versioning model](framework-release-versioning-and-deprecation.md), which defines the change levels these summaries report. New to the project? Start with [Brain Factory: how it works](how-brain-factory-works.md).

## Purpose

The framework already defines its change levels (`PATCH` / `MINOR` / `MAJOR`)
and upgrade guidance. What was missing is a consistent, low-friction way for an
adopter — a project whose brain inherits the core layer — to answer:

- what changed
- why it matters
- whether action is required
- whether the change applies to their profile or maturity context

This model makes that communication durable and easy to scan.

## Design goals

1. Keep summaries lightweight and high signal.
2. Avoid forcing formal release management for every small change.
3. Make adopter action expectations explicit.
4. Keep summaries durable in GitHub artifacts, not chat memory.
5. Preserve profile-aware and maturity-aware adoption paths.

## Minimal artifact model

Use three lightweight surfaces:

1. **Summary content** — one release note or upgrade summary per meaningful
   change batch (`MINOR`/`MAJOR`, and any `PATCH` with non-trivial adoption
   implications).
2. **Reusable template** — author summaries with
   [`framework-change-summary-template.md`](framework-change-summary-template.md).
3. **Durable index** — add one row to
   [`framework-release-notes.md`](framework-release-notes.md) pointing to the
   summary artifact and linked work.

Summary artifacts can live as:

- GitHub Release notes, or
- a release-summary issue/discussion, or
- a repository markdown packet if release tooling is intentionally minimal.

For repository markdown packets, store summaries under
`docs/release-notes/YYYY-MM-DD-<slug>.md` and always index them in
[`framework-release-notes.md`](framework-release-notes.md).

## Classification model for summaries

Every summary should classify the change on four axes:

1. **Lifecycle impact**: `PATCH` / `MINOR` / `MAJOR`
2. **Adopter action level**:
   - `Informational` (no action expected)
   - `Recommended` (action advised, not required)
   - `Required` (must adopt to stay aligned)
3. **Applicability scope**:
   - `Universal` (applies to all adopters)
   - `Profile-specific`
   - `Maturity-gated`
   - `Optional`
4. **Compatibility signal**:
   - `Backward compatible`
   - `Backward compatible with migration`
   - `Not backward compatible`

When scope is profile-specific or maturity-gated, name the exact profile(s) and
level(s) in the summary.

Also include a migration-burden estimate (`Low` / `Medium` / `High`) and a
short rationale.

## When to publish a summary

Publish a new summary when at least one is true:

- framework operating expectations change
- required fields/checks/guardrails change
- deprecation is introduced, advanced, or removed
- upgrade decisions for adopters are no longer obvious from one PR
- multi-artifact changes should be consumed as one coherent update packet

You may skip a dedicated summary for low-risk `PATCH` clarifications that are
purely editorial and have no upgrade implications.

## Fast applicability and action decision

Use this matrix when triaging whether a summary needs immediate action:

| Signal | Interpretation | Action |
| --- | --- | --- |
| `Required` + `Universal` | Applies broadly and blocks alignment if ignored | Open a bounded upgrade issue now. |
| `Required` + `Profile-specific` or `Maturity-gated` | Mandatory only for named contexts | Act now if context matches; otherwise document why not applicable. |
| `Recommended` + matching applicability | Improvement with practical value in your context | Plan in next review cycle or batch with nearby upgrades. |
| `Informational` | Awareness-only update | Record baseline awareness; no upgrade issue required. |

## Maintainer workflow

1. During PR authoring, capture preliminary lifecycle/adopter-impact notes in
   the PR template.
2. At merge (or release batching), create one bounded summary packet using the
   template.
3. Link the summary to related issue/PR/ADR/runbook artifacts.
4. Add/update the row in [`framework-release-notes.md`](framework-release-notes.md).
5. If action is `Required`, include a bounded adopter checklist and explicit
   timeline/target.
6. For deprecations/removals, include replacement path and link the governance
   lifecycle artifact so deprecation state remains durable and auditable.

## Adopter workflow

1. Start from [`framework-release-notes.md`](framework-release-notes.md).
2. Review new summaries since your baseline.
3. Filter by action level and applicability (`Required` first, then
   `Recommended` that match your profile/maturity).
4. Open one bounded upgrade issue per coherent update batch.
5. Record adopt/defer/diverge outcomes durably.

## Lightweight guardrails

- Keep one coherent summary per change batch; do not publish summary sprawl.
- Prefer concise bullets and checklists over prose-heavy release packets.
- Do not force version bump mechanics for docs-only editorial cleanups.
- Do not hide required adoption changes in PR comments without durable summaries.

## Mobile quick action

- **Use when:** you need to quickly determine whether a framework update requires
  immediate action.
- **Do from mobile:**
  - check action level (`Informational` / `Recommended` / `Required`)
  - confirm applicability (universal/profile/maturity/optional)
  - open or update one upgrade issue if action is needed
- **Do not do from mobile:**
  - author broad multi-artifact summary packets
  - classify ambiguous lifecycle impact without linked evidence
- **Escalate to desktop/cloud when:**
  - the summary spans multiple docs/templates/scripts/workflows
  - required adopter actions need coordinated upgrade slicing
- **Primary artifact to update:**
  - [`framework-release-notes.md`](framework-release-notes.md) and the linked
    summary artifact.

## Related docs

- [Framework release/versioning/deprecation model](framework-release-versioning-and-deprecation.md)
- [Framework release notes index](framework-release-notes.md)
- [Framework change summary template](framework-change-summary-template.md)
- [Framework upgrade and adoption maintenance](framework-upgrade-and-maintenance.md)
- [Maintain framework alignment](runbooks/maintain-framework-alignment.md)
- [Framework profile packs](framework-profile-packs.md)
- [Framework adoption maturity model](framework-adoption-maturity-model.md)
