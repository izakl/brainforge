# GH Agents and Automation

This document defines how the different kinds of helpers — GitHub-hosted agents, GitHub Copilot, local tooling, GitHub Mobile, the GitHub CLI, and external AI agents — participate in Brain Factory, and what GitHub automation should do for them. It is written for a developer setting up or joining a brain (a per-project repository) and deciding which agent should do which work.

If the terms *hub*, *brain*, or *surface* are new, read [how Brain Factory works](how-brain-factory-works.md) first.

## Objectives

- Route work to the right execution mode and surface.
- Keep prompts, constraints, and validation expectations attached to durable artifacts.
- Preserve GitHub repository controls while allowing several agents to collaborate.
- Enable consistent handoffs across discovery, planning, implementation, review, and mobile follow-up.

## Multi-Agent Ecosystem

A brain can draw on several kinds of helper, and most mature teams mix several in one work stream:

- **VS Code Copilot (local)** for day-to-day coding and local validation.
- **GitHub Copilot Chat and the Copilot coding agent (GitHub cloud)** for bounded work driven entirely from repository context.
- **GitHub CLI (`gh`)** for scripted issue triage, labeling, status updates, and contributor operations.
- **GitHub Mobile** for quick triage, approvals, follow-up capture, and status updates.
- **External AI agents (such as Claude Code)** for discovery, synthesis, and planning from context that lives outside the repository.

## Agent Roles

### 1. Human lead

- Owns scope, risk decisions, approvals, and final sign-off.
- Decides execution mode and handoff timing.
- Confirms constraints, non-goals, and release expectations.

### 2. GitHub-native execution agents

"GitHub-native" means the agent works from repository context and operates through normal GitHub flows (issues, branches, PRs, checks). This covers GitHub Copilot Chat, the Copilot coding agent (GitHub cloud), and local Copilot usage.

Best for:

- implementing bounded repository changes
- updating tests and docs tied to code
- executing tasks with clear acceptance criteria
- preparing PR-ready patches from existing artifacts

### 3. External AI agents

Best for:

- discovery and synthesis across many non-repository sources
- redevelopment framing and migration decomposition
- converting raw context (notes, screenshots, exports) into structured work packets

External agents should not bypass repository controls; outputs must be normalized into GitHub artifacts before implementation begins.

### 4. Mobile participants

Best for:

- fast intake/triage updates
- status checks and lightweight approvals
- capturing follow-up tasks while away from desktop

## Surface Selection Rules

Pick a surface by where the work's friction is:

- **Local VS Code + Copilot**: implementation needs local tools, debugging, or deeper editing loops.
- **GitHub Copilot Chat or coding agent (GitHub cloud)**: the task is repository-bounded and the issue is execution-ready.
- **GitHub CLI**: bulk or scripted issue and PR operations are needed.
- **GitHub Mobile**: quick governance, triage, and follow-up interactions.
- **External AI**: context lives outside the repository and needs synthesis before implementation.

## Issue Preparation for Cross-Agent Consistency

A prepared issue should be executable by any agent without hidden assumptions. Before implementation starts, make sure the issue contains:

- Objective
- Context
- Constraints
- Acceptance criteria
- Validation steps
- Non-goals
- Suggested execution mode

## Handoff Contract

Use this handoff sequence:

1. **Discovery** (often external AI + human)
   - produce normalized summary and candidate tasks
2. **Planning** (human lead)
   - decide routing, risk, and acceptance criteria
3. **Implementation** (local or GH-native agent)
   - execute bounded work from issue packet
4. **Review** (human + automation)
   - verify validation evidence and constraints
5. **Mobile follow-up** (optional)
   - close loop with status updates and deferred item capture

## Prompt and Constraint Preservation

Prompt text and constraints must be preserved in durable artifacts:

- issues
- pull requests
- docs and ADRs
- project item fields and comments

Private chat memory alone is insufficient for execution governance.

## Prompt Template

Use this structure for GH agents and external AI agents:

```text
Objective:
<what must be delivered>

Context:
<business, technical, and repository context>

Constraints:
<files to avoid, standards to follow, security and governance limits>

Expected output:
<PR, doc update, issue refinement, ADR draft, discovery summary>

Acceptance criteria:
<testable outcomes>

Validation:
<commands/checks/review expectations>
```

## Branch and PR Expectations

- Use pull requests for agent-authored code changes.
- Preserve prompt and validation context in PR description.
- Keep normal repository protections active regardless of agent source.
- Delete branches after PR completion.

## Repository Control Guardrails

- External outputs must be normalized into repository artifacts before implementation.
- Do not accept direct implementation changes from external chat transcripts alone.
- Do not place secrets, credentials, or exploit detail in public issues, prompts, or PR text.
- Route suspected vulnerabilities via private reporting in `SECURITY.md`.
- Keep review and approval authority with maintainers.
- Use GitHub Projects and issue/PR links to maintain traceability.

## Copilot coding agent firewall and API-access constraints

GitHub-hosted Copilot coding agent runs can have outbound network access restricted by a firewall. When that firewall is active, agent commands that call live GitHub APIs are blocked unless the host is allowlisted in the repository's Copilot coding agent settings. Plan for this so runs that depend on live API calls do not fail silently.

Calls commonly blocked in this framework:

- `https://api.github.com/graphql`
- `https://api.github.com/repos/<owner>/<repo>/issues`
- `https://api.github.com/repos/<owner>/<repo>/issues/<number>`

Use this decision order:

1. **Allowlist required hosts for live API-dependent execution.**
   - For queue/issue reconciliation scripts that intentionally query GitHub API, allowlist
     `api.github.com` (admins only).
2. **Prefer pre-firewall setup for deterministic prerequisites.**
   - If setup is mandatory (tool install, auth bootstrap, metadata fetch), use Actions setup
     steps that run before firewall enforcement.
3. **Design checks/scripts to degrade gracefully without live API access.**
   - Keep core validations deterministic from repository state first.
   - Treat API-backed enrichment checks as optional/fallback when network is blocked.
   - Provide manual reconciliation steps that preserve queue↔issue↔PR continuity when API
     checks are skipped.

Drift between the task queue and issues grows when merged outcomes are not written back into durable queue state. After merge, reconcile `.github/framework-task-queue.json` and issue closure or linkage, even if API-backed checks were skipped during an agent run.

## Automation Role

Automation should support consistency across agents and surfaces:

- issue template structure and labeling
- project routing defaults (status/work type)
- CI validation and required checks
- stale/blocked reminders
- merged PR to Done transitions

### PR auto-labeling

Pull requests are labeled by changed path automatically by `.github/workflows/labeler.yml`, using rules in `.github/labeler.yml`. Those rules mirror `.github/CODEOWNERS`, so labels follow the same path-ownership boundaries.

GitHub Actions versions are kept current by weekly Dependabot pull requests configured in `.github/dependabot.yml`.

Automation should never hide an unresolved decision or stand in for human approval.

## Mobile quick action

- **Use when:** you need to verify agent routing and guardrails quickly from mobile before execution proceeds.
- **Do from mobile:**
  - Confirm the issue packet includes objective, constraints, acceptance, and validation.
  - Check that execution mode and surface match task risk and scope.
  - Leave a routing comment when external context is not yet normalized into GitHub artifacts.
- **Do not do from mobile:**
  - Edit automation workflows or policy-heavy agent rules.
  - Approve multi-agent execution without visible guardrail evidence.
- **Escalate to desktop/cloud when:**
  - Workflow or automation-file changes are required.
  - Security, governance, or cross-surface conflicts need deeper analysis.
- **Primary artifact to update:**
  - The issue or pull request routing decision comment.

## Related docs

- [Multi-agent handoff playbook](multi-agent-handoff-playbook.md) — handoff structure across humans and agents.
- [Operating model](operating-model.md) — core lifecycle and execution surfaces.
- [GitHub Projects setup](github-projects-setup.md) — board operations and tracking conventions.
- [Context synchronization](context-synchronization.md) — keeping agent context durable across surfaces.
- [Product support and improvement loop](product-support-and-improvement-loop.md) — support signal intake and improvement flow.
- [Security and secure delivery guardrails](security-and-secure-delivery.md) — security-sensitive routing and safe delivery controls.
- [Framework queued execution memory](framework-queued-execution-memory.md) — canonical queue schema, queue↔issue↔PR linkage, drift detection, and recovery semantics.
- [Framework setup intent schema and application model](framework-setup-intent-schema-and-application-model.md) — durable setup contract for prompt-to-intent normalization and deterministic setup outputs.
- [Operate the framework task queue](runbooks/operate-framework-task-queue.md) — queue transitions, post-merge writeback checklist, and firewall-aware recovery steps.
