# Cross-lane onboarding contract

Reusable contract for onboarding and retrofitting project lanes so proven
autonomy behavior transfers safely across brains.

## Objective

Standardize lane onboarding so proven patterns are promoted once and inherited
without rework:

1. Proving lane validates a pattern in real delivery.
2. Brain Factory codifies the pattern in core artifacts.
3. Inheriting lanes adopt through inspect-first and bounded apply.

## Non-negotiable gates

| Gate | Contract |
| --- | --- |
| Approval gate | No onboarding apply step runs without an explicit, reviewable decision packet (scope, keep/augment/add decisions, acceptance criteria, owner). |
| Boundary gate | `brain.manifest.json` remains the authority for core vs extension ownership; `adopted: false` assets are never silently overwritten. |
| No-loss gate | External or pre-existing context must be migrated to durable GitHub artifacts before execution depends on it; no chat-only or Drive-only execution truth. |
| Inspect-first gate | Existing repos always run inspect before apply; blind provision is only for truly new/empty repos. |
| Queue integrity gate | Out-of-band completion must be recorded honestly (`done`) and any intentionally paused downstream auto-flow must carry an explicit `hold_reason`. |

## Required onboarding packet

Every lane onboarding/retrofit packet must include:

- Objective and scope boundaries (what is in/out for this onboarding).
- Current-state evidence (gap report + notable drift/risk findings).
- Module-by-module decisions (`keep`, `augment`, `add`) with rationale.
- Core/extension ownership mapping in manifest terms.
- Explicit confirmation that all toolchain instruction files (`AGENTS.md`,
  `.github/copilot-instructions.md`, `CLAUDE.md`) carry the permanent
  `SYNC-LATEST-FIRST`, `CLEANUP-NO-STALE-STATE`, and
  `CONTINUITY-CAPTURE / BRAIN-MEMORY WRITEBACK` standards.
- Validation plan and explicit operator approval checkpoint.
- Durable writeback plan (issue/PR links, continuity entry, queue linkage).

## Transfer loop contract (prove → codify → inherit)

| Stage | Owner | Durable output |
| --- | --- | --- |
| Prove in a lane | Lane operators | Learning file in `brain-factory/registry/learnings-inbox/` with evidence PR/issue links. |
| Codify in factory | Hub maintainers | Updated template/onboarding/registry artifacts + release note describing the generalized change. |
| Inherit in other lanes | Lane operators + hub maintainers | Inspect-first onboarding PRs applying only approved deltas, with boundary/no-loss evidence. |

## Done criteria for a lane onboarding

- Gap report exists and is linked from the onboarding issue/PR.
- Approval checkpoint is recorded before apply.
- Manifest reflects ownership boundaries and enabled core modules.
- External context migration is complete and durable in GitHub artifacts.
- Onboarding PR is merged with validation evidence.
- Queue/task state reflects actual lane state (no stale `pending`/`blocked` drift).
