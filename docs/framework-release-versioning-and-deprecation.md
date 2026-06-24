# Framework Release, Versioning, and Deprecation Model

This guide is for maintainers releasing changes to Brain Factory's shared framework (its core layer). It lets you evolve the framework like a reusable product without heavy release bureaucracy. Throughout, an *adopter* is a project whose brain inherits the core layer; new to these terms? See [Brain Factory: how it works](how-brain-factory-works.md).

## Purpose

The framework already includes broad operational guidance (continuity, governance, queueing, portability, maturity, reporting, and checks), but its release lifecycle was left implicit.

This model makes that lifecycle explicit, covering how to:

- classify a framework change by its impact
- communicate meaningful changes to adopters
- represent framework version milestones
- deprecate and retire artifacts without silent breakage
- signal compatibility risk, migration burden, and required operator action

## Design principles

1. Keep GitHub artifacts as the durable system of record.
2. Keep lifecycle rules lightweight and practical for a docs/governance-first framework.
3. Make adopter impact explicit before merge.
4. Avoid silent expectation shifts in templates, checks, workflows, or core guidance.

## Versioning model (lightweight SemVer for framework guidance)

Version the framework with [Semantic Versioning](https://semver.org/) in `vMAJOR.MINOR.PATCH` form: bump `MAJOR` for breaking changes, `MINOR` for backward-compatible additions, and `PATCH` for fixes that change nothing operational. The rules below adapt those levels to a docs- and governance-first framework.

### Change classification rules

| Level | Use when | Typical examples | Adopter impact |
| --- | --- | --- | --- |
| `PATCH` | Clarifies existing behavior without changing expected operating contract | wording fixes, typo fixes, stronger examples, non-semantic cross-link cleanup | Usually no adopter action |
| `MINOR` | Adds or improves capabilities in a backward-compatible way | new optional guidance/runbook/template, additive check guidance, new review packet templates | Selective adoption encouraged |
| `MAJOR` | Changes required operating expectations or retires previously valid paths | required field changes, required validation/gating changes, removed canonical artifact, changed invariant/policy semantics | Planned upgrade action required |

### Guardrails for classification

- If maintainers or adopters must change how they operate to stay compliant, treat as `MAJOR`.
- If behavior is additive and existing adoption remains valid, treat as `MINOR`.
- If uncertainty exists between `MINOR` and `MAJOR`, choose `MAJOR` or document rationale explicitly in the PR.

### Compatibility signaling expectations

Every meaningful change (`MINOR`/`MAJOR`, and any non-trivial `PATCH`) should
carry an explicit compatibility signal in the release summary:

- **Backward compatible** — existing adopters can continue without immediate changes.
- **Backward compatible with migration** — old behavior remains valid short-term, but
  migration is needed before a stated future boundary.
- **Not backward compatible** — required operating expectations changed now.

Pair this with:

- a migration-burden estimate (`Low` / `Medium` / `High`)
- explicit operator action level (`Informational` / `Recommended` / `Required`)

## Release communication model

### Durable release artifacts

For meaningful framework updates (`MINOR`/`MAJOR`), publish one durable release artifact:

- a GitHub Release entry, or
- a release-summary issue/discussion linked from the merge PR(s).

`PATCH` changes may be batched into the next `MINOR` release note unless they fix urgent ambiguity.

Use [`framework-release-notes.md`](framework-release-notes.md) as the durable quick-scan
index and
[`framework-change-summary-template.md`](framework-change-summary-template.md) for
consistent summary packets.

For detailed release-summary rules (including action levels and profile/maturity
applicability), use
[`framework-release-notes-and-upgrade-summaries.md`](framework-release-notes-and-upgrade-summaries.md).

### Required release note sections

Each `MINOR`/`MAJOR` release note should include:

1. **What changed** (new/changed/retired framework artifacts)
2. **Change level** (`MINOR` or `MAJOR`) with rationale
3. **Adopter impact** (`no action`, `recommended action`, or `required action`)
4. **Compatibility signal** (`backward compatible`, `backward compatible with migration`, or `not backward compatible`)
5. **Migration burden** (`low`, `medium`, `high`) with rationale
6. **Deprecations and timelines** (if any)
7. **Upgrade steps** (bounded checklist)
8. **Applicability scope** (`universal`, `profile-specific`, `maturity-gated`, `optional`)
9. **Related artifacts** (issue, PR, ADR, runbook, health/governance updates)

## Deprecation lifecycle

Use this state model for docs/templates/scripts/workflows/process conventions:

1. **Active** — current recommended path.
2. **Deprecated** — still usable, but replacement exists and retirement is planned.
3. **Removed** — no longer supported as a current path; retained history remains traceable in Git.

### Deprecation rules

When marking an artifact or practice as deprecated:

- Open or link a durable issue/PR that explains **why**.
- Name the **replacement path** (or explicit rationale if none).
- Add a deprecation notice at the top of the deprecated artifact when practical.
- Record expected removal target as a version milestone or explicit follow-up issue.
- Update discoverability links so new contributors land on the replacement first.
- Include the deprecation/removal linkage in release communication so policy state
  and adopter upgrade expectations stay traceable together.

### Minimum notice expectation

- Do not remove deprecated canonical artifacts in the same PR that first deprecates them, except for urgent security/safety reasons.
- Keep at least one review cycle (and preferably one `MINOR` release boundary) between deprecation and removal.

## Maintainer workflow

For framework-change PRs with lifecycle impact:

1. Classify change level (`PATCH`/`MINOR`/`MAJOR`) in issue + PR packet.
2. Add compatibility signal, migration burden estimate, and operator action level.
3. Confirm deprecation handling if any artifact/practice is being retired.
4. Update cross-links (`README.md`, `docs/README.md`, `AGENTS.md`) when new canonical lifecycle guidance appears.
5. Update governance/health/continuity references when lifecycle expectations change.
6. Capture validation evidence in the PR and include release communication links.

If the change redefines framework policy semantics, open or update an ADR.

## Adopter workflow

When consuming framework updates:

1. Identify your currently adopted framework version snapshot.
2. Read all `MINOR`/`MAJOR` release notes since that snapshot.
3. Open one bounded upgrade issue with:
   - impacted artifacts in your repo
   - required vs optional changes
   - validation expectations
4. Apply updates in bounded PRs and preserve invariant checks.
5. Record deferred lifecycle work as explicit follow-up issues.

## Anti-patterns to avoid

- Silent required-field or required-check changes with no release communication.
- Immediate removal of artifacts with no replacement path or transition window.
- Treating all framework updates as equal-impact.
- Storing lifecycle decisions only in chat without issue/PR/ADR writeback.

## Mobile quick action

- **Use when:** you need to quickly classify framework change impact or confirm deprecation status from mobile.
- **Do from mobile:**
  - confirm whether the active change is `PATCH`, `MINOR`, or `MAJOR`
  - verify deprecations include replacement path and target removal note
  - capture missing lifecycle details in the active issue/PR
- **Do not do from mobile:**
  - redesign release/versioning policy without coordinated review
  - remove deprecated canonical artifacts without desktop validation
- **Escalate to desktop/cloud when:**
  - release note updates span multiple docs/templates/workflows
  - lifecycle changes require governance/health/continuity cross-document updates
- **Primary artifact to update:**
  - the framework-change issue or pull request carrying the lifecycle decision.

## Related docs

- [Framework upgrade and adoption maintenance](framework-upgrade-and-maintenance.md)
- [Framework change governance and deprecation policy](framework-change-governance-and-deprecation-policy.md)
- [Framework release notes and upgrade summaries](framework-release-notes-and-upgrade-summaries.md)
- [Framework release notes index](framework-release-notes.md)
- [Framework change summary template](framework-change-summary-template.md)
- [Maintain framework alignment](runbooks/maintain-framework-alignment.md)
- [Framework continuity and memory](framework-continuity-and-memory.md)
- [Framework setup intent schema and application model](framework-setup-intent-schema-and-application-model.md)
- [Governance checklist](governance-checklist.md)
- [Framework health](framework-health.md)
- [Framework portability and adoption](framework-portability-and-adoption.md)
- [Framework adoption maturity model](framework-adoption-maturity-model.md)
- [Framework starter kit / bootstrap pack](framework-starter-kit.md)
- [Framework roadmap: next GitHub agent prompts](framework-roadmap-next-prompts.md)
- [Start a framework change](runbooks/start-a-framework-change.md)
