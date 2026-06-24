# Operator Onboarding Pack

This is a day-0/day-1 checklist for getting productive in a Brain Factory brain
fast, without reading the entire documentation set first. It is written for
people who operate the system day to day: maintainers, contributors, and the
agents (and their human operators) that do bounded work in the repository.

New to the project? Read [How Brain Factory works](how-brain-factory-works.md)
first for the five-minute tour, then come back here. In short: Brain Factory is a
hub that provisions a per-project repository called a "brain"; this pack helps
you operate inside a brain.

## What to read first (in order)

1. [`../AGENTS.md`](../AGENTS.md) — minimum contract and non-negotiable rules.
2. [`framework-continuity-and-memory.md`](framework-continuity-and-memory.md) —
   continuity model and durable principles.
3. [`operating-model.md`](operating-model.md) — execution surfaces and work packet model.
4. [`runbooks/open-an-issue.md`](runbooks/open-an-issue.md) — create execution-ready issues.
5. [`work-type-matrix.md`](work-type-matrix.md) — choose the right path and rigor.

Then use this onboarding pack as your day-0/day-1 operating checklist.

## Minimal mental model (day one)

- GitHub is the system of record. Decisions and context live in issues, PRs, and
  docs, not in chat or private notes.
- Work starts from a complete issue packet: an issue that states objective,
  context, constraints, acceptance criteria, and validation expectations.
- Each PR is bounded to one objective.
- External context is normalized into GitHub before implementation: anything from
  chat, local notes, or other tools is promoted into an issue/PR/ADR first.
- Handoffs preserve the required packet fields so the next person can resume
  without private context.
- Queue-backed work (work tracked in the framework task queue) stays linked to
  its issue/PR and keeps its state accurate.

If one of these is missing, pause and fix the artifact before coding.

## Day-one artifacts that matter most

| Need | Primary artifact |
| --- | --- |
| Full operating lifecycle map (bootstrap → execute → handoff → resume) | [`runbooks/framework-lifecycle-map.md`](runbooks/framework-lifecycle-map.md) |
| Event-style milestone model for major state transitions | [`framework-state-milestones.md`](framework-state-milestones.md) |
| Fast artifact lookup conventions for continuity/handoff/readiness/queue posture | [`framework-continuity-artifact-indexing.md`](framework-continuity-artifact-indexing.md) |
| Structured continuity status for handoff/resume | [`framework-continuity-snapshot-template.md`](framework-continuity-snapshot-template.md) + [`runbooks/create-continuity-snapshot.md`](runbooks/create-continuity-snapshot.md) |
| Ordered resume procedure from handoff packet to next safe action | [`runbooks/resume-from-handoff-packet.md`](runbooks/resume-from-handoff-packet.md) |
| Operating contract | [`../AGENTS.md`](../AGENTS.md) |
| First-use continuity and guardrails | [`framework-continuity-and-memory.md`](framework-continuity-and-memory.md) |
| Surface and mode selection | [`operating-model.md`](operating-model.md) |
| Work-type routing and rigor | [`work-type-matrix.md`](work-type-matrix.md) |
| Lightweight adoption coherence check | [`framework-readiness-checklist.md`](framework-readiness-checklist.md) |
| Durable setup contract (intent → profile/default mapping → expected outputs) | [`framework-setup-intent-schema-and-application-model.md`](framework-setup-intent-schema-and-application-model.md) |
| Concrete setup profiles and setup-intent examples | [`framework-setup-profiles-and-intent-examples.md`](framework-setup-profiles-and-intent-examples.md) |
| End-to-end prompt-to-setup bootstrap path | [`runbooks/prompt-to-setup-bootstrap.md`](runbooks/prompt-to-setup-bootstrap.md) |
| Automation/check/workflow selection | [`framework-automation-bundles-by-profile.md`](framework-automation-bundles-by-profile.md) |
| Framework change summaries and upgrade impact | [`framework-release-notes.md`](framework-release-notes.md) + [`framework-release-notes-and-upgrade-summaries.md`](framework-release-notes-and-upgrade-summaries.md) |
| Major reusable prompt selection | [`framework-prompt-library.md`](framework-prompt-library.md) + [`framework-roadmap-next-prompts.md`](framework-roadmap-next-prompts.md) |
| Issue packet quality | [`issue-taxonomy.md`](issue-taxonomy.md) + [`runbooks/open-an-issue.md`](runbooks/open-an-issue.md) |
| Handoff quality | [`multi-agent-handoff-playbook.md`](multi-agent-handoff-playbook.md) + [`handoff-packet-template.md`](handoff-packet-template.md) |
| Queue-aware continuation | [`framework-queued-execution-memory.md`](framework-queued-execution-memory.md) + [`runbooks/operate-framework-task-queue.md`](runbooks/operate-framework-task-queue.md) |
| Validation and governance checks | [`governance-checklist.md`](governance-checklist.md) + validation commands in [`../AGENTS.md`](../AGENTS.md) |

## Day-0 setup path (before first implementation)

1. Read the minimum contract in [`../AGENTS.md`](../AGENTS.md).
2. Read continuity and durable writeback expectations in
   [`framework-continuity-and-memory.md`](framework-continuity-and-memory.md).
3. Choose the startup surface path that matches how you will operate:
   - [`runbooks/surface-specific-startup-guides.md`](runbooks/surface-specific-startup-guides.md)
4. Choose your adoption profile and check bundle:
   - **Solo developer / local-first:** use
     [`runbooks/local-first-quickstart.md`](runbooks/local-first-quickstart.md)
     — recommended `solo_prototype` default, minimum field edits, exact commands,
     readiness confirmation, and safe deferrals.
   - **Full natural-language → profile → apply path:** use
     [`runbooks/prompt-to-setup-bootstrap.md`](runbooks/prompt-to-setup-bootstrap.md).
   - [`framework-setup-intent-schema-and-application-model.md`](framework-setup-intent-schema-and-application-model.md)
   - [`framework-setup-profiles-and-intent-examples.md`](framework-setup-profiles-and-intent-examples.md)
   - [`framework-profile-packs.md`](framework-profile-packs.md)
   - [`framework-automation-bundles-by-profile.md`](framework-automation-bundles-by-profile.md)
5. Run one local baseline validation pass:
   - `npx -y markdownlint-cli2 "**/*.md"`
   - `bash scripts/check-framework-task-queue.sh`
   - `bash scripts/check-queue-health.sh`
6. Confirm queue and firewall constraints before relying on API-backed checks:
   - [`gh-agents-and-automation.md`](gh-agents-and-automation.md)
   - [`runbooks/operate-framework-task-queue.md`](runbooks/operate-framework-task-queue.md)

## Day-1 operating path (first bounded task)

1. Confirm there is a scoped issue or ADR for the work.
2. Confirm the issue packet is complete before implementation.
3. Pick execution surface (local/cloud/CLI/mobile/external) from
   [`operating-model.md`](operating-model.md).
4. Classify work type and apply stricter-path precedence when needed using
   [`work-type-matrix.md`](work-type-matrix.md).
5. Implement in one bounded PR linked to source issue.
6. Run required checks and capture validation evidence in the PR.
7. If queue-backed, run queue integrity/health checks and reconcile state:
   - `bash scripts/check-framework-task-queue.sh`
   - `bash scripts/check-queue-health.sh`
8. Close out with durable writeback:
   - issue/project status and follow-up links
   - queue `in_progress` → `done`/`superseded` transitions when applicable
   - branch cleanup

## First-week path

- Run at least one full issue → PR → validation → merge flow.
- Run one queue-health and queue-integrity pass if working from roadmap/queue:
  - `bash scripts/check-framework-task-queue.sh`
  - `bash scripts/check-queue-health.sh`
- Run one lightweight governance pass using
  [`governance-checklist.md`](governance-checklist.md).
- Run one framework health audit dry-run using
  [`runbooks/run-the-framework-health-audit.md`](runbooks/run-the-framework-health-audit.md).
- Capture one onboarding friction or missing-link issue for improvement.

## How to start a task checklist

- [ ] Source artifact exists (issue/discussion/ADR) and is linked.
- [ ] Objective and non-goals are explicit and bounded.
- [ ] Constraints and acceptance criteria are testable.
- [ ] Validation expectations are defined before coding.
- [ ] Work type and execution surface are explicitly selected.
- [ ] External context is normalized and auditable in GitHub.
- [ ] Security routing is explicit for sensitive content.

## How to continue someone else’s work checklist

- [ ] Read the linked issue, PR, and handoff packet fields before editing.
- [ ] Read the canonical continuity artifact index (if present) before deep review.
- [ ] Read the latest continuity snapshot before editing.
- [ ] Follow `runbooks/resume-from-handoff-packet.md` review order before touching files.
- [ ] Confirm milestone acknowledgment status and evidence links are current.
- [ ] Confirm constraints/non-goals survived from source issue to current PR.
- [ ] Confirm setup/readiness posture is still valid; run checks if stale/unknown.
- [ ] Confirm validation expectations and current status are explicit.
- [ ] Confirm queue marker/state linkage if this is queue-backed work.
- [ ] Identify and record one next safe action before implementation resumes.
- [ ] Continue only the current bounded objective; open follow-up issues for extras.
- [ ] Update durable artifacts with status, evidence, and unresolved risks.

## Common operator mistakes to avoid

- Starting from chat/private notes instead of normalized GitHub artifacts.
- Implementing before acceptance/validation is explicit.
- Expanding scope inside a single PR instead of creating follow-up issues.
- Losing constraints during handoff.
- Letting queue state drift from issue/PR reality.
- Treating mobile as an implementation surface for deep multi-file changes.

## What good operation looks like

- New work becomes executable quickly from issue packets.
- Handoffs are resumable without private context.
- PRs are small, reviewable, and evidence-backed.
- Queue state and durable artifact truth stay aligned.
- Reviews produce bounded, linked follow-up actions.

## Escalate to deeper docs when needed

- Governance/deprecation policy:
  [`framework-change-governance-and-deprecation-policy.md`](framework-change-governance-and-deprecation-policy.md)
- Portability/transplant: [`framework-portability-and-adoption.md`](framework-portability-and-adoption.md), [`framework-starter-kit.md`](framework-starter-kit.md)
- Adoption depth: [`framework-adoption-maturity-model.md`](framework-adoption-maturity-model.md), [`framework-profile-packs.md`](framework-profile-packs.md)
- Lightweight readiness self-check: [`framework-readiness-checklist.md`](framework-readiness-checklist.md)
- Automation staging by profile/maturity: [`framework-automation-bundles-by-profile.md`](framework-automation-bundles-by-profile.md)
- Setup intent/application contract:
  [`framework-setup-intent-schema-and-application-model.md`](framework-setup-intent-schema-and-application-model.md)
- Setup profile defaults and setup-intent examples:
  [`framework-setup-profiles-and-intent-examples.md`](framework-setup-profiles-and-intent-examples.md)
- Framework release/version/deprecation expectations:
  [`framework-release-versioning-and-deprecation.md`](framework-release-versioning-and-deprecation.md)
- Upgrade impact/release summaries:
  [`framework-release-notes.md`](framework-release-notes.md),
  [`framework-release-notes-and-upgrade-summaries.md`](framework-release-notes-and-upgrade-summaries.md)
- Troubleshooting and recovery runbooks:
  [`runbooks/operate-framework-task-queue.md`](runbooks/operate-framework-task-queue.md),
  [`runbooks/run-queue-health-check.md`](runbooks/run-queue-health-check.md),
  [`runbooks/maintain-framework-alignment.md`](runbooks/maintain-framework-alignment.md)
- Copilot coding agent firewall/API constraints:
  [`gh-agents-and-automation.md`](gh-agents-and-automation.md)
- Reporting cadence: [`framework-reporting-and-review-cadence.md`](framework-reporting-and-review-cadence.md)
- Prompt framing: [`prompt-cookbook.md`](prompt-cookbook.md)
- Queue drift recovery: [`runbooks/run-queue-health-check.md`](runbooks/run-queue-health-check.md)

## Mobile quick action

- **Use when:** you need a fast first-use routing pass from mobile.
- **Do from mobile:**
  - Use the day-one checklist to confirm issue readiness before implementation.
  - Choose the work-type path and flag stricter handling needs.
  - Leave a handoff note with next owner and unresolved risks.
- **Do not do from mobile:**
  - Run broad onboarding rewrites across many docs in one pass.
  - Start deep implementation without complete packet and validation expectations.
- **Escalate to desktop/cloud when:**
  - Work spans multiple docs/templates/scripts and needs coordinated changes.
  - Queue reconciliation, governance checks, or validation evidence are unclear.
- **Primary artifact to update:**
  - The active issue or pull request carrying the current work packet.

## Related docs

- [Framework lifecycle map and operator journey](runbooks/framework-lifecycle-map.md)
- [Framework state milestones](framework-state-milestones.md)
- [Operating model](operating-model.md)
- [Framework continuity and memory](framework-continuity-and-memory.md)
- [Issue taxonomy](issue-taxonomy.md)
- [Open an issue](runbooks/open-an-issue.md)
- [Work-type matrix](work-type-matrix.md)
- [Framework setup intent schema and application model](framework-setup-intent-schema-and-application-model.md)
- [Framework setup profiles and intent examples](framework-setup-profiles-and-intent-examples.md)
- [Prompt-to-setup bootstrap](runbooks/prompt-to-setup-bootstrap.md)
- [Framework automation bundles by profile](framework-automation-bundles-by-profile.md)
- [Framework readiness checklist](framework-readiness-checklist.md)
- [Framework prompt library and execution queue](framework-prompt-library.md)
- [Multi-agent handoff playbook](multi-agent-handoff-playbook.md)
- [Handoff packet template](handoff-packet-template.md)
- [Framework continuity snapshot template](framework-continuity-snapshot-template.md)
- [Create continuity snapshot](runbooks/create-continuity-snapshot.md)
- [Resume from a handoff packet](runbooks/resume-from-handoff-packet.md)
- [Framework queued execution memory](framework-queued-execution-memory.md)
- [Operate the framework task queue](runbooks/operate-framework-task-queue.md)
- [Framework release notes index](framework-release-notes.md)
- [Framework release notes and upgrade summaries](framework-release-notes-and-upgrade-summaries.md)
- [Framework release/versioning/deprecation model](framework-release-versioning-and-deprecation.md)
- [Governance checklist](governance-checklist.md)
- [Framework reporting and review cadence](framework-reporting-and-review-cadence.md)
- [Run the framework health audit](runbooks/run-the-framework-health-audit.md)
- [Maintain framework alignment](runbooks/maintain-framework-alignment.md)
- [GH agents and automation](gh-agents-and-automation.md)
