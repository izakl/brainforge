# Framework Profile Packs

Profile packs let you fit one shared framework to different repository and team
contexts without weakening its core principles. Each pack is a preset operating
profile — solo, product, platform, support-heavy, governance-heavy — that scales
the optional layers up or down while keeping the same invariants. This doc is for
maintainers choosing or evolving a profile.

New to the project? See [How Brain Factory works](how-brain-factory-works.md) and
the [adoption maturity model](framework-adoption-maturity-model.md), which pairs
with profile selection.

## Why this exists

Brain Factory's framework already defines strong invariants, maturity
progression, work-type tailoring, and a recurring review cadence.

What many adopters still need is practical guidance for questions like:

- "Which setup is enough for our team size and workload right now?"
- "What should stay mandatory vs be scaled down?"
- "How do we evolve safely as complexity increases?"

Profile packs answer those questions with a small set of operating profiles that
share the same framework contract.

## What is invariant vs adaptable

## Invariants (never relaxed)

Every profile keeps these unchanged:

1. GitHub artifacts remain the durable execution system of record.
2. External context is normalized before implementation.
3. PRs stay bounded to one objective.
4. Handoffs preserve the required packet fields.
5. Validation evidence is recorded in durable artifacts.
6. Security-sensitive intake follows private/sanitized routing rules.

If a setup breaks these, it is not a compatible profile.

## Adaptable layers (scaled by profile)

Profiles can tune:

- review cadence depth and ownership model
- GitHub Projects field/view richness beyond MVP
- runbook inventory breadth
- automation sophistication and escalation paths
- degree of governance/audit formality
- support-intake routing depth and reporting detail

## Essential baseline for every profile

Regardless of profile, keep this minimum setup:

- `AGENTS.md`
- `docs/framework-continuity-and-memory.md`
- `docs/operating-model.md`
- issue and PR templates with full work-packet fields
- markdown lint/link validation and relevant framework checks
- `SECURITY.md` + `docs/security-and-secure-delivery.md`

Then scale up with profile-specific additions.

For a copy-ready bootstrap subset and transplant checklist before selecting
profile depth, use [`framework-starter-kit.md`](framework-starter-kit.md).
For profile-aware automation/check/workflow bundle recommendations, use
[`framework-automation-bundles-by-profile.md`](framework-automation-bundles-by-profile.md).
For setup-oriented profile defaults and machine-readable setup-intent examples,
use [`framework-setup-profiles-and-intent-examples.md`](framework-setup-profiles-and-intent-examples.md).

## Profile chooser

Pick the profile that best matches your current operating reality, not your
long-term ideal.

| Profile | Best fit | Main adaptation goal |
| --- | --- | --- |
| Small repository / solo maintainer | One maintainer or very small team, low parallel work | Keep overhead low while preserving invariants |
| Product delivery team | Multi-contributor feature/bug delivery with steady PR flow | Keep issue→project→PR execution predictable |
| Platform / infrastructure team | Automation, CI, tooling, shared services, higher blast radius | Increase control depth for automation and risk |
| Support-heavy / intake-heavy team | High inbound support volume and frequent triage/routing | Improve intake quality and support-to-improvement conversion |
| Governance/compliance-heavy environment | Audit/compliance sensitivity and strict evidence expectations | Strengthen repeatable controls and audit trails |

## Profile packs

## 1) Small repository / solo maintainer

### Use when (small repository / solo maintainer)

- one primary owner handles most work
- limited concurrent PRs
- low need for complex project views

### Minimum viable setup (small repository / solo maintainer)

- keep all invariants and essential baseline docs/checks
- use one lightweight issue/project flow with canonical statuses
- run per-change validation plus weekly hygiene and monthly health/effectiveness
- keep runbooks limited to high-frequency tasks only

### Scale-up triggers (small repository / solo maintainer)

- rising PR concurrency
- repeated blocked/deferred work
- recurring support themes without clear routing

## 2) Product delivery team

### Use when (product delivery team)

- multiple engineers/designers/product contributors share delivery flow
- active feature, defect, and docs changes run in parallel

### Minimum viable setup (product delivery team)

- enforce complete work packets and explicit non-goals in PRs
- use GitHub Projects MVP fields plus routing views for intake/execution/follow-up
- run weekly hygiene, monthly health/effectiveness, quarterly adoption reviews
- use work-type matrix rigor consistently in triage and review

### Scale-up triggers (product delivery team)

- recurring routing drift between issue/project/PR state
- handoff losses across owners/surfaces
- repeated rework due to weak acceptance/validation definition

## 3) Platform / infrastructure team

### Use when (platform / infrastructure team)

- workflow/CI/automation/reliability changes are frequent
- failure blast radius is broad across repos or teams

### Minimum viable setup (platform / infrastructure team)

- treat automation and security-sensitive work as stricter paths by default
- use explicit risk/blocker/next-owner fields in project routing
- require stronger event-driven review behavior for incidents/check regressions
- capture durable policy decisions in ADRs when controls or guardrails change

### Scale-up triggers (platform / infrastructure team)

- repeated CI regressions or permission-risk findings
- coordination friction across platform consumers
- manual operational steps becoming reliability bottlenecks

## 4) Support-heavy / intake-heavy team

### Use when (support-heavy / intake-heavy team)

- large support queue or frequent operational intake
- triage and communication load is high

### Minimum viable setup (support-heavy / intake-heavy team)

- prioritize support-intake template quality and rapid classification
- maintain dedicated support-focused project views and aging/blocked monitoring
- enforce closure notes and follow-up issue creation for deferred scope
- include support conversion quality in monthly effectiveness reviews

### Scale-up triggers (support-heavy / intake-heavy team)

- intake backlog growth or stale triage
- repeated unresolved themes without product/docs improvements
- weak linkage from support issues to implementation artifacts

## 5) Governance/compliance-heavy environment

### Use when (governance/compliance-heavy environment)

- strict auditability and policy evidence requirements apply
- security/privacy/process controls need explicit traceability

### Minimum viable setup (governance/compliance-heavy environment)

- keep full continuity, governance, health, and security references active
- run recurring checks and monthly/quarterly reviews as explicit control points
- require durable evidence links for decisions, exceptions, and closure
- use ADRs for process/policy decisions that affect controls

### Scale-up triggers (governance/compliance-heavy environment)

- audit findings about missing evidence or control drift
- policy exceptions becoming frequent or unclear
- repeated gaps between documented process and execution artifacts

## Comparing profile behavior

| Capability area | Invariant baseline | Typical lighter setting | Typical heavier setting |
| --- | --- | --- | --- |
| Review cadence | Per-change validation and durable writeback | Weekly + monthly | Weekly + monthly + quarterly + event-driven with stricter ownership |
| GitHub Projects usage | Canonical statuses + durable-state rule | MVP fields/views | Extended risk/compliance/support fields and focused governance views |
| Work-type routing | Work-type matrix and strict-path precedence | Core support/defect/enhancement/docs routing | Full matrix usage including automation/security/redevelopment rigor |
| Security handling | `SECURITY.md` routing and sanitized public context | Security path used when needed | Security path integrated into routine governance and event reviews |
| Governance artifacts | Repeatable checks and durable evidence | Lightweight periodic review packets | Formalized recurring packets with broader evidence linkage |

## How to choose and evolve profiles

1. Start with the smallest profile that matches your current work reality.
2. Use the adoption maturity model to assess weak dimensions.
3. Add only bounded upgrades tied to observed gaps.
4. Reassess quarterly; move profile only when triggers persist.
5. Keep invariants unchanged during every transition.

## Evolution map

- **Solo/small repo → Product delivery team:** when concurrent execution and
  handoff complexity increases.
- **Product delivery team → Platform/infrastructure:** when automation-risk and
  cross-team blast radius become dominant.
- **Product delivery team → Support-heavy:** when intake volume/queue pressure
  exceeds current triage and follow-up capacity.
- **Any profile → Governance/compliance-heavy overlay:** when audit or policy
  requirements demand stronger recurring evidence controls.

Profiles can combine where needed (for example Product + Governance), but keep
one primary profile as the default operating mode.

## Follow-on packaging opportunities

To reduce adoption effort further, future work can add:

- profile-specific issue/PR template starter bundles
- profile-specific project field/view starter kits
- profile-specific automation bootstrap scripts
- profile-specific review packet examples

Keep these as implementation aids for one shared framework, not separate
framework variants.

## Mobile quick action

- **Use when:** you need to choose or confirm the active profile quickly from
  mobile.
- **Do from mobile:**
  - select the nearest-fit profile and note why in the issue/PR.
  - flag profile-evolution triggers (routing drift, intake overload, audit gaps).
  - open one bounded follow-up issue for any profile mismatch.
- **Do not do from mobile:**
  - redesign profile definitions or invariants in chat-only context.
  - introduce broad profile migrations without cross-artifact planning.
- **Escalate to desktop/cloud when:**
  - profile changes require coordinated template/workflow/docs updates.
  - multiple profiles need blending with explicit governance decisions.
- **Primary artifact to update:**
  - the adoption/operations issue or PR that tracks profile selection and updates.

## Related docs

- [Framework portability and adoption](framework-portability-and-adoption.md)
- [Framework starter kit / bootstrap pack](framework-starter-kit.md)
- [Framework adoption maturity model](framework-adoption-maturity-model.md)
- [Framework readiness checklist](framework-readiness-checklist.md)
- [Framework automation bundles by profile](framework-automation-bundles-by-profile.md)
- [Framework setup profiles and intent examples](framework-setup-profiles-and-intent-examples.md)
- [Framework setup intent schema and application model](framework-setup-intent-schema-and-application-model.md)
- [Work-type matrix](work-type-matrix.md)
- [Framework reporting and review cadence](framework-reporting-and-review-cadence.md)
- [GitHub Projects setup](github-projects-setup.md)
- [Product support and improvement loop](product-support-and-improvement-loop.md)
- [Context synchronization](context-synchronization.md)
- [Security and secure delivery guardrails](security-and-secure-delivery.md)
