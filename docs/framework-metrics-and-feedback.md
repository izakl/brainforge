# Framework Metrics and Feedback Loop

This guide is for maintainers who want to know whether Brain Factory's shared framework is actually improving outcomes over time. It defines a lightweight set of signals to watch and how to act on them — the goal is practical learning, not reporting overhead. New to the project? Start with [Brain Factory: how it works](how-brain-factory-works.md).

## Purpose

The framework already defines operating rules, governance checks, and recurring audits.
This metrics layer adds a lightweight way to answer:

- Is work quality improving?
- Are handoffs and coordination improving?
- Is throughput improving without lowering quality?
- Are hygiene and security expectations being maintained?
- Is the framework reusable in repositories that adopt it?

## Gaps this layer closes

The framework had strong process guidance but no consolidated model for:

- separating **leading indicators** (early warning) from **lagging indicators** (outcomes)
- turning recurring audit, support, and project signals into a periodic effectiveness review
- distinguishing useful signals from vanity metrics
- capturing review findings as durable follow-up artifacts in a consistent format
- evaluating portability and adoption success against the same operating contract

## Design principles (keep it lightweight)

1. Prefer signals observable from existing GitHub artifacts and workflows.
2. Use trend direction and exceptions more than absolute targets.
3. Measure only signals that can trigger a concrete improvement action.
4. Keep one bounded review packet per review period.
5. Treat this as a learning loop, not a performance leaderboard.

## Signal model

### Leading indicators (predictive)

Use these to detect drift early:

- issue packet completeness at triage (`objective`, `context`, `constraints`, `acceptance`, `validation`)
- normalization quality (external context promoted before implementation starts)
- handoff packet completeness and constraint carry-forward quality
- PR boundedness and reviewability (single objective, explicit non-goals, validation evidence)
- project state hygiene (`Status` transitions aligned to issue/PR truth)
- unresolved security-sensitive intake beyond expected response window

### Lagging indicators (outcomes)

Use these to evaluate whether the framework is working:

- reduced rework caused by unclear issue packets or dropped constraints
- reduced aging/staleness of active branches and blocked project items
- stable or improving check-pass trend on framework checks
- support themes converted into durable docs/process/product improvements
- recurring audit findings decreasing over successive review periods
- successful portability/adoption passes that preserve invariants

### Guardrail indicators (must not regress)

- security routing remains compliant with `SECURITY.md`
- no increase in unresolved sensitive-intake obligations
- CI guardrails remain green on `main`
- branch cleanup and follow-up capture remain consistent

## Framework goal-to-signal matrix

| Framework goal | What to observe (GitHub-visible) | Indicator type | Suggested cadence | Typical action if off-track |
| --- | --- | --- | --- | --- |
| Correct work-type path selection | Intake artifact/work-type classification matches matrix expectations; mixed-type precedence handled explicitly | Leading | Weekly | update triage guidance; reinforce [work-type matrix](work-type-matrix.md) usage in issue/project routing |
| Higher issue quality and context normalization | Issue template field completeness, linked external context summary before PR start | Leading | Weekly | tighten issue triage checklist; update issue template wording |
| Stronger handoff quality | Handoff packet check status, review comments about missing constraints/validation | Leading | Weekly | update handoff guidance/template; open targeted governance issue |
| Bounded and reviewable PRs | PR template continuity checks completed, PR size/scope drift notes, aging PR count | Leading + Lagging | Weekly | split oversized work; tighten PR template reviewer prompts |
| Better stale-branch hygiene | Weekly stale-branch report findings and cleanup closure trend | Lagging | Weekly | run cleanup follow-up and update branching/runbook guidance |
| Reliable check quality | Framework checks pass/fail trends from Actions runs | Lagging | Weekly/Monthly | create issue per repeated failure mode; improve scripts/docs |
| Security responsiveness | Time from sensitive intake to routed artifact/remediation action | Guardrail + Lagging | Weekly/Monthly | adjust ownership/escalation in security runbook |
| Project routing fidelity | Project `Status` and `Work Type` match linked issue/PR/handoff evidence | Leading | Weekly | fix stale transitions; reinforce durable-state rule |
| Audit cadence and closure quality | Monthly audit completion, open findings age, closure evidence quality | Lagging | Monthly | schedule bounded fixes; track unresolved findings explicitly |
| Portability/adoption success | Adopted repos preserve invariants and baseline checks in phased rollout | Lagging | Monthly/Quarterly | create adoption gap issue and phase-specific remediation plan |
| Guidance adherence | Repeated governance findings tied to skipped guidance sections | Leading + Lagging | Monthly | clarify docs, improve discoverability, or reduce ambiguous guidance |

## Avoid vanity metrics

Do not optimize for:

- raw issue or PR volume
- number of comments without resolution quality
- check run counts without failure-mode analysis
- dashboard complexity disconnected from actions

A metric is useful only if it changes a decision, a backlog item, a template, a runbook, or a governance control.

## Review cadence and ownership

Use a lightweight cadence:

- **Weekly (operator pulse):** triage leading indicators and immediate drift.
- **Monthly (framework effectiveness review):** complete one scorecard packet and open bounded follow-up issues.
- **Quarterly (adaptation/portability review):** verify invariants and adoption maturity for consumer repositories.
- **Quarterly (maturity progression review):** use the adoption maturity model to identify lowest-level dimensions and choose 2-3 bounded improvement actions.

Each review period should name:

- review owner
- covered timeframe
- evidence links (issues, PRs, workflow runs, project views)
- top 3 findings
- approved follow-up actions

## Feedback writeback pattern (required)

Each effectiveness review should produce durable artifacts:

1. scorecard packet (use the template below)
2. one issue per actionable finding
3. linked PRs for implemented improvements
4. updates to framework docs/runbooks/templates when guidance changes
5. optional ADR when the improvement changes architecture/process policy

Use:

- [`docs/framework-weekly-hygiene-summary-template.md`](framework-weekly-hygiene-summary-template.md)
- [`docs/framework-effectiveness-scorecard-template.md`](framework-effectiveness-scorecard-template.md)
- [`docs/framework-quarterly-adoption-portability-summary-template.md`](framework-quarterly-adoption-portability-summary-template.md)
- [`docs/framework-reporting-and-review-cadence.md`](framework-reporting-and-review-cadence.md)
- [`docs/product-support-and-improvement-loop.md`](product-support-and-improvement-loop.md)
- [`docs/framework-health.md`](framework-health.md)
- [`docs/governance-checklist.md`](governance-checklist.md)

## How to start with low overhead

1. Start with 6-10 signals from the matrix above.
2. Reuse existing GitHub artifacts; do not build a new data collection system
   first. (`scripts/framework-metrics.sh` prints a read-only structural baseline
   — framework version and artifact counts — from committed artifacts; it is a
   starting point, not a data system.)
3. Review trends and exceptions, not raw totals.
4. Open bounded improvement issues only for high-signal findings.
5. Revisit the metric set quarterly and remove low-value signals.

## Mobile quick action

- **Use when:** you need to capture a quick effectiveness finding from mobile.
- **Do from mobile:**
  - Add a short finding note and evidence link in the active review issue.
  - Open one follow-up issue per actionable gap.
  - Flag if a signal appears to be vanity or non-actionable.
- **Do not do from mobile:**
  - Redesign the full scorecard model or indicator matrix.
  - Close a monthly review without evidence links.
- **Escalate to desktop/cloud when:**
  - Multiple signals need cross-artifact analysis.
  - Findings require coordinated docs/templates/workflow changes.
- **Primary artifact to update:**
  - The active framework effectiveness review issue/PR.

## Related docs

- [Framework effectiveness scorecard template](framework-effectiveness-scorecard-template.md) — reusable monthly review packet.
- [Framework weekly hygiene summary template](framework-weekly-hygiene-summary-template.md) — concise weekly hygiene writeback packet.
- [Framework quarterly adoption and portability summary template](framework-quarterly-adoption-portability-summary-template.md) — concise quarterly adoption/portability writeback packet.
- [Framework reporting and review cadence](framework-reporting-and-review-cadence.md) — practical weekly/monthly/quarterly/event-driven review rhythm and writeback model.
- [Framework review cadence template](framework-review-cadence-template.md) — reusable cadence packet for weekly, quarterly, or event-driven reviews.
- [Framework adoption maturity model](framework-adoption-maturity-model.md) — practical levels, dimensions, and lightweight progression aid.
- [Operating model](operating-model.md) — execution model and success intent.
- [Framework health](framework-health.md) — recurring framework audit baseline.
- [Product support and improvement loop](product-support-and-improvement-loop.md) — support signal routing.
- [GitHub Projects setup](github-projects-setup.md) — durable status and routing expectations.
- [Work-type matrix](work-type-matrix.md) — practical path selection and work-type-specific rigor guidance.
- [Framework portability and adoption](framework-portability-and-adoption.md) — phased adoption and invariants.
- [Governance checklist](governance-checklist.md) — periodic governance controls.
