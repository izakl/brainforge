# Framework Health Check

A re-runnable audit that checks whether this repository still has all the documents,
scripts, and workflows Brain Factory expects — and whether they are current and
discoverable. The full set of expectations is the "continuity charter," defined in
[`docs/framework-continuity-and-memory.md`](framework-continuity-and-memory.md).
Re-run this audit after large changes, or on a regular cadence (monthly is a good
default). New to the project? See
[How Brain Factory works](how-brain-factory-works.md) first.

## How to use this document

- For the step-by-step procedure, see
  [Run the framework health audit](runbooks/run-the-framework-health-audit.md).
- Walk through each section below.
- For each artifact, confirm it exists, is current, and is linked from the right entry
  points (`README.md` and the continuity doc).
- Capture any gaps as issues or PRs; do not let them live only in chat or review comments.

## Charter-to-artifact map

Each row maps one charter expectation to the file (or files) that satisfies it. During
an audit, confirm each listed path still exists and remains current.

| Charter expectation | Artifact path | Status |
| --- | --- | --- |
| Agent/contributor entrypoint | `AGENTS.md` | ✅ Present |
| Continuity anchor | `docs/framework-continuity-and-memory.md` | ✅ Present |
| Portability/adoption layer | `docs/framework-portability-and-adoption.md` | ✅ Present |
| Starter-kit bootstrap layer | `docs/framework-starter-kit.md` | ✅ Present |
| Repo-transplant checklist layer | `docs/framework-repo-transplant-checklist.md` | ✅ Present |
| Adoption maturity model | `docs/framework-adoption-maturity-model.md` | ✅ Present |
| Framework readiness checklist layer | `docs/framework-readiness-checklist.md` | ✅ Present |
| Automation bundles by profile layer | `docs/framework-automation-bundles-by-profile.md` | ✅ Present |
| Setup intent schema/application model layer | `docs/framework-setup-intent-schema-and-application-model.md` | ✅ Present |
| Framework roadmap queue | `docs/framework-roadmap-next-prompts.md` | ✅ Present |
| Framework prompt library | `docs/framework-prompt-library.md` | ✅ Present |
| Machine-readable framework task queue | `.github/framework-task-queue.json` | ✅ Present |
| Copilot coding agent firewall/API-access guidance | `docs/gh-agents-and-automation.md` + queue docs/runbooks cross-links | ✅ Present |
| Queued execution memory model | `docs/framework-queued-execution-memory.md` | ✅ Present |
| Queue health / drift-detection layer | `scripts/check-queue-health.sh` + `docs/runbooks/run-queue-health-check.md` | ✅ Present |
| Metrics/feedback loop layer | `docs/framework-metrics-and-feedback.md` | ✅ Present |
| Reporting/review cadence layer | `docs/framework-reporting-and-review-cadence.md` | ✅ Present |
| Framework change governance/deprecation policy layer | `docs/framework-change-governance-and-deprecation-policy.md` | ✅ Present |
| Release/versioning/deprecation layer | `docs/framework-release-versioning-and-deprecation.md` | ✅ Present |
| Release notes / upgrade summary layer | `docs/framework-release-notes-and-upgrade-summaries.md` + `docs/framework-release-notes.md` + `docs/framework-change-summary-template.md` | ✅ Present |
| Review cadence packet template | `docs/framework-review-cadence-template.md` | ✅ Present |
| Effectiveness scorecard template | `docs/framework-effectiveness-scorecard-template.md` | ✅ Present |
| Weekly hygiene summary template | `docs/framework-weekly-hygiene-summary-template.md` | ✅ Present |
| Quarterly adoption/portability summary template | `docs/framework-quarterly-adoption-portability-summary-template.md` | ✅ Present |
| Operating model | `docs/operating-model.md` | ✅ Present |
| Governance checklist | `docs/governance-checklist.md` | ✅ Present |
| Multi-agent handoff | `docs/multi-agent-handoff-playbook.md` | ✅ Present |
| Context sync | `docs/context-synchronization.md` | ✅ Present |
| Security and secure delivery guardrails | `docs/security-and-secure-delivery.md` | ✅ Present |
| Projects setup | `docs/github-projects-setup.md` | ✅ Present |
| Work-type matrix | `docs/work-type-matrix.md` | ✅ Present |
| Support/improvement loop | `docs/product-support-and-improvement-loop.md` | ✅ Present |
| Branching/cleanup | `docs/branching-and-cleanup.md` | ✅ Present |
| Redevelopment playbook | `docs/redevelopment-playbook.md` | ✅ Present |
| Prompt cookbook | `docs/prompt-cookbook.md` | ✅ Present |
| Contributor environment | `docs/contributor-environment-guide.md` | ✅ Present |
| GitHub Mobile guide | `docs/github-mobile-guide.md` | ✅ Present |
| ADR template + log | `docs/adr-template-guide.md` + `docs/adr/README.md` | ✅ Present |
| Upgrade/adoption maintenance layer | `docs/framework-upgrade-and-maintenance.md` | ✅ Present |
| Alignment maintenance runbook | `docs/runbooks/maintain-framework-alignment.md` | ✅ Present |
| Operator runbooks | `docs/runbooks/README.md` | ✅ Present |
| Worked examples | `examples/README.md` | ✅ Present |
| External-context normalization example | `examples/worked-example-external-context-normalization.md` | ✅ Present |
| Downstream adoption worked examples | `examples/adoption-example-solo-small-repo.md`, `examples/adoption-example-product-delivery-team.md`, `examples/adoption-example-platform-infra-team.md` | ✅ Present |
| Example issue→PR flow | `docs/example-issue-to-pr-flow.md` | ✅ Present |
| Glossary | `docs/glossary.md` | ✅ Present |
| CONTRIBUTING | `CONTRIBUTING.md` | ✅ Present |
| LICENSE | `LICENSE` | ✅ Present |
| SECURITY | `SECURITY.md` | ✅ Present |
| CODEOWNERS | `.github/CODEOWNERS` | ✅ Present |
| CI guardrails | `.github/workflows/markdown.yml` | ✅ Present |
| Dependabot | `.github/dependabot.yml` | ✅ Present |
| PR auto-labeler | .github/workflows/labeler.yml + .github/labeler.yml | ✅ Present |
| Stale-branch cleanup | .github/workflows/stale-branches.yml | ✅ Present |
| Code of conduct | CODE_OF_CONDUCT.md | ✅ Present |
| Visual diagrams plan | docs/visual-diagrams-plan.md | ✅ Present |
| Visual diagrams convention | [docs/visual-diagrams-plan.md](visual-diagrams-plan.md) | ✅ In sync — rollout completed and convention formalized in [ADR 0010](adr/0010-diagrams-convention.md) |
| SVG companions in sync | [docs/diagrams/README.md](diagrams/README.md) | ✅ Governed by [ADR 0012](adr/0012-svg-companions-for-diagrams.md); verify companion parity during each health audit |
| Mobile quick action coverage | core docs, runbooks, examples (see inventory) | ✅ Governed by [ADR 0013](adr/0013-mobile-quick-action-convention.md); CI-enforced via `scripts/check-mobile-quick-action.sh`; inventory in [docs/github-mobile-guide.md](github-mobile-guide.md) |
| Mobile quick action CI + inventory | scripts/check-mobile-quick-action.* + docs/github-mobile-guide.md | ✅ CI enforcement + coverage inventory landed in PR #82 |
| Handoff packet template | `docs/handoff-packet-template.md` | ✅ Canonical template — all nine required fields present |
| Handoff packet enforcement | `scripts/check-handoff-packet.sh` + `.github/workflows/check-handoff-packet.yml` | ✅ Governed by [ADR 0015](adr/0015-handoff-packet-enforcement.md); CI-enforced; inventory in [docs/multi-agent-handoff-playbook.md](multi-agent-handoff-playbook.md) |
| Security guardrail check | `scripts/check-security-guardrails.sh` + `.github/workflows/check-security-guardrails.yml` | ✅ CI-enforced check for private-reporting and secure-delivery guardrail anchors |
| Index parity check | `scripts/check-index-parity.sh` + `.github/workflows/framework-audit.yml` | ✅ Governed by [ADR 0016](adr/0016-continuous-checks-layer.md); CI-enforced on PR + scheduled monthly; verifies ADR index, runbooks index, and examples index stay in sync |
| Scheduled framework audit | `.github/workflows/framework-audit.yml` | ✅ Monthly scheduled + `workflow_dispatch` consolidation of all framework check scripts; see [ADR 0016](adr/0016-continuous-checks-layer.md) |
| Merge-triggered next-task preparation | `.github/workflows/prepare-next-framework-task.yml` | ✅ Push-to-main + `workflow_dispatch` workflow prepares next dependency-ready queue task as an issue (human-in-the-loop for execution/review remains required) |
| Framework task queue integrity check | `scripts/check-framework-task-queue.sh` + `.github/workflows/framework-audit.yml` | ✅ CI-enforced queue schema/dependency validation |
| Queue health and drift detection | `scripts/check-queue-health.sh` + `.github/workflows/framework-audit.yml` | ✅ Governed by [ADR 0017](adr/0017-queue-health-check-layer.md); CI-enforced on PR + scheduled monthly; checks related_docs existence, blocked/pending state consistency, superseded-dep traps, multiple in_progress, and (with GitHub API context) merged-PR/open-issue closure drift |
| Issue templates | .github/ISSUE_TEMPLATE/ | ✅ Present |
| Issue taxonomy | `docs/issue-taxonomy.md` | ✅ Present |
| Support routing | .github/SUPPORT.md | ✅ Present |
| Pull request template | .github/pull_request_template.md | ✅ Present |
| Editor config | .editorconfig | ✅ Present |
| Git attributes | .gitattributes | ✅ Present |

See [ADR 0010: Diagrams convention](adr/0010-diagrams-convention.md) for the rules `## Diagram` sections follow.

## Automated vs manual checks

This table separates what CI verifies continuously from what still requires a manual
audit. Use it to set expectations during an audit and to spot where more automation
would help.

| Check | Automated | How |
| --- | --- | --- |
| Markdown linting | ✅ CI (PR + push) | `markdown.yml` → `markdownlint-cli2` |
| Markdown link check | ✅ CI (PR + push) | `markdown.yml` → `markdown-link-check` |
| SVG companion parity | ✅ CI (PR) | `check-svg-companions.yml` / `check-svg-companions.sh` |
| Mobile quick-action coverage | ✅ CI (PR + push) | `markdown.yml` / `check-mobile-quick-action.sh` |
| Handoff packet completeness | ✅ CI (PR + push) | `check-handoff-packet.yml` / `check-handoff-packet.sh` |
| Security guardrail anchors | ✅ CI (PR + push) | `check-security-guardrails.yml` / `check-security-guardrails.sh` |
| ADR index parity | ✅ CI (PR + monthly) | `framework-audit.yml` / `check-index-parity.sh` |
| Runbooks index parity | ✅ CI (PR + monthly) | `framework-audit.yml` / `check-index-parity.sh` |
| Examples index parity | ✅ CI (PR + monthly) | `framework-audit.yml` / `check-index-parity.sh` |
| Framework task queue integrity | ✅ CI (PR + monthly) | `framework-audit.yml` / `check-framework-task-queue.sh` |
| Queue health and drift detection | ✅ CI (PR + monthly) | `framework-audit.yml` / `check-queue-health.sh` |
| Stale branch cleanup | ✅ Scheduled (weekly) | `stale-branches.yml` |
| PR auto-labeling | ✅ Automated (PR) | `labeler.yml` |
| Next framework task issue preparation | ✅ Automated (push to `main`) | `prepare-next-framework-task.yml` |
| `docs/README.md` full index parity | 🔲 Manual | Health audit walkthrough |
| Cross-link discoverability | 🔲 Manual | Health audit walkthrough |
| Open PRs > 14 days | 🔲 Manual | Health audit walkthrough |
| Dependabot PR backlog | 🔲 Manual | Health audit walkthrough |
| CI on `main` green | 🔲 Manual | Review Actions tab |
| Latest effectiveness scorecard packet exists with linked follow-up actions | 🔲 Manual | Review latest effectiveness issue/PR packet |

## Operational hygiene checks

- [ ] CI on `main` is green — check the latest runs of
  [`.github/workflows/markdown.yml`](../.github/workflows/markdown.yml) from the repository's
  Actions tab.
- [ ] No stale `copilot/*` branches without an open PR — see
  [`docs/branching-and-cleanup.md`](branching-and-cleanup.md).
- [ ] No open PRs older than 14 days without status updates.
- [ ] ADR index parity, runbooks index, and examples index are green — automated by
  [`scripts/check-index-parity.sh`](../scripts/check-index-parity.sh) (runs monthly via
  [`framework-audit.yml`](../.github/workflows/framework-audit.yml) and on relevant PRs).
- [ ] Framework task queue integrity check is green — automated by
  [`scripts/check-framework-task-queue.sh`](../scripts/check-framework-task-queue.sh) (runs in
  [`framework-audit.yml`](../.github/workflows/framework-audit.yml)).
- [ ] Queue health and drift detection check is green — automated by
  [`scripts/check-queue-health.sh`](../scripts/check-queue-health.sh) (runs in
  [`framework-audit.yml`](../.github/workflows/framework-audit.yml)); see
  [`docs/runbooks/run-queue-health-check.md`](runbooks/run-queue-health-check.md)
  for bounded queue audit/reconciliation checks and recovery steps.
- [ ] Copilot coding agent firewall/API-access guidance remains current and cross-linked (`api.github.com` allowlist guidance, pre-firewall setup-step guidance, deterministic/manual fallback expectations) — see [`docs/gh-agents-and-automation.md`](gh-agents-and-automation.md), [`docs/framework-queued-execution-memory.md`](framework-queued-execution-memory.md), and [`docs/runbooks/operate-framework-task-queue.md`](runbooks/operate-framework-task-queue.md).
- [ ] After recent merges that touched queue state, the latest
  [`prepare-next-framework-task.yml`](../.github/workflows/prepare-next-framework-task.yml)
  run prepared (or intentionally skipped) the correct next queue item.
- [ ] Queue schema, issue-marker linkage, and state transitions remain aligned with
  [`docs/framework-queued-execution-memory.md`](framework-queued-execution-memory.md).
- [ ] `docs/README.md` index reflects the current state of `docs/`, `docs/runbooks/`,
  `examples/`, and `docs/adr/` — verify manually during audit.
- [ ] `README.md` and `AGENTS.md` "Core framework docs" / "Operator quick paths" links resolve.
- [ ] Work-type matrix guidance remains aligned with issue taxonomy, project routing, and support/metrics/adoption docs — see [`docs/work-type-matrix.md`](work-type-matrix.md).
- [ ] Portability/adoption guidance remains current for external adopters — see [`docs/framework-portability-and-adoption.md`](framework-portability-and-adoption.md).
- [ ] Starter-kit bootstrap guidance remains current and aligned with portability/profile/maturity docs — see [`docs/framework-starter-kit.md`](framework-starter-kit.md).
- [ ] Adoption maturity model remains aligned with portability phases, governance checks, and effectiveness review cadence — see [`docs/framework-adoption-maturity-model.md`](framework-adoption-maturity-model.md).
- [ ] Framework readiness checklist remains aligned with profile/maturity/automation/release/governance surfaces and remains lightweight (no heavy compliance ceremony) — see [`docs/framework-readiness-checklist.md`](framework-readiness-checklist.md).
- [ ] Setup intent schema/application model remains aligned with profile packs, automation bundles, portability/starter guidance, and executable setup goals — see [`docs/framework-setup-intent-schema-and-application-model.md`](framework-setup-intent-schema-and-application-model.md).
- [ ] Reporting/review cadence guidance remains aligned with health, governance, metrics, adoption, support loop, and project-routing guidance — see [`docs/framework-reporting-and-review-cadence.md`](framework-reporting-and-review-cadence.md).
- [ ] Framework component change/deprecation governance policy remains aligned with release, continuity, cadence, and checklist expectations — see [`docs/framework-change-governance-and-deprecation-policy.md`](framework-change-governance-and-deprecation-policy.md).
- [ ] Framework lifecycle model remains aligned with governance, continuity, health, and adoption guidance — see [`docs/framework-release-versioning-and-deprecation.md`](framework-release-versioning-and-deprecation.md).
- [ ] Framework release-notes index and summary model remain current and linked from lifecycle/upgrade guidance — see [`docs/framework-release-notes.md`](framework-release-notes.md) and [`docs/framework-release-notes-and-upgrade-summaries.md`](framework-release-notes-and-upgrade-summaries.md).
- [ ] Roadmap queue remains current and execution-ordered for the next major bounded framework tasks — see [`docs/framework-roadmap-next-prompts.md`](framework-roadmap-next-prompts.md).
- [ ] Prompt library remains curated, dependency-aware, and reusable for major bounded work packets — see [`docs/framework-prompt-library.md`](framework-prompt-library.md).
- [ ] Latest framework effectiveness review packet exists, includes evidence links, and captures follow-up issue ownership — see [`docs/framework-metrics-and-feedback.md`](framework-metrics-and-feedback.md) and [`docs/framework-effectiveness-scorecard-template.md`](framework-effectiveness-scorecard-template.md).
- [ ] GitHub Projects state model remains coherent: minimum viable fields are in use and status transitions align with issue/PR/handoff artifact state — see [`docs/github-projects-setup.md`](github-projects-setup.md).
- [ ] Dependabot PRs are being reviewed/merged (not piling up).
- [ ] Security guardrail check is green on latest relevant PRs — see
  [`.github/workflows/check-security-guardrails.yml`](../.github/workflows/check-security-guardrails.yml).

## Governance and review routing

- [ ] `CODEOWNERS` covers all paths — confirmed: `*`, `/docs/`, `/docs/adr/`,
  `/docs/framework-continuity-and-memory.md`, `/.github/`, `/.github/workflows/`
  are all mapped to `@izakl`.
- [ ] `SECURITY.md` private reporting path is current — confirmed: uses GitHub's private
  vulnerability reporting (Security tab → "Report a vulnerability").
- [ ] `docs/security-and-secure-delivery.md` remains aligned with issue templates, runbooks, and governance checklist.
- [ ] `docs/governance-checklist.md` cross-links CODEOWNERS and SECURITY.md — confirmed.

## Cross-link discipline

- [ ] Every doc in `docs/` is reachable from at least one of: `README.md`,
  `docs/framework-continuity-and-memory.md`, or another doc that itself is reachable.
- [ ] Markdown link-check job has been passing on the latest `main` runs of
  [`.github/workflows/markdown.yml`](../.github/workflows/markdown.yml).

## Snapshot (as of 2026-05-26, Copilot coding agent firewall/API guidance and queue-reconciliation writeback hardened)

At this snapshot, every charter-to-artifact row is **present**. Diagram governance
is covered by:

- [ADR 0009](adr/0009-mermaid-as-primary-diagram-format.md) (Mermaid as primary format)
- [ADR 0010](adr/0010-diagrams-convention.md) (diagram section convention)
- [ADR 0012](adr/0012-svg-companions-for-diagrams.md) (SVG companion convention)
- [ADR 0013](adr/0013-mobile-quick-action-convention.md) (mobile quick action section convention)
- [ADR 0015](adr/0015-handoff-packet-enforcement.md) (handoff packet enforcement)
- [ADR 0016](adr/0016-continuous-checks-layer.md) (continuous checks and recurring audit layer)
- [ADR 0017](adr/0017-queue-health-check-layer.md) (queue health check and drift-detection layer)

Companion parity should be re-validated as part of each health audit, with
`docs/diagrams/README.md` treated as the companion inventory.

Mobile quick-action coverage now also has a tracked inventory in
`docs/github-mobile-guide.md` and CI enforcement via `scripts/check-mobile-quick-action.sh`.

Portability/adoption guidance is now centralized in
`docs/framework-portability-and-adoption.md`, including core invariants,
essential/recommended/optional inventory, and incremental rollout guidance.

Starter-kit bootstrap guidance is now centralized in
`docs/framework-starter-kit.md`, including copy/adapt/customize mapping,
minimum viable bootstrap bundle, and phased first-hour/day/week onboarding.

Framework readiness guidance is now centralized in
`docs/framework-readiness-checklist.md`, adding a lightweight baseline /
recommended / advanced self-assessment model that helps adopters confirm
coherent, profile-aware, maturity-aware adoption without requiring full-surface
adoption.

Automation selection guidance is now centralized in
`docs/framework-automation-bundles-by-profile.md`, including baseline vs
recommended vs advanced/situational distinctions, explicit
minimum/recommended/deferred profile bundle staging, per-bundle advance criteria
and operator runbook linkage, a dedicated least-privilege enablement guardrails
section, and a deferred automation registry format for tracking deferred items
with durable enablement criteria and owner assignment.

Reusable entrypoint harmonization pass aligned issue templates, PR template,
prompt cookbook, examples index guidance, and issue/runbook discoverability
links with the current framework contract (work packet fields, normalization,
security routing, and canonical-vs-supporting guidance).

Framework effectiveness now has a dedicated metrics and feedback-loop layer in
`docs/framework-metrics-and-feedback.md`, with a reusable scorecard packet in
`docs/framework-effectiveness-scorecard-template.md`.

Recurring review/reporting rhythm now has a dedicated cadence layer in
`docs/framework-reporting-and-review-cadence.md`, with a reusable packet
template in `docs/framework-review-cadence-template.md`.

Compact weekly hygiene and quarterly adoption/portability writeback packets are
now available in `docs/framework-weekly-hygiene-summary-template.md` and
`docs/framework-quarterly-adoption-portability-summary-template.md`.

Framework lifecycle semantics are now centralized in
`docs/framework-release-versioning-and-deprecation.md`, including lightweight
`PATCH`/`MINOR`/`MAJOR` classification rules, release communication expectations,
explicit compatibility/migration/operator-action signaling, and deprecation
lifecycle guidance.

Framework release-note and upgrade-summary guidance now has a dedicated model in
`docs/framework-release-notes-and-upgrade-summaries.md`, a reusable packet in
`docs/framework-change-summary-template.md`, and a durable scan/index surface in
`docs/framework-release-notes.md`. Published summary packets are stored under
`docs/release-notes/` and linked from the index.

A durable next-prompts roadmap is now available in
`docs/framework-roadmap-next-prompts.md` to queue remaining major bounded framework-completion tasks.

A durable major-prompt library is now available in
`docs/framework-prompt-library.md` to preserve reusable execution packets with
explicit ordering/dependencies and bounded-scope guardrails.

A machine-readable queue now exists at `.github/framework-task-queue.json`, with merge-triggered
next-task issue preparation via `.github/workflows/prepare-next-framework-task.yml`.
Queue schema/dependency integrity is CI-validated by `scripts/check-framework-task-queue.sh`.
Canonical queue-entry schema, issue/PR linkage model, state semantics, and drift recovery are now
defined in `docs/framework-queued-execution-memory.md`.

Queue health and drift detection is now a dedicated CI-enforced layer:
`scripts/check-queue-health.sh` checks semantic drift signals (stale `related_docs` references,
`blocked`/`pending` state inconsistency, superseded-dependency traps, and multiple concurrent
`in_progress` entries) that the schema validator does not cover, and also checks
merged-PR/open-queue-issue closure drift when GitHub API context is available.
The operator runbook for queue health is `docs/runbooks/run-queue-health-check.md`.
Governed by [ADR 0017](adr/0017-queue-health-check-layer.md).

Copilot coding agent firewall/API-access behavior is now explicitly documented as an
operational concern: blocked `api.github.com` calls can suppress optional API-backed
queue closure/linkage checks in agent environments, so queue/issue reconciliation must
still be written back durably through bounded maintenance PRs. Guidance is centralized
in `docs/gh-agents-and-automation.md` and cross-linked to queue model/runbook docs.

GitHub Projects guidance is now explicit about minimum viable setup, durable
state synchronization across issue/project/PR/handoff, and work-type routing.

Handoff packet completeness now has a tracked inventory in
`docs/multi-agent-handoff-playbook.md` and CI enforcement via
`scripts/check-handoff-packet.sh`.

Security guardrails now have a dedicated framework guide
(`docs/security-and-secure-delivery.md`) and CI anchor check via
`scripts/check-security-guardrails.sh` and
`.github/workflows/check-security-guardrails.yml`.

- Mobile quick-action convention remains closed-loop and CI-enforced (guidance + inventory + script check).
- Handoff packet convention is now closed-loop and CI-enforced (template + issue template + inventory + script check).
- ADR 0014 (deployment/infrastructure scope) remains **Deferred** — framework stays doc/governance-only; revisit when a concrete consumer need arises.
- **Stale-branch hygiene first pass completed (2026-05-25):**
  - Branch inventory at pass start: **92 pre-existing `copilot/*` branches** with no open PRs (plus the current hygiene PR branch `copilot/bounded-stale-branch-hygiene`).
  - Workflow fix applied: `dry_run` values corrected from non-documented booleans to `"yes"`/`"no"` as required by the action; a `workflow_dispatch` input (`dry_run: boolean`, default `true`) added for safe first-run mode.
  - Decision rule for all 92 branches: all are historical Copilot agent branches whose work is integrated into `main`; none have open PRs; all meet the ≥7-day age criterion; all are safe for automated deletion via the first scheduled or manual workflow run.
  - The [`Stale Branches` workflow](../.github/workflows/stale-branches.yml) is now ready for first execution. Trigger via `workflow_dispatch` with `dry_run: true` to verify the list, then with `dry_run: false` to execute cleanup.
  - Next automated deletion cycle: next Monday 06:00 UTC (weekly cron), or earlier via manual dispatch.
  - Runbook updated: [`docs/runbooks/triage-stale-branch-report.md`](runbooks/triage-stale-branch-report.md) now includes `copilot/*`-specific decision rules, a first-run procedure, and a cadence table.
  - Branching guidance updated: [`docs/branching-and-cleanup.md`](branching-and-cleanup.md) now documents the `copilot/*` cleanup criteria and the dry-run dispatch mode.
- **Handoff packet enforcement landed (2026-05-25):**
  - Canonical template: [`docs/handoff-packet-template.md`](handoff-packet-template.md) — nine required fields, reusable by humans and agents.
  - Issue template: [`.github/ISSUE_TEMPLATE/handoff-packet.yml`](../.github/ISSUE_TEMPLATE/handoff-packet.yml) — GitHub-native form with all nine required fields.
  - Enforcement script: [`scripts/check-handoff-packet.sh`](../scripts/check-handoff-packet.sh) — reads inventory from playbook, verifies all required fields in Expected files.
  - CI workflow: [`.github/workflows/check-handoff-packet.yml`](../.github/workflows/check-handoff-packet.yml) — runs on PRs and push to main.
  - Governance: [`docs/governance-checklist.md`](governance-checklist.md) and [`docs/adr/0015-handoff-packet-enforcement.md`](adr/0015-handoff-packet-enforcement.md) updated.
  - Handoff completeness is no longer purely advisory.
- **Continuous-checks layer added (2026-05-25):**
  - New script: [`scripts/check-index-parity.sh`](../scripts/check-index-parity.sh) — CI-enforces that ADR index, runbooks index, and examples index stay in sync with their respective directories.
  - New workflow: [`.github/workflows/framework-audit.yml`](../.github/workflows/framework-audit.yml) — monthly scheduled + `workflow_dispatch` consolidation of all framework check scripts; a one-click full-framework audit.
  - ADR: [`docs/adr/0016-continuous-checks-layer.md`](adr/0016-continuous-checks-layer.md) — decision record documenting the continuous-checks model.
  - Automated vs manual check table added to this document (see [Automated vs manual checks](#automated-vs-manual-checks)).
  - Index parity is no longer purely a manual health-audit item.

**ADR log (`docs/adr/`):**

| File | Indexed in `docs/adr/README.md` |
| --- | --- |
| `0001-github-as-durable-control-plane.md` | ✅ Yes |
| `0002-multi-surface-hybrid-execution-model.md` | ✅ Yes |
| `0003-pull-requests-as-primary-control-gate.md` | ✅ Yes |
| `0004-markdown-ci-guardrail.md` | ✅ Yes |
| `0005-dependabot-for-github-actions.md` | ✅ Yes |
| `0006-codeowners-for-review-routing.md` | ✅ Yes |
| `0007-path-based-pr-auto-labeler.md` | ✅ Yes |
| `0008-stale-branch-cleanup-automation.md` | ✅ Yes |
| `0009-mermaid-as-primary-diagram-format.md` | ✅ Yes |
| `0010-diagrams-convention.md` | ✅ Yes |
| `0011-documentation-navigation.md` | ✅ Yes |
| `0012-svg-companions-for-diagrams.md` | ✅ Yes |
| `0013-mobile-quick-action-convention.md` | ✅ Yes |
| `0014-deployment-infrastructure-scope.md` | ✅ Yes — **Deferred**: framework stays doc/governance-only; revisit when a concrete consumer need arises. |
| `0015-handoff-packet-enforcement.md` | ✅ Yes |
| `0016-continuous-checks-layer.md` | ✅ Yes |

**Operational hygiene status:**

| Check | Status |
| --- | --- |
| CI on `main` green | ✅ Passing (latest `Markdown` run on `main` completed successfully; latest PR-branch `Check SVG companions` run also successful) |
| Stale `copilot/*` branches | ✅ First hygiene pass completed (2026-05-25): 92 pre-existing `copilot/*` branches inventoried, all with no open PRs, all safe for deletion. Workflow fixed and ready for first execution via `workflow_dispatch`. See [triage runbook](runbooks/triage-stale-branch-report.md) for first-run steps. |
| Open PRs > 14 days without update | ✅ None (no open PRs at review time) |
| ADR index complete | ✅ All 16 ADR files indexed (parity now CI-enforced via `check-index-parity.sh`) |
| Docs README index parity | ✅ Verified against docs/runbooks/examples/adr directories; runbooks and examples parity now CI-enforced |
| README links resolve | ✅ Verified (`AGENTS.md` added as new entrypoint; README.md and docs/README.md cross-linked) |
| Dependabot PRs piling up | ✅ No open PR backlog at review time |
| Runbook index complete | ✅ All runbook files indexed in docs/runbooks/README.md |

**Next audit due:** approximately 2026-06-25 or after the next large framework change.
Monthly scheduled audit: [`framework-audit.yml`](../.github/workflows/framework-audit.yml) runs on the first of each month; trigger on demand via `workflow_dispatch`.

## Mobile quick action

- **Use when:** you need a quick health-audit triage pass from mobile between full desktop audits.
- **Do from mobile:**
  - Spot-check key charter rows and hygiene checkboxes for obvious drift.
  - Open one focused issue per confirmed gap.
  - Leave an audit status note naming owner, scope, and next validation step.
- **Do not do from mobile:**
  - Mark a full health audit complete without desktop verification.
  - Perform broad status rewrites across multiple audit sections.
- **Escalate to desktop/cloud when:**
  - Findings require coordinated updates across docs, workflows, or automation.
  - Validation depends on full markdown lint/link-check and CI run investigation.
- **Primary artifact to update:**
  - The health-audit issue or pull request that records findings and closure evidence.

## Related docs

- [Operating model](operating-model.md) — how the framework runs day-to-day.
- [Product support and improvement loop](product-support-and-improvement-loop.md) — how signals flow back into the framework.
- [GitHub Projects setup](github-projects-setup.md) — minimum viable setup and state/routing model.
- [Framework continuity and memory](framework-continuity-and-memory.md) — what the framework remembers across sessions.
- [Framework metrics and feedback loop](framework-metrics-and-feedback.md) — practical indicators and recurring framework effectiveness review model.
- [Framework reporting and review cadence](framework-reporting-and-review-cadence.md) — practical recurring rhythm and writeback model for framework operation.
- [Framework change governance and deprecation policy](framework-change-governance-and-deprecation-policy.md) — canonical lifecycle governance policy for introducing/changing/retiring framework components.
- [Framework weekly hygiene summary template](framework-weekly-hygiene-summary-template.md) — concise reusable packet for weekly hygiene writeback.
- [Framework quarterly adoption and portability summary template](framework-quarterly-adoption-portability-summary-template.md) — concise reusable packet for quarterly adoption/portability writeback.
- [Framework release/versioning/deprecation model](framework-release-versioning-and-deprecation.md) — lightweight lifecycle semantics for framework changes and adopter communication.
- [Framework roadmap: next GitHub agent prompts](framework-roadmap-next-prompts.md) — durable ordered queue of next major bounded framework-completion tasks.
- [Framework prompt library and execution queue](framework-prompt-library.md) — durable catalog of major reusable prompts with practical execution metadata.
- [Framework queued execution memory](framework-queued-execution-memory.md) — canonical queue schema, linkage model, state transitions, and drift-recovery governance.
- [GH agents and automation](gh-agents-and-automation.md) — execution-surface guardrails, including Copilot coding agent firewall/API-access mitigation guidance.
- [Framework adoption maturity model](framework-adoption-maturity-model.md) — staged adoption depth model and lightweight progression checklist.
- [Framework setup intent schema and application model](framework-setup-intent-schema-and-application-model.md) — durable setup contract for setup intent fields, profile/default mapping, expected setup outputs, and ready-to-work success criteria.
- [Framework repo-transplant checklist](framework-repo-transplant-checklist.md) — strict phase-gated migration control list with required evidence, assumption capture, and validation gates.
- [Framework automation bundles by profile](framework-automation-bundles-by-profile.md) — profile-aware staged automation/check/workflow bundle guidance with tradeoffs and maturity assumptions.
- [Branching and cleanup](branching-and-cleanup.md) — branch lifecycle and stale-branch handling.
- [Governance checklist](governance-checklist.md) — periodic audit items.
