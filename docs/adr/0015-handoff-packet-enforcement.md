# ADR 0015: Handoff packet enforcement

- Status: Accepted
- Date: 2026-05-25

## Context

The repository documents a minimum handoff packet in
`docs/multi-agent-handoff-playbook.md`. The required fields are:

- Objective
- Context
- Constraints
- Acceptance criteria
- Validation expectations
- Related artifacts
- Next owner
- Status / current state
- Unresolved risks / questions

These fields are referenced across governance materials and are cited as a
framework principle in `docs/framework-continuity-and-memory.md`. However, until
this ADR no automation verified that canonical handoff artifacts actually contain
all nine fields. Completeness was purely advisory.

The existing enforcement precedent for similar conventions:

- ADR 0012 / `scripts/check-svg-companions.sh` — enforces diagram companion parity
- ADR 0013 / `scripts/check-mobile-quick-action.sh` — enforces mobile quick-action
  section coverage

## Decision

Introduce a lightweight, durable enforcement mechanism for handoff packet
completeness, following the same pattern as ADR 0012 and ADR 0013.

Specifically:

1. **Canonical template** — `docs/handoff-packet-template.md` is the single
   authoritative handoff packet format. It contains all nine required sections as
   level-2 Markdown headings.

2. **Issue template** — `.github/ISSUE_TEMPLATE/handoff-packet.yml` provides a
   GitHub-native form so agents and humans can create compliant handoff artifacts
   directly in GitHub Issues.

3. **Coverage inventory** — a `## Handoff packet coverage` table in
   `docs/multi-agent-handoff-playbook.md` lists which artifacts are "Expected" to
   contain all nine required fields, "Skip" (out of scope), or "Pending"
   (temporarily incomplete, blocks merge).

4. **Enforcement script** — `scripts/check-handoff-packet.sh` reads the inventory
   and verifies that every "Expected" file contains all nine required field
   headings. "Pending" rows block merge; "Skip" rows are ignored.

5. **CI workflow** — `.github/workflows/check-handoff-packet.yml` runs the script
   on pull requests and on push to `main`.

Required field labels verified by the script:

- `Objective`
- `Context`
- `Constraints`
- `Acceptance criteria`
- `Validation expectations`
- `Related artifacts`
- `Next owner`
- `Status`
- `Unresolved risks`

## Alternatives considered

- **Advisory only:** rejected because the governance checklist already lists handoff
  completeness as an expectation; leaving it purely advisory perpetuates the gap.

- **PR template expansion only:** rejected because PR templates are suggestions, not
  enforced — the existing PR template shows that authors skip optional sections.

- **Broad issue/PR body scanning:** rejected because parsing arbitrary GitHub issue
  bodies from CI requires API token scopes outside the read-only content model;
  enforcing the template file itself is simpler and sufficient.

## Consequences

Positive:

- Handoff packet completeness is no longer purely advisory.
- Future contributors can discover and follow the convention through the canonical
  template without relying on chat memory.
- Adds a CI gate that prevents canonical artifacts from silently degrading over time.

Negative:

- Authors of new handoff-facing canonical files must add all nine sections.

Follow-ups:

- Update `docs/github-mobile-guide.md` coverage inventory to include
  `docs/handoff-packet-template.md` (Expected).
- Update governance checklist and framework health to reflect the new enforcement.

## References

- [`docs/multi-agent-handoff-playbook.md`](../multi-agent-handoff-playbook.md)
- [`docs/handoff-packet-template.md`](../handoff-packet-template.md)
- [`scripts/check-handoff-packet.sh`](../../scripts/check-handoff-packet.sh)
- [ADR 0012: SVG companions for diagrams](./0012-svg-companions-for-diagrams.md)
- [ADR 0013: Mobile quick action section convention](./0013-mobile-quick-action-convention.md)
