# Adoption example: profile upgrade from small-repo baseline to product team

This example walks a repository through a bounded upgrade after it outgrows the
solo/small baseline — moving up one profile in a single issue and a single PR,
without sprawling into layers it does not need yet. A **profile** is the preset
matching team size and risk; each profile maps to an **automation bundle** (its set
of CI checks). Here the team moves from Bundle A to Bundle B. New to the project?
Read [`../docs/how-brain-factory-works.md`](../docs/how-brain-factory-works.md)
first.

## Scenario

A repository started with the Small repository / solo maintainer profile. Within two
months, contributor count and concurrent PR volume increased, and handoffs became common.

The team runs one explicit profile-upgrade issue and one bounded PR to move from the
small baseline to product-team operating controls.

## Upgrade trigger and objective

- Trigger: repeated handoff losses and more than two concurrent PRs.
- Objective: upgrade profile and automation from Bundle A to Bundle B without changing
  unrelated governance layers.

## Scope boundary

- In scope:
  - profile decision writeback
  - handoff packet template + enforcement check
  - work-type routing guidance links used by the team
- Out of scope:
  - queue automation rollout
  - governance/compliance-heavy overlays
  - broad documentation redesign

## Artifact trace (issue → PR → validation → writeback)

### 1) Profile-upgrade issue

The issue packet captures:

- objective and context (why profile changed now)
- constraints/non-goals (bounded to Bundle B deltas)
- acceptance criteria (handoff enforcement and routing artifacts live)
- validation expectations (checks to run and evidence to collect)
- linked follow-up items for deferred queue/governance additions

### 2) One bounded profile-upgrade PR

- PR uses `Closes #<profile-upgrade-issue>`.
- PR includes only Bundle B enablement artifacts and cross-links.
- Any later-stage items are referenced with `Relates-to #...`.

### 3) Validation evidence in PR

- `npx -y markdownlint-cli2 "**/*.md"`
- `bash scripts/check-handoff-packet.sh`
- `bash scripts/check-security-guardrails.sh`
- Any existing baseline checks already enabled in the repository.

### 4) Durable writeback

- Issue auto-closes from PR merge.
- Deferred work remains in follow-up issues with explicit trigger criteria.
- Team health/review notes record the profile change and rationale.

## Minimal artifact delta in the upgrade PR

| Added/updated now | Deferred intentionally |
| --- | --- |
| `docs/multi-agent-handoff-playbook.md` and `docs/handoff-packet-template.md` | Queue integrity + queue health scripts/workflows |
| `scripts/check-handoff-packet.sh` + workflow wiring | Scheduled framework audit workflow expansion |
| `docs/work-type-matrix.md` routing references | Governance/compliance overlay documents |

## Why this pattern is high-signal

- It demonstrates profile-based adoption as an incremental issue→PR transition.
- It prevents common anti-patterns (over-scoping and uncontrolled policy expansion).
- It keeps durable continuity through explicit deferred-scope linkage.

## Mobile quick action

- **Use when:** confirming whether profile-upgrade scope and deferred items still look correct.
- **Do from mobile:**
  - Confirm upgrade triggers still apply (handoff losses, PR concurrency).
  - Confirm profile-upgrade PR remains bounded to Bundle B changes.
  - Open one follow-up issue per deferred higher-complexity layer.
- **Do not do from mobile:**
  - Approve broad workflow expansion beyond the bounded profile-upgrade scope.
  - Add queue/governance overlays ad hoc without desktop review.
- **Escalate to desktop/cloud when:**
  - Profile upgrade requires multi-file workflow/script integration work.
  - Deferred queue/governance items need coordinated rollout planning.
- **Primary artifact to update:**
  - The profile-upgrade issue or PR documenting trigger evidence, scope, and deferred links.

## Related docs

- [Framework profile packs](../docs/framework-profile-packs.md)
- [Framework automation bundles by profile](../docs/framework-automation-bundles-by-profile.md)
- [Framework starter kit / bootstrap pack](../docs/framework-starter-kit.md)
- [Framework adoption maturity model](../docs/framework-adoption-maturity-model.md)
- [Framework roadmap: next GitHub agent prompts](../docs/framework-roadmap-next-prompts.md)
- [Operate the framework task queue](../docs/runbooks/operate-framework-task-queue.md)
- [Adoption example: solo maintainer / small repository](adoption-example-solo-small-repo.md)
- [Adoption example: product delivery team](adoption-example-product-delivery-team.md)
