# Framework Repo-Transplant Checklist

Use this checklist to transplant Brain Factory's framework into a different
repository — that is, to copy and adapt the core operating model, templates, and
guardrails into a new home. It turns the portability and starter-kit guidance
into strict, gate-based migration controls so teams do not ship a partial or
unsafe adoption.

New to the project? Read [How Brain Factory works](how-brain-factory-works.md)
and the [starter kit](framework-starter-kit.md) before running these gates.

Scope: this document is a checklist and documentation linkage only. It is not
authorization to modify another repository; each target repo needs its own
bounded issue and PR.

## How to use this checklist

1. Open one migration issue in the target repository with the full work packet
   (objective, context, constraints, acceptance criteria, validation expectations).
2. Run this checklist in order. Do not skip phase gates.
3. For each gate, attach required evidence in the migration issue or PR.
4. If any gate fails, stop and open bounded follow-up issues before continuing.

## Migration invariants (must hold at all times)

These invariants are mandatory throughout pre-migration, migration, and
post-migration validation:

1. **GitHub artifacts are the system of record.** Migration decisions and evidence
   must live in issues/PRs/docs, not chat-only notes.
2. **External context is normalized before implementation.** Any external guidance
   must be promoted into target-repo issues/PR context first.
3. **Bounded PR scope is preserved.** Use one objective per PR; split deferred work
   into linked follow-up issues.
4. **Required packet fields remain intact.** Objective, context, constraints,
   acceptance criteria, and validation expectations stay explicit.
5. **Validation gates cannot be bypassed.** Required checks must pass before merge.
6. **Repo-specific assumptions are explicit.** Hardcoded links/owners/paths must be
   identified and adapted or deferred with rationale.

If an action violates an invariant, pause the migration and correct the plan before
proceeding.

## Repo-specific assumption capture ledger (required before Gate 1)

Record each assumption and adaptation decision in the migration issue/PR:

| Assumption area | Source repo pattern | Target repo decision | Evidence artifact |
| --- | --- | --- | --- |
| Org/repo links | Hardcoded links in templates/docs | Updated to target owner/repo | Link to changed file(s) |
| Ownership model | Owner handles/CODEOWNERS routing | Updated reviewer/owner mapping | CODEOWNERS diff + reviewer note |
| Label/project taxonomy | Current label names + project field model | Mapped to target taxonomy | Issue template/project config diff |
| Validation inventory paths | Script-expected files/tables/indexes | Paths adapted or checks deferred with issue link | Script/workflow diff + defer issue |
| Workflow names/permissions | Existing workflow trigger + permission model | Adapted least-privilege workflow config | Workflow diff |
| Branch/merge conventions | Current cleanup/status expectations | Target branch policy confirmed | Target governance doc/PR note |

Do not start Gate 1 until all assumption rows are filled with a decision.

## Phase gates

Run these gates in strict order: Gate 0 → Gate 1 → Gate 2. Each gate is a
stop/go control point with required evidence. Do not start the next gate until
the current gate has a clear proceed decision recorded in a durable artifact.

## Gate 0 — Pre-migration readiness

### Gate 0 required actions

- [ ] Migration issue exists in target repo with full work packet fields.
- [ ] Adoption scope is classified as essential/recommended/optional.
- [ ] Initial file set is selected from `framework-starter-kit.md`.
- [ ] Repo-specific assumption ledger is started (all rows present).
- [ ] Non-goals and deferrals are listed as bounded follow-up issues.

### Gate 0 required evidence

- Link to migration issue with completed packet fields.
- Link to starter inventory decision note (what is in/out now).
- Link to assumption ledger (table in issue/PR body or linked doc).
- Links to deferral issues for any excluded recommended/optional components.

### Gate 0 decision

Proceed only when all required evidence exists and no invariant is violated.

## Gate 1 — Controlled migration execution

### Gate 1 required actions

- [ ] Create one bounded migration PR in the target repo.
- [ ] Transplant selected files with explicit copy/adapt decisions.
- [ ] Update hardcoded owner/repo references discovered in Gate 0.
- [ ] Keep required issue/PR packet fields and continuity rules intact.
- [ ] Document any deferred rewiring (scripts/workflows/docs) with linked issues.

### Gate 1 required evidence

- Migration PR link with objective/constraints/non-goals filled.
- File-level diff references showing copy/adapt/customize decisions.
- Explicit note confirming invariants remained intact.
- Linked defer issues for every intentionally skipped adaptation.

### Gate 1 decision

Proceed only when migration PR scope is bounded and all adapted assumptions are
either completed or deferred with linked issues.

## Gate 2 — Post-migration validation and closure

### Gate 2 required actions

- [ ] Run required markdown/docs/framework checks in target repo.
- [ ] Confirm target CI passes the same required checks.
- [ ] Verify cross-link discoverability from README/docs/AGENTS entrypoints.
- [ ] Confirm assumption ledger is resolved (adapted or deferred with links).
- [ ] Capture validation evidence and close migration issue with outcomes.

### Gate 2 required evidence

- Local command outputs (or summarized pass logs) attached to PR.
- CI run URL(s) with successful status.
- Manual checklist note confirming discoverability links resolve.
- Final migration summary: completed scope, deferred scope, next owner.

### Gate 2 decision

Merge only after all required checks pass and closure evidence is written into
durable artifacts.

## Validation commands and checks

Run the following in the target repository after migration changes are in place:

```bash
# Markdown lint
npx -y markdownlint-cli2 "**/*.md"

# Markdown link check (one file at a time or changed files)
npx -y markdown-link-check -q -c .github/markdown-link-check.json <file>

# SVG companion parity
bash scripts/check-svg-companions.sh

# Mobile quick-action coverage
bash scripts/check-mobile-quick-action.sh

# Handoff packet completeness
bash scripts/check-handoff-packet.sh

# Security guardrail anchors
bash scripts/check-security-guardrails.sh

# ADR / runbooks / examples index parity
bash scripts/check-index-parity.sh

# Framework task queue integrity
bash scripts/check-framework-task-queue.sh

# Queue health and drift detection
bash scripts/check-queue-health.sh
```

Only run checks that are actually enabled in the target repository. If a check is
deferred, create a follow-up issue and record it in the assumption ledger.

## Migration evidence packet template

Use this compact template in the migration PR description:

| Field | Evidence |
| --- | --- |
| Gate 0 readiness evidence | `<links>` |
| Gate 1 migration evidence | `<links>` |
| Gate 2 validation evidence | `<links>` |
| Invariants confirmation | `<explicit yes/no + note>` |
| Assumption ledger link | `<link>` |
| Deferred items and follow-up issues | `<links>` |
| Next owner | `<@team-or-user>` |

## Mobile quick action

This section is intentionally last: it is an execution shortcut for status
checks, not a replacement for full desktop/cloud gate validation.

- **Use when:** you need to verify gate status or capture a migration blocker quickly.
- **Do from mobile:**
  - confirm the current gate and whether required evidence links exist
  - open one issue per blocker or deferred adaptation
  - leave a status comment naming next owner and validation step
- **Do not do from mobile:**
  - approve gate completion without checking evidence artifacts
  - perform broad multi-file transplant planning edits
- **Escalate to desktop/cloud when:**
  - migration requires coordinated template/workflow/script updates
  - validation commands and CI failure triage are required
- **Primary artifact to update:**
  - the migration issue or PR carrying this checklist evidence

## Related docs

- [Framework portability and adoption](framework-portability-and-adoption.md)
- [Framework starter kit / bootstrap pack](framework-starter-kit.md)
- [Framework readiness checklist](framework-readiness-checklist.md)
- [Framework profile packs](framework-profile-packs.md)
- [Framework automation bundles by profile](framework-automation-bundles-by-profile.md)
- [Framework health](framework-health.md)
- [Operator onboarding pack](operator-onboarding-pack.md)
