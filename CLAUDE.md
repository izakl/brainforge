# Claude Code operating instructions

This repository's canonical operating contract is [`AGENTS.md`](AGENTS.md).
These Claude Code instructions mirror permanent framework standards that are
required in every lane.

## SYNC-LATEST-FIRST STANDARD (required)

- Sync to latest online default branch before any decision, session creation, or
  code change (`git fetch`; base on `origin/<default>`).
- Start each new work session from an up-to-date default branch.
- Re-sync lane brains/app repos before touching them directly.
- Verify PR mergeability against current online default branch before merge.
- On session start/rehydration, refresh managed lanes before acting/reporting.

## CLEANUP-NO-STALE-STATE STANDARD (required)

- Cleanup triad: remote **BRANCH**, local **WORKTREE**, owning **SESSION**.
- Tear down the full triad together after merge.
- Session definition (Claude Code): the conversation/session workspace.
- Enforce the same no-loss gate before deleting branch/worktree/session; if
  unique unmerged content exists, preserve/escalate instead of deleting.
- Run periodic stale-state audits and flag merged-but-undeleted branches,
  branches with no open PR, orphaned worktrees, and orphaned sessions
  (completed/abandoned sessions still lingering).
- Target one active worktree and one active session per active task.

## CONTINUITY-CAPTURE / BRAIN-MEMORY WRITEBACK STANDARD (required)

- For work executed in any lane repo (product/runtime or governance), the lane
  brain must record WHAT, WHY, WHERE (repo + PR/commit), and OUTCOME.
- Orchestrator actions must write back to the lane continuity ledger and master
  session index after directing/executing lane work.
- A lane change without a brain continuity entry is a defect (memory loss).
- Capture timing: open/update in-progress entry at start or PR open, then
  finalize outcome on merge.
- Cross-link where practical between product/runtime PR and brain continuity
  entry in both directions.
- No-loss continuity invariant: lane brain memory must cover all lane repos, not
  just governance.
