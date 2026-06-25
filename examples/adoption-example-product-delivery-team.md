# Adoption example: product delivery team

This example walks a multi-contributor product team through adopting Brain Factory in
an active feature/bug/docs repository with a steady PR flow. You will see how the team
turns on the full issue/project/PR/handoff loop, which automation bundle they choose,
and what they defer. A **profile** is the preset matching team size and risk; an
**automation bundle** is its matching set of CI checks. New to the project? Read
[`../docs/how-brain-factory-works.md`](../docs/how-brain-factory-works.md) first.

## Scenario

A product team of five engineers and one product manager delivers a SaaS web application.
Work arrives as feature requests, defects, docs improvements, and occasional
infrastructure changes. There are always several open PRs at once, and contributors
regularly hand work off between each other and to GitHub Copilot agent tasks.

The team wants structured intake and routing, predictable PR quality gates, consistent
handoffs between contributors and agents, and periodic health reviews to catch drift.

## Profile selected

**Product delivery team.**

Chosen because:

- multiple contributors share delivery flow
- active feature, defect, and docs changes run in parallel
- work regularly moves between contributors and execution surfaces (local, cloud agent, mobile)
- handoff quality affects output reliability

See [`docs/framework-profile-packs.md`](../docs/framework-profile-packs.md) for
the full profile definition.

## Automation bundle selected

**Bundle B — Product delivery team.**

Chosen because:

- baseline checks (markdown + security) are non-negotiable for any profile
- handoff packet enforcement is essential once work moves between contributors
- index parity checks keep documentation coherent as the surface grows
- queue and scheduled-audit automation are deferred until queue-backed planning is routine

See [`docs/framework-automation-bundles-by-profile.md`](../docs/framework-automation-bundles-by-profile.md)
for the full bundle definition.

## File selection

### Copied and adapted on day one (Essential tier)

| File | Adaptation made |
| --- | --- |
| `AGENTS.md` | Updated repo links; added team-specific owner handles and agent-surface guidance |
| `docs/framework-continuity-and-memory.md` | Kept principles; updated scope to reflect team and product context |
| `docs/operating-model.md` | Kept; no adaptation needed |
| `.github/ISSUE_TEMPLATE/framework-change.yml` | Renamed to `feature.yml`, `defect.yml`, and `docs.yml` for common work types |
| `.github/ISSUE_TEMPLATE/config.yml` | Updated repo URLs and private advisory link |
| `.github/pull_request_template.md` | Kept all required packet fields; added explicit non-goals section |
| `.github/workflows/markdown.yml` | Kept as-is |
| `.github/markdown-link-check.json` | Kept as-is |
| `.markdownlint.jsonc` | Kept as-is |
| `SECURITY.md` | Updated owner references; kept private-reporting language |
| `docs/security-and-secure-delivery.md` | Kept; no adaptation needed |

### Added in the first week (Recommended tier, essential for this profile)

| File | Why added |
| --- | --- |
| `docs/work-type-matrix.md` | Used in triage to route issues to the correct artifact path |
| `docs/multi-agent-handoff-playbook.md` + `docs/handoff-packet-template.md` | Handoffs between contributors and agents are frequent |
| `scripts/check-handoff-packet.sh` + `.github/workflows/check-handoff-packet.yml` | Enforces handoff quality in CI from week one |
| `docs/github-projects-setup.md` | Team uses GitHub Projects for intake → execution → follow-up routing |
| `docs/framework-profile-packs.md` | Reference for profile and automation decisions |
| `docs/framework-adoption-maturity-model.md` | Used for monthly self-assessment |

### Added in the first month (Recommended tier, added once baseline loop was stable)

| File | Why added |
| --- | --- |
| `scripts/check-index-parity.sh` + `.github/workflows/framework-audit.yml` | ADR/runbook/examples surface grew; index drift became a risk |
| `docs/framework-health.md` + `docs/governance-checklist.md` | Monthly health and governance reviews formalized |
| `docs/framework-reporting-and-review-cadence.md` | Recurring weekly/monthly review cadence established |
| `docs/framework-metrics-and-feedback.md` | Effectiveness review loop started |

### Explicitly deferred

| Component | Deferral rationale |
| --- | --- |
| Queue automation (`check-queue-health.sh`, `prepare-next-framework-task.yml`) | Queue-backed planning is not yet routine; will add once roadmap operations stabilize |
| `docs/framework-queued-execution-memory.md` | Deferred with queue automation |
| `docs/redevelopment-playbook.md` | No active redevelopment work in scope yet |
| Governance/compliance overlay (Bundle E) | Not required; current work does not have strict audit obligations |

## First-week rollout path

### Day 1: Copy and adapt the essential baseline

- Copied the ten-file essential baseline from the framework starter kit
- Replaced hardcoded references with team-specific owners and labels
- Opened one bootstrap PR scoped only to essential baseline
- Ran markdown lint + link check locally before pushing
- Confirmed CI passed on first PR

### Day 2–3: Add work-type templates and handoff enforcement

- Added feature, defect, and docs issue templates
- Added `docs/work-type-matrix.md` and adapted the team's issue labels to match matrix categories
- Added handoff packet template and enforcement check
- Ran `scripts/check-handoff-packet.sh` locally to confirm inventory was correct
- Opened follow-up issue: "Configure GitHub Projects MVP fields and views"

### Day 4–5: Set up GitHub Projects MVP

- Created one GitHub Project with canonical statuses: `Triage`, `Ready`, `In Progress`, `Blocked`,
  `Done`, `Cancelled`
- Added basic routing views: active work, intake queue, blocked items
- Confirmed issue→project→PR linkage was working for the first real change

### End of week: Run one real change through the full loop

- Opened one real feature issue using the new template
- Confirmed packet fields (objective, context, constraints, acceptance criteria,
  validation expectations, owner) were complete before moving to `Ready`
- Opened implementation PR, confirmed PR template prompted for validation evidence
- Ran all CI checks; merged; updated project status and closure note
- Retrospective note in the bootstrap issue: handoff enforcement was the highest-value
  addition in week one

## Customizations and tradeoffs

| Decision | Tradeoff |
| --- | --- |
| Three issue templates instead of one | Higher specificity for common work types; acceptable for team size |
| Handoff enforcement from week one | Slightly more setup overhead; pays off immediately with multiple contributors |
| GitHub Projects MVP from day one | Some overhead configuring views; essential for routing visibility at this scale |
| Index parity deferred to month one | Acceptable; ADR/runbook surface was small in week one |
| Queue automation deferred | Appropriate; queue-backed planning adds overhead before it is stable |

## Scale-up triggers to watch

- Routing drift between issue/project/PR state → tighten project status discipline and
  add queue health check
- Handoff losses between contributors or execution surfaces → review handoff packet quality
  and add more runbooks for recurring flows
- Recurring rework from weak acceptance criteria → improve issue template validation field
  guidance
- Support volume grows significantly → consider adding support-intake templates and
  moving toward Bundle D

## Mobile quick action

- **Use when:** reviewing this example from mobile to confirm adoption scope, profile
  fit, and deferred items are still appropriate.
- **Do from mobile:**
  - Verify current profile is still Product delivery team.
  - Check for scale-up triggers (routing drift, handoff losses, rising rework).
  - Open one bounded follow-up issue per identified gap.
- **Do not do from mobile:**
  - Execute multi-file bootstrap or project setup from mobile.
  - Redesign issue templates or bundle selections without desktop review.
- **Escalate to desktop/cloud when:**
  - Scale-up triggers warrant bundle upgrade or profile evolution.
  - Handoff enforcement inventory needs updating across multiple docs.
- **Primary artifact to update:**
  - The active adoption/bootstrap issue or PR that tracks profile selection and deferred decisions.

## Related docs

- [Framework profile packs](../docs/framework-profile-packs.md)
- [Framework starter kit / bootstrap pack](../docs/framework-starter-kit.md)
- [Framework automation bundles by profile](../docs/framework-automation-bundles-by-profile.md)
- [Framework adoption maturity model](../docs/framework-adoption-maturity-model.md)
- [Framework portability and adoption](../docs/framework-portability-and-adoption.md)
- [Multi-agent handoff playbook](../docs/multi-agent-handoff-playbook.md)
- [Work-type matrix](../docs/work-type-matrix.md)
- [GitHub Projects setup](../docs/github-projects-setup.md)
- [Adoption example: solo maintainer / small repository](adoption-example-solo-small-repo.md)
- [Adoption example: platform and infrastructure team](adoption-example-platform-infra-team.md)
