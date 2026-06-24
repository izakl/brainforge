# Framework Setup Profiles and Intent Examples

This is a starting-point catalog for setting up a new project. Pick the **setup profile** that
most resembles your situation (for example a solo prototype or a regulated service) and it
gives you sensible defaults to drop into a *setup intent* — the structured description of how
you want the framework configured. The full schema for that input lives in the
[setup intent schema and application model](framework-setup-intent-schema-and-application-model.md);
this catalog supplies the profile presets that fill it in.

It is for anyone bootstrapping the framework in a repository. New to the project? Read
[How Brain Factory works](how-brain-factory-works.md) first.

This document is deliberately limited to:

- reusable setup profiles
- default values for setup-intent fields
- links to concrete, machine-readable setup-intent examples

It does **not** implement setup automation.

## How this catalog fits the setup contract

The setup intent schema defines required/optional fields and mapping precedence.
This catalog supplies reusable default bundles for profile-based setup choices.

Use this order when resolving setup defaults:

1. Framework invariants
2. Explicit setup intent fields
3. Profile defaults from this catalog
4. Automation bundle defaults from
   [`framework-automation-bundles-by-profile.md`](framework-automation-bundles-by-profile.md)
5. Repository fallback defaults

For a guided bridge from natural-language setup description to profile and
intent selection, use
[`docs/runbooks/prompt-to-setup-bootstrap.md`](runbooks/prompt-to-setup-bootstrap.md).

## Reusable setup profile catalog

| Setup profile ID | Typical context | `team.primary_profile` | Default `project.repo_shape` | Default `automation.bundle` / `automation.stage` | Default `governance.evidence_level` | Default `security.posture` |
| --- | --- | --- | --- | --- | --- | --- |
| `solo_prototype` | Solo prototype, low process overhead, fast iteration | `small_repo_solo` | `small_repo` | `A` / `minimum` | `lightweight` | `standard` |
| `solo_production_app` | Solo-owned production service with stronger reliability expectations | `small_repo_solo` | `product_delivery` | `A` / `recommended` | `standard` | `elevated` |
| `small_saas_team` | Multi-contributor SaaS delivery team with steady issue→PR flow | `product_delivery_team` | `product_delivery` | `B` / `recommended` | `standard` | `standard` |
| `internal_platform_service_team` | Platform/infrastructure or shared-service team with broader blast radius | `platform_infra_team` | `platform_infra` | `C` / `recommended` | `strict` | `elevated` |
| `regulated_high_governance_service` | Regulated or audit-heavy service requiring strict evidence and controls | `governance_compliance_overlay` | `governance_heavy` | `E` / `recommended` | `strict` | `compliance_strict` |

## Profile defaults by setup-intent axis

Use these defaults when an intent selects one of the catalog IDs above and does
not override the field explicitly.

| Axis | `solo_prototype` | `solo_production_app` | `small_saas_team` | `internal_platform_service_team` | `regulated_high_governance_service` |
| --- | --- | --- | --- | --- | --- |
| `deployment.model` | `local_only` | `cloud_hosted` | `cloud_hosted` | `platform_shared` | `regulated` |
| `execution_surfaces` | `vscode_local`, `github_cloud_agent` | `vscode_local`, `github_cloud_agent`, `gh_cli` | `vscode_local`, `github_cloud_agent`, `gh_cli`, `github_mobile` | `vscode_local`, `github_cloud_agent`, `gh_cli` | `vscode_local`, `github_cloud_agent`, `gh_cli`, `github_mobile` |
| `preferences.projects_enabled` | `false` | `false` | `true` | `true` | `true` |
| `preferences.mobile_surface` | `false` | `false` | `true` | `false` | `true` |
| Typical deferral posture | Defer non-essential queue/governance layers | Defer queue automation until recurring roadmap usage | Defer queue prep workflow until queue discipline is stable | Defer stale-branch hygiene until branch churn justifies it | Minimize long-lived deferrals; capture owner and review criteria for any exception |

## Mapping rules for setup intent

When using this catalog:

- Record selected profile in `preferences.setup_profile`.
- Populate all required schema fields even when defaults are applied.
- Keep explicit intent fields authoritative when they differ from profile defaults.
- Capture every deferral in `deferred[]` with reason, owner, and enablement criteria.

If `preferences.setup_profile` is omitted, setup can still proceed from explicit
fields and existing schema precedence rules.

## Setup-intent example artifacts

Use these machine-readable examples:

- [`../examples/setup-intent/solo-prototype.intent.json`](https://github.com/izakl/brainforge/blob/main/examples/setup-intent/solo-prototype.intent.json)
- [`../examples/setup-intent/solo-production-app.intent.json`](https://github.com/izakl/brainforge/blob/main/examples/setup-intent/solo-production-app.intent.json)
- [`../examples/setup-intent/small-saas-team.intent.json`](https://github.com/izakl/brainforge/blob/main/examples/setup-intent/small-saas-team.intent.json)
- [`../examples/setup-intent/internal-platform-service-team.intent.json`](https://github.com/izakl/brainforge/blob/main/examples/setup-intent/internal-platform-service-team.intent.json)
- [`../examples/setup-intent/regulated-high-governance-service.intent.json`](https://github.com/izakl/brainforge/blob/main/examples/setup-intent/regulated-high-governance-service.intent.json)

These examples are bounded artifacts for understanding/testing setup-intent
shape and profile-default mapping only.

## Related docs

- [Framework setup intent schema and application model](framework-setup-intent-schema-and-application-model.md)
- [Prompt-to-setup bootstrap](runbooks/prompt-to-setup-bootstrap.md)
- [Framework profile packs](framework-profile-packs.md)
- [Framework automation bundles by profile](framework-automation-bundles-by-profile.md)
- [Framework starter kit / bootstrap pack](framework-starter-kit.md)
- [Framework portability and adoption](framework-portability-and-adoption.md)
- [Operator onboarding pack](operator-onboarding-pack.md)
