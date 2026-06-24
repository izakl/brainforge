# Contributor Environment Guide

This guide explains the development setup files shipped with the repository — the
dev container, VS Code workspace, and editor settings — and how to use them. It is
for contributors getting their local environment ready to work on Brain Factory.
New to the project? See [How Brain Factory works](how-brain-factory-works.md) first.

## Purpose

These files give contributors a consistent experience across local development,
VS Code, and GitHub Codespaces-style environments. The goal is to reduce setup
friction so you can focus on structured delivery, documentation, and repository
artifacts.

## Environment Components

### Dev container

The `.devcontainer/` configuration defines a portable development environment for contributors who want a reproducible setup.

Current repository support includes:

- `devcontainer.json` for container configuration
- `post-create.sh` for setup tasks after container creation

Use the dev container when you want a consistent environment across machines or when onboarding contributors quickly.

### VS Code settings

The `.vscode/` directory contains workspace guidance for contributors using VS Code.

Current repository support includes:

- `settings.json` for repository-scoped editor behavior
- `extensions.json` for recommended extensions
- `tasks.json` for reusable repository tasks

These files help align contributors around a common editor experience without requiring extensive manual setup.

### Workspace file

The repository also includes a dedicated workspace file:

- `brain-factory.code-workspace`

Use the workspace file when you want a preconfigured working context for the repository.

## Recommended Contributor Flow

1. Open the repository in VS Code.
2. Use the workspace file if you want the intended repository context.
3. Reopen in the dev container if you want a reproducible environment.
4. Review recommended extensions and repository tasks.
5. Use the repository templates and docs when creating issues, branches, and pull requests.

## How this supports the framework

A shared contributor environment helps the framework by:

- reducing environment drift
- improving onboarding consistency
- making tasks and tooling more discoverable
- supporting repeatable AI-assisted workflows
- letting humans and agents work from the same repository conventions

## Maintenance Guidance

Review these environment files whenever:

- repository workflows change materially
- new tooling becomes standard for contributors
- task automation is added or removed
- onboarding friction is discovered during team use

If environment choices affect contributor behavior, update this guide and any related README references.

## Mobile quick action

- **Use when:** you need to triage contributor setup friction quickly from mobile.
- **Do from mobile:**
  - Confirm whether the question is about dev container, VS Code settings, or workspace usage.
  - Request or add missing environment details in the issue (surface, symptom, expected behavior).
  - Open or update a focused onboarding/docs follow-up issue when gaps are confirmed.
- **Do not do from mobile:**
  - Edit dev container or workspace configuration files.
  - Treat unverified setup assumptions as resolved.
- **Escalate to desktop/cloud when:**
  - Environment configuration changes are required.
  - Validation requires reproducing setup behavior locally or in a container.
- **Primary artifact to update:**
  - The contributor setup issue or pull request documenting the environment fix.

## Related docs

- [How Brain Factory works](how-brain-factory-works.md) — five-minute tour for newcomers.
- [Operating model](operating-model.md) — how the framework runs day-to-day.
- [Product support and improvement loop](product-support-and-improvement-loop.md) — how signals flow back into the framework.
- [Framework continuity and memory](framework-continuity-and-memory.md) — what the framework remembers across sessions.
- [Branching and cleanup](branching-and-cleanup.md) — branch lifecycle and stale-branch handling.
- [Governance checklist](governance-checklist.md) — periodic audit items.
