# Surface-Specific Startup Guides

## When to use this runbook

Use this runbook when you need the fastest startup path for the *execution
surface* you are actually using, instead of treating startup as one generic
flow. An execution surface is simply where you do the work: the GitHub cloud
agent, local VS Code with Copilot, or GitHub Mobile.

New to the project? Read
[How Brain Factory works](../how-brain-factory-works.md) first. For the full
natural-language-to-setup path, use
[Prompt-to-setup bootstrap](prompt-to-setup-bootstrap.md).

## Surface startup matrix

### 1) GitHub cloud agent workflow

#### When to use the GitHub cloud agent surface

- You want a bounded repository task executed from GitHub with durable issue/PR
  linkage.
- You are coordinating across PRs/issues and want cloud-side execution.

#### What the GitHub cloud agent surface is good for

- Bounded doc/runbook updates
- Bounded code changes tied to one issue
- PR-based validation and review loops

#### What not to do on the GitHub cloud agent surface

- Heavy local environment setup/debug loops
- Device-specific tooling checks you can only run locally
- Long exploratory refactors without tight scope

#### Shortest startup path on the GitHub cloud agent surface

1. Read [`../../AGENTS.md`](../../AGENTS.md).
2. Use this surface guide to confirm cloud is appropriate.
3. Start from [`prompt-to-setup-bootstrap.md`](prompt-to-setup-bootstrap.md) if
   setup intent is not yet established.
4. Apply and verify setup using
   [`apply-setup.md`](apply-setup.md) and
   [`apply-framework-setup.md`](apply-framework-setup.md).
5. Execute one bounded issue → PR task.

#### When to escalate from the GitHub cloud agent surface

- You need deep local implementation/debugging → move to VS Code/local.
- You only need quick triage/approval/routing actions → move to mobile.

### 2) Local VS Code / Copilot workflow

#### When to use the local VS Code/Copilot surface

- You are implementing, debugging, or validating locally.
- You need tight edit-run-validate loops.

#### What the local VS Code/Copilot surface is good for

- First-time local setup and readiness checks
- Multi-file implementation with local tooling
- Faster iterative development cycles

#### What not to do on the local VS Code/Copilot surface

- Mobile-only oversight/approvals
- Cloud-only queue/triage actions that do not need local execution
- Broad unscoped work that should be split into bounded issues

#### Shortest startup path on the local VS Code/Copilot surface

1. Read [`../../AGENTS.md`](../../AGENTS.md).
2. Run [Local-first quickstart](local-first-quickstart.md) (recommended
   `solo_prototype` default path).
3. If needed, use [Prompt-to-setup bootstrap](prompt-to-setup-bootstrap.md) to
   refine setup intent/profile.
4. Run readiness and baseline checks.
5. Start one bounded issue → PR task.

#### When to escalate from the local VS Code/Copilot surface

- You need bounded cloud-agent execution and PR-loop continuity in GitHub →
  move to GitHub cloud agent.
- You only need lightweight triage/status/handoff notes from phone → move to
  mobile.

### 3) Lightweight mobile / operator oversight workflow

#### When to use the mobile/operator oversight surface

- You are coordinating, triaging, reviewing, or unblocking from GitHub Mobile.
- You need quick oversight while away from desktop/cloud IDE surfaces.

#### What the mobile/operator oversight surface is good for

- Quick triage and routing
- PR comments/approvals and follow-up issue creation
- Capturing handoff notes and escalation decisions

#### What not to do on the mobile/operator oversight surface

- Running setup scripts or readiness checks
- Deep multi-file implementation
- Large JSON/edit-heavy setup authoring

#### Shortest startup path on the mobile/operator oversight surface

1. Read [`../github-mobile-guide.md`](../github-mobile-guide.md).
2. Use this surface guide to confirm mobile-safe scope.
3. If setup/startup decisions are unclear, route to
   [Prompt-to-setup bootstrap](prompt-to-setup-bootstrap.md) or
   [Local-first quickstart](local-first-quickstart.md) and leave a durable
   handoff note.
4. Keep mobile actions bounded to triage/review/routing.

#### When to escalate from the mobile/operator oversight surface

- Code edits, script execution, or validation evidence are required → move to
  VS Code/local or GitHub cloud agent.
- Setup intent/profile decisions need substantive updates → move to desktop/cloud.

## Escalation quick map

- **Need deep implementation + local validation loops** → Local VS Code/Copilot
- **Need bounded GitHub-native task execution** → GitHub cloud agent
- **Need quick triage/review/handoff only** → Mobile oversight

## Mobile quick action

- **Use when:** you need to pick the right startup surface quickly from phone
  and leave a durable handoff.
- **Do from mobile:**
  - Use this runbook to choose cloud agent vs local vs mobile-only scope.
  - Leave a short note in the active issue/PR naming the chosen surface and why.
  - Escalate startup work to local/cloud when scripts or validation are needed.
- **Do not do from mobile:**
  - Execute setup/readiness scripts.
  - Rewrite large setup-intent JSON or broad startup docs.
  - Treat mobile triage as completion of implementation/startup validation.
- **Escalate to desktop/cloud when:**
  - Setup intent/profile updates are needed.
  - Any readiness/baseline validation evidence must be produced.
  - The task moves from oversight into implementation.
- **Primary artifact to update:**
  - The active issue or PR with the chosen surface and next-step handoff.

## Related docs

- [Prompt-to-setup bootstrap](prompt-to-setup-bootstrap.md)
- [Local-first quickstart](local-first-quickstart.md)
- [Apply framework setup](apply-framework-setup.md)
- [Apply setup](apply-setup.md)
- [Operator onboarding pack](../operator-onboarding-pack.md)
- [Using the framework with GitHub Mobile](../github-mobile-guide.md)
- [AGENTS.md](../../AGENTS.md)
