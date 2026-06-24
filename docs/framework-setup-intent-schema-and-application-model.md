# Framework Setup Intent Schema and Application Model

This document is the **setup contract** for the framework: a precise specification of the
input a setup flow consumes (the *setup intent*), how defaults are resolved, which artifacts
setup produces, and what "ready to work" means once setup finishes. Think of it as the data
contract that turns written setup guidance into a repeatable, auditable, tool-driven flow.

It is for contributors building or maintaining setup tooling, and for operators who want to
understand what a setup run does. New to the project? Start with
[How Brain Factory works](how-brain-factory-works.md); to pick a starting profile, see the
[setup profiles and intent examples](framework-setup-profiles-and-intent-examples.md).

## Why this exists

The framework already has strong governance, onboarding, profile, and automation guidance.
What it lacked was an explicit contract tying those pieces together — connecting:

- user setup intent (a prompt or structured input)
- profile and default selection
- deterministic artifact application
- readiness validation

This document is the source of truth for that bridge.

## Scope for this contract

This is the contract layer, not the full implementation.

- It **defines** the schema, mapping rules, expected outputs, and success criteria.
- It does **not** specify a complete setup engine; tooling is built incrementally against this
  contract (see [Implementation notes](#implementation-notes) for what already exists).

Any setup script or tool must conform to this contract.

## Canonical setup input surfaces

A future setup flow should accept either:

1. **Natural-language setup prompt** (user describes team/product/deployment intent)
2. **Structured setup intent document** (machine-readable canonical input)

Natural-language input must be normalized into the structured setup intent before
artifact mutations occur.

For an operator-facing bootstrap flow from natural-language setup needs to
readiness validation, use
[`docs/runbooks/prompt-to-setup-bootstrap.md`](runbooks/prompt-to-setup-bootstrap.md).

## Canonical setup intent artifact

Default path for normalized setup intent:

- `.github/framework-setup-intent.json`

If adopters need another path, they should keep a stable pointer and preserve the
same schema.

## Setup intent schema (v1)

Top-level object:

| Field | Required | Type | Description |
| --- | --- | --- | --- |
| `schema_version` | Yes | string | Schema version, starting with `1.0`. |
| `setup_id` | Yes | string | Unique identifier for this setup application packet. |
| `setup_mode` | Yes | string enum | `new_adoption` or `existing_repo_upgrade`. |
| `project` | Yes | object | Project shape and delivery intent. |
| `team` | Yes | object | Team/operator profile and ownership context. |
| `deployment` | Yes | object | Deployment/operations model expectations. |
| `governance` | Yes | object | Governance/evidence posture. |
| `automation` | Yes | object | Automation bundle and enablement strategy. |
| `execution_surfaces` | Yes | array | Surfaces expected in active workflow (`vscode_local`, `github_cloud_agent`, `gh_cli`, `github_mobile`, `external_ai`). |
| `security` | Yes | object | Security-sensitivity posture and routing expectations. |
| `preferences` | No | object | Optional preferences for naming, cadence, and documentation emphasis. |
| `deferred` | No | array | Explicit deferred setup items with enablement criteria and owner. |
| `notes` | No | string | Optional human-readable setup notes. |

### Required nested fields

| Path | Required | Type | Notes |
| --- | --- | --- | --- |
| `project.name` | Yes | string | Repository/project display name for setup packet. |
| `project.primary_work_types` | Yes | array | One or more work types aligned with `docs/work-type-matrix.md`. |
| `project.repo_shape` | Yes | string enum | `small_repo`, `product_delivery`, `platform_infra`, `support_heavy`, `governance_heavy`. |
| `team.primary_profile` | Yes | string enum | Must map to profile packs (`small_repo_solo`, `product_delivery_team`, `platform_infra_team`, `support_intake_team`, `governance_compliance_overlay`). |
| `team.owners` | Yes | array | At least one durable owner handle/group for setup and follow-up. |
| `deployment.model` | Yes | string enum | `local_only`, `cloud_hosted`, `hybrid`, `platform_shared`, `regulated`. |
| `governance.evidence_level` | Yes | string enum | `lightweight`, `standard`, `strict`. |
| `automation.bundle` | Yes | string enum | `A`, `B`, `C`, `D`, `E`, or `custom`. |
| `automation.stage` | Yes | string enum | `minimum`, `recommended`, or `deferred`. |
| `security.posture` | Yes | string enum | `standard`, `elevated`, or `compliance_strict`. |

### Optional nested fields (recommended when known)

| Path | Type | Purpose |
| --- | --- | --- |
| `team.maturity_level` | string/number | Link to staged adoption depth from `docs/framework-adoption-maturity-model.md`. |
| `deployment.targets` | array | Concrete targets (for example `github_actions`, `kubernetes`, `vercel`, `internal_runner`). |
| `automation.overrides` | object | Controlled deviations from bundle defaults. |
| `governance.cadence` | object | Preferred weekly/monthly/quarterly review rhythm. |
| `preferences.setup_profile` | string | Setup profile ID from `docs/framework-setup-profiles-and-intent-examples.md` used to resolve profile defaults. |
| `preferences.projects_enabled` | boolean | Whether GitHub Projects setup should be applied now. |
| `preferences.mobile_surface` | boolean | Whether mobile quick-action coverage should be enforced now. |

## Profile/default mapping model

Setup engines should apply mapping precedence in this order:

1. **Framework invariants** (never relaxed)
2. **Explicit setup intent fields**
3. **Profile defaults** (`docs/framework-profile-packs.md`)
4. **Automation bundle defaults** (`docs/framework-automation-bundles-by-profile.md`)
5. **Repository fallback defaults** (documented by setup engine)

### Mapping rules

- If intent conflicts with invariants, setup must fail with a clear validation error.
- If intent omits optional fields, fill them from profile + bundle defaults.
- If `preferences.setup_profile` is set, resolve profile defaults from
  `docs/framework-setup-profiles-and-intent-examples.md` before applying
  automation-bundle defaults.
- If `automation.bundle = custom`, setup must still resolve to explicit enabled/deferred
  controls with owner and enablement criteria.
- Every deferred control must be captured as a durable follow-up artifact.

## Expected setup outputs and artifact mutations

A future setup engine should create/update/select these artifacts deterministically.

| Artifact | Action | Required | Purpose |
| --- | --- | --- | --- |
| `.github/framework-setup-intent.json` | Create/Update | Yes | Durable normalized setup input record. |
| Setup application summary artifact (for example issue or doc packet) | Create | Yes | Human-readable record of resolved profile/default decisions, deferrals, and ownership. |
| `AGENTS.md`, `README.md`, `docs/README.md` discoverability links | Update/Verify | Yes | Keep setup pathway and canonical references discoverable. |
| Profile-selection evidence (`docs/framework-profile-packs.md` mapping) | Select/Record | Yes | Show which profile rules were applied. |
| Automation-selection evidence (`docs/framework-automation-bundles-by-profile.md` mapping) | Select/Record | Yes | Show which bundle/stage was applied and what is deferred. |
| Starter/adoption guidance references (`docs/framework-starter-kit.md`, `docs/framework-portability-and-adoption.md`) | Select/Record | Yes | Preserve transplant/adoption coherence. |
| Queue/governance follow-up issue(s) for deferred setup work | Create (when deferred exists) | Conditional | Ensure deferred scope is durable and owner-bound. |
| Optional profile-specific overlays (Projects, mobile, additional runbooks) | Select/Apply | Optional | Enable only when intent/profile indicates readiness. |

## Successful application state: "framework applied / ready to work"

A setup application is successful only when all of the following are true:

1. Setup intent validates against this schema (required fields present, enums valid).
2. Invariants remain intact (GitHub artifacts as system of record, normalized context,
   bounded PR model, handoff packet expectations, security routing).
3. Profile and automation selections are explicit and traceable to source docs.
4. Deferred items (if any) are explicitly recorded with owner + enablement criteria.
5. Discoverability entrypoints reference the setup contract and selected operating path.
6. Baseline validation checks pass in the configured repository state.

Minimum validation evidence should include:

- `npx -y markdownlint-cli2 "**/*.md"`
- `bash scripts/check-framework-task-queue.sh`
- `bash scripts/check-queue-health.sh`
- other enabled checks from the selected automation bundle

## Example setup intent (v1)

```json
{
  "schema_version": "1.0",
  "setup_id": "setup-2026-05-26-product-team",
  "setup_mode": "new_adoption",
  "project": {
    "name": "payments-api",
    "primary_work_types": ["enhancement", "defect", "automation"],
    "repo_shape": "product_delivery"
  },
  "team": {
    "primary_profile": "product_delivery_team",
    "owners": ["@team-leads"],
    "maturity_level": "2"
  },
  "deployment": {
    "model": "cloud_hosted",
    "targets": ["github_actions", "kubernetes"]
  },
  "governance": {
    "evidence_level": "standard"
  },
  "automation": {
    "bundle": "B",
    "stage": "recommended"
  },
  "execution_surfaces": ["vscode_local", "github_cloud_agent", "gh_cli"],
  "security": {
    "posture": "standard"
  },
  "preferences": {
    "projects_enabled": true,
    "mobile_surface": false
  },
  "deferred": [
    {
      "item": "prepare-next-task workflow",
      "reason": "queue governance not yet routine",
      "enablement_criteria": "queue state transitions are stable for two cycles",
      "owner": "@team-leads"
    }
  ]
}
```

## Implementation notes

The following components from the implementation plan have been added:

1. **Schema validator** (`scripts/apply-setup.sh`) — validates
   `.github/framework-setup-intent.json` against this schema and resolves
   profile defaults.
2. **Setup application engine** (`scripts/apply-setup.sh`) — reads a setup
   intent, validates it, writes it to the canonical path, and outputs a
   concise operator summary of applied settings and next steps.
3. **Readiness validator** (`scripts/check-setup-readiness.sh`) — checks each
   readiness dimension defined in this contract and reports pass/fail with
   guidance on baseline validation commands to run.
4. **Bootstrap runbook** (`docs/runbooks/apply-setup.md`) — step-by-step
   procedure connecting intent creation → apply → readiness → bootstrap issue.

The prompt-to-intent normalization path (natural-language input → structured
JSON) is out of scope for this iteration and should be addressed in a follow-up PR.

Those implementations treat this document as the canonical contract unless
superseded by ADR.

## Related docs

- [Framework profile packs](framework-profile-packs.md)
- [Framework automation bundles by profile](framework-automation-bundles-by-profile.md)
- [Framework setup profiles and intent examples](framework-setup-profiles-and-intent-examples.md)
- [Prompt-to-setup bootstrap](runbooks/prompt-to-setup-bootstrap.md)
- [Framework readiness checklist](framework-readiness-checklist.md)
- [Apply setup runbook](runbooks/apply-setup.md)
- [Framework starter kit / bootstrap pack](framework-starter-kit.md)
- [Framework portability and adoption](framework-portability-and-adoption.md)
- [Framework continuity and memory](framework-continuity-and-memory.md)
- [Framework health check](framework-health.md)
- [GH agents and automation](gh-agents-and-automation.md)
- [Framework release/versioning/deprecation model](framework-release-versioning-and-deprecation.md)
- [Start a framework change](runbooks/start-a-framework-change.md)
