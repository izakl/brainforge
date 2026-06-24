# Work-Type Matrix

Different kinds of work need different rigor: a docs tweak and a security fix should not move through the same checks. This guide is a lookup table that tells you, for each work type, which artifact to start from, how deeply to normalize context, how much validation to expect, and what follow-up to leave behind — all without breaking the rules that apply to every task. It is for contributors and agents deciding how to handle a piece of work in a brain (a per-project repository); for the bigger picture, see [how Brain Factory works](how-brain-factory-works.md).

## Why this exists

Brain Factory already defines durable artifacts, context normalization, handoff quality, validation, and governance controls. What was previously left implicit is how those controls should flex across support, defects, framework changes, security-sensitive work, docs updates, ADR work, CI/automation changes, and redevelopment. This matrix makes that situational guidance explicit so teams can choose the right path quickly while keeping the invariants below intact.

## Non-negotiable invariants (apply to every work type)

1. GitHub artifacts are the execution system of record.
2. External context is normalized before implementation begins.
3. PR scope stays bounded to one clear objective.
4. Handoffs preserve objective, context, constraints, acceptance, validation, links, next owner, status, and unresolved risks.
5. Validation evidence is captured in durable artifacts.

## Quick chooser

Use this order:

1. If the signal is ambiguous or inbound, start with **Support Intake**.
2. If there is a reproducible failure, route to **Defect**.
3. If behavior is not broken but should improve, route to **Feature/Enhancement**.
4. If the framework itself is changing, route to **Framework/Process change**.
5. If vulnerability or sensitive detail risk exists, treat as **Security-sensitive** first.
6. If no product behavior changes and only guidance changes, use **Documentation-only**.
7. If an architecture/process policy choice is needed, route through **ADR/Policy/Governance**.
8. If workflows/checks/permissions/pipelines change, use **Automation/CI/Workflow**.
9. If legacy uncertainty and migration risk dominate, use **Redevelopment/Modernization**.

When uncertain, use `support-intake.yml` and route during triage.

## Work-type behavior matrix

Find your work type in the first column, then read across for the expected handling. ("ADR" is an architecture decision record; "writeback" is the closing update that records the outcome in durable artifacts.)

| Work type | Start artifact | Context normalization depth | Handoff expectation | PR required? | Validation depth | Security/privacy caution | ADR trigger | GitHub Projects routing | Writeback/follow-up |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Support intake | `support-intake.yml`; see [Support loop](product-support-and-improvement-loop.md) | Medium at intake; increase after triage before execution | Triage handoff must record owner, classification, severity, next step | Not for intake alone; yes for downstream implementation | Intake quality + routing correctness | Raise caution if sensitive user/system data appears | Consider ADR only if recurring signal implies policy/process decision | `Intake` → `Triage` → routed work type status | Closure note, communication status, and routed issue links |
| Defect / bug fix | `bug-defect.yml` or `bug-report.yml` | High: repro, expected vs actual, constraints, validation plan | Preserve repro, constraints, and validation evidence between owners | Yes when a repository change is made | High: repro confirmation + tests/checks + regression evidence | Increase caution for security or privacy-impacting bugs | ADR when fix implies architectural/process tradeoff | `Ready` → `In Progress` → `In Review` → `Done` | Resolution evidence, follow-up for deferred hardening/tests/docs |
| Feature / change request | `enhancement.yml` | High: objective, non-goals, acceptance, rollout constraints | Preserve scope boundaries and non-goals through handoffs | Yes for implementation | High: acceptance validation + impacted checks | Moderate by default; raise if permissions/data exposure changes | ADR when behavior change requires durable architecture/process decision | Standard execution flow with explicit `Work Type=Enhancement` | Outcome summary + deferred follow-up issues |
| Framework / process change | `framework-change.yml` or `improvement.yml` | High: include framework constraints and affected docs/artifacts | Preserve invariants and out-of-scope boundaries | Yes | High: markdown checks + applicable framework scripts + link integrity | Moderate; higher if touching security/governance controls | ADR when changing durable policy/convention | Route as framework/improvement with explicit owner and validation owner | Update discoverability links, health/governance artifacts as needed |
| Security-sensitive work | Private report flow in `SECURITY.md`; optionally sanitized tracker issue | Highest: sanitize public context, keep sensitive details private | Explicit secure handoff with least detail necessary in public artifacts | Yes for remediation/hardening changes | Highest: secure-delivery checks + remediation validation | Maximum caution; no secrets/exploit details in public artifacts | ADR when long-lived security policy/process changes are needed | `Support Active`/`Blocked` until safe routing, then normal execution states | Sanitized closure note + remediation evidence + follow-up hardening tasks |
| Documentation-only work | `docs.yml` (or routed issue from support/defect/framework work) | Medium: enough context to preserve intent and audience | Preserve target audience, constraints, and linked source artifacts | Usually yes (PR flow preferred for shared docs) | Medium: markdown lint, links, and cross-reference quality | Low unless documenting sensitive topics | ADR only for policy-level documentation decisions | Route through `Ready`/`In Review`/`Done` with `Work Type=Documentation` | Cross-link updates, support communication or runbook follow-up where relevant |
| ADR / policy / governance change | `adr.yml` (often with linked implementation issue) | High: alternatives, consequences, and constraints | Decision handoff must preserve unresolved obligations and next owner | Yes for ADR/doc updates and any downstream implementation | High: doc checks + evidence that downstream obligations are tracked | Moderate to high depending on policy topic | Always central to this work type | Route as decision work, then split implementation follow-ups | ADR merged, follow-up issues created, governance/health references updated |
| Automation / CI / workflow change | Usually `improvement.yml`, `framework-change.yml`, or routed defect issue | High: include risk, permissions, failure modes, rollback approach | Preserve workflow constraints, risk notes, and validation expectations | Yes | High: affected checks/workflow validation and least-privilege review | Elevated caution because automation changes can widen blast radius | ADR when introducing or changing durable automation policy | Route with explicit risk/owner and blocked reason if waiting on infra/access | Capture validation evidence and any operational follow-up runbook/docs updates |
| Redevelopment / modernization | `redevelopment-discovery.yml` | Progressive: medium during discovery, high before each implementation slice | Strong handoff packet discipline across phases/surfaces | Yes for implementation slices (docs-only discovery writeback may be docs PR) | High: phase-based validation, migration/rollback checks per slice | Elevated caution for data migration, integration, and continuity risks | ADR often needed for migration boundaries and architecture decisions | Use phased statuses (`Intake`/`Triage`/`Ready`/`In Progress`) per slice | Discovery writeback, phased follow-up issues, ADR links, migration evidence |

## When work spans multiple categories

Use the stricter path when multiple types apply:

1. **Security-sensitive overrides all other paths** until safe routing is established.
2. If **ADR/policy** is required, capture that decision before broad implementation.
3. If intake is still ambiguous, remain in **Support intake** until routed.
4. For combined **defect + docs** or **feature + docs**, keep one primary execution issue and track docs updates in the same PR when bounded, or a linked follow-up issue/PR when not.
5. For combined **framework + automation** work, treat validation depth as automation-level.
6. For **redevelopment** work, use phase-specific routing and avoid large mixed-scope PRs.

## Practical usage pattern

1. Classify the work type in issue triage.
2. Use this matrix to set:
   - artifact path
   - normalization depth
   - validation depth
   - ADR expectation
   - follow-up/writeback expectations
3. Reflect those decisions in the issue, project fields, and PR description.
4. Re-check matrix alignment during review and closure.

## Mobile quick action

- **Use when:** you need to quickly choose the correct work-type path and expected rigor from mobile.
- **Do from mobile:**
  - Identify the primary work type and note any secondary types.
  - Confirm the required intake artifact and routing status are set.
  - Flag if stricter handling is required (security-sensitive, ADR-first, or automation-risk).
- **Do not do from mobile:**
  - Finalize disputed classification without enough durable context.
  - Start implementation from ambiguous intake or chat-only context.
- **Escalate to desktop/cloud when:**
  - Work spans multiple categories with unclear precedence.
  - Security, policy, or automation risk needs deeper review.
- **Primary artifact to update:**
  - The active issue or project item carrying work-type classification and routing notes.

## Related docs

- [Issue taxonomy](issue-taxonomy.md)
- [Operating model](operating-model.md)
- [Context synchronization](context-synchronization.md)
- [Multi-agent handoff playbook](multi-agent-handoff-playbook.md)
- [Product support and improvement loop](product-support-and-improvement-loop.md)
- [GitHub Projects setup](github-projects-setup.md)
- [Security and secure delivery guardrails](security-and-secure-delivery.md)
- [Redevelopment playbook](redevelopment-playbook.md)
- [Framework portability and adoption](framework-portability-and-adoption.md)
- [Framework profile packs](framework-profile-packs.md)
- [Framework automation bundles by profile](framework-automation-bundles-by-profile.md)
- [Framework metrics and feedback loop](framework-metrics-and-feedback.md)
- [Framework reporting and review cadence](framework-reporting-and-review-cadence.md)
- [Framework adoption maturity model](framework-adoption-maturity-model.md)
