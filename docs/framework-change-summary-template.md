<!-- markdownlint-disable-file MD013 -->

# Framework Change Summary Template

This is a reusable template. Copy it and fill in each field to produce a
lightweight release note or upgrade summary when a change ships in the Brain
Factory **core** (the shared, upgradeable layer that every per-project repo, or
**brain**, inherits). A release maintainer typically fills it in; downstream
adopters who run a brain read it to decide what, if anything, to change on their
side. For background on the hub, the core layer, and how upgrades flow down to
each brain, see
[`docs/how-brain-factory-works.md`](how-brain-factory-works.md).

Keep the field labels, placeholders, and checklist items below exactly as written
so downstream readers and any tooling can parse them.

## Summary metadata

- Summary title:
- Date:
- Lifecycle impact (`PATCH` / `MINOR` / `MAJOR`):
- Adopter action level (`Informational` / `Recommended` / `Required`):
- Applicability (`Universal` / `Profile-specific` / `Maturity-gated` / `Optional`):
- Compatibility signal (`Backward compatible` / `Backward compatible with migration` / `Not backward compatible`):
- Migration burden (`Low` / `Medium` / `High`) + rationale:
- Profiles affected (if profile-specific):
- Maturity levels affected (if maturity-gated):

## What changed

- Added:
- Changed:
- Deprecated:
- Removed:

## Why this matters

- Problem or gap addressed:
- Risk if not adopted (if any):

## Adopter impact and actions

### Required now

- [ ] None
- [ ] Action 1:
- [ ] Action 2:
- Owner + target date:

### Recommended next

- [ ] None
- [ ] Action 1:
- [ ] Action 2:

### Optional / context-specific

- [ ] None
- [ ] Action 1:
- [ ] Action 2:

## Upgrade checklist

- [ ] Reviewed affected artifacts in my repository.
- [ ] Classified each as adopt / defer / intentional divergence.
- [ ] Opened bounded upgrade issue(s) for required/recommended changes.
- [ ] Recorded deferred work as explicit follow-up issue(s).
- [ ] Preserved validation expectations in upgrade PR(s).

## Deprecation and timeline notes

- Deprecation state (`Active` / `Deprecated` / `Removed`):
- Replacement path:
- Target version/date for removal (if applicable):

## Related artifacts

- Source issue(s):
- Pull request(s):
- ADR(s):
- Runbook/doc updates:
- Validation evidence:

## Notes for downstream adopters

- Suggested sequencing:
- Safe deferral boundaries:
- Known profile/maturity caveats:
