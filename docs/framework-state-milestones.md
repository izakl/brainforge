# Framework State Milestones

This guide gives operators a small, shared set of named milestones for marking the major
transitions in a project's lifecycle — from choosing a setup, to verifying readiness, to
starting work, to handing off and resuming. Recording each milestone in a durable GitHub
artifact (an issue, PR, or snapshot) makes the current state obvious at a glance and lets
anyone safely pick the work back up.

New to the project? [How Brain Factory works](how-brain-factory-works.md) explains the broader
model. The milestones below map onto the numbered lifecycle stages described in the
[lifecycle map](runbooks/framework-lifecycle-map.md).

The model is deliberately lightweight: it adds clarity and resumability, not a heavy runtime
automation engine.

## Milestone model (canonical)

Record the following milestone events as they occur:

| Milestone | What it means | When to record | Evidence / supporting artifacts | What should happen next |
| --- | --- | --- | --- | --- |
| `setup_selected` | A concrete setup profile/intent path is chosen for this repository context. | After Stage 3 selection/adaptation is complete and before setup apply. | Setup profile decision in issue/discussion; selected intent file link. | Run setup application and capture `setup_applied`. |
| `setup_applied` | The selected setup intent has been successfully applied to canonical framework state. | Immediately after `scripts/apply-setup.sh` succeeds. | Apply output summary; `.github/framework-setup-intent.json` link. | Run readiness validation and capture `readiness_verified`. |
| `readiness_verified` | Setup/readiness posture is confirmed valid for bounded work start. | After `scripts/check-setup-readiness.sh` and baseline checks pass (or explicit bounded exception is documented). | Readiness command output and baseline check evidence in issue/PR. | Start one bounded objective and capture `active_work_started`. |
| `active_work_started` | A specific bounded objective has moved from readiness to execution. | When implementation begins for a scoped issue/PR after readiness is valid. | Linked scoped issue, active PR, current owner/surface. | Continue bounded execution or prepare handoff state if pausing/transferring. |
| `handoff_created` | A complete handoff packet (with resumable fields) and continuity snapshot exist for transfer. | After packet + snapshot are published and reviewed for completeness. | Handoff packet link, continuity snapshot link, packet completeness check evidence. | Next owner runs resume verification and captures `resume_completed`. |
| `resume_completed` | The next owner has completed ordered resume verification and selected a safe next action. | After resume runbook checks are completed and durable resume note is published. | Resume verification note, validated lifecycle/setup/readiness posture, chosen next action. | Return to active execution loop and capture/refresh `active_work_started` as needed. |

## Lifecycle-stage relationship

Milestones complement lifecycle stages; they do not replace stage tracking.

| Lifecycle stage | Typical milestone signals |
| --- | --- |
| Stage 3 — Choose or adapt setup | `setup_selected` |
| Stage 4 — Apply setup | `setup_applied` |
| Stage 5 — Verify readiness | `readiness_verified` |
| Stage 6 — Execute work | `active_work_started` |
| Stage 7 — Create handoff / continuity state | `handoff_created` |
| Stage 8 — Resume later | `resume_completed` |

## Continuity, handoff, and readiness relationship

- **Continuity snapshot:** should carry a compact milestone status block so major
  transitions are inspectable at a glance.
- **Handoff packet:** should include milestone acknowledgment fields in the resume
  refinement section so the next owner sees exactly which transitions already happened.
- **Continuity index:** should link to the latest milestone log so current stage and
  implied next action are searchable in one place.
- **Resume flow:** should verify milestone state before coding resumes.
- **Readiness posture:** `readiness_verified` is the event-style confirmation that
  readiness moved from implicit assumption to explicit durable evidence.

## Lightweight milestone acknowledgment convention

Use this checklist in the active issue/PR/snapshot when you need a quick, consistent
state summary:

```markdown
## Framework milestone acknowledgments

- [ ] setup_selected — timestamp + artifact link
- [ ] setup_applied — timestamp + artifact link
- [ ] readiness_verified — timestamp + evidence link
- [ ] active_work_started — timestamp + issue/PR link
- [ ] handoff_created — timestamp + packet/snapshot link
- [ ] resume_completed — timestamp + resume note link
```

Only check a milestone when the supporting evidence exists in a durable repository
artifact.

## Mobile quick action

- **Use when:** you need to confirm milestone progression quickly from mobile.
- **Do from mobile:**
  - Confirm latest milestone checks and links exist in issue/PR comments.
  - Add missing timestamp/link for milestones that already happened.
  - Flag milestones that are claimed without evidence.
- **Do not do from mobile:**
  - Infer or backfill milestone state from memory without artifact proof.
  - Mark readiness or resume milestones complete without validation evidence.
- **Escalate to desktop/cloud when:**
  - Validation commands must be run before recording milestone completion.
  - Handoff/resume artifacts require multi-file or cross-artifact reconciliation.
- **Primary artifact to update:**
  - The active issue, PR, continuity snapshot, or handoff packet carrying current state.

## Related docs

- [Framework lifecycle map and operator journey](runbooks/framework-lifecycle-map.md)
- [Framework continuity snapshot template](framework-continuity-snapshot-template.md)
- [Searchable continuity and artifact indexing guidance](framework-continuity-artifact-indexing.md)
- [Create continuity snapshot](runbooks/create-continuity-snapshot.md)
- [Handoff packet template](handoff-packet-template.md)
- [Resume from a handoff packet](runbooks/resume-from-handoff-packet.md)
- [Apply setup](runbooks/apply-setup.md)
- [Framework readiness checklist](framework-readiness-checklist.md)
