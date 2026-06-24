# ADR 0020: Portable core, additive enterprise — runtime-agnostic brains

- Status: Accepted
- Date: 2026-06-19

## Context

Brain Factory must serve individual maintainers and small teams as well as larger
organizations. A primary operating constraint is cost and continuity: a sole
proprietor may run on GitHub Pro with organization-provided GitHub Copilot that
is tied to employment and can disappear.

At the same time the agent ecosystem has split into two layers:

- **Open, portable, free formats** that most tools now honor — `AGENTS.md`, the
  Agent Skills `SKILL.md` specification, and the Model Context Protocol (MCP).
- **Paid orchestration** — GitHub Agent HQ / Mission Control multi-agent control,
  managed memory services — that sits behind Copilot Pro+ / Enterprise tiers.

If a brain depends on one paid agent, it stops working when that subscription or
employment ends, and adoption is gated by cost. We need an explicit principle so
brains stay affordable and portable while still allowing richer paid integrations.

## Decision

Adopt **portable core, additive enterprise** as a design principle for brains.

1. A brain's value lives in plain files, open standards, and deterministic code.
   The AI agent runtime is a swappable execution engine, not a dependency.
2. The deterministic adapter layer is the floor: every brain must operate with
   `agent_runtimes: ["none"]` for its mechanical tasks (inspect, capabilities,
   docs-mesh, intent-gate) with no LLM.
3. Core commands are authored once and emitted to multiple open targets (a Claude
   Code skill, a GitHub Copilot agent/skill, and an MCP surface) so no single
   vendor is required.
4. Every brain ships a standards-compliant `AGENTS.md` at its root.
5. Paid/enterprise integrations (Agent HQ / Mission Control, managed memory) are
   additive, off by default, and never required for core operation.
6. The manifest gains an `agent_runtimes` array declaring supported runtimes;
   `none` is always valid and is the default.

This ADR introduces the principle and item 6 (the `agent_runtimes` field) plus
`AGENTS.md` generation. Items 3 (multi-target emission) and the MCP surface are
tracked as follow-ups.

## Consequences

Positive:

- No vendor lock-in; brains keep working if a runtime or subscription is lost.
- Adoption is free on the GitHub Pro plan an individual already has.
- Aligns with the open standards (`AGENTS.md`, `SKILL.md`, MCP) the ecosystem
  has converged on.

Trade-offs:

- Command artifacts are emitted in several formats, creating some duplication.
- The multi-target generator and the MCP surface are additional code to build and
  maintain (tracked below).

## Follow-ups

- Implement the multi-target command generator from the single core command
  source: Claude skill, GitHub Copilot `.github/agents/*.agent.md` and
  `.github/skills/<name>/SKILL.md`, and `AGENTS.md`.
- Expose the registry and onboarding engine as an MCP server so any MCP-capable
  agent can use them without bash wrappers.
- Optional, additive adapters: GitHub Spec Kit for bounded specs; a pluggable,
  self-hosted memory layer with GitHub remaining the system of record.

## References

- [`docs/framework-brain-factory-architecture.md`](../framework-brain-factory-architecture.md)
- [`brain-factory/brain-template/brain.manifest.schema.json`](../../brain-factory/brain-template/brain.manifest.schema.json)
- [ADR 0002: Multi-surface hybrid execution model](./0002-multi-surface-hybrid-execution-model.md)
- [ADR 0019: Project brain factory and bidirectional improvement loop](./0019-project-brain-factory-and-improvement-loop.md)
- [AGENTS.md standard](https://agents.md)
