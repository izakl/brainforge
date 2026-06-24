# Framework Change Governance and Deprecation Policy

This policy is for maintainers of Brain Factory's shared framework — the docs, templates, scripts, and workflows that make up its core layer. Use it whenever you introduce, change, deprecate, or remove one of those components. New to the project? Start with [Brain Factory: how it works](how-brain-factory-works.md).

## Purpose

As the framework grows, maintainers need explicit, durable rules for:

- introducing new components without fragmenting the operating model
- changing existing components with clear impact signaling
- retiring components with the required notice and replacement guidance

This policy governs how component lifecycle events are run day to day. The [release/versioning model](framework-release-versioning-and-deprecation.md) is its companion: that doc classifies change impact and defines release communication, while this one defines the operational rules around each change.

## Scope

This policy applies to framework components that shape day-to-day operation:

- `docs/**/*.md`
- `.github/ISSUE_TEMPLATE/**`, `.github/pull_request_template.md`, and related templates
- `scripts/*.sh` and other framework validation/automation scripts
- `.github/workflows/*.yml` and adjacent workflow governance files

## Change types and minimum governance requirements

| Change type | Required before merge | Required writeback |
| --- | --- | --- |
| New component | Objective, owner, and bounded scope in issue/PR; discoverability links updated from entrypoints; validation path defined | Issue + PR with validation evidence; docs cross-links updated; ADR if policy/invariant changes |
| Behavior change | Impact classified (`PATCH`/`MINOR`/`MAJOR`); constraints/non-goals preserved; downstream guidance alignment checked | Issue + PR + release summary linkage for meaningful (`MINOR`/`MAJOR`) changes |
| Deprecation | Deprecation state recorded; replacement path named (or explicit "no replacement" rationale); notice period and removal target set | Deprecation note in artifact (when practical), issue/PR linkage, lifecycle tracking in release communication |
| Removal | Verify prior deprecation notice window (unless urgent security/safety exception); replacement path still discoverable | Removal PR linked to prior deprecation artifact and closure of deprecation tracking issue |

## Introducing new framework components

When adding new docs/templates/scripts/workflows:

1. Confirm the component fills a real framework gap and is not duplicative.
2. Define owner and maintenance expectation in the issue/PR packet.
3. Add discoverability links from canonical entrypoints (`README.md`, `docs/README.md`, `AGENTS.md`, and relevant continuity/health/governance docs).
4. Align related guidance so contributors get one coherent path (no conflicting instructions).
5. Add or update validation checks if the new component introduces a new invariant.

If the new component changes policy semantics or required operating behavior, create or update an ADR.

## Required notice and replacement path for changes/retirements

For any component being deprecated or retired:

1. Publish durable notice in issue/PR artifacts before removal.
2. Name the replacement path explicitly (file/path + expected usage), or record why no replacement exists.
3. Update cross-links so new contributors land on the replacement first.
4. Set and track a removal target (version milestone and/or follow-up issue).
5. Avoid same-PR deprecate-and-remove unless urgent security/safety risk requires immediate action.

## Deprecation lifecycle states

Use this state model for framework components:

1. **Active** — current recommended path; fully supported and discoverable.
2. **Deprecated (notice issued)** — still usable for transition period; replacement and removal target are documented.
3. **Removal scheduled** — replacement and timing are confirmed; cleanup PR is planned/linked.
4. **Removed** — no longer supported as current path; historical trace remains in Git history and linked artifacts.

## Owner responsibilities

For each lifecycle event, the owner is responsible for:

- preserving issue → PR → (ADR/release note if needed) linkage
- keeping constraints, acceptance criteria, and validation expectations explicit
- updating discoverability links and adjacent governance docs
- ensuring deprecation notices include replacement path and removal target
- capturing post-merge writeback and follow-up ownership for remaining lifecycle work

## Writeback expectations for governance events

Every governance-significant framework change should leave durable writeback:

1. **Planning writeback:** issue captures objective, context, constraints, acceptance criteria, and validation.
2. **Implementation writeback:** PR records bounded scope, lifecycle impact, validation evidence, and out-of-scope notes.
3. **Decision writeback:** ADR records policy-level decisions or invariant changes.
4. **Lifecycle writeback:** release/deprecation communication captures replacement path, notice, and removal target.
5. **Operational writeback:** follow-up issues track deferred lifecycle work to closure.

Do not treat chat-only notes or ephemeral agent memory as sufficient governance writeback.

## Relationship to lifecycle/release guidance

This policy defines the operational rules for component lifecycle events. For impact classification and release communication, use the release/versioning model:

- [`framework-release-versioning-and-deprecation.md`](framework-release-versioning-and-deprecation.md)
- [`framework-release-notes-and-upgrade-summaries.md`](framework-release-notes-and-upgrade-summaries.md)
- [`framework-release-notes.md`](framework-release-notes.md)

When a change deprecates or removes something, the release summary should carry the compatibility signal, migration burden, replacement path, and removal timeline. This keeps governance state and adopter-facing upgrade communication aligned.

## Mobile quick action

- **Use when:** you need to quickly validate whether a framework change/deprecation has enough governance coverage.
- **Do from mobile:**
  - verify lifecycle state (`Active`, `Deprecated`, `Removal scheduled`, `Removed`) is explicit
  - check replacement path and removal target are recorded
  - request missing writeback in the active issue/PR thread
- **Do not do from mobile:**
  - approve policy-significant removals with no durable notice/replacement path
  - perform broad cross-document governance rewrites
- **Escalate to desktop/cloud when:**
  - changes require coordinated updates across entrypoints, health/continuity docs, and ADRs
  - deprecation/removal affects multiple templates/scripts/workflows at once
- **Primary artifact to update:**
  - the active framework-change issue or pull request carrying the governance event.

## Related docs

- [Governance checklist](governance-checklist.md)
- [Framework reporting and review cadence](framework-reporting-and-review-cadence.md)
- [Framework continuity and memory](framework-continuity-and-memory.md)
- [Framework health](framework-health.md)
- [Framework release/versioning/deprecation model](framework-release-versioning-and-deprecation.md)
- [Framework release notes and upgrade summaries](framework-release-notes-and-upgrade-summaries.md)
- [Start a framework change](runbooks/start-a-framework-change.md)
