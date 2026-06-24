# Adoption example: platform and infrastructure team

This example walks a platform or infrastructure team through adopting Brain Factory in
a shared-services repository, where automation changes, CI/CD updates, and cross-team
reliability impacts are routine. Because a change here can break many downstream teams
at once ("broad blast radius"), this team turns on more guardrails from day one. A
**profile** is the preset matching team size and risk; an **automation bundle** is its
matching set of CI checks; an **ADR** (Architecture Decision Record) is a short,
durable note capturing a decision and its rationale. New to the project? Read
[`../docs/how-brain-factory-works.md`](../docs/how-brain-factory-works.md) first.

## Scenario

A platform engineering team of four manages shared GitHub Actions workflows, internal
tooling, and CI/CD infrastructure used by ten product teams. Changes to this repository
have broad blast radius: a broken workflow or misconfigured permission can block all
downstream teams.

The team wants strong intake discipline, early detection of automation drift, explicit
security routing, and durable records for decisions that affect the platform. ADRs are
important because platform decisions affect teams that did not participate in the original
discussion.

## Profile selected

**Platform / infrastructure team.**

Chosen because:

- workflow and automation changes are frequent with broad downstream impact
- failure blast radius is broad across teams and repositories
- CI/CD and security-sensitive changes require stronger operational controls
- durable policy decisions (ADRs) are needed so consumers can understand the rationale

See [`docs/framework-profile-packs.md`](../docs/framework-profile-packs.md) for
the full profile definition.

## Automation bundle selected

**Bundle C — Platform / infrastructure team.**

Chosen because:

- baseline checks are non-negotiable for any profile
- handoff enforcement is essential with a small team operating across multiple surfaces
- index parity and SVG checks keep documentation coherent as the ADR catalog grows
- queue integrity check is appropriate because platform roadmap work benefits from
  structured queue operations
- stale-branch automation is deferred until branch volume justifies the setup cost

See [`docs/framework-automation-bundles-by-profile.md`](../docs/framework-automation-bundles-by-profile.md)
for the full bundle definition.

## File selection

### Copied and adapted on day one (Essential tier)

| File | Adaptation made |
| --- | --- |
| `AGENTS.md` | Updated repo links; added platform-specific agent surface guidance and blast-radius note |
| `docs/framework-continuity-and-memory.md` | Kept principles; updated scope to reflect platform and infrastructure context |
| `docs/operating-model.md` | Kept; no adaptation needed |
| `.github/ISSUE_TEMPLATE/framework-change.yml` | Adapted into `platform-change.yml` and `incident.yml`; added risk/blast-radius field |
| `.github/ISSUE_TEMPLATE/config.yml` | Updated repo URLs and private advisory link |
| `.github/pull_request_template.md` | Added explicit risk-assessment and rollback-plan fields; kept all required packet fields |
| `.github/workflows/markdown.yml` | Kept as-is |
| `.github/markdown-link-check.json` | Kept as-is |
| `.markdownlint.jsonc` | Kept as-is |
| `SECURITY.md` | Updated owner references; added platform-specific escalation path |
| `docs/security-and-secure-delivery.md` | Kept; no adaptation needed |

### Added in the first week (Recommended tier, essential for this profile)

| File | Why added |
| --- | --- |
| `scripts/check-security-guardrails.sh` + workflow | Security anchor check; especially important for platform repositories |
| `docs/security-and-secure-delivery.md` | Referenced in PR template risk field; enforced from day one |
| `docs/multi-agent-handoff-playbook.md` + `docs/handoff-packet-template.md` | Agent-assisted platform changes require consistent handoffs |
| `scripts/check-handoff-packet.sh` + workflow | Handoff quality enforced in CI from day one |
| `docs/adr-template-guide.md` | ADR authoring starts immediately for platform decisions |
| `docs/work-type-matrix.md` | Automation and security-sensitive paths follow matrix guidance |

### Added in the first two weeks (Recommended tier, added once ADR surface began growing)

| File | Why added |
| --- | --- |
| `scripts/check-index-parity.sh` + `framework-audit.yml` | ADR index drift becomes a risk quickly in platform repos |
| `scripts/check-svg-companions.sh` | Added with index parity; Mermaid diagrams appear in ADRs and architecture docs |
| `docs/framework-health.md` | Monthly health audits formalized; platform team uses recurring check cadence |
| `docs/governance-checklist.md` | Periodic governance review established |
| `docs/framework-reporting-and-review-cadence.md` | Weekly hygiene and monthly health review cadence established |

### Added in the first month (Recommended tier, added with queue operations)

| File | Why added |
| --- | --- |
| `docs/framework-queued-execution-memory.md` | Platform roadmap work moves to queue-backed model |
| `scripts/check-framework-task-queue.sh` | Queue schema validation enabled in CI |
| `scripts/check-queue-health.sh` | Queue health and drift detection enabled |
| `.github/framework-task-queue.json` | Machine-readable queue state established |

### Explicitly deferred

| Component | Deferral rationale |
| --- | --- |
| Stale-branch automation | Branch volume does not yet justify setup; deferred until justified |
| `prepare-next-framework-task.yml` workflow | Merge-triggered next-task preparation deferred until queue operations are stable |
| Governance/compliance overlay (Bundle E) | Not required; current platform work does not have strict audit obligations yet |
| `docs/github-projects-setup.md` | Platform work tracked in parent org project; dedicated Projects instance not needed yet |

## First-week rollout path

### Day 1: Copy and adapt the essential baseline with security focus

- Copied the ten-file essential baseline from the framework starter kit
- Added platform-specific risk and rollback fields to the PR template
- Added platform-change and incident issue templates with blast-radius and downstream-impact fields
- Opened one bootstrap PR scoped only to the essential baseline and template adaptations
- Ran markdown lint, link check, and security guardrail check locally before pushing
- Confirmed all CI checks passed before merging

### Day 2–3: Add handoff enforcement and ADR infrastructure

- Added handoff packet template and enforcement check
- Added `docs/adr-template-guide.md` and the existing ADR template to the repository
- Opened the first platform ADR: decision to adopt this framework for platform change governance
- Confirmed ADR index parity check was in place before ADR volume grew

### Day 4–5: Enable index parity and recurring audit

- Added `scripts/check-index-parity.sh`, `scripts/check-svg-companions.sh`, and the
  monthly `framework-audit.yml` workflow
- Confirmed checks ran in CI against the first ADR
- Opened follow-up issue: "Enable queue operations once roadmap items are structured"

### End of week: Run one real platform change through the full loop

- Opened a real platform-change issue with the adapted template (risk, blast-radius, downstream
  consumers, rollback plan)
- Confirmed all packet fields were complete before starting implementation
- Opened implementation PR with explicit risk assessment and validation evidence
- Confirmed all CI checks passed; merged
- Reviewed whether an ADR was warranted for the decision — it was, so one was created

## Customizations and tradeoffs

| Decision | Tradeoff |
| --- | --- |
| Added blast-radius and rollback fields to PR template | Extra friction per PR; justified by broad failure impact |
| ADR-first approach from day one | More overhead upfront; essential for consumer teams who need decision rationale |
| Security guardrail check from day one | Low overhead; important for any repository that manages CI/CD permissions |
| Queue automation added in month one, not week one | Staged correctly; queue operations need stable baseline before adding drift detection |
| Stale-branch automation deferred | Appropriate; branch volume does not justify it yet |
| No GitHub Projects instance | Platform work tracked in parent org project; avoids redundant setup |

## Scale-up triggers to watch

- Repeated CI regressions or permission-risk findings → tighten security guardrail
  enforcement and add incident runbook
- Consumer team coordination friction → add explicit consumer communication template
  and ADRs for breaking changes
- Manual operational steps becoming reliability bottlenecks → promote to runbooks
  and queue-backed roadmap items
- Audit or compliance obligations imposed → activate governance/compliance overlay (Bundle E)

## Mobile quick action

- **Use when:** reviewing this example from mobile to confirm adoption scope, profile
  fit, and deferred items are still appropriate.
- **Do from mobile:**
  - Verify current profile is still Platform / infrastructure team.
  - Check for scale-up triggers (CI regressions, coordination friction, manual bottlenecks).
  - Open one bounded follow-up issue per identified gap.
- **Do not do from mobile:**
  - Execute multi-file bootstrap or ADR infrastructure setup from mobile.
  - Approve platform changes that touch CI/CD permissions without desktop review.
- **Escalate to desktop/cloud when:**
  - Scale-up triggers warrant bundle upgrade or governance overlay activation.
  - Queue operations require coordinated workflow and schema changes.
- **Primary artifact to update:**
  - The active adoption/bootstrap issue or PR that tracks profile selection, deferred decisions,
    and scale-up trigger assessments.

## Related docs

- [Framework profile packs](../docs/framework-profile-packs.md)
- [Framework starter kit / bootstrap pack](../docs/framework-starter-kit.md)
- [Framework automation bundles by profile](../docs/framework-automation-bundles-by-profile.md)
- [Framework adoption maturity model](../docs/framework-adoption-maturity-model.md)
- [Framework portability and adoption](../docs/framework-portability-and-adoption.md)
- [Multi-agent handoff playbook](../docs/multi-agent-handoff-playbook.md)
- [Security and secure delivery guardrails](../docs/security-and-secure-delivery.md)
- [ADR template guide](../docs/adr-template-guide.md)
- [Work-type matrix](../docs/work-type-matrix.md)
- [Adoption example: solo maintainer / small repository](adoption-example-solo-small-repo.md)
- [Adoption example: product delivery team](adoption-example-product-delivery-team.md)
