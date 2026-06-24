# ADR 0002: Multi-surface hybrid execution model

- Status: Accepted
- Date: 2026-05-24

## Context

The framework is designed for coordinated work across VS Code Copilot, GitHub Copilot Chat/Coding Agent, GH CLI, GitHub Mobile, and external AI agents. Real workflows move between discovery, planning, implementation, review, and follow-up on different surfaces. A single-surface or chat-only approach breaks continuity and weakens handoff quality.

## Decision

Adopt and preserve a multi-surface hybrid execution model. Contributors may choose the best surface per task stage, while preserving a durable handoff contract and normalizing execution context into GitHub artifacts.

The framework explicitly supports:

- VS Code Copilot (local)
- GitHub Copilot Chat/Coding Agent (GitHub cloud)
- GH CLI
- GitHub Mobile
- External AI agents (for discovery/synthesis, then normalization)

## Consequences

- Improves delivery flexibility while keeping governance consistency.
- Requires explicit handoff packets (objective, context, constraints, acceptance criteria, validation, next owner).
- Increases importance of normalization and artifact discipline across surfaces.
- Prevents regression to single-surface or transcript-dependent execution.

## Alternatives considered

- **Single-surface model:** rejected because it does not match real operational workflows.
- **GitHub-only without external synthesis:** rejected because discovery often starts outside repository context.
- **External-agent-led implementation without normalization:** rejected due to control-plane and reviewability risks.

## References

- `docs/gh-agents-and-automation.md`
- `docs/multi-agent-handoff-playbook.md`
