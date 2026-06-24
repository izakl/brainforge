<!-- mobile-quick-action: How framework versions, releases, and the up/down learning loop are recorded. -->

# Brain-factory registry

The registry is the hub-side record that powers the bidirectional improvement
loop described in [the architecture](../../docs/framework-brain-factory-architecture.md).

## Contents

| Path | Purpose |
| --- | --- |
| `framework-version.json` | The current canonical framework version and the core modules it ships. `<prefix>-upgrade` compares a brain's `framework_version` against this. |
| `releases/` | One note per framework version describing what changed and what action brains should take on upgrade. |
| `learnings-inbox/` | Upstream proposals (the up-sync): structured learnings emitted from project brains via `<prefix>-learn`, awaiting curation into a release. |
| `propagation.md` | How the down-sync (`<prefix>-upgrade`) computes and applies an upgrade plan to a brain. |

## Up-sync (brain → hub)

1. A brain runs `<prefix>-learn`, producing a structured learning file.
2. The learning is opened as a PR adding a file under `learnings-inbox/`
   (files promoted via PR, consistent with GitHub-as-system-of-record).
3. A maintainer curates accepted learnings into the next framework release and
   updates the core modules + `framework-version.json` accordingly.

## Down-sync (hub → brain)

1. A brain runs `<prefix>-upgrade`.
2. The command reads `framework-version.json`, compares it with the brain's
   manifest `framework_version`, and reads the intervening `releases/` notes.
3. It produces an **upgrade plan** (which core modules changed and why), applies
   the core-layer deltas, preserves the project's `extensions`, and bumps the
   brain manifest's `framework_version`.

See `propagation.md` for the detailed contract.
