# Framework Reporting and Review Cadence

This guide is for maintainers and operators of Brain Factory's shared framework. It sets a lightweight, recurring review rhythm — who reviews what, how often, and where the results are recorded — so the framework stays healthy without reporting bureaucracy. New to the project? Start with [Brain Factory: how it works](how-brain-factory-works.md).

## Purpose

Other docs cover **what** to check (governance, health, metrics, adoption, routing). This one covers **when and how** to review those signals and write the results back into durable GitHub artifacts.

It defines practical review rhythms, owners, required artifacts, and expected
outputs so teams can review consistently over time.

## Design principles (lightweight by default)

1. Reuse existing GitHub-native artifacts before creating new reporting assets.
2. Keep one bounded review packet per cadence event.
3. Favor trends and exceptions over dashboard volume.
4. Open one issue per actionable finding.
5. Keep cadence strict enough to catch drift, but small enough to sustain.

## Cadence matrix

| Rhythm | Primary purpose | Inputs (existing artifacts) | Typical owner | Required output | Writeback path |
| --- | --- | --- | --- | --- | --- |
| Per PR / per change | Confirm bounded scope, quality gates, and constraint preservation before merge | Issue + PR packet, checks, review comments, handoff links | PR author + reviewer | Merge decision with validation evidence | PR discussion + linked issue updates |
| Weekly hygiene review | Catch operational drift early | Stale-branch report, blocked/follow-up project views, aging PRs, support triage flow | Operator/maintainer on rotation | Weekly hygiene note with top gaps | Issue comment or weekly hygiene issue; one follow-up issue per gap |
| Monthly framework health review | Verify charter-to-artifact integrity and governance alignment | `framework-health.md`, governance checklist, framework audit workflow runs | Framework maintainer | Updated health snapshot + finding list | Health-audit issue/PR + linked remediation issues |
| Monthly effectiveness review | Evaluate quality/outcome trends and conversion to improvements | Metrics guide signals + scorecard template + support/improvement evidence | Framework owner or delegate | One completed effectiveness scorecard packet | Review issue/PR + bounded follow-up issues/PRs |
| Quarterly adoption and portability review | Assess maturity progression and cross-repo adoption quality | Adoption maturity model, portability guidance, scorecard trends | Framework owner + adopter representatives | Quarterly adoption review packet | Adoption issue(s), docs/template updates, optional ADR |
| Event-driven review | Learn quickly after incidents, security findings, or process failures | Incident/support/security artifacts, failed checks, post-incident notes | Incident/security/process owner | Focused review note with root causes and controls | Security advisory/public tracker + remediation issue/PR/ADR |

## What to review at each cadence

### 1) Per PR / per change

Minimum checks:

- issue packet completeness and scope clarity
- PR boundedness and explicit non-goals
- validation evidence present and relevant checks green
- constraint carry-forward from issue to PR
- follow-up capture for deferred scope

Primary artifacts:

- source issue
- pull request
- linked workflow runs

### 2) Weekly hygiene review

Focus on drift and queue quality:

- stale branch findings and cleanup closure
- open PR aging and review responsiveness
- blocked project items and unblock ownership
- follow-up/deferred queue age and owner clarity
- support intake routing quality (`Intake` → `Triage` → routed work)

Primary artifacts:

- stale-branches workflow output
- GitHub Projects hygiene views
- active PR list and linked issues

### 3) Monthly framework health review

Focus on framework coherence:

- charter-to-artifact map remains accurate
- automated framework checks are green and meaningful
- manual audit items still covered and current
- discoverability/cross-link integrity from entrypoints
- governance/security routing references remain aligned

Primary artifacts:

- `docs/framework-health.md`
- `docs/governance-checklist.md`
- `.github/workflows/framework-audit.yml` runs

### 4) Monthly effectiveness review

Focus on outcomes and improvement loop quality:

- leading/lagging/guardrail signal direction
- recurring failure modes or repeated governance findings
- support-to-improvement conversion quality
- action closure quality from prior review cycle

Primary artifacts:

- `docs/framework-metrics-and-feedback.md`
- `docs/framework-effectiveness-scorecard-template.md`

### 5) Quarterly adoption and portability review

Focus on adoption depth and transferability:

- maturity levels by dimension and lowest-level gaps
- preservation of framework invariants in adopted repos
- portability pain points and missing guidance/templates
- candidate standardization opportunities

Primary artifacts:

- `docs/framework-adoption-maturity-model.md`
- `docs/framework-portability-and-adoption.md`

### 6) Event-driven review

Trigger when one of these occurs:

- security-sensitive finding or routing failure
- major incident tied to process/control failure
- repeated CI/check regression pattern
- repeated handoff/constraint loss pattern

Primary artifacts:

- security advisory and/or sanitized tracker issue
- incident/support issue chain
- remediation PR(s) and optional ADR

## Work-type-specific variation (keep rigor proportional)

- **Security-sensitive / automation-risk work:** escalate immediately to
  event-driven review in addition to regular cadence.
- **Docs-only changes:** keep cadence lightweight; focus on discoverability,
  cross-links, and guidance clarity.
- **Framework/process changes:** include weekly hygiene and monthly health
  checkpoints before closure, and verify lifecycle handling against
  [`framework-change-governance-and-deprecation-policy.md`](framework-change-governance-and-deprecation-policy.md).
- **Redevelopment work:** run event-driven reviews at phase boundaries and
  include results in monthly effectiveness packets.

Use [Work-type matrix](work-type-matrix.md) to choose the stricter path when
categories overlap.

## Required writeback pattern

Every cadence review should produce durable writeback:

1. one bounded review packet or note (not chat-only)
2. one issue per actionable finding
3. linked PR(s) for implemented fixes
4. doc/runbook/template updates when guidance changes
5. optional ADR for architecture/process policy changes
6. explicit deprecation-state/replacement-target writeback for lifecycle events affecting framework docs/templates/scripts/workflows

If findings are non-actionable, explicitly record why no action is needed.

## Completed packet location conventions

Use one primary durable location per cadence packet:

- **Weekly hygiene:** issue body or dated issue comment in a weekly hygiene issue.
- **Monthly/quarterly packets tied to one bounded implementation:** PR
  description/comment, with linked follow-up issues.
- **Cross-repo or broad synthesis-first reviews:** discussion first, then
  normalize outcomes into issue(s)/PR(s)/ADR(s) before closure.

## Suggested operating rhythm (starter profile)

Use this default profile unless team constraints require adjustment.
For profile-specific scaling guidance, see
[Framework profile packs](framework-profile-packs.md):
for automation/check/workflow bundle selection, pair with
[Framework automation bundles by profile](framework-automation-bundles-by-profile.md).

- **Per change:** PR continuity checks and validation evidence (always)
- **Weekly:** 15-30 minute hygiene pass
- **Monthly:** health audit + effectiveness scorecard
- **Quarterly:** adoption/portability maturity review
- **Event-driven:** within 24-72 hours after major incident/finding

If a team cannot sustain all rhythms, keep per-change + weekly + monthly first.

## Review packet template

Use:

- [Framework weekly hygiene summary template](framework-weekly-hygiene-summary-template.md)
- [Framework quarterly adoption and portability summary template](framework-quarterly-adoption-portability-summary-template.md)
- [Framework cadence review template](framework-review-cadence-template.md)
- [Framework effectiveness scorecard template](framework-effectiveness-scorecard-template.md)

## Mobile quick action

- **Use when:** you need to capture or route a cadence finding quickly.
- **Do from mobile:**
  - record one concise finding with evidence link
  - open one follow-up issue per actionable gap
  - assign owner and next review touchpoint
- **Do not do from mobile:**
  - run full cross-artifact synthesis for monthly/quarterly reviews
  - close major findings without durable evidence links
- **Escalate to desktop/cloud when:**
  - findings span multiple docs, workflows, or project views
  - root-cause analysis requires broad artifact correlation
- **Primary artifact to update:**
  - the active cadence review issue or pull request

## Related docs

- [Framework health](framework-health.md)
- [Governance checklist](governance-checklist.md)
- [Framework metrics and feedback loop](framework-metrics-and-feedback.md)
- [Framework weekly hygiene summary template](framework-weekly-hygiene-summary-template.md)
- [Framework quarterly adoption and portability summary template](framework-quarterly-adoption-portability-summary-template.md)
- [Framework effectiveness scorecard template](framework-effectiveness-scorecard-template.md)
- [Framework adoption maturity model](framework-adoption-maturity-model.md)
- [Framework portability and adoption](framework-portability-and-adoption.md)
- [Framework profile packs](framework-profile-packs.md)
- [Framework automation bundles by profile](framework-automation-bundles-by-profile.md)
- [Framework change governance and deprecation policy](framework-change-governance-and-deprecation-policy.md)
- [GitHub Projects setup](github-projects-setup.md)
- [Product support and improvement loop](product-support-and-improvement-loop.md)
- [Work-type matrix](work-type-matrix.md)
