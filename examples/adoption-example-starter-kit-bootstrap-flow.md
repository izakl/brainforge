# Adoption example: starter-kit bootstrap in one bounded issue → PR flow

This example walks a first-time adopter through bootstrapping a new repository with
Brain Factory in exactly one issue and one PR — the fastest safe way to get
guardrails in place without importing the whole documentation surface on day one.
The **starter kit** is the curated bundle of files to copy; its **essential
baseline** is the minimal subset you adopt first. New to the project? Read
[`../docs/how-brain-factory-works.md`](../docs/how-brain-factory-works.md) first.

## Scenario

A team starts a new internal automation repository and wants framework guardrails
without importing the full documentation surface on day one.

They decide to execute one bootstrap issue and one bootstrap PR first, then capture
deferred items as follow-up issues.

## Objective and scope boundary

- Objective: onboard the target repository with the starter-kit essential baseline.
- In scope: essential files, minimal adaptation, baseline validation evidence.
- Out of scope: profile-specific recommended/optional layers and broad workflow expansion.

## Starter-kit and profile choices

- Starter-kit baseline used:
  [`docs/framework-starter-kit.md`](../docs/framework-starter-kit.md)
- Initial profile selected: **Small repository / solo maintainer** (Bundle A baseline).
- Deferred profile upgrades are recorded as follow-up issues, not bundled into the first PR.

## Artifact trace (issue → PR → validation → writeback)

### 1) Canonical bootstrap issue

- Open one issue with:
  - objective and context
  - constraints/non-goals
  - acceptance criteria
  - validation expectations
  - owner/next owner
- Add explicit note: "One objective, one PR; deferred scope tracked separately."

### 2) One bounded implementation PR

- PR body includes `Closes #<bootstrap-issue>`.
- Changes only include starter-kit essential baseline and direct repo-reference rewrites.
- Deferred components are linked with non-closing references (`Relates-to #...`).

### 3) Validation evidence captured in PR

- `npx -y markdownlint-cli2 "**/*.md"`
- `npx -y markdown-link-check -q -c .github/markdown-link-check.json <changed-file>`
- Any newly enabled checks in CI are reported in the PR evidence section.

### 4) Durable writeback after merge

- Bootstrap issue closes via PR keyword.
- Follow-up issues remain open for recommended/optional layers.
- Queue/continuity notes stay in GitHub artifacts (issue/PR), not chat-only notes.

## Example file selection used in the bootstrap PR

| Tier | Included in first PR |
| --- | --- |
| Essential | `AGENTS.md`, continuity + operating model docs, framework-change issue template, issue `config.yml`, PR template, markdown workflow/link config, `SECURITY.md`, security guidance |
| Recommended | Deferred to follow-up issues |
| Optional | Deferred to follow-up issues |

## Why this pattern is high-signal

- Demonstrates the fastest safe onboarding path without over-scoping.
- Preserves the framework's bounded issue→PR rule from day one.
- Leaves a reusable issue/PR trace that other adopters can copy directly.

## Mobile quick action

- **Use when:** checking whether starter-kit bootstrap is staying bounded.
- **Do from mobile:**
  - Confirm only one bootstrap issue and one bootstrap PR are active.
  - Confirm deferred layers are tracked as separate follow-up issues.
  - Verify PR includes explicit validation evidence.
- **Do not do from mobile:**
  - Expand the bootstrap PR with recommended/optional layers.
  - Rewrite multiple templates/workflows in one pass.
- **Escalate to desktop/cloud when:**
  - The bootstrap PR scope is drifting beyond essential baseline files.
  - Profile selection needs coordinated edits across multiple docs/workflows.
- **Primary artifact to update:**
  - The bootstrap issue or PR carrying starter-kit adoption scope and deferred links.

## Related docs

- [Framework starter kit / bootstrap pack](../docs/framework-starter-kit.md)
- [Framework profile packs](../docs/framework-profile-packs.md)
- [Framework automation bundles by profile](../docs/framework-automation-bundles-by-profile.md)
- [Framework roadmap: next GitHub agent prompts](../docs/framework-roadmap-next-prompts.md)
- [Operate the framework task queue](../docs/runbooks/operate-framework-task-queue.md)
- [Adoption example: solo maintainer / small repository](adoption-example-solo-small-repo.md)
- [Adoption example: product delivery team](adoption-example-product-delivery-team.md)
