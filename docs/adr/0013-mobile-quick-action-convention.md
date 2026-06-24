# ADR 0013: Mobile quick action section convention

- Status: Accepted
- Date: 2026-05-24

## Context

Framework contributors and reviewers frequently operate from GitHub Mobile, where
deep implementation and validation are constrained by screen size and tooling.

To preserve execution clarity, the framework rolled out a standardized `## Mobile quick action`
section across core docs, runbooks, and worked examples in PR #78, then expanded that
coverage in a follow-up coverage-extension PR #80.

This ADR formalizes the convention so future documentation remains consistent and
mobile-reviewable without re-deciding section shape or placement each time.

## Decision

Codify `## Mobile quick action` as the required section name for mobile-operability guidance.

When present, the section uses this exact 5-bullet shape:

- **Use when:** one concise sentence.
- **Do from mobile:** 2–4 concise bullets.
- **Do not do from mobile:** 1–3 concise bullets.
- **Escalate to desktop/cloud when:** 1–3 concise bullets.
- **Primary artifact to update:** one concise bullet.

Placement rule:

- Insert `## Mobile quick action` near the end of the file, before any `## Related docs` footer.
- Do not disturb existing `## Diagram` sections or their placement conventions.

Scope:

- Expected on core docs, runbooks, and worked examples that include operator-facing actions.
- Out of scope for ADRs, pure reference/index files, and repository policy/legal files such as
  `CODE_OF_CONDUCT.md`, `LICENSE`, and `SECURITY.md`.

## Alternatives considered

- **Single central guide only:** rejected because mobile decisions are less actionable when guidance is far from the task-specific document.
- **Free-form mobile notes in each doc:** rejected because structure drift makes reviews inconsistent and harder to audit.

## Consequences

Positive:

- Better mobile operability through a predictable section shape in operator-facing docs.
- Clearer reviewer expectations about what should and should not be done from mobile.
- Added governance surface that can be audited consistently.

Negative:

- Authors must maintain one additional section in applicable docs.

Follow-ups:

- CI enforcement of this convention is a separate follow-up and is not introduced by this ADR.

## References

- PR #78 (initial rollout)
- Coverage-extension PR #80
- [`../github-mobile-guide.md`](../github-mobile-guide.md)
- [ADR 0010: Diagrams convention](./0010-diagrams-convention.md)
- [ADR 0011: Documentation navigation](./0011-documentation-navigation.md)
