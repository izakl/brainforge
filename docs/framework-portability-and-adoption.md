# Framework Portability and Adoption Guide

This guide explains how to adopt Brain Factory's documentation-and-governance
framework in another repository, team, or organization without copying it
blindly. It is for maintainers planning an adoption: it defines what is invariant
(the core guarantees you must keep), what is safe to customize, and how to roll
out incrementally.

If Brain Factory is new to you, read
[How Brain Factory works](how-brain-factory-works.md) first. Throughout this
guide, "the framework" means the reusable operating model, templates, and
guardrails that Brain Factory packages — the layer you are porting into another
repo.

Where to go for related, more specific tasks:

- Copy-ready minimum bundle, setup order, and copy/adapt/customize matrix:
  [`framework-starter-kit.md`](framework-starter-kit.md). Start there, then use
  this guide for deeper portability design decisions.
- Strict gate-based migration execution:
  [`framework-repo-transplant-checklist.md`](framework-repo-transplant-checklist.md).
- A durable setup intent/application contract for future setup automation:
  [`framework-setup-intent-schema-and-application-model.md`](framework-setup-intent-schema-and-application-model.md).
- Concrete setup-profile defaults and example setup-intent artifacts:
  [`framework-setup-profiles-and-intent-examples.md`](framework-setup-profiles-and-intent-examples.md).
- A single operator-facing bootstrap path from a natural-language setup request
  to applied setup and readiness checks:
  [`runbooks/prompt-to-setup-bootstrap.md`](runbooks/prompt-to-setup-bootstrap.md).

## Core contract (invariants)

These are non-negotiable across any adopting repository:

1. **GitHub artifacts are the system of record** for execution context.
2. **External context is normalized before implementation** (issue/ADR/discussion first).
3. **PRs remain bounded** to one clear objective.
4. **Handoffs preserve required fields** (objective, context, constraints,
   acceptance criteria, validation, links, next owner, status, unresolved risks).
5. **Governance and validation are repeatable** (lightweight checks + periodic audit).

If an adaptation breaks one of these, it is not a compatible framework adoption.

## Essential vs recommended vs optional components

| Tier | Component | Why it matters | Customization guidance |
| --- | --- | --- | --- |
| Essential | `AGENTS.md` | Shared operating contract for humans/agents. | Keep contract intent; adapt examples/links for your repo. |
| Essential | `docs/framework-continuity-and-memory.md` | Continuity anchor and durable principles. | Keep principles; update scope/surface wording for your environment. |
| Essential | `docs/operating-model.md` | Execution model and work packet expectations. | Keep packet structure; adapt mode names only if your surfaces differ. |
| Essential | Issue templates (`.github/ISSUE_TEMPLATE/`) | Forces structured intake and normalization. | Keep required packet fields; adapt taxonomy labels/wording. |
| Essential | PR template (`.github/pull_request_template.md`) | Enforces bounded scope + validation evidence. | Keep continuity/validation sections; adjust checklist wording. |
| Essential | Baseline checks (`markdown.yml`, check scripts) | Keeps docs/governance layer enforceable. | Keep intent; adjust paths/inventories to your repo layout. |
| Recommended | `docs/multi-agent-handoff-playbook.md` + handoff template | Standardized multi-surface handoff quality. | Keep required fields; adapt examples to your work types. |
| Recommended | `docs/governance-checklist.md` | Recurring lightweight governance pass. | Keep control points; tune cadence and ownership model. |
| Recommended | `docs/framework-health.md` | Re-runnable health snapshot and gap capture. | Keep charter-to-artifact mapping; replace repo-specific rows. |
| Recommended | `docs/framework-metrics-and-feedback.md` + scorecard template | Practical way to assess whether adoption improves outcomes over time. | Keep goals-to-signals model; adapt specific evidence sources and cadence. |
| Recommended | `docs/framework-release-versioning-and-deprecation.md` | Makes framework evolution predictable for adopters and maintainers. | Keep change-impact/deprecation semantics; adapt release communication surface. |
| Recommended | `docs/github-projects-setup.md` | Operational routing in GitHub Projects. | Customize statuses/fields/views to team workflow. |
| Optional | `docs/prompt-cookbook.md` | Prompt acceleration and consistency. | Adapt prompt patterns to your tools and constraints. |
| Optional | Runbooks in `docs/runbooks/` | Repeatable operator procedures. | Keep runbooks for recurring tasks only; omit unused flows. |
| Optional | Worked examples in `examples/` | Concrete onboarding reference for new contributors. | Add examples only for your high-frequency scenarios. |

## Dependency and setup order

Adopt in this sequence to avoid broken or partial setup:

1. **Contract first:** `AGENTS.md`, continuity anchor, operating model.
2. **Intake next:** issue templates + PR template + taxonomy decisions.
3. **Validation layer:** markdown workflow + only the scripts you will enforce.
4. **Handoff/governance layer:** handoff template, playbook, governance checklist.
5. **Operational layer:** Projects setup, runbooks, examples, recurring audits.

Do not add enforcement scripts before the referenced docs/inventories exist.
Use [`framework-automation-bundles-by-profile.md`](framework-automation-bundles-by-profile.md)
to decide which automation bundle to enable first by profile and maturity.

## Minimum viable adoption path (MVA)

If you need a fast start, adopt only this minimal path first:

- `AGENTS.md` with your repository links
- one framework-change issue template with required work-packet fields
- PR template with scope + validation checklist
- continuity anchor (`docs/framework-continuity-and-memory.md`)
- operating model (`docs/operating-model.md`)
- markdown lint/link workflow

Then scale to handoff enforcement, governance checklist, health audits, and
project/routing automation.

For a practical first-hour/first-day/first-week path and explicit starter
bundle inventory, use [`framework-starter-kit.md`](framework-starter-kit.md).

## Bootstrap checklist for a new repository

- [ ] Confirm owner and reviewer model (`CODEOWNERS`, approval boundaries).
- [ ] Define your issue taxonomy and map templates to work types.
- [ ] Create/port `AGENTS.md`, continuity anchor, and operating model.
- [ ] Install PR template and required issue templates.
- [ ] Enable markdown validation workflow.
- [ ] Add only enforcement scripts you can maintain immediately.
- [ ] Verify all cross-links use repo-relative paths.
- [ ] Run local validation and ensure CI is green.
- [ ] Document what is intentionally deferred (follow-up issues).

For a durable phase-gated migration control list with required evidence and
invariant checks, use
[`framework-repo-transplant-checklist.md`](framework-repo-transplant-checklist.md).

## Repo-specific assumptions in this repository

The following are specific to `izakl/brainforge` and must be
adapted when transplanted:

- Organization/repo hardcoded links in issue template contact links.
- `@izakl` ownership references in governance/routing artifacts.
- Script expectations for current inventory files:
  - `scripts/check-mobile-quick-action.sh` reads
    `docs/github-mobile-guide.md` coverage table.
  - `scripts/check-handoff-packet.sh` reads
    `docs/multi-agent-handoff-playbook.md` coverage table.
  - `scripts/check-index-parity.sh` assumes index files:
    `docs/adr/README.md`, `docs/runbooks/README.md`, `examples/README.md`.
- Current branch-hygiene conventions and existing workflow names.
- Current label taxonomy and project field naming conventions.

## Safe customization points

You can safely customize:

- issue type names, labels, and project statuses
- execution-surface naming and team-specific role names
- runbook granularity and cadence
- prompt examples and wording
- which recommended/optional checks are automated first

You should avoid customizing:

- required work-packet fields
- normalized-context-before-implementation rule
- bounded PR expectation
- durable artifact linkage and validation evidence expectations

## Incremental rollout model

Use phased adoption to reduce friction:

1. **Foundation:** core contract + intake + baseline CI.
2. **Reliability:** handoff and governance checks.
3. **Operations:** Projects routing, work-type matrix adoption, runbooks, examples.
4. **Optimization:** recurring audits, automation tuning, metrics.

Each phase should ship as bounded PRs with explicit non-goals.

Use [`framework-adoption-maturity-model.md`](framework-adoption-maturity-model.md)
to assess depth per capability area within and across these phases.
Use [`framework-profile-packs.md`](framework-profile-packs.md) to pick the right
operating profile for your current team/repository context while keeping
invariants intact.

### Projects setup in adopted repositories

When entering the **Operations** phase, start with the minimum viable project model:

- required fields: `Status`, `Work Type`, `Priority`, `Owner`, `Execution Mode`, `Linked PR`, `Needs Follow-up`
- canonical statuses: `Intake`, `Triage`, `Ready`, `In Progress`, `In Review`, `Blocked`, `Support Active`, `Follow-up / Deferred`, `Done`

Then add repo-specific fields/views only after the baseline issue→project→PR→writeback loop is stable.

## Example adaptation (different repo shape)

For a small application repository with no ADR practice yet:

- adopt core contract + issue/PR templates first
- use a lightweight decision log section in issues temporarily
- defer ADR files until architectural decision volume justifies them
- keep handoff packet fields in issue/PR bodies from day one
- add health/governance docs once the first few framework PRs are merged

This preserves framework invariants while avoiding over-configuration.

## Mobile quick action

- **Use when:** you need to assess portability scope or adoption phase from mobile
  without redesigning the framework.
- **Do from mobile:**
  - Confirm whether the target repo is in Foundation, Reliability, Operations, or
    Optimization phase.
  - Flag missing invariants (normalization, bounded PRs, handoff fields) in the
    active issue or PR.
  - Capture one bounded follow-up issue per adoption gap.
- **Do not do from mobile:**
  - Attempt full framework transplantation planning across many files.
  - Redefine invariants or governance checks through mobile-only edits.
- **Escalate to desktop/cloud when:**
  - Adoption requires coordinated template/workflow/script changes.
  - Repo-specific assumptions need broad path or automation rewiring.
- **Primary artifact to update:**
  - The framework-adoption issue or pull request carrying the active migration
    checklist.

## Related docs

- [Framework upgrade and adoption maintenance](framework-upgrade-and-maintenance.md)
- [AGENTS entrypoint](../AGENTS.md)
- [Operator onboarding pack](operator-onboarding-pack.md)
- [Framework continuity and memory](framework-continuity-and-memory.md)
- [Framework starter kit / bootstrap pack](framework-starter-kit.md)
- [Framework repo-transplant checklist](framework-repo-transplant-checklist.md)
- [Operating model](operating-model.md)
- [Framework adoption maturity model](framework-adoption-maturity-model.md)
- [Framework readiness checklist](framework-readiness-checklist.md)
- [Framework release/versioning/deprecation model](framework-release-versioning-and-deprecation.md)
- [Framework profile packs](framework-profile-packs.md)
- [Framework automation bundles by profile](framework-automation-bundles-by-profile.md)
- [Framework setup intent schema and application model](framework-setup-intent-schema-and-application-model.md)
- [Framework setup profiles and intent examples](framework-setup-profiles-and-intent-examples.md)
- [Prompt-to-setup bootstrap](runbooks/prompt-to-setup-bootstrap.md)
- [Governance checklist](governance-checklist.md)
- [Framework health](framework-health.md)
- [Framework metrics and feedback loop](framework-metrics-and-feedback.md)
- [GitHub Projects setup](github-projects-setup.md)
- [Work-type matrix](work-type-matrix.md)
- [Multi-agent handoff playbook](multi-agent-handoff-playbook.md)
