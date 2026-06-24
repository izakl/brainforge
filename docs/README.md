# Brain Factory

A hub that gives every project an upgradeable, runtime-agnostic **brain** for
AI-assisted delivery — a portable core layer, a project-owned extension layer,
and a two-way improvement loop.

[Get started](how-brain-factory-works.md){ .md-button .md-button--primary }
[See the architecture](brain-factory-design-overview.md){ .md-button }

## Start here

<div class="grid cards" markdown>

-   :material-rocket-launch:{ .lg .middle } &nbsp;**How it works**

    ---

    A five-minute, plain-language tour of the hub, the brains it provisions, the core/extension split, and the improvement loop.

    [:octicons-arrow-right-24: Read the overview](how-brain-factory-works.md)

-   :material-map-marker-path:{ .lg .middle } &nbsp;**Design overview**

    ---

    The whole target architecture on one page — the moving parts, the diagrams, and what's built vs. planned.

    [:octicons-arrow-right-24: See the design](brain-factory-design-overview.md)

-   :material-console:{ .lg .middle } &nbsp;**Bootstrap a setup**

    ---

    Go from a natural-language description of your needs to a ready-to-work setup, then verify readiness.

    [:octicons-arrow-right-24: Prompt-to-setup runbook](runbooks/prompt-to-setup-bootstrap.md)

</div>

## Explore the framework

<div class="grid cards" markdown>

-   :material-cog-outline:{ .lg .middle } &nbsp;**Operating model**

    ---

    How the framework runs day-to-day: agents and automation, handoffs, issue intake, and routing.

    [:octicons-arrow-right-24: Operating model](operating-model.md)

-   :material-arrow-expand-all:{ .lg .middle } &nbsp;**Adoption & profiles**

    ---

    Reuse the framework across repos and teams — maturity model, profile packs, setup intent, and transplant checklists.

    [:octicons-arrow-right-24: Adoption & portability](framework-portability-and-adoption.md)

-   :material-database-sync-outline:{ .lg .middle } &nbsp;**Continuity & memory**

    ---

    What the framework remembers across sessions: continuity snapshots, artifact indexing, and queued execution.

    [:octicons-arrow-right-24: Continuity & memory](framework-continuity-and-memory.md)

-   :material-shield-check-outline:{ .lg .middle } &nbsp;**Governance & policy**

    ---

    Change governance, release and versioning semantics, security and secure delivery, and the governance checklist.

    [:octicons-arrow-right-24: Governance & policy](framework-change-governance-and-deprecation-policy.md)

-   :material-book-open-page-variant-outline:{ .lg .middle } &nbsp;**Runbooks**

    ---

    Step-by-step operator procedures — apply setup, resume from a handoff, triage a Dependabot PR, run health checks.

    [:octicons-arrow-right-24: All runbooks](runbooks/README.md)

-   :material-file-document-multiple-outline:{ .lg .middle } &nbsp;**Architecture decisions**

    ---

    The ADR log — every significant design decision, its context, and the trade-offs behind it.

    [:octicons-arrow-right-24: ADR index](adr/README.md)

</div>

## New here?

First-time maintainer or operator? The fastest path:

1. **Read the contract.** [`AGENTS.md`](https://github.com/izakl/brainforge/blob/main/AGENTS.md) at the repository root is the minimum operating contract for agents and contributors.
2. **Get oriented.** The [Operator onboarding pack](operator-onboarding-pack.md) covers your first day and first week.
3. **Set up.** Describe your needs and run the [prompt-to-setup bootstrap](runbooks/prompt-to-setup-bootstrap.md), then verify with [Apply setup](runbooks/apply-setup.md).

For everything else, use the tabs above — each section has its own index. Start with the [Operating model](operating-model.md), and treat the [Issue taxonomy](issue-taxonomy.md) as canonical for issue-template selection.
