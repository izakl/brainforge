# AGENTS.md — Operational Entrypoint

This file is the minimum operating contract for coding agents and new contributors.
Read this before touching the repository. Go deeper into the linked docs as work requires.
If you need a practical first-time day-0/day-1 path, use
[`docs/operator-onboarding-pack.md`](docs/operator-onboarding-pack.md) after this file.

## What this repository is

A reusable framework for AI-assisted software delivery across multiple agent surfaces and
participation modes, with GitHub as the durable control plane.
It covers delivery, governance, support routing, handoff contracts, and continuous improvement.

Full context: [`docs/framework-continuity-and-memory.md`](docs/framework-continuity-and-memory.md)

## Non-negotiable rules

1. **GitHub artifacts are the system of record.** Implementation depends on durable GitHub
   artifacts — issues, PRs, ADRs, discussions — not on chat memory or private notes.
2. **Normalize external context before acting.** Output from external AI agents or local notes
   must be promoted into a GitHub artifact before implementation or review continues.
3. **Keep PRs bounded.** One objective per PR. Small, reviewable, cleanly closable.
4. **Preserve constraints across handoffs.** Objective, context, constraints, acceptance
   criteria, and validation evidence must survive every agent-to-agent or human-to-agent
   transition.
5. **Do not reintroduce undocumented or chat-only execution patterns.** If a new workflow,
   work type, or execution mode is added, update the surrounding framework so it stays coherent.
6. **Branch cleanup is required.** Delete branches after PR merge. Stale branches are cleaned
   automatically by the weekly workflow; do not accumulate them.

## Permanent framework operating standards

### SYNC-LATEST-FIRST STANDARD (required)

- Before starting any work in a repo or lane (state reads for decisions, session creation, or
  changes), sync to the latest online default branch first (`git fetch`; base work on
  `origin/<default>`). Local clones are stale until proven current.
- Every new work session branches from an up-to-date default branch.
- When working directly in a lane brain, re-sync that lane before touching it.
- Before merge, verify the PR is mergeable against the current online default branch.
- On session start/rehydration, refresh managed lanes from online before reporting or acting.

### CLEANUP-NO-STALE-STATE STANDARD (required)

- Cleanup triad: remote **BRANCH**, local **WORKTREE**, owning **SESSION**.
- Tear down the full triad together after merge; do not leave stale branches, worktrees, or
  sessions lingering.
- Session definition by toolchain:
  - GitHub Copilot: the app/project session and its worktree.
  - Claude Code: the conversation/session workspace.
- Apply a no-loss gate before deleting any triad element (branch/worktree/session): if unique
  unmerged content exists, preserve/escalate instead of deleting.
- Maintain periodic stale-state audits and flag:
  - merged-but-undeleted branches
  - branches with no open PR
  - orphaned worktrees
  - orphaned sessions (completed/abandoned sessions still lingering)
- Target steady state: one active worktree and one active session per active task.

### CONTINUITY-CAPTURE / BRAIN-MEMORY WRITEBACK STANDARD (required)

- For any work executed in lane-owned repositories (product/runtime or governance),
  the lane brain must record continuity/memory with:
  - **WHAT** changed
  - **WHY** it changed (trigger/feedback)
  - **WHERE** it changed (repo + PR/commit)
  - **OUTCOME** (validation + merge status)
- This binds orchestrator behavior especially: after directing or executing lane work
  (including runtime/product fixes), write back to the lane brain continuity ledger and
  master session index.
- A lane change with no corresponding brain continuity entry is a defect (memory loss).
- Capture timing:
  - at start / PR open: in-progress continuity entry
  - at merge: finalized outcome entry
- Cross-reference where practical: product/runtime PR links to brain entry, and brain entry
  links back to the product/runtime PR.
- No-loss continuity invariant: lane brain memory must reflect reality across all lane repos,
  not only governance repos.

## How to start work safely

1. **Check for an existing issue or ADR** that scopes the work. If none exists, open one using the canonical issue-type guidance in [`docs/issue-taxonomy.md`](docs/issue-taxonomy.md) and [`docs/runbooks/open-an-issue.md`](docs/runbooks/open-an-issue.md).
2. **Confirm the work packet is complete** before starting implementation:
   - objective, context, constraints, acceptance criteria, validation steps, owner.
3. **Choose the right execution surface** (see [Operating model](docs/operating-model.md)):
   - VS Code Copilot local — deep implementation, local validation.
   - GitHub Copilot Chat / Coding Agent — bounded repository tasks.
   - GH CLI — scripted triage, routing, maintenance.
   - External AI — discovery/synthesis only; normalize output into GitHub before acting.
   - Fast startup path by surface: [`docs/runbooks/surface-specific-startup-guides.md`](docs/runbooks/surface-specific-startup-guides.md).
4. **Run CI checks locally before pushing** (see [Validation](#validation)).

For step-by-step start procedures: [`docs/runbooks/start-a-framework-change.md`](docs/runbooks/start-a-framework-change.md)

## Durable artifact expectations

Every meaningful unit of work should be captured in at least one GitHub artifact:

| Stage | Artifact |
| --- | --- |
| Planning / scoping | Issue (with objective, context, constraints, acceptance criteria, validation) |
| Architecture / process decision | ADR in `docs/adr/` |
| Implementation | Pull request (objective, constraints, validation evidence, out-of-scope notes) |
| Early discovery | Discussion (before scope is bounded enough for an issue) |
| Status / routing | Project item or issue comment |

Rule: do not force execution-relevant context to live only in project comments or mobile notes.
Promote it into an issue, PR, ADR, or discussion.

## Handoff packet expectations

When work moves between agents or surfaces, preserve at minimum:

| Field | Required? |
| --- | --- |
| Objective | Yes |
| Context | Yes |
| Constraints | Yes |
| Acceptance criteria | Yes |
| Validation expectations | Yes |
| Related artifacts | Yes |
| Next owner | Yes |
| Status / current state | Yes |
| Unresolved risks / questions | Yes |

Use the canonical template: [`docs/handoff-packet-template.md`](docs/handoff-packet-template.md)

Handoff completeness is CI-enforced via `scripts/check-handoff-packet.sh`.
See [ADR 0015](docs/adr/0015-handoff-packet-enforcement.md) for the decision record.

## Validation

Before merging, confirm all checks pass:

```bash
# Markdown lint
npx -y markdownlint-cli2 "**/*.md"

# Markdown link check (one file at a time)
npx -y markdown-link-check -q -c .github/markdown-link-check.json <file>

# Mobile quick-action coverage (ADR 0013)
bash scripts/check-mobile-quick-action.sh

# Handoff packet completeness (ADR 0015)
bash scripts/check-handoff-packet.sh

# Security guardrail anchors
bash scripts/check-security-guardrails.sh

# CodeQL action component version alignment
bash scripts/check-codeql-action-versions.sh
bash scripts/test-codeql-action-versions.sh

# ADR / runbooks / examples index parity (ADR 0016)
bash scripts/check-index-parity.sh

# Framework task queue integrity
bash scripts/check-framework-task-queue.sh

# Queue health and drift detection (ADR 0017)
bash scripts/check-queue-health.sh

# Python unit tests (brainfactory package)
bash scripts/check-python-tests.sh
```

CI runs all of these automatically on PRs and pushes to `main`.
A consolidated scheduled audit also runs monthly via
[`.github/workflows/framework-audit.yml`](.github/workflows/framework-audit.yml)
and can be triggered on demand via `workflow_dispatch`.

## When to escalate to deeper docs

| Situation | Go to |
| --- | --- |
| Choosing the correct issue template and work type | [`docs/issue-taxonomy.md`](docs/issue-taxonomy.md) and [`docs/runbooks/open-an-issue.md`](docs/runbooks/open-an-issue.md) |
| Understanding the full operating lifecycle from bootstrap through resume | [`docs/runbooks/framework-lifecycle-map.md`](docs/runbooks/framework-lifecycle-map.md) |
| Making major setup/readiness/work/handoff/resume transitions explicit with lightweight event-style acknowledgments | [`docs/framework-state-milestones.md`](docs/framework-state-milestones.md) |
| Finding the latest continuity snapshot, handoff packet, readiness evidence, and queue/deferred posture quickly | [`docs/framework-continuity-artifact-indexing.md`](docs/framework-continuity-artifact-indexing.md) |
| Creating or refreshing structured handoff/resume state quickly | [`docs/framework-continuity-snapshot-template.md`](docs/framework-continuity-snapshot-template.md) and [`docs/runbooks/create-continuity-snapshot.md`](docs/runbooks/create-continuity-snapshot.md) |
| Resuming paused work safely from a handoff packet | [`docs/runbooks/resume-from-handoff-packet.md`](docs/runbooks/resume-from-handoff-packet.md) |
| First time in the repo | [`docs/framework-continuity-and-memory.md`](docs/framework-continuity-and-memory.md) |
| Choosing execution surface / work mode | [`docs/operating-model.md`](docs/operating-model.md) |
| Handoff between agents or surfaces | [`docs/multi-agent-handoff-playbook.md`](docs/multi-agent-handoff-playbook.md) |
| External context that needs normalization | [`docs/context-synchronization.md`](docs/context-synchronization.md) |
| Making an architecture or process decision | [`docs/adr-template-guide.md`](docs/adr-template-guide.md) |
| Support / product signal routing | [`docs/product-support-and-improvement-loop.md`](docs/product-support-and-improvement-loop.md) |
| Prompt or agent task framing | [`docs/prompt-cookbook.md`](docs/prompt-cookbook.md) |
| Choosing the right framework path by work type | [`docs/work-type-matrix.md`](docs/work-type-matrix.md) |
| Project routing, status model, and operational visibility | [`docs/github-projects-setup.md`](docs/github-projects-setup.md) |
| Bootstrapping this framework into another repo with minimum guesswork | [`docs/framework-starter-kit.md`](docs/framework-starter-kit.md) |
| Running a strict gate-based framework transplant with required evidence | [`docs/framework-repo-transplant-checklist.md`](docs/framework-repo-transplant-checklist.md) |
| Porting this framework to another repo/team | [`docs/framework-portability-and-adoption.md`](docs/framework-portability-and-adoption.md) |
| Assessing adoption maturity and next-step improvements | [`docs/framework-adoption-maturity-model.md`](docs/framework-adoption-maturity-model.md) |
| Running a lightweight readiness check for coherent/right-sized adoption | [`docs/framework-readiness-checklist.md`](docs/framework-readiness-checklist.md) |
| Choosing a profile for your team/repository context | [`docs/framework-profile-packs.md`](docs/framework-profile-packs.md) |
| Choosing practical automation/check/workflow bundles by profile and maturity | [`docs/framework-automation-bundles-by-profile.md`](docs/framework-automation-bundles-by-profile.md) |
| Defining durable setup intent, profile/default mapping, setup outputs, and ready-to-work criteria | [`docs/framework-setup-intent-schema-and-application-model.md`](docs/framework-setup-intent-schema-and-application-model.md) |
| Choosing concrete setup profiles and setup-intent example artifacts | [`docs/framework-setup-profiles-and-intent-examples.md`](docs/framework-setup-profiles-and-intent-examples.md) |
| Running a single end-to-end bootstrap path from natural-language setup needs to ready-to-work validation | [`docs/runbooks/prompt-to-setup-bootstrap.md`](docs/runbooks/prompt-to-setup-bootstrap.md) |
| Applying a setup intent and confirming a coherent ready-to-work state | [`docs/runbooks/apply-framework-setup.md`](docs/runbooks/apply-framework-setup.md) and [`docs/runbooks/apply-setup.md`](docs/runbooks/apply-setup.md) |
| Governing framework component introduction/change/deprecation/removal | [`docs/framework-change-governance-and-deprecation-policy.md`](docs/framework-change-governance-and-deprecation-policy.md) |
| Seeing concrete adoption examples by team/repo type or bounded onboarding/upgrade flow | [`examples/README.md`](examples/README.md), including [`examples/adoption-example-starter-kit-bootstrap-flow.md`](examples/adoption-example-starter-kit-bootstrap-flow.md) and [`examples/adoption-example-profile-upgrade-small-to-product.md`](examples/adoption-example-profile-upgrade-small-to-product.md) |
| Understanding framework release/version/deprecation expectations, compatibility signaling, and operator upgrade action expectations | [`docs/framework-release-versioning-and-deprecation.md`](docs/framework-release-versioning-and-deprecation.md) |
| Scanning recent framework changes and upgrade impact quickly | [`docs/framework-release-notes.md`](docs/framework-release-notes.md) and [`docs/framework-release-notes-and-upgrade-summaries.md`](docs/framework-release-notes-and-upgrade-summaries.md) |
| Choosing the next major bounded framework-completion task | [`docs/framework-roadmap-next-prompts.md`](docs/framework-roadmap-next-prompts.md) |
| Reusing major GitHub agent prompts with durable execution metadata | [`docs/framework-prompt-library.md`](docs/framework-prompt-library.md) |
| Finding the next major framework prompts in Ready now/Later execution order | [`docs/framework-next-monster-prompts.md`](docs/framework-next-monster-prompts.md) |
| Issue-backed queue schema/linkage and drift-recovery governance | [`docs/framework-queued-execution-memory.md`](docs/framework-queued-execution-memory.md) |
| Operating merge-driven next-task preparation and queue recovery | [`docs/runbooks/operate-framework-task-queue.md`](docs/runbooks/operate-framework-task-queue.md) |
| Detecting and recovering from queue drift with bounded audit/reconciliation across queue↔issue↔PR↔automation state | [`docs/runbooks/run-queue-health-check.md`](docs/runbooks/run-queue-health-check.md) |
| Handling Copilot coding agent firewall/API-access restrictions | [`docs/gh-agents-and-automation.md`](docs/gh-agents-and-automation.md), [`docs/framework-queued-execution-memory.md`](docs/framework-queued-execution-memory.md), and [`docs/runbooks/operate-framework-task-queue.md`](docs/runbooks/operate-framework-task-queue.md) |
| Queue closure/linkage closeout hygiene after merges | [`docs/runbooks/operate-framework-task-queue.md`](docs/runbooks/operate-framework-task-queue.md), [`docs/runbooks/run-queue-health-check.md`](docs/runbooks/run-queue-health-check.md), and [`docs/framework-upgrade-and-maintenance.md`](docs/framework-upgrade-and-maintenance.md) |
| Staying aligned with framework changes as a downstream adopter | [`docs/framework-upgrade-and-maintenance.md`](docs/framework-upgrade-and-maintenance.md) and [`docs/runbooks/maintain-framework-alignment.md`](docs/runbooks/maintain-framework-alignment.md) |
| Measuring framework effectiveness and review cadence | [`docs/framework-metrics-and-feedback.md`](docs/framework-metrics-and-feedback.md) |
| Running recurring reporting and review rhythms | [`docs/framework-reporting-and-review-cadence.md`](docs/framework-reporting-and-review-cadence.md) |
| Writing compact weekly hygiene summaries | [`docs/framework-weekly-hygiene-summary-template.md`](docs/framework-weekly-hygiene-summary-template.md) |
| Writing compact quarterly adoption/portability summaries | [`docs/framework-quarterly-adoption-portability-summary-template.md`](docs/framework-quarterly-adoption-portability-summary-template.md) |
| Security-sensitive intake or remediation | [`docs/security-and-secure-delivery.md`](docs/security-and-secure-delivery.md) |
| Governance / audit | [`docs/governance-checklist.md`](docs/governance-checklist.md) |
| Framework health snapshot | [`docs/framework-health.md`](docs/framework-health.md) |
| Full documentation index | [`docs/README.md`](docs/README.md) |

## Key references

- **Framework lifecycle map and operator journey:** [`docs/runbooks/framework-lifecycle-map.md`](docs/runbooks/framework-lifecycle-map.md)
- **Continuity snapshot runbook:** [`docs/runbooks/create-continuity-snapshot.md`](docs/runbooks/create-continuity-snapshot.md)
- **Resume-from-handoff runbook:** [`docs/runbooks/resume-from-handoff-packet.md`](docs/runbooks/resume-from-handoff-packet.md)
- **Upgrade/adoption maintenance guide:** [`docs/framework-upgrade-and-maintenance.md`](docs/framework-upgrade-and-maintenance.md)
- **Continuity anchor:** [`docs/framework-continuity-and-memory.md`](docs/framework-continuity-and-memory.md)
- **Continuity artifact indexing guidance:** [`docs/framework-continuity-artifact-indexing.md`](docs/framework-continuity-artifact-indexing.md)
- **Continuity snapshot template:** [`docs/framework-continuity-snapshot-template.md`](docs/framework-continuity-snapshot-template.md)
- **Portability/adoption guide:** [`docs/framework-portability-and-adoption.md`](docs/framework-portability-and-adoption.md)
- **Starter kit / bootstrap pack:** [`docs/framework-starter-kit.md`](docs/framework-starter-kit.md)
- **Repo-transplant checklist:** [`docs/framework-repo-transplant-checklist.md`](docs/framework-repo-transplant-checklist.md)
- **Adoption maturity model:** [`docs/framework-adoption-maturity-model.md`](docs/framework-adoption-maturity-model.md)
- **Framework readiness checklist:** [`docs/framework-readiness-checklist.md`](docs/framework-readiness-checklist.md)
- **Framework profile packs:** [`docs/framework-profile-packs.md`](docs/framework-profile-packs.md)
- **Automation bundles by profile:** [`docs/framework-automation-bundles-by-profile.md`](docs/framework-automation-bundles-by-profile.md)
- **Setup intent schema/application model:** [`docs/framework-setup-intent-schema-and-application-model.md`](docs/framework-setup-intent-schema-and-application-model.md)
- **Setup profiles and intent examples:** [`docs/framework-setup-profiles-and-intent-examples.md`](docs/framework-setup-profiles-and-intent-examples.md)
- **Prompt-to-setup bootstrap runbook:** [`docs/runbooks/prompt-to-setup-bootstrap.md`](docs/runbooks/prompt-to-setup-bootstrap.md)
- **Apply-setup runbooks:** [`docs/runbooks/apply-framework-setup.md`](docs/runbooks/apply-framework-setup.md) and [`docs/runbooks/apply-setup.md`](docs/runbooks/apply-setup.md)
- **Framework change governance/deprecation policy:** [`docs/framework-change-governance-and-deprecation-policy.md`](docs/framework-change-governance-and-deprecation-policy.md)
- **Release/versioning/deprecation model (with compatibility and migration/action signaling):** [`docs/framework-release-versioning-and-deprecation.md`](docs/framework-release-versioning-and-deprecation.md)
- **Release notes and upgrade-summary model:** [`docs/framework-release-notes-and-upgrade-summaries.md`](docs/framework-release-notes-and-upgrade-summaries.md)
- **Release notes index:** [`docs/framework-release-notes.md`](docs/framework-release-notes.md)
- **Framework roadmap queue:** [`docs/framework-roadmap-next-prompts.md`](docs/framework-roadmap-next-prompts.md)
- **Framework prompt library:** [`docs/framework-prompt-library.md`](docs/framework-prompt-library.md)
- **Next major framework prompts (no queue machinery):** [`docs/framework-next-monster-prompts.md`](docs/framework-next-monster-prompts.md)
- **GH agents + firewall/API guidance:** [`docs/gh-agents-and-automation.md`](docs/gh-agents-and-automation.md)
- **Queued execution memory model:** [`docs/framework-queued-execution-memory.md`](docs/framework-queued-execution-memory.md)
- **Queue operations runbook:** [`docs/runbooks/operate-framework-task-queue.md`](docs/runbooks/operate-framework-task-queue.md)
- **Queue health check runbook:** [`docs/runbooks/run-queue-health-check.md`](docs/runbooks/run-queue-health-check.md)
- **Framework alignment maintenance runbook:** [`docs/runbooks/maintain-framework-alignment.md`](docs/runbooks/maintain-framework-alignment.md)
- **Metrics and feedback loop:** [`docs/framework-metrics-and-feedback.md`](docs/framework-metrics-and-feedback.md)
- **Reporting and review cadence:** [`docs/framework-reporting-and-review-cadence.md`](docs/framework-reporting-and-review-cadence.md)
- **Weekly hygiene summary template:** [`docs/framework-weekly-hygiene-summary-template.md`](docs/framework-weekly-hygiene-summary-template.md)
- **Quarterly adoption/portability summary template:** [`docs/framework-quarterly-adoption-portability-summary-template.md`](docs/framework-quarterly-adoption-portability-summary-template.md)
- **Operating model:** [`docs/operating-model.md`](docs/operating-model.md)
- **Projects setup:** [`docs/github-projects-setup.md`](docs/github-projects-setup.md)
- **Work-type matrix:** [`docs/work-type-matrix.md`](docs/work-type-matrix.md)
- **Handoff playbook:** [`docs/multi-agent-handoff-playbook.md`](docs/multi-agent-handoff-playbook.md)
- **Handoff template:** [`docs/handoff-packet-template.md`](docs/handoff-packet-template.md)
- **Governance checklist:** [`docs/governance-checklist.md`](docs/governance-checklist.md)
- **Framework health:** [`docs/framework-health.md`](docs/framework-health.md)
- **Operator runbooks:** [`docs/runbooks/README.md`](docs/runbooks/README.md)
- **Worked examples:** [`examples/README.md`](examples/README.md)
