# Using the Framework with GitHub Mobile

GitHub Mobile is a high-leverage coordination surface in Brain Factory — strong for triage, review, approvals, and follow-up, but not a deep implementation surface. New to the project? Start with [how it works](how-brain-factory-works.md).

The `## Mobile quick action` section convention used across framework docs is formalized in [ADR 0013](./adr/0013-mobile-quick-action-convention.md).

## Best use cases for GitHub Mobile

Use GitHub Mobile for:

- support intake capture and first-pass triage
- issue updates (labels, assignees, severity, routing notes)
- pull request approvals, change requests, and quick comments
- follow-up issue creation while context is fresh
- monitoring notifications and unblocking stalled work

## What GitHub Mobile is not for

Do not treat mobile as the primary surface for:

- deep multi-file implementation
- large refactors or debugging
- detailed local validation or release checks
- architecture-heavy authoring

When work moves beyond lightweight coordination, hand off to:

- **VS Code Copilot (local)** for deep implementation and local validation
- **GitHub Copilot Chat/Coding Agent (GitHub cloud)** for bounded repository tasks
- **GH CLI** for batch triage/routing/maintenance

## Mobile handoff contract

Every mobile-originated handoff should leave a durable GitHub artifact with:

- objective
- context
- constraints
- acceptance criteria
- validation expectations
- execution surface selected

If context came from outside GitHub (local notes, Google Drive, OneDrive, connector sources, external AI output), normalize it into the issue/ADR/discussion before implementation starts.

For broader cross-surface handoff patterns, see `docs/multi-agent-handoff-playbook.md`.

## Concrete mobile follow-up flow

### Scenario: Reviewer spots a missing acceptance check on mobile

1. On mobile, reviewer opens PR and notices acceptance criteria are incomplete.
2. Reviewer leaves a focused comment: “Missing validation for edge case X; add test evidence before merge.”
3. Reviewer opens a linked follow-up issue from mobile using **Bug/Defect** or **Improvement** template (depending on impact).
4. In issue body, reviewer pastes normalized context:
   - what was observed
   - relevant PR/issue links
   - constraints to preserve
   - expected outcome
5. Reviewer sets labels + project status (`Triage` or `Ready`) from mobile.
6. Assignee continues on desktop:
   - **VS Code Copilot (local)** or **GitHub Copilot Coding Agent** implements fix
   - PR links back to follow-up issue
7. Reviewer re-checks on mobile, approves, merge completes.
8. Owner updates follow-up communication and closes the issue.

This preserves speed on mobile without losing governance or validation rigor.

## Quick decision guide

- Need fast triage or approval? **GitHub Mobile**
- Need code changes + debug loop? **VS Code Copilot (local)**
- Need bounded repo task execution? **GitHub Copilot Coding Agent**
- Need scripted bulk operations? **GH CLI**
- Need synthesis from non-repo context? **External AI agent**, then normalize into GitHub artifacts first

## Mobile governance checklist

Before approving from mobile, confirm:

- linked issue/ADR/discussion exists
- constraints survived handoff
- validation evidence is visible in PR
- any deferred work is captured as follow-up issues
- project status and closure notes are updated

## Mobile quick action

- **Use when:** you need to decide mobile-safe next steps and apply this repo's mobile quick-action convention consistently.
- **Do from mobile:**
  - Use this guide to confirm whether the current task should stay on mobile or be handed off.
  - Check the target doc's `## Mobile quick action` section before acting from phone.
  - Leave a concise decision note describing what was done on mobile and what was deferred.
- **Do not do from mobile:**
  - Treat this guide as approval to perform deep implementation or debugging from phone.
  - Make repo-wide convention updates from mobile-only review context.
- **Escalate to desktop/cloud when:**
  - The work requires code changes, deep validation, or broad document rewrites.
  - The mobile quick-action convention itself needs structural or governance updates.
- **Primary artifact to update:**
  - The active issue or pull request comment recording the mobile decision and handoff.

## Mobile quick action coverage

ADR 0013 defines this convention: [ADR 0013: Mobile quick action section convention](./adr/0013-mobile-quick-action-convention.md).

| Doc path | Status | Notes |
| --- | --- | --- |
| `docs/branching-and-cleanup.md` | Expected | Core doc with operator branching/cleanup actions. |
| `docs/context-synchronization.md` | Expected | Core doc with operator handoff actions. |
| `docs/contributor-environment-guide.md` | Expected | Core doc with contributor setup actions. |
| `docs/example-issue-to-pr-flow.md` | Expected | Core doc with operational issue→PR actions. |
| `docs/framework-continuity-and-memory.md` | Expected | Core continuity operations doc. |
| `docs/framework-continuity-snapshot-template.md` | Expected | Structured continuity snapshot template for explicit handoff/resume status. |
| `docs/framework-portability-and-adoption.md` | Expected | Core portability/adoption operations doc. |
| `docs/framework-upgrade-and-maintenance.md` | Expected | Core upgrade/adoption maintenance and queue closure hygiene guidance. |
| `docs/framework-starter-kit.md` | Expected | Core bootstrap/transplant operations doc. |
| `docs/framework-roadmap-next-prompts.md` | Expected | Core roadmap queue for selecting the next bounded framework-completion task. |
| `docs/framework-queued-execution-memory.md` | Expected | Canonical queued-execution-memory schema, linkage, and queue-governance operations doc. |
| `docs/framework-health.md` | Expected | Core audit operations doc. |
| `docs/operator-onboarding-pack.md` | Expected | Practical first-use operating path for maintainers, contributors, and agent operators. |
| `docs/gh-agents-and-automation.md` | Expected | Core automation operations doc. |
| `docs/github-mobile-guide.md` | Expected | Core mobile operations guide. |
| `docs/github-projects-setup.md` | Expected | Core Projects operations doc. |
| `docs/governance-checklist.md` | Expected | Core governance review checklist. |
| `docs/handoff-packet-template.md` | Expected | Canonical handoff packet template with required field sections. |
| `docs/issue-taxonomy.md` | Expected | Core issue intake/routing reference with operator classification actions. |
| `docs/work-type-matrix.md` | Expected | Core work-type path-selection and tailoring guide for operators. |
| `docs/multi-agent-handoff-playbook.md` | Expected | Core handoff operations playbook. |
| `docs/operating-model.md` | Expected | Core operating model with operator actions. |
| `docs/product-support-and-improvement-loop.md` | Expected | Core support/improvement operations doc. |
| `docs/prompt-cookbook.md` | Expected | Core prompt operations guidance. |
| `docs/security-and-secure-delivery.md` | Expected | Core security and secure-delivery guardrail doc. |
| `docs/redevelopment-playbook.md` | Expected | Core redevelopment operations playbook. |
| `docs/runbooks/apply-setup.md` | Expected | Runbook for applying setup intent and confirming ready-to-work state. |
| `docs/runbooks/surface-specific-startup-guides.md` | Expected | Runbook for picking the right startup path by surface and escalating cleanly. |
| `docs/runbooks/framework-lifecycle-map.md` | Expected | Durable lifecycle map covering all eight operating stages from bootstrap through resume, with a stage quick-reference and self-check. |
| `docs/runbooks/create-continuity-snapshot.md` | Expected | Runbook for creating/updating structured continuity snapshots for handoff/resume. |
| `docs/runbooks/local-first-quickstart.md` | Expected | Quickstart runbook for solo/local setup with recommended default profile, minimum edits, and safe deferrals. |
| `docs/runbooks/close-out-a-multi-agent-handoff.md` | Expected | Runbook with operator handoff closure actions. |
| `docs/runbooks/handle-a-dependabot-pr.md` | Expected | Runbook with operator Dependabot actions. |
| `docs/runbooks/open-an-issue.md` | Expected | Runbook with operator issue-filing and template-selection actions. |
| `docs/runbooks/prompt-to-setup-bootstrap.md` | Expected | Runbook for translating natural-language setup needs into setup intent/profile and readiness path. |
| `docs/runbooks/operate-framework-task-queue.md` | Expected | Runbook with queue-state maintenance and merge-preparation recovery actions. |
| `docs/runbooks/run-queue-health-check.md` | Expected | Runbook with queue drift-detection checks and recovery steps. |
| `docs/runbooks/maintain-framework-alignment.md` | Expected | Runbook for running upgrade review cycles and recovering from missed issue closure. |
| `docs/runbooks/promote-external-ai-artifact.md` | Expected | Runbook with artifact promotion actions. |
| `docs/runbooks/respond-to-support-intake.md` | Expected | Runbook with support intake actions. |
| `docs/runbooks/handle-security-sensitive-intake.md` | Expected | Runbook with security-sensitive intake routing actions. |
| `docs/runbooks/run-the-framework-health-audit.md` | Expected | Runbook with health-audit actions. |
| `docs/runbooks/start-a-framework-change.md` | Expected | Runbook with framework-change kickoff actions. |
| `docs/runbooks/triage-stale-branch-report.md` | Expected | Runbook with stale-branch triage actions. |
| `docs/visual-diagrams-plan.md` | Expected | Core diagrams planning operations doc. |
| `examples/worked-example-dependabot-pr.md` | Expected | Worked example with operator workflow steps. |
| `examples/worked-example-external-context-normalization.md` | Expected | Worked example with operator normalization steps. |
| `examples/worked-example-issue-to-pr.md` | Expected | Worked example with operator workflow steps. |
| `examples/adoption-example-solo-small-repo.md` | Expected | Adoption worked example with mobile profile-check actions. |
| `examples/adoption-example-product-delivery-team.md` | Expected | Adoption worked example with mobile profile-check actions. |
| `examples/adoption-example-platform-infra-team.md` | Expected | Adoption worked example with mobile profile-check actions. |
| `examples/adoption-example-starter-kit-bootstrap-flow.md` | Expected | Adoption worked example with bounded starter-kit onboarding checks. |
| `examples/adoption-example-profile-upgrade-small-to-product.md` | Expected | Adoption worked example with bounded profile-upgrade checks. |
| `AGENTS.md` | Skip | Root-level entrypoint/reference doc for agents and contributors (non-operator procedure). |
| `CODE_OF_CONDUCT.md` | Skip | Repository policy document (non-operator procedure). |
| `CONTRIBUTING.md` | Skip | Contributor policy/reference doc, not a task runbook. |
| `LICENSE` | Skip | Legal document. |
| `README.md` | Skip | Repository index/entrypoint doc. |
| `SECURITY.md` | Skip | Security policy/reference doc. |
| `docs/adr/README.md` | Skip | ADR index file. |
| `docs/adr/*.md` | Skip | ADR decision records are out of scope by ADR 0013. |
| `docs/diagrams/README.md` | Skip | Diagram companion inventory index. |
| `docs/runbooks/README.md` | Skip | Runbook index file. |
| `examples/README.md` | Skip | Examples index file. |

## Related docs

- [Operating model](operating-model.md) — how the framework runs day-to-day.
- [Product support and improvement loop](product-support-and-improvement-loop.md) — how signals flow back into the framework.
- [Framework continuity and memory](framework-continuity-and-memory.md) — what the framework remembers across sessions.
- [Branching and cleanup](branching-and-cleanup.md) — branch lifecycle and stale-branch handling.
- [Governance checklist](governance-checklist.md) — periodic audit items.
