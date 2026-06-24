# Framework Readiness Checklist

Use this checklist to quickly judge whether your Brain Factory adoption is
coherent, durable, and right-sized for the repository's current profile and
maturity. It is a lightweight decision aid for maintainers — not a formal
compliance program, and not a "must adopt everything" scorecard.

New to the project? See [How Brain Factory works](how-brain-factory-works.md)
first. Here, "the framework" is the reusable operating model and guardrails you
have adopted.

## Readiness gap this closes

Brain Factory already offers detailed guidance across bootstrapping,
portability, maturity, profiles, automation bundles, release semantics,
governance, and queue continuity. This checklist is the one compact, operator-
facing surface that ties those signals into a single practical question: are we
ready for our current context?

## How to use this checklist (lightweight)

1. Select your active profile using
   [`framework-profile-packs.md`](framework-profile-packs.md).
2. Estimate your current maturity level using
   [`framework-adoption-maturity-model.md`](framework-adoption-maturity-model.md).
3. Walk **Baseline readiness** first.
4. Use **Recommended readiness** for your next maturity step.
5. Use **Advanced readiness** only where your profile/workload justifies it.
6. Record intentional deferrals and profile-specific exceptions in durable
   artifacts (issue/PR/discussion), with review dates.

Do not block delivery waiting for every item to be complete.

## Baseline readiness (coherent minimum)

Treat baseline readiness as met when all items below are true for current work.

| Dimension | Minimum signal | Primary evidence | Canonical references |
| --- | --- | --- | --- |
| Durable artifacts | Work starts from issue/ADR/discussion, not chat-only context. | Active issues/PRs with complete packets | [`operating-model.md`](operating-model.md), [`issue-taxonomy.md`](issue-taxonomy.md), [`runbooks/open-an-issue.md`](runbooks/open-an-issue.md) |
| Bounded issue → PR execution | PRs stay scoped to one objective with explicit constraints, acceptance, and validation evidence. | PR template usage + linked issue/PR history | [`../AGENTS.md`](../AGENTS.md), [`framework-continuity-and-memory.md`](framework-continuity-and-memory.md) |
| Normalized external context | External AI/local notes are promoted into GitHub artifacts before implementation. | Linked issue/discussion/ADR references | [`context-synchronization.md`](context-synchronization.md), [`framework-continuity-and-memory.md`](framework-continuity-and-memory.md) |
| Validation baseline | Required markdown/docs checks are enabled and passing. | CI runs + local validation evidence | [`../AGENTS.md`](../AGENTS.md), [`framework-automation-bundles-by-profile.md`](framework-automation-bundles-by-profile.md) |
| Security routing | Security-sensitive intake follows private/sanitized routing paths. | `SECURITY.md` + guardrail-check evidence | [`../SECURITY.md`](../SECURITY.md), [`security-and-secure-delivery.md`](security-and-secure-delivery.md) |
| Deferral discipline | Deferred scope is explicit and issue-tracked. | Linked follow-up issues | [`framework-starter-kit.md`](framework-starter-kit.md), [`framework-portability-and-adoption.md`](framework-portability-and-adoption.md) |

## Recommended readiness (right-sized reliability)

Use this layer once baseline behavior is stable.

| Dimension | Readiness signal | Typical fit | Canonical references |
| --- | --- | --- | --- |
| Handoff continuity | Required handoff fields are consistently preserved and reusable. | Product/platform teams; any frequent handoff flow | [`multi-agent-handoff-playbook.md`](multi-agent-handoff-playbook.md), [`handoff-packet-template.md`](handoff-packet-template.md) |
| Governance/health loop | Periodic governance and health checks produce bounded follow-up issues. | Teams with recurring framework updates | [`governance-checklist.md`](governance-checklist.md), [`framework-health.md`](framework-health.md) |
| Profile-aware automation | Enabled checks match current profile and maturity instead of ad hoc accumulation. | All profiles after baseline | [`framework-automation-bundles-by-profile.md`](framework-automation-bundles-by-profile.md), [`framework-profile-packs.md`](framework-profile-packs.md) |
| Operational routing | Issue/project/PR states stay aligned for active work. | Multi-contributor and intake-heavy repos | [`github-projects-setup.md`](github-projects-setup.md), [`work-type-matrix.md`](work-type-matrix.md) |
| Upgrade awareness | Meaningful framework changes are consumed via release notes/upgrade summaries. | Any downstream adopter | [`framework-release-notes.md`](framework-release-notes.md), [`framework-release-notes-and-upgrade-summaries.md`](framework-release-notes-and-upgrade-summaries.md), [`framework-release-versioning-and-deprecation.md`](framework-release-versioning-and-deprecation.md) |

## Advanced readiness (mature and workload-driven)

Adopt only if needed for your profile, risk level, and scale.

| Dimension | Readiness signal | Typical fit | Canonical references |
| --- | --- | --- | --- |
| Queue continuity hardening | Queue schema, linkage, and drift checks are in routine use. | Queue-backed execution models | [`framework-queued-execution-memory.md`](framework-queued-execution-memory.md), [`runbooks/operate-framework-task-queue.md`](runbooks/operate-framework-task-queue.md), [`runbooks/run-queue-health-check.md`](runbooks/run-queue-health-check.md) |
| Recurring effectiveness reviews | Evidence-backed review packets drive bounded improvements. | Level 3-4 maturity contexts | [`framework-metrics-and-feedback.md`](framework-metrics-and-feedback.md), [`framework-reporting-and-review-cadence.md`](framework-reporting-and-review-cadence.md) |
| Governance/compliance overlay depth | Stricter recurring controls are used where audit obligations require them. | Governance/compliance-heavy environments | [`framework-profile-packs.md`](framework-profile-packs.md), [`framework-automation-bundles-by-profile.md`](framework-automation-bundles-by-profile.md) |

## Outcome model (no rigid scoring)

Use this lightweight outcome language:

- **Ready for current context:** Baseline readiness is fully met and deferrals are
  explicit, bounded, and justified.
- **Partially ready:** Baseline has clear gaps, but bounded actions are in flight.
- **Not ready:** Core baseline signals are missing or undocumented.

Avoid synthetic numeric scores. Focus on the next 2-3 highest-signal gaps.

## Intentional deferrals and profile-specific exceptions

Use this compact log format in the active issue or PR:

| Item | Decision (`Adopt now` / `Defer` / `Not applicable`) | Why (profile/maturity context) | Follow-up artifact | Review date |
| --- | --- | --- | --- | --- |
| Example: queue-health automation | Defer | Solo profile, no queue-backed roadmap yet | `#123` | 2026-09-01 |

Rule: every `Defer` should have an explicit trigger or review date.

## Suggested assessment cadence

- At adoption/bootstrap start
- At major profile or maturity transition
- During monthly/quarterly governance/health/effectiveness reviews
- After `MAJOR` framework guidance updates

## Related docs

- [Framework starter kit / bootstrap pack](framework-starter-kit.md)
- [Framework portability and adoption](framework-portability-and-adoption.md)
- [Framework adoption maturity model](framework-adoption-maturity-model.md)
- [Framework profile packs](framework-profile-packs.md)
- [Framework setup profiles and intent examples](framework-setup-profiles-and-intent-examples.md)
- [Apply setup runbook](runbooks/apply-setup.md)
- [Framework automation bundles by profile](framework-automation-bundles-by-profile.md)
- [Operator onboarding pack](operator-onboarding-pack.md)
- [Framework release/versioning/deprecation model](framework-release-versioning-and-deprecation.md)
- [Framework release notes and upgrade summaries](framework-release-notes-and-upgrade-summaries.md)
- [Framework release notes index](framework-release-notes.md)
- [Governance checklist](governance-checklist.md)
- [Framework health](framework-health.md)
