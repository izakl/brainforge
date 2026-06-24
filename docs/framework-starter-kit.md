# Framework Starter Kit / Bootstrap Pack

This is the hands-on bootstrap layer for adopting Brain Factory's
documentation-and-governance framework in another repository, without
reverse-engineering this entire repo. It tells you the smallest coherent set of
files to copy first, what to copy versus adapt versus defer, and which checks are
safe to turn on right away.

New to Brain Factory? Start with
[How Brain Factory works](how-brain-factory-works.md). Here, "the framework"
means the reusable operating model, templates, and guardrails you are
transplanting.

This kit sits between the higher-level and stricter adoption docs:

- High-level portability guidance:
  [`framework-portability-and-adoption.md`](framework-portability-and-adoption.md)
- Strict migration control gates:
  [`framework-repo-transplant-checklist.md`](framework-repo-transplant-checklist.md)
- Profile scaling: [`framework-profile-packs.md`](framework-profile-packs.md)
- Profile-aware automation bundle selection:
  [`framework-automation-bundles-by-profile.md`](framework-automation-bundles-by-profile.md)
- Setup-profile defaults and setup-intent examples:
  [`framework-setup-profiles-and-intent-examples.md`](framework-setup-profiles-and-intent-examples.md)
- Natural-language-to-setup bootstrap flow:
  [`runbooks/prompt-to-setup-bootstrap.md`](runbooks/prompt-to-setup-bootstrap.md)
- Maturity progression:
  [`framework-adoption-maturity-model.md`](framework-adoption-maturity-model.md)

## What this starter kit solves

Before this starter kit, adopters had guidance, but still had to infer:

- the smallest coherent file set to copy first
- what to copy directly vs adapt vs defer
- which checks/scripts are safe to enable immediately
- which artifacts depend on repo-specific structure

This pack makes those choices explicit.

## Non-negotiable invariants (must stay unchanged)

1. GitHub artifacts are the execution system of record.
2. External context is normalized before implementation.
3. PRs stay bounded to one objective.
4. Handoffs preserve required packet fields.
5. Validation evidence is captured in durable artifacts.

If a bootstrap path breaks these, it is not compatible adoption.

## Starter inventory (essential / recommended / optional)

"MVP bootstrap" below means the minimum viable first pass: the smallest file set
that gives you a coherent, enforceable framework on day one. Add recommended and
optional tiers later, in separate bounded PRs.

| Tier | Artifact set | Include in MVP bootstrap? | Why |
| --- | --- | --- | --- |
| Essential | `AGENTS.md`, `docs/framework-continuity-and-memory.md`, `docs/operating-model.md` | Yes | Core operating contract and continuity anchor. |
| Essential | `.github/ISSUE_TEMPLATE/framework-change.yml`, `.github/ISSUE_TEMPLATE/config.yml`, `.github/pull_request_template.md` | Yes | Enforces structured intake and bounded PR behavior. |
| Essential | `.github/workflows/markdown.yml`, `.github/markdown-link-check.json`, `.markdownlint.jsonc` | Yes | Baseline docs/links quality gate for framework-first repos. |
| Essential | `SECURITY.md`, `docs/security-and-secure-delivery.md` | Yes | Security-sensitive routing and redaction guardrails. |
| Recommended | `docs/framework-portability-and-adoption.md`, `docs/framework-adoption-maturity-model.md`, `docs/framework-profile-packs.md`, `docs/work-type-matrix.md` | Soon after MVP | Keeps adoption explicit, staged, and profile-aware. |
| Recommended | `docs/framework-release-versioning-and-deprecation.md`, `docs/framework-release-notes-and-upgrade-summaries.md`, `docs/framework-release-notes.md` | Soon after MVP | Gives adopters a predictable update/upgrade model with quick release-summary scanning. |
| Recommended | `docs/framework-health.md`, `docs/governance-checklist.md`, `docs/framework-reporting-and-review-cadence.md`, `docs/framework-metrics-and-feedback.md` | After baseline loop is stable | Gives recurring review and evidence loops. |
| Recommended | `docs/multi-agent-handoff-playbook.md`, `docs/handoff-packet-template.md`, `scripts/check-handoff-packet.sh`, `.github/workflows/check-handoff-packet.yml` | Add at Reliability phase | Makes handoff quality enforceable. |
| Optional | `docs/github-projects-setup.md` | Only if using Projects now | Needed for explicit project state model and routing. |
| Optional | `scripts/check-mobile-quick-action.sh`, `docs/github-mobile-guide.md` | Only if adopting mobile convention now | Useful when mobile is an active operating surface. |
| Optional | `scripts/check-index-parity.sh`, `.github/workflows/framework-audit.yml`, runbooks and examples indexes | Add when docs surface grows | Prevents index drift once repo documentation expands. |
| Optional | `examples/`, `docs/runbooks/`, `docs/prompt-cookbook.md` | As needed | Useful accelerators, not required for the MVP bootstrap. |

## Copy / adapt / customize matrix

| Path | Action | Keep invariant | Customize immediately | Defer-friendly? |
| --- | --- | --- | --- | --- |
| `AGENTS.md` | Copy + adapt | Rules and work-packet contract | Repo links, owner references, validation command paths | No |
| `docs/framework-continuity-and-memory.md` | Copy + adapt | Principles and durable-artifact rules | Scope text, resume/writeback notes | No |
| `docs/operating-model.md` | Copy + adapt | Packet discipline and bounded PR model | Surface names and examples | No |
| `.github/ISSUE_TEMPLATE/framework-change.yml` | Copy + adapt | Required fields and continuity/security checks | Labels, wording, template title prefix | No |
| `.github/ISSUE_TEMPLATE/*.yml` (execution templates) | Copy + adapt selectively | Work-packet field contract (`Objective`, `Context`, `Constraints/non-goals`, `Acceptance criteria`, `Validation expectations`, `Related artifacts`) | Work-type-specific context prompts and labels | Yes |
| `.github/ISSUE_TEMPLATE/config.yml` | Adapt | Private reporting and taxonomy guidance intent | Hardcoded repo URLs/contact links | No |
| `.github/pull_request_template.md` | Copy + adapt | Continuity + CI evidence sections and work-packet carry-forward terminology | Checklist wording, expected labels | No |
| `.github/workflows/markdown.yml` | Copy + adapt | Markdown lint/link checks baseline | Paths, optional extra script step toggles | No |
| `scripts/check-handoff-packet.sh` | Adapt | Nine required handoff fields | Inventory source path and expected files | Yes |
| `scripts/check-mobile-quick-action.sh` | Adapt | Required mobile quick-action labels | Coverage table source paths/patterns | Yes |
| `scripts/check-index-parity.sh` | Adapt | Index-parity intent | Index file paths and file globs | Yes |
| `.github/workflows/framework-audit.yml` | Adapt | Recurring consolidated checks | Which scripts run and trigger filters | Yes |
| `docs/github-projects-setup.md` | Adapt | Durable-state rule | Fields/statuses/views for local workflow | Yes |
| `docs/framework-health.md` | Adapt | Charter-to-artifact mapping discipline | Artifact rows and audit snapshot | Yes |
| `docs/runbooks/*` and `examples/*` | Selective copy/adapt | Durable artifact writeback expectation | Keep only recurring/high-frequency flows | Yes |

## Minimum viable bootstrap checklist

Use this as the transplant control list for a new repository.

- [ ] Confirm adoption owner, reviewer path, and approval boundaries.
- [ ] Add/adapt `AGENTS.md`, continuity anchor, and operating model.
- [ ] Install framework-change issue template and PR template with required packet fields.
- [ ] Configure issue template `config.yml` links to the target repository.
- [ ] Enable markdown lint/link workflow and confirm least-privilege permissions.
- [ ] Add `SECURITY.md` and security guardrail guidance.
- [ ] Open one bootstrap issue documenting scope, constraints, acceptance, and validation.
- [ ] Run lint/link checks locally and in CI.
- [ ] Capture explicitly deferred components as linked follow-up issues.

For required migration phase gates, evidence capture, and invariant validation,
run the full
[`framework-repo-transplant-checklist.md`](framework-repo-transplant-checklist.md)
in parallel with this starter checklist.

## First-hour / first-day / first-week path

### First hour

- Pick an adoption profile (small/product/platform/support-heavy/governance-heavy).
- Copy essential baseline files only.
- Replace hardcoded repo/org references.

### First day

- Open one bounded bootstrap PR with the MVP subset.
- Validate markdown + links.
- Confirm issue/PR templates enforce packet fields.

### First week

- Run one real change through issue → PR → validation → closure.
- Add Reliability components (handoff template/check) if handoffs are frequent.
- Add Projects or cadence/governance layers only where usage justifies them.

## Profile-aware bootstrap guidance

| Profile | Start with | Add next | Defer until needed |
| --- | --- | --- | --- |
| Small repository / solo maintainer | Essential baseline only | Health + governance checklist | Projects complexity, large runbook inventory |
| Product delivery team | Essential baseline + work-type matrix | Projects MVP + handoff enforcement | Heavy governance overlays |
| Platform / infrastructure | Essential baseline + security docs | Handoff enforcement + monthly audit workflow | Broad examples pack |
| Support-heavy / intake-heavy | Essential baseline + support templates + work-type matrix | Projects support views + cadence notes | Extensive ADR catalog |
| Governance/compliance-heavy | Essential baseline + health/governance/cadence + security | Framework audit workflow + stricter evidence packets | Lightweight-only review model |

## Checks/workflows enablement order

Enable checks in this sequence:

1. `markdown.yml` (lint + links) — always first.
2. `check-security-guardrails.sh` + workflow — early, especially for security-adjacent repos.
3. `check-handoff-packet.sh` + workflow — once handoff template and coverage inventory exist.
4. `check-mobile-quick-action.sh` — only after mobile coverage table is curated.
5. `check-index-parity.sh` + `framework-audit.yml` — once ADR/runbook/example indexes are in active use.

Do not enable scripts before their referenced inventories/docs are present.
Use [`framework-automation-bundles-by-profile.md`](framework-automation-bundles-by-profile.md)
to choose which checks/workflows to enable now vs defer by profile/maturity.

## Avoid importing unnecessary complexity too early

- Do not copy all issue templates on day one; start with framework-change + one or two high-frequency types.
- Do not adopt all scripts/workflows at once.
- Do not create broad runbook/example inventories before repeated usage patterns appear.
- Do not adopt advanced Projects fields/views until the MVP status loop is stable.

Use bounded follow-up issues for every deferred component.

## Sample target-repo bootstrap bundle (practical minimum)

This is a recommended first-pass file set for transplant:

```text
AGENTS.md
SECURITY.md
docs/framework-continuity-and-memory.md
docs/operating-model.md
docs/security-and-secure-delivery.md
.github/ISSUE_TEMPLATE/framework-change.yml
.github/ISSUE_TEMPLATE/config.yml
.github/pull_request_template.md
.github/workflows/markdown.yml
.github/markdown-link-check.json
.markdownlint.jsonc
```

Then add recommended/optional layers in separate bounded PRs.

## Mobile quick action

- **Use when:** you need to pick a minimal bootstrap subset quickly from mobile.
- **Do from mobile:**
  - Confirm whether the target repo is still at essential, recommended, or optional tier.
  - Capture one follow-up issue for each deferred starter-kit component.
  - Flag hardcoded links/owners that still reference this source repository.
- **Do not do from mobile:**
  - Plan full multi-file transplant and script rewiring in one pass.
  - Enable advanced workflows before verifying required inventory documents exist.
- **Escalate to desktop/cloud when:**
  - Bootstrap requires coordinated templates/workflows/scripts changes.
  - Repo-specific assumptions require broad path/ownership rewiring.
- **Primary artifact to update:**
  - The bootstrap issue or PR carrying the migration checklist and deferred-scope links.

## Related docs

- [Operator onboarding pack](operator-onboarding-pack.md)
- [Framework portability and adoption](framework-portability-and-adoption.md)
- [Framework repo-transplant checklist](framework-repo-transplant-checklist.md)
- [Framework adoption maturity model](framework-adoption-maturity-model.md)
- [Framework readiness checklist](framework-readiness-checklist.md)
- [Framework profile packs](framework-profile-packs.md)
- [Framework automation bundles by profile](framework-automation-bundles-by-profile.md)
- [Framework setup intent schema and application model](framework-setup-intent-schema-and-application-model.md)
- [Framework setup profiles and intent examples](framework-setup-profiles-and-intent-examples.md)
- [Prompt-to-setup bootstrap](runbooks/prompt-to-setup-bootstrap.md)
- [Framework release/versioning/deprecation model](framework-release-versioning-and-deprecation.md)
- [Framework release notes and upgrade summaries](framework-release-notes-and-upgrade-summaries.md)
- [Framework release notes index](framework-release-notes.md)
- [Work-type matrix](work-type-matrix.md)
- [Framework reporting and review cadence](framework-reporting-and-review-cadence.md)
- [GitHub Projects setup](github-projects-setup.md)
- [Framework health](framework-health.md)
- [Adoption example: starter-kit bootstrap in one bounded issue → PR flow](https://github.com/izakl/brainforge/blob/main/examples/adoption-example-starter-kit-bootstrap-flow.md)
- [Adoption example: profile upgrade from small-repo baseline to product team](https://github.com/izakl/brainforge/blob/main/examples/adoption-example-profile-upgrade-small-to-product.md)
