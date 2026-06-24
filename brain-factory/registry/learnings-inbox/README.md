# Learnings inbox (up-sync)

This directory receives **structured learnings** emitted from project brains via
`<prefix>-learn`. Each learning is a candidate improvement to the framework, awaiting
curation into a release.

## How a learning arrives

A brain runs `<prefix>-learn`, which writes a learning file and opens a PR adding it
here. Files are promoted via PR (consistent with GitHub-as-system-of-record), so
the inbox is an auditable queue of proposals.

## Learning file format

Name: `<framework-version-seen>-<project-slug>-<short-slug>.md`

```markdown
# Learning: <short title>

- From brain: <owner/repo>
- Framework version seen: <x.y.z>
- Proposed core module: <module id or "new">
- Kind: added | changed | deprecated | removed

## What we observed
<the concrete situation in the project that revealed the gap or improvement>

## What we propose for the framework
<the generalized change to a core module — must be project-neutral>

## Evidence
<links to the brain PR(s)/issue(s) where this was proven>
```

## Curation

A maintainer reviews inbox items, generalizes anything project-specific, folds
accepted items into the next `releases/` note and the affected core modules,
bumps `framework-version.json`, and removes the curated learning from the inbox
(its history is preserved in git and the release note).
