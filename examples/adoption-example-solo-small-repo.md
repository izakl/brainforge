# Adoption example: solo maintainer / small repository

This example walks a solo maintainer or small team (one to three people) through
adopting Brain Factory in a low-volume open-source library or personal project. You
will see which files to copy on day one, which automation to turn on, and what to
defer — and why. Two terms recur: a **profile** is the preset that matches your
team's size and risk; an **automation bundle** is the matching set of CI checks. New
to the project? Read
[`../docs/how-brain-factory-works.md`](../docs/how-brain-factory-works.md) first.

## Scenario

A developer maintains an open-source Python utility library with a small but active
user base. Issues arrive infrequently — a mix of feature requests, occasional bugs,
and docs gaps. There is no team; the maintainer handles all triage, implementation,
and review personally.

The maintainer wants repeatable structure for issue handling, a consistent PR quality
gate, and a path for future contributors to follow without extensive hand-holding.

## Profile selected

**Small repository / solo maintainer.**

Chosen because:

- one primary owner handles most work
- low concurrent PR volume
- no need for complex project views or handoff machinery
- overhead cost must stay near zero

See [`docs/framework-profile-packs.md`](../docs/framework-profile-packs.md) for
the full profile definition.

## Automation bundle selected

**Bundle A — Small repository / solo maintainer baseline.**

Chosen because:

- markdown quality gate catches doc regressions without manual checking
- security guardrail check preserves private-reporting routing from day one
- labeler adds basic triage signal without maintenance burden
- handoff enforcement, queue automation, and scheduled audits are deferred until
  needed

See [`docs/framework-automation-bundles-by-profile.md`](../docs/framework-automation-bundles-by-profile.md)
for the full bundle definition.

## File selection

### Copied and adapted on day one (Essential tier)

| File | Adaptation made |
| --- | --- |
| `AGENTS.md` | Updated repo links, removed agent-surface references not relevant to solo workflow |
| `docs/framework-continuity-and-memory.md` | Kept principles; stripped org-facing language |
| `docs/operating-model.md` | Kept; no adaptation needed for the core model |
| `.github/ISSUE_TEMPLATE/framework-change.yml` | Renamed to `improvement.yml`; simplified label set |
| `.github/ISSUE_TEMPLATE/config.yml` | Replaced repo URLs with this repo's advisory link |
| `.github/pull_request_template.md` | Kept all required packet fields; simplified checklist wording |
| `.github/workflows/markdown.yml` | Kept as-is; no path changes needed |
| `.github/markdown-link-check.json` | Kept as-is |
| `.markdownlint.jsonc` | Kept as-is |
| `SECURITY.md` | Updated contact link; kept private-reporting language |
| `docs/security-and-secure-delivery.md` | Kept; no adaptation needed |

### Added in the first month (Recommended tier, highest-signal items)

| File | Why added |
| --- | --- |
| `docs/framework-profile-packs.md` | Reference for future decisions about when to evolve the profile |
| `docs/work-type-matrix.md` | Useful for classifying incoming issues quickly |
| `.github/workflows/check-security-guardrails.yml` | Security anchor check; low overhead, high signal |

### Explicitly deferred

| Component | Deferral rationale |
| --- | --- |
| `docs/multi-agent-handoff-playbook.md` + enforcement | No multi-agent or multi-owner handoffs occurring |
| `docs/github-projects-setup.md` + Projects setup | Issue list alone sufficient at this volume |
| `scripts/check-handoff-packet.sh` | Deferred until handoffs become frequent |
| `scripts/check-index-parity.sh` | Deferred until ADR/runbook/examples surface grows |
| `docs/framework-automation-bundles-by-profile.md` | Deferred until bundle decisions become recurring |
| `docs/framework-adoption-maturity-model.md` | Deferred until periodic self-assessment is warranted |
| `docs/runbooks/` (most) | Only `open-an-issue.md` and `handle-a-dependabot-pr.md` copied |
| `examples/` (most) | Only this file and the Dependabot example copied |

## First-week rollout path

### Day 1: Copy and adapt the essential baseline

- Copied the ten-file essential baseline from the framework starter kit
- Replaced hardcoded repo/org references with this repository's links
- Opened one bootstrap PR scoped only to the essential baseline files
- Ran `npx -y markdownlint-cli2 "**/*.md"` and `npx -y markdown-link-check` locally
- Confirmed markdown and link checks passed in CI before merging

### Day 2–3: Validate the issue and PR flow

- Opened one test issue using the adapted framework-change template
- Confirmed all required packet fields (objective, context, constraints, acceptance criteria,
  validation, next owner) were present
- Opened a small follow-up PR, verified the PR template prompted for validation evidence
- Merged and confirmed branch cleanup was handled

### Day 4–5: Enable security guardrail check

- Added `scripts/check-security-guardrails.sh` and its workflow
- Confirmed SECURITY.md and config.yml passed the guardrail check
- Captured one deferred follow-up issue: "Add handoff enforcement once contributors join"

### End of week: Assess and document deferrals

- Reviewed the optional and recommended tiers in the starter kit
- Opened one bounded issue for each deferred component, noting explicit enablement criteria
- Captured the active maturity level estimate in the bootstrap issue: Level 2 Structured on
  most dimensions, Level 1 on portability and feedback loops

## Customizations and tradeoffs

| Decision | Tradeoff |
| --- | --- |
| Simplified issue template to one type | Slightly less triage precision; acceptable at this volume |
| No GitHub Projects setup | Lower overhead; acceptable while issue volume stays low |
| Labeler kept as-is | No customization; all default label paths cover the solo workflow |
| No queue automation | Queue-backed planning is not needed at solo scale |
| Security guardrail enabled from day one | Low overhead; avoids gaps if contributors join unexpectedly |

## Scale-up triggers to watch

- More than two open PRs at once → consider GitHub Projects MVP
- A second regular contributor joins → add handoff enforcement
- Support issue volume grows → add the support-intake template and work-type matrix
- Adoption of this repo by other teams → add portability and maturity model references

## Mobile quick action

- **Use when:** reviewing this example from mobile to confirm adoption scope and
  deferred items are still appropriate.
- **Do from mobile:**
  - Verify current profile is still Small repository / solo maintainer.
  - Check for scale-up triggers (rising concurrent PRs, new contributors, support volume).
  - Open one bounded follow-up issue per triggered scale-up area.
- **Do not do from mobile:**
  - Execute the multi-file bootstrap PR from mobile.
  - Redesign issue templates or change profile definitions without desktop review.
- **Escalate to desktop/cloud when:**
  - Scale-up triggers are firing and profile evolution requires coordinated file changes.
  - A second owner joins and handoff machinery needs to be added.
- **Primary artifact to update:**
  - The active adoption/bootstrap issue or PR that tracks profile selection and deferral decisions.

## Related docs

- [Framework profile packs](../docs/framework-profile-packs.md)
- [Framework starter kit / bootstrap pack](../docs/framework-starter-kit.md)
- [Framework automation bundles by profile](../docs/framework-automation-bundles-by-profile.md)
- [Framework adoption maturity model](../docs/framework-adoption-maturity-model.md)
- [Framework portability and adoption](../docs/framework-portability-and-adoption.md)
- [Work-type matrix](../docs/work-type-matrix.md)
- [Adoption example: product delivery team](adoption-example-product-delivery-team.md)
- [Adoption example: platform and infrastructure team](adoption-example-platform-infra-team.md)
