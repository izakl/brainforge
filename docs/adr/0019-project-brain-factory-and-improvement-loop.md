# ADR 0019: Project brain factory and bidirectional improvement loop

- Status: Accepted
- Date: 2026-06-17

## Context

The framework had matured into a complete documentation and governance model:
operating model, adoption profiles, starter kit, setup-intent schema with
`apply-setup.sh`, CI guardrails, task queue, and an ADR log. Its own task queue
reported all foundational tasks done.

However, the framework could describe an autonomy operating model it could not
itself execute. A sibling system (the Northwind autonomy system) had independently
proven the executable layer the framework only documented: an agent command set
(`/xs-*`) implemented as both Claude Code skills and Copilot prompts,
SessionStart/SessionEnd continuity hooks, a self-extending capabilities map
generated from code with a CI intent gate, a docs-mesh anti-drift sweep,
multi-agent coordination, and a workspace bootstrap.

The operator's intent is broader than merging the two repositories: the framework
should *do the setup* for new or existing projects, give each project its own
**brain**, and run a **two-way improvement loop** so learnings from every brain
flow up into the framework and approved improvements flow back down into every
brain.

## Decision

Adopt a **brain factory** architecture for the framework, documented in
`docs/framework-brain-factory-architecture.md`, with these commitments:

1. **Hub-and-spoke topology.** This repository is the canonical **hub**. Each
   project gets its own **brain** repository (one brain per project), instantiated
   from a hub-shipped **brain template** using the proven `00–08` numbered
   structure generalized from the donor system.
2. **Core + extension split.** A brain carries a hub-owned **core layer**
   (governance, flow, continuity, quality, and the brain/framework loop commands)
   and a project-owned **extension layer** (project-specific skills). The
   `brain.manifest.json` is the boundary; the down-sync never overwrites
   extensions.
3. **Inspect-first onboarding.** Onboarding an existing project audits what it
   already has and applies only what is missing or upgradeable, never clobbering
   working artifacts.
4. **Bidirectional improvement loop.** Brains emit structured **learnings** to a
   hub **registry**; the hub curates them into framework **releases**; an
   `<prefix>-upgrade` flow diffs a brain's `framework_version` against the hub and
   applies core-layer deltas down into the brain.
5. **Cross-platform, extensible automation.** Each ops capability is defined once
   with per-platform implementations under an `adapters/` seam (bash, PowerShell,
   Python initially), extensible to additional runtimes without changing callers.

This supersedes the doc-only posture of [ADR 0014](./0014-deployment-infrastructure-scope.md)
for the specific scope of executable brain provisioning and continuity tooling
(ADR 0014 remains in force for application deployment/infrastructure, which stays
out of scope).

## Consequences

Positive:

- The framework can provision and continuously improve real projects, not just
  describe how to.
- Proven patterns (capabilities map, docs-mesh, hooks, command set) become
  reusable, cross-platform core that every brain inherits.
- The improvement loop turns each project into a source of framework learning,
  with a governed path for those learnings to reach all projects.

Trade-offs:

- The framework now ships executable assets (scripts, skills, hooks), which
  carry maintenance and testing cost beyond documentation.
- A new manifest/versioning contract must be kept stable enough to support
  down-sync upgrades across framework versions.

## Follow-ups

- Build the `brain-factory/` engine: template, core command catalog, onboarding
  engine (inspect-first), registry + manifest schema, adapters seam.
- Onboard the first project (Acme, renamed from Legacy) as a separate brain
  repo, retiring its Drive-as-source-of-truth model.
- Retrofit the donor (Northwind) into a hub-managed brain once the loop is proven.
- Add CI validation for `brain.manifest.json` and the core-commands catalog.

## References

- [`docs/framework-brain-factory-architecture.md`](../framework-brain-factory-architecture.md)
- [ADR 0014: Deployment and infrastructure scope](./0014-deployment-infrastructure-scope.md)
- [`docs/framework-setup-intent-schema-and-application-model.md`](../framework-setup-intent-schema-and-application-model.md)
- [`docs/framework-starter-kit.md`](../framework-starter-kit.md)
- [`docs/framework-continuity-and-memory.md`](../framework-continuity-and-memory.md)
