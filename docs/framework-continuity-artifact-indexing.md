# Searchable Continuity and Artifact Indexing Guidance

This guide gives operators simple naming and linking conventions that keep
*continuity artifacts* — the durable files that carry a project's state across
sessions, such as snapshots, handoff packets, and readiness evidence — easy to
find and inspect, without standing up a search system. (See the
[glossary](glossary.md) for the precise definition of a continuity artifact, and
[How Brain Factory works](how-brain-factory-works.md) for the bigger picture.)

## Why this exists

The framework already has strong lifecycle, milestone, readiness, handoff, and
queue guidance. Even so, operators lose time reconstructing:

- the latest continuity snapshot
- the latest handoff/resume packet
- current readiness evidence
- blocked/deferred queue posture
- current lifecycle/milestone state

This guide adds lightweight naming/linking/indexing conventions so those answers
are discoverable quickly from durable artifacts.

## Scope and boundary

- This is a docs/template convention layer only.
- Keep indexing lightweight and human-maintainable.
- Do not add a runtime indexing engine or full search service.

## Canonical continuity artifact groups

| Group | Canonical artifacts | What should be obvious |
| --- | --- | --- |
| Lifecycle + milestone state | [`runbooks/framework-lifecycle-map.md`](runbooks/framework-lifecycle-map.md), [`framework-state-milestones.md`](framework-state-milestones.md) | Current stage, last milestone, implied next step |
| Continuity snapshots | [`framework-continuity-snapshot-template.md`](framework-continuity-snapshot-template.md), [`runbooks/create-continuity-snapshot.md`](runbooks/create-continuity-snapshot.md) | Latest snapshot, previous snapshot, next action |
| Handoff/resume packets | [`handoff-packet-template.md`](handoff-packet-template.md), [`runbooks/resume-from-handoff-packet.md`](runbooks/resume-from-handoff-packet.md) | Latest handoff packet, resume readiness, read order |
| Readiness evidence | [`runbooks/apply-setup.md`](runbooks/apply-setup.md), [`framework-readiness-checklist.md`](framework-readiness-checklist.md) | Latest readiness status, evidence links, freshness |
| Queue/deferred state | [`framework-queued-execution-memory.md`](framework-queued-execution-memory.md), [`runbooks/operate-framework-task-queue.md`](runbooks/operate-framework-task-queue.md), [`runbooks/run-queue-health-check.md`](runbooks/run-queue-health-check.md) | What is blocked, deferred, pending, or in progress |

## Lightweight continuity index pattern

For each active workstream, keep one canonical continuity index block in the
primary issue or PR. Keep it short and link outward.

Use this structure:

```markdown
## Continuity artifact index

- Workstream: <short name>
- Current lifecycle stage: <stage 1-8 + link>
- Milestone status reference: <latest milestone log link>
- Read this first: <latest continuity snapshot link>
- Latest continuity snapshot: <link>
- Latest handoff packet: <link or n/a>
- Latest readiness evidence: <link>
- Latest queue/deferred status: <link>
- Blocked by / deferred summary: <one line + links>
- Next ready action: <one line + target artifact>
- Last updated (UTC): <timestamp + owner>
```

## Naming and search-token conventions

Use stable heading tokens so repository search can find current artifacts fast.
Keep tokens unchanged and update only the values/links.

| Artifact class | Recommended heading token |
| --- | --- |
| Continuity index | `## Continuity artifact index` |
| Snapshot body | `## Continuity snapshot` |
| Handoff packet body | `## Handoff packet` |
| Resume verification note | `## Resume verification` |
| Milestone status block | `## Framework milestone acknowledgments` |
| Queue/deferred summary block | `## Queue and deferred-work posture` |
| Readiness evidence block | `## Readiness evidence` |

## Linking and freshness rules

1. **Link latest ↔ previous snapshots.** Every new snapshot should include the
   prior snapshot link and the canonical index link.
2. **Link handoff packets to snapshots and index.** Handoff packets should point
   to the latest snapshot and canonical continuity index.
3. **Link readiness evidence from snapshot/index.** Avoid leaving readiness proof
   only in CI logs or chat.
4. **Link queue/deferred source artifacts directly.** Prefer queue file, queue
   health output notes, and queue-linked issues over summaries without links.
5. **Update one index per state change.** Refresh the continuity index whenever
   lifecycle stage, readiness, handoff status, or queue posture changes.

## Fast-answer map for operators

Use the continuity index first, then confirm in linked artifacts.

| Operator question | Read first | Then confirm in |
| --- | --- | --- |
| What state is this workstream in? | Continuity index (`Current lifecycle stage`) | Lifecycle map + milestone log |
| What should I read first? | Continuity index (`Read this first`) | Latest continuity snapshot |
| What is the latest continuity artifact? | Continuity index (`Latest continuity snapshot`) | Snapshot timestamp + previous link chain |
| What is blocked, deferred, or ready next? | Continuity index (`Latest queue/deferred status` + `Next ready action`) | Queue health + queue file + active issue/PR |
| Is resume safe now? | Latest handoff packet + resume verification note | Readiness evidence + milestone status |

## Low-maintenance safeguards

- Keep one canonical continuity index per active workstream.
- Prefer links over duplicated narrative.
- When information diverges, update the index first, then deeper artifacts.
- If no handoff exists yet, keep `Latest handoff packet: n/a` explicit.

## Related docs

- [Framework continuity snapshot template](framework-continuity-snapshot-template.md)
- [Handoff packet template](handoff-packet-template.md)
- [Framework state milestones](framework-state-milestones.md)
- [Framework lifecycle map and operator journey](runbooks/framework-lifecycle-map.md)
- [Create continuity snapshot](runbooks/create-continuity-snapshot.md)
- [Resume from a handoff packet](runbooks/resume-from-handoff-packet.md)
- [Framework queued execution memory](framework-queued-execution-memory.md)
- [Run the queue health check](runbooks/run-queue-health-check.md)
