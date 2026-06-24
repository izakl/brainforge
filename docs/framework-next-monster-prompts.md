# Framework next monster prompts

A durable, in-repo list of the remaining large ("monster") prompts for building out Brain Factory's shared framework, so future work does not depend on chat history. Each entry is a self-contained brief you can hand to a coding agent. For the fuller, dependency-ordered catalog, see the [prompt library](framework-prompt-library.md); new to the project? Start with [Brain Factory: how it works](how-brain-factory-works.md).

## How to use this file

- Pick the first dependency-ready item from **Ready now** and run it as one bounded PR.
- Move to the next ordered item only after earlier dependencies are satisfied.
- Reuse the prompt text directly in the GitHub Copilot coding agent.
- After merge, update this file so order and status stay accurate.

## Ready now

### 1) Queue closure/linkage hygiene hardening

- **Why it matters:** Queue/issue/PR closure and linkage drift can silently erode execution continuity and confidence in queue state over time.
- **Dependencies:**
  - `docs/framework-queued-execution-memory.md`
  - `docs/runbooks/operate-framework-task-queue.md`
  - `docs/runbooks/run-queue-health-check.md`
  - `scripts/check-queue-health.sh`
- **Suggested GitHub agent prompt text:**

```text
Open a PR to harden queue closure/linkage hygiene so merged work, queue state, and linked issues stay consistently aligned.

Repository:
izakl/brainforge

Goal:
Reduce queue drift risk by tightening closure/linkage guidance and checks.

What to do:
1. Review current queue memory model, queue runbooks, and queue-health checks.
2. Add or refine bounded guidance for reliable queue↔issue↔PR closeout.
3. Improve drift-detection/repair instructions where ambiguity exists.
4. Update discoverability links in `README.md`, `docs/README.md`, and `AGENTS.md` as needed.
5. Keep scope limited to hygiene hardening (no major queue redesign).
6. Validate markdown/docs checks and include validation evidence in the PR description.

Acceptance criteria:
- Operators can reliably perform queue closure/linkage closeout.
- Drift recovery guidance is clearer and easier to execute.
- Existing queue model remains intact.
- All affected checks pass.
```

## Completed

### Framework readiness / certification checklist

- **Status:** completed on 2026-05-25.
- **Durable outputs:**
  - `docs/framework-readiness-checklist.md`
  - `README.md` (updated)
  - `docs/README.md` (updated)
  - `AGENTS.md` (updated)
  - `docs/operator-onboarding-pack.md` (updated)
  - `docs/framework-starter-kit.md` (updated)
  - `docs/framework-portability-and-adoption.md` (updated)
  - `docs/framework-adoption-maturity-model.md` (updated)
  - `docs/framework-profile-packs.md` (updated)
  - `docs/framework-automation-bundles-by-profile.md` (updated)
  - `docs/framework-continuity-and-memory.md` (updated)
  - `docs/framework-health.md` (updated)
- **Why this was completed:** adopters now have a lightweight, reusable
  readiness checklist that supports profile-aware and maturity-aware
  self-assessment with explicit deferrals, without rigid "adopt everything"
  scoring.

### Downstream adoption worked examples

- **Status:** completed on 2026-05-25.
- **Durable outputs:**
  - `examples/adoption-example-solo-small-repo.md`
  - `examples/adoption-example-product-delivery-team.md`
  - `examples/adoption-example-platform-infra-team.md`
  - `examples/README.md` (updated)
  - `docs/README.md` (updated)
  - `README.md` (updated)
  - `AGENTS.md` (updated)
  - `docs/github-mobile-guide.md` (updated)
  - `docs/framework-health.md` (updated)
- **Why this was completed:** adopters now have concrete, profile-specific worked
  examples showing realistic file selection, automation bundle choices, first-week
  rollout paths, and intentional deferrals for solo/small, product delivery, and
  platform/infra team contexts.

### Automation bundles by profile

- **Status:** completed on 2026-05-25.
- **Durable outputs:**
  - `docs/framework-automation-bundles-by-profile.md`
  - `README.md`
  - `docs/README.md`
  - `AGENTS.md`
  - `docs/framework-continuity-and-memory.md`
  - `docs/framework-health.md`
- **Why this was completed:** adopters now have profile-aware, maturity-aware
  automation bundle guidance with clear minimum/recommended/later rollout
  staging and explicit defer-path tradeoffs.

### Release notes / upgrade summary system

- **Status:** completed on 2026-05-25.
- **Durable outputs:**
  - `docs/framework-release-notes-and-upgrade-summaries.md`
  - `docs/framework-change-summary-template.md`
  - `docs/framework-release-notes.md`
  - `docs/release-notes/2026-05-25-release-notes-upgrade-summary-model.md`
- **Why this was completed:** maintainers/adopters now have a lightweight,
  durable change-summary model with lifecycle/action/applicability classification
  and a reusable summary packet.
