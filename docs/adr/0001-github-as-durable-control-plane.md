# ADR 0001: GitHub as durable control plane

- Status: Accepted
- Date: 2026-05-24

## Context

The framework supports work across multiple surfaces and tools, including external AI-assisted discovery. Without a durable system of record, execution can drift into private chat memory and non-reviewable context. The continuity anchor and operating model both require repository-native traceability and normalized execution context.

## Decision

GitHub artifacts are the primary system of record for execution in this framework. Issues, pull requests, projects, docs, and ADRs are the durable control plane.

External AI or chat outputs must be normalized into GitHub artifacts before implementation starts. Implementation and review should depend on normalized GitHub context, not private notes or chat transcripts alone.

## Consequences

- Improves continuity across contributors, agents, and time.
- Preserves reviewability, traceability, and governance controls.
- Requires explicit normalization work when context originates outside GitHub.
- Reduces risk of hidden assumptions and chat-only execution dependencies.

## Alternatives considered

- **Chat-first execution:** rejected due to weak durability and reviewability.
- **External tool as primary record:** rejected because framework governance and delivery controls are GitHub-centered.
- **Mixed unofficial records:** rejected because it fragments context and increases handoff risk.

## References

- `docs/framework-continuity-and-memory.md`
- `docs/operating-model.md`
