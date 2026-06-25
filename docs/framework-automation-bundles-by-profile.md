# Framework Automation Bundles by Profile

This guide groups Brain Factory's CI workflows, checks, and lightweight
automation into ready-made "bundles" you can enable by repository and team
context, instead of turning automation on ad hoc. It is for maintainers deciding
what to automate, and in what order.

New to the project? See [How Brain Factory works](how-brain-factory-works.md),
then pick your operating profile in
[`framework-profile-packs.md`](framework-profile-packs.md) before choosing a
bundle here.

## Purpose

Brain Factory ships strong automation components — validation checks, recurring
audits, queue guardrails, and routing support — but adopters still need a simple
answer to three questions:

- What should we enable first?
- What can wait?
- Which combinations fit our profile and maturity?

This guide provides that bundle model.

## Automation capability inventory (baseline → advanced)

| Layer | Capability | Primary assets |
| --- | --- | --- |
| Baseline | Markdown quality gate | `../.github/workflows/markdown.yml`, `../.markdownlint.jsonc`, `../.github/markdown-link-check.json` |
| Baseline | Security routing anchor check | `../scripts/check-security-guardrails.sh`, `../.github/workflows/check-security-guardrails.yml` |
| Recommended | Handoff packet completeness | `../scripts/check-handoff-packet.sh`, `../.github/workflows/check-handoff-packet.yml` |
| Recommended | Documentation/nav consistency | `../scripts/check-index-parity.sh`, `../.github/workflows/framework-audit.yml` |
| Recommended | Queue integrity and drift detection | `../scripts/check-framework-task-queue.sh`, `../scripts/check-queue-health.sh`, `../.github/workflows/framework-audit.yml`, `../.github/workflows/prepare-next-framework-task.yml` |
| Situational | Mobile convention enforcement | `../scripts/check-mobile-quick-action.sh`, `../docs/github-mobile-guide.md`, `../.github/workflows/markdown.yml` |
| Situational | PR routing labels | `../.github/workflows/labeler.yml`, `../.github/labeler.yml` |
| Situational | Branch hygiene automation | `../.github/workflows/stale-branches.yml` |

## Quick selection flow

1. Pick the profile that best matches your repository/team reality.
2. Start at that profile's **minimum** set.
3. Add **recommended** items once minimum checks are stable and green.
4. Add **deferred** items only when trigger conditions are real and recurring.

Use one primary bundle as your default operating mode, then add overlays only
when needed.

## Bundle model (minimum → recommended → deferred)

### Bundle A — Small repository / solo maintainer baseline

- **Minimum:** markdown workflow + security guardrail check.
- **Recommended:** add labeler for basic routing and triage support.
- **Deferred until later:** handoff check, queue checks, scheduled framework audit,
  stale-branch automation.
- **Advance from minimum to recommended when:** labeler paths are defined and
  routing labels are actively used in triage.
- **Advance from recommended to deferred when:** PR concurrency rises, queue
  operations become a recurring workflow, or scale-up triggers in the profile
  pack persist for more than one quarter.
- **Why this fits:** preserves core quality/security/routing with minimal overhead.
- **Expected benefit:** low-maintenance baseline with predictable docs quality.
- **Maintenance cost:** low.
- **Prerequisites/maturity assumption:** Level 1-2 adoption; low parallel work.
- **Operator runbooks:** [Start a framework change](runbooks/start-a-framework-change.md),
  [Run the framework health audit](runbooks/run-the-framework-health-audit.md).

### Bundle B — Product delivery team

- **Minimum:** Bundle A recommended set + handoff packet check.
- **Recommended:** add index parity + monthly framework audit.
- **Deferred until later:** queue preparation/health automation until queue-backed
  roadmap operations become routine.
- **Advance from minimum to recommended when:** handoff packet check is green for
  two consecutive PR cycles and index parity is actively maintained.
- **Advance from recommended to deferred when:** queue-backed roadmap planning is a
  routine practice, not a one-off experiment.
- **Why this fits:** supports multi-contributor continuity and documentation
  coherence in steady delivery flow.
- **Expected benefit:** fewer handoff losses and lower doc/runbook drift.
- **Maintenance cost:** medium.
- **Prerequisites/maturity assumption:** Level 2-3 adoption; repeatable issue→PR flow.
- **Operator runbooks:** [Close out a multi-agent handoff](runbooks/close-out-a-multi-agent-handoff.md),
  [Operate the framework task queue](runbooks/operate-framework-task-queue.md),
  [Run the framework health audit](runbooks/run-the-framework-health-audit.md).

### Bundle C — Platform / infrastructure team

- **Minimum:** Bundle B recommended set + queue integrity check.
- **Recommended:** add queue health + merge-triggered next-task preparation.
- **Deferred until later:** stale-branch automation until branch volume and
  churn patterns justify the overhead.
- **Advance from minimum to recommended when:** `.github/framework-task-queue.json`
  is actively governed (state transitions are timely, no long-lived stale items).
- **Advance from recommended to deferred when:** branch count growth or repeated
  stale-branch findings appear in health audits.
- **Why this fits:** platform work has higher automation blast radius and requires
  stronger operational drift detection.
- **Expected benefit:** earlier detection of workflow/queue drift and safer
  automation operations.
- **Maintenance cost:** medium-high.
- **Prerequisites/maturity assumption:** Level 3+ in validation/governance.
- **Operator runbooks:** [Operate the framework task queue](runbooks/operate-framework-task-queue.md),
  [Run the queue health check](runbooks/run-queue-health-check.md),
  [Triage the stale-branch report](runbooks/triage-stale-branch-report.md),
  [Handle security-sensitive intake](runbooks/handle-security-sensitive-intake.md).

### Bundle D — Support-heavy / intake-heavy team

- **Minimum:** Bundle B recommended set + labeler.
- **Recommended:** add queue integrity + queue health checks.
- **Deferred until later:** prepare-next-task workflow until queue discipline is
  stable and intake-to-queue linkage is well-established.
- **Advance from minimum to recommended when:** labeler routing is stable and
  triage-to-issue conversion is consistent across sprints.
- **Advance from recommended to deferred when:** queue state is reliably maintained
  and intake-to-follow-up linkage is repeatable.
- **Why this fits:** high intake volume benefits from routing consistency and
  queue-state reliability before deeper automation.
- **Expected benefit:** better intake-to-follow-up conversion and less stalled work.
- **Maintenance cost:** medium.
- **Prerequisites/maturity assumption:** Level 2-3 with active issue/project routing.
- **Operator runbooks:** [Respond to support intake](runbooks/respond-to-support-intake.md),
  [Operate the framework task queue](runbooks/operate-framework-task-queue.md),
  [Run the queue health check](runbooks/run-queue-health-check.md).

### Bundle E — Governance/compliance-heavy overlay

- **Minimum:** Bundle C or D recommended set + strict monthly audit cadence.
- **Recommended:** add explicit recurring evidence reviews in governance/reporting
  packets.
- **Deferred until later:** no current core checks are candidates for long-term
  deferral while this overlay is active — all controls must be kept live.
- **Advance from minimum to recommended when:** monthly audit findings are being
  captured in durable artifacts with issue-linked follow-up.
- **Why this fits:** audit-sensitive environments need repeatable, durable evidence.
- **Expected benefit:** stronger control traceability and reduced audit friction.
- **Maintenance cost:** high.
- **Prerequisites/maturity assumption:** Level 3-4 with stable ownership model.
- **Operator runbooks:** [Run the framework health audit](runbooks/run-the-framework-health-audit.md),
  [Handle security-sensitive intake](runbooks/handle-security-sensitive-intake.md),
  [Maintain framework alignment](runbooks/maintain-framework-alignment.md).

## Bundle comparison matrix

| Bundle | Baseline checks | Reliability checks | Queue checks/automation | Hygiene automation | Best when |
| --- | --- | --- | --- | --- | --- |
| A: Solo baseline | Yes | Limited | No | Optional | Low volume, one/few maintainers |
| B: Product delivery | Yes | Yes | Optional | Optional | Parallel product/docs delivery |
| C: Platform/infra | Yes | Yes | Yes | Recommended | Automation-heavy shared systems |
| D: Support-heavy | Yes | Yes | Yes (health first) | Optional | High intake/routing pressure |
| E: Governance overlay | Yes | Yes | Yes | Recommended | Audit/compliance-heavy operation |

## Profile + maturity chooser

| Profile context | Typical maturity start | First bundle stage | Next stage to add | Defer until |
| --- | --- | --- | --- | --- |
| Small repo / solo maintainer | Level 1 | Bundle A minimum | Bundle A recommended | Queue operations become a recurring workflow |
| Product delivery team | Level 2 | Bundle B minimum | Bundle B recommended | Queue-backed planning is routine (not experimental) |
| Platform / infrastructure team | Level 3 | Bundle C minimum | Bundle C recommended | Branch churn or stale-branch reports appear in audits |
| Support-heavy / intake-heavy team | Level 2 | Bundle D minimum | Bundle D recommended | Intake-to-queue linkage is stable and consistent |
| Governance/compliance-heavy operation | Level 3 | Bundle E minimum | Bundle E recommended | Never defer core controls once overlay is active |

## Staged enablement path (recommended order)

1. **Always first:** markdown workflow + security guardrail anchors.
2. **Then continuity reliability:** handoff packet + index checks.
3. **Then operations depth:** queue integrity + queue health.
4. **Then merge-time queue assist:** prepare-next-task workflow.
5. **Then hygiene extras:** stale-branch automation and stricter recurring reviews.

Do not skip directly to later stages without stable behavior in earlier stages.

## Baseline vs recommended vs advanced/situational

- **Baseline (all profiles):** markdown + link checks, security guardrail anchors,
  path-based labeling.
- **Recommended (most teams after MVP):** handoff packet enforcement, index
  parity checks, recurring framework audit.
- **Advanced/situational:** queue-preparation workflow, queue-health layer, stale
  branch cleanup, mobile quick-action enforcement (when mobile is an active surface).

## When not to enable automation yet

Delay a check/workflow if its required inventory or operating discipline does not
exist yet (for example queue automations without queue governance, or mobile
coverage checks without curated mobile guidance inventory).

Open bounded follow-up issues for each deferred automation item, and record
explicit enablement criteria.

## Least-privilege enablement guardrails

Before enabling any automation layer, confirm all of the following:

1. **Prerequisite inventory exists.** Each check targets specific artifacts. Enabling
   a check without the artifact it verifies produces false positives and erodes
   confidence.
   - Queue checks require an actively governed `.github/framework-task-queue.json`.
   - Index parity checks require maintained index files:
     `docs/adr/README.md`, `docs/runbooks/README.md`, `examples/README.md`.
   - Handoff packet check requires `docs/multi-agent-handoff-playbook.md` with a
     populated `## Handoff packet coverage` section.
   - Mobile quick-action check requires `docs/github-mobile-guide.md` with a
     tracked inventory section.

2. **Prefer scoped triggers over repo-wide triggers.** Use `on.push.paths` or
   `on.pull_request.paths` path filters to limit workflow scope to relevant changes.
   Do not enable schedules (cron) until the workflow has run successfully on-demand
   at least once.

3. **Do not enable queue operations automation before queue governance is
   operational.** Queue health and merge-triggered next-task preparation require
   an actively maintained queue file, timely state transitions, and a clear owner.

4. **Enable one new automation layer per bounded PR.** Validate that the new
   check is green before stacking another layer. Do not enable multiple workflows
   in one PR.

5. **Do not suppress or loosen guardrails to accelerate enablement.** If a check
   reveals a real gap, fix the gap (open a bounded issue) rather than bypassing
   the check. Bypasses must be documented in a durable ADR or issue, not left as
   silent exceptions.

6. **Never merge queue-operations automation changes without a passing local
   dry-run.** Run `bash scripts/check-framework-task-queue.sh` and
   `bash scripts/check-queue-health.sh` locally before pushing.

## Deferred automation registry

When deferring an automation item, capture it as a bounded follow-up issue
with the following fields in the issue body. Do not leave deferrals implicit
in PR comments.

```markdown
## Deferred automation item

- **Deferred item:** [name the workflow/check, e.g. "queue integrity check"]
- **Bundle stage:** [the bundle + stage this item belongs to, e.g. "Bundle C minimum"]
- **Defer reason:** [why it is not being enabled now — missing prerequisite, low ROI,
  overhead exceeds value at current team size]
- **Enablement criteria:** [the specific, observable condition that makes this item
  ready to enable, e.g. "queue file is actively governed with timely state transitions"]
- **Review trigger:** [when to reassess — next quarterly review, when a scale-up
  trigger from the profile pack fires, or a specific event]
- **Owner:** [who is responsible for reassessing this item]
```

Example issue title format:
`[Deferred automation] Enable <check/workflow> — enablement criteria: <brief criterion>`

## Safe customization boundaries

Safe to customize:

- trigger paths and schedules
- inventory file paths for scripts when repository layout differs
- ownership and review routing model

Do not customize away:

- durable artifact linkage requirements
- bounded PR and validation evidence expectations
- secure-routing and sanitized-public-context guardrails

## Follow-on packaging opportunities

- profile-specific workflow starter presets
- profile-aware bootstrap copy manifests
- optional script wrappers for target repos with differing docs structure

Keep these lightweight and opt-in; this framework remains governance-first, not
a heavyweight automation platform.

## Mobile quick action

- **Use when:** you need to choose or confirm automation depth from mobile.
- **Do from mobile:**
  - confirm current profile and maturity level.
  - capture one follow-up issue per deferred bundle item.
  - flag automation that is enabled without prerequisites.
- **Do not do from mobile:**
  - redesign bundle model or workflow policies in chat-only context.
  - enable multiple new workflows without desktop validation evidence.
- **Escalate to desktop/cloud when:**
  - bundle changes require coordinated workflow/script/docs updates.
  - queue/security/governance automation boundaries are being changed.
- **Primary artifact to update:**
  - the adoption or framework-change issue/PR tracking automation decisions.

## Related docs

- [Framework profile packs](framework-profile-packs.md)
- [Framework setup profiles and intent examples](framework-setup-profiles-and-intent-examples.md)
- [Framework setup intent schema and application model](framework-setup-intent-schema-and-application-model.md)
- [Framework adoption maturity model](framework-adoption-maturity-model.md)
- [Framework readiness checklist](framework-readiness-checklist.md)
- [Framework starter kit / bootstrap pack](framework-starter-kit.md)
- [Framework portability and adoption](framework-portability-and-adoption.md)
- [Work-type matrix](work-type-matrix.md)
- [Framework reporting and review cadence](framework-reporting-and-review-cadence.md)
- [Framework health](framework-health.md)
- [Governance checklist](governance-checklist.md)
- [Operate the framework task queue](runbooks/operate-framework-task-queue.md)
- [Run the queue health check](runbooks/run-queue-health-check.md)
