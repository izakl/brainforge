# ADR 0014: Deployment and infrastructure scope

- Status: Deferred
- Date: 2026-05-24
- Deferred: 2026-05-24

## Context

Today the framework is documentation-and-governance only: ADRs, runbooks, worked
examples, documentation conventions (diagrams, SVG companions, doc navigation,
mobile quick action), and CI guardrails for docs.

There is no IaC, no Kubernetes manifests, no container builds, no environment
definitions, no deployment workflows, and no release pipelines.

ADR 0001 positions GitHub as the durable control plane for the framework itself,
not as a deployment target.

This ADR opens the question: should the framework expand to cover deployment of
infrastructure, or remain doc/governance-only and reference external deployment
frameworks?

## Options considered

**Option 1 — Stay out of scope.**
Framework remains doc/governance-only. Deployment tooling and IaC live entirely
in consumer repos. No changes required here.

**Option 2 — Add a thin governance layer only.**
Provide ADRs, runbooks, and conventions for deployments (approval gates,
environment promotion, rollback checklists) but ship no IaC implementations.
Consumers bring their own tooling.

**Option 3 — Add a reference IaC implementation.**
Pick one tool (e.g. Terraform, Pulumi, Bicep, or GitHub-native via Actions +
OIDC) and ship a minimal reference implementation alongside existing governance
docs.

**Option 4 — Full deployment framework.**
Multi-environment promotion, approval gates, rollback, secret rotation, and
observability hooks — a complete deployment companion to the existing governance
framework.

## Decision

Deferred. The framework remains doc/governance-only (Option 1) for now.
The open questions listed below must be resolved before expanding scope.
This decision will be revisited when a concrete consumer need drives one
of the expansion options.

When this ADR is reopened, prefer Option 2 (thin governance layer) as the
starting point: it preserves the documentation-first model while adding
value to teams that already have deployment tooling.

## Consequences

- **Option 1:** No scope change; deployment concerns remain outside this repo.
- **Option 2:** Adds governance surface without implementation; low maintenance cost.
- **Option 3:** Unlocks reference patterns; requires tool selection and ongoing IaC upkeep.
- **Option 4:** Maximum capability; highest maintenance burden and blast-radius risk.

## Open questions

- Which IaC tool (if any) should be adopted?
- What blast-radius limits apply to reference implementations?
- What is the secret management posture (OIDC, vault, repo secrets)?
- Which environments does the matrix cover (dev / staging / prod)?
- Who owns rotation runbooks and how are they kept current?

## References

- [ADR 0001: GitHub as durable control plane](./0001-github-as-durable-control-plane.md)
- [`../framework-health.md`](../framework-health.md)
- [`../framework-continuity-and-memory.md`](../framework-continuity-and-memory.md)
- [ADR 0010: Diagrams convention](./0010-diagrams-convention.md)
- [ADR 0011: Documentation navigation](./0011-documentation-navigation.md)
- [ADR 0012: SVG companions for diagrams](./0012-svg-companions-for-diagrams.md)
- [ADR 0013: Mobile quick action section convention](./0013-mobile-quick-action-convention.md)
