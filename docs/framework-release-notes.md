# Framework Release Notes Index

A single, quick-scan list of every meaningful change to Brain Factory's shared framework. Adopters start here to find what changed since their last upgrade; maintainers add a row here whenever they publish a release note or upgrade summary. New to the project? Start with [Brain Factory: how it works](how-brain-factory-works.md).

## How to use this index

- Add one row for each published framework release note or upgrade summary.
- Keep entries concise and link to the full summary packet.
- Include lifecycle impact, adopter action level, and applicability scope.
- Prefer one row per coherent update batch, not one row per tiny edit.

For how to write the summaries this index points to, see
[`framework-release-notes-and-upgrade-summaries.md`](framework-release-notes-and-upgrade-summaries.md)
and [`framework-change-summary-template.md`](framework-change-summary-template.md).

## Index

| Date | Summary | Lifecycle impact | Adopter action | Applicability | Primary links |
| --- | --- | --- | --- | --- | --- |
| 2026-07-07 | `brain-checks` CI gate codified as an inherited, governed standard (`04-policies/ci-checks-standard.md`): `capabilities --check` + `intent-gate` always blocking, `docs-mesh` blocking-by-default with a narrow honest escape hatch, plus a superset-generator allowance and a hub guard against silent removal | `MINOR` | `Required` | `Universal` | [`brain-factory/registry/releases/0.8.0.md`](../brain-factory/registry/releases/0.8.0.md), [ADR 0027](adr/0027-brain-checks-ci-standard-and-superset-allowance.md) |
| 2026-07-07 | QA-twin pattern promoted to an inheritable core primitive: a new core `qa` command and an inherited QA standard (`04-policies/qa-standard.md`) | `MINOR` | `Required` | `Universal` | [`brain-factory/registry/releases/0.7.0.md`](../brain-factory/registry/releases/0.7.0.md), [ADR 0026](adr/0026-promote-qa-twin-pattern-as-core-primitive.md) |
| 2026-07-06 | Continuity-capture / brain-memory writeback codified as a third permanent operating standard across both toolchains | `MINOR` | `Required` | `Universal` | [`brain-factory/registry/releases/0.6.0.md`](../brain-factory/registry/releases/0.6.0.md), [`AGENTS.md`](../AGENTS.md), [`.github/copilot-instructions.md`](../.github/copilot-instructions.md), [`CLAUDE.md`](../CLAUDE.md) |
| 2026-07-06 | Permanent operating standards codified framework-wide and cross-tool (`SYNC-LATEST-FIRST`, `CLEANUP-NO-STALE-STATE`) | `MINOR` | `Required` | `Universal` | [`brain-factory/registry/releases/0.5.0.md`](../brain-factory/registry/releases/0.5.0.md), [`AGENTS.md`](../AGENTS.md), [`.github/copilot-instructions.md`](../.github/copilot-instructions.md), [`CLAUDE.md`](../CLAUDE.md) |
| 2026-07-06 | Acme onboarding learnings codified into framework release 0.4.0 (byte-exact non-text migration rule, inspect-first runtime/docs drift check, explicit queue hold marker) | `MINOR` | `Recommended` | `Universal` | [`brain-factory/registry/releases/0.4.0.md`](../brain-factory/registry/releases/0.4.0.md), [`brain-factory/onboard/README.md`](../brain-factory/onboard/README.md), [`docs/framework-queued-execution-memory.md`](framework-queued-execution-memory.md) |
| 2026-05-25 | Automation bundle guidance hardened: least-privilege guardrails, per-bundle runbook linkage, advance criteria, and deferred automation registry | `MINOR` | `Recommended` | `Universal` | [`release-notes/2026-05-25-automation-bundles-hardened.md`](release-notes/2026-05-25-automation-bundles-hardened.md), [`framework-automation-bundles-by-profile.md`](framework-automation-bundles-by-profile.md) |
| 2026-05-25 | Release notes + upgrade summary model introduced | `MINOR` | `Recommended` | `Universal` | [`release-notes/2026-05-25-release-notes-upgrade-summary-model.md`](release-notes/2026-05-25-release-notes-upgrade-summary-model.md), [`framework-release-notes-and-upgrade-summaries.md`](framework-release-notes-and-upgrade-summaries.md), [`framework-change-summary-template.md`](framework-change-summary-template.md) |
