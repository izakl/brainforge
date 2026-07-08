# Changelog

All notable changes to Brain Factory are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project aims to follow [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

The framework version that brains stamp and sync against is tracked separately in
[`brain-factory/registry/framework-version.json`](brain-factory/registry/framework-version.json).

## [0.8.0] - 2026-07-07

Codifies the inherited **`brain-checks`** CI gate as a governed, inheritable
standard, and blesses richer "superset" capability generators.

### Added

- **CI checks standard.** A new inherited policy
  (`brain-template/04-policies/ci-checks-standard.md`) states the `brain-checks`
  contract: `capabilities --check` (anti-drift) and `intent-gate` (no command
  without a capabilities row) are **always blocking**; `docs-mesh` is **blocking
  by default** with a narrow, honest escape hatch — a lane MAY soft-fail **one**
  check `continue-on-error` only for a pre-existing unresolvable, with a
  `TODO(<lane>-docs-mesh)` and a `::warning::`, and **never** by repointing links
  or editing append-only logs (Contoso's `TODO(contoso-docs-mesh)` is the reference
  precedent).
- **Superset-generator allowance.** The standard blesses a richer, system-wide
  generator (e.g. Northwind's `08-ops/generate-capabilities.ps1`) in place of the
  stock `python -m brainfactory` generator, provided CI still enforces the same
  three invariants. See ADR 0027.
- **Hub guard for the inherited gate.** `scripts/check-brain-factory.sh` now
  asserts the template ships `.github/workflows/brain-checks.yml` with its two
  blocking invocations (`capabilities … --check` and `intent-gate`), so the
  standard cannot be silently removed.

### Changed

- **Framework version → 0.8.0.** Brains inherit the CI-checks standard via
  `<prefix>-upgrade`. `core_modules` is unchanged — this is a policy, not a
  module.
- **`brainfactory` CLI → 0.2.0.** First CLI refresh since 0.1.1, bundling the
  engine changes accumulated since: the inspector's runtime/docs drift scan, the
  `operating-contract` down-sync now also propagating `CLAUDE.md` and
  `.github/copilot-instructions.md`, and a command-naming guard that fails
  `capabilities --check` / `intent-gate` on a redundant `<prefix>-` directory
  instead of emitting a doubled invocation. Additive, backward-compatible
  behavior, so a minor bump; PyPI and npm publish in lockstep. The CLI version
  stays independent of the framework version (ADR 0025).

## [0.7.0] - 2026-07-07

Promotes the **QA-twin pattern** into the hub as a reusable, inheritable core
primitive, generalized from the Northwind System QA twin (`xs-qa`). The Northwind
harness itself stays product-scoped in its lane; only the pattern is inherited.

### Added

- **Core `qa` command.** A new hub-owned core command
  (`03-templates/agent-commands/core/qa/` — SKILL + prompt, invoked
  `<prefix>-qa`) encoding the QA-twin pattern: the map → sweep → validate →
  behavioral → report → fix-route stages, the fast / deep / scenario cadence, and
  the FIX / IMPROVE / FLAG taxonomy. It is a **generic scaffold** each lane
  instantiates into its own harness.
- **Inherited QA standard.** `brain-template/04-policies/qa-standard.md` captures
  the QA discipline — stages, cadence, taxonomy, and the eleven non-negotiable
  lessons (generalized from the donor twin) — inherited by every brain.
- **Twin taxonomy note.** The core-commands catalog now distinguishes the
  **orchestrator twin** (control plane) from the per-lane **product QA twin**
  (`<prefix>-qa`).

### Changed

- **Framework version → 0.7.0.** `core-commands` gains the `qa` command; brains
  inherit it and the QA standard via `<prefix>-upgrade`, and gain a `<prefix>-qa`
  row on the next capabilities regenerate.

## [0.6.0] - 2026-07-06

Adds a third permanent framework operating standard:
**CONTINUITY-CAPTURE / BRAIN-MEMORY WRITEBACK**.

### Added

- **Continuity-capture standard across both toolchains.** Hub and template
  instruction surfaces (`AGENTS.md`, `.github/copilot-instructions.md`,
  `CLAUDE.md`) now require continuity writeback for lane work in product/runtime
  and governance repos.

### Changed

- **No-loss continuity invariant codified.** Lane brains must reflect reality
  across all repos with WHAT/WHY/WHERE/OUTCOME, not governance-only changes.
- **Timing requirement made explicit.** Continuity entries are required at
  in-progress start/PR open and must be finalized on merge.
- **Onboarding/propagation contracts updated.** Lane onboarding packets now
  require explicit verification of the continuity-capture standard, and
  propagation calls out cross-tool instruction updates for continuity capture.

## [0.5.0] - 2026-07-06

Permanent operating standards are now codified as inherited core policy across
all lanes and both agent toolchains (GitHub Copilot and Claude Code).

### Added

- **Cross-tool instruction surfaces in hub + template.**
  `.github/copilot-instructions.md` and `CLAUDE.md` are now first-class operating
  contract surfaces in both the framework repo and the lane brain template.
- **Automated regression checks for permanent standards.**
  Python tests now assert that both standards stay present in `AGENTS.md`,
  `.github/copilot-instructions.md`, and `CLAUDE.md` in both hub and template.

### Changed

- **SYNC-LATEST-FIRST standard codified.**
  Work must begin from current online default branch state; lane/session
  rehydration and merge checks require online freshness first.
- **CLEANUP-NO-STALE-STATE standard codified.**
  Branch/worktree/session cleanup is required after merge with a no-loss gate and
  periodic stale-state auditing.
- **Onboarding and propagation contracts updated.**
  Down-sync now treats cross-tool instruction files as operating-contract surface,
  and lane onboarding packets must verify both permanent standards are present.

## [0.4.0] - 2026-07-06

Acme onboarding learnings are now codified in the framework contract and
release stream: inspect-first drift detection is explicit, non-text migration is
byte-exact by rule, and queue reconciliation supports explicit operator holds
after out-of-band completion.

### Added

- **Explicit queue hold marker.** Queue operations now recognize an explicit
  `hold_reason` marker to keep dependency-satisfied work intentionally blocked
  when external merge windows require pause, while still allowing completed
  upstream work to be marked `done`.

### Changed

- **Inspect-first drift detection codified.** The onboarding inspector now emits a
  high-severity runtime-config drift risk when PostgreSQL versions in runtime
  configuration and docs diverge.
- **No-loss migration contract codified.** Onboarding docs now require base64
  transport plus byte-exact verification for non-text artifact migration before
  apply.
- **Acme onboarding learning curated into release artifacts.** The Acme
  learning was promoted from the inbox into framework release `0.4.0`.

## [0.3.0] - 2026-06-25

Distribution and instrumentation: the `brainfactory` CLI now publishes itself to
PyPI and npm on every release, the framework reports a read-only metrics snapshot,
and the diagram convention moves to live-rendered Mermaid.

### Added

- **Automated CLI publishing.** `publish.yml` publishes the `brainfactory` CLI to
  PyPI (OIDC Trusted Publishing) and npm (with build provenance) when a GitHub
  Release is published. Publishes are idempotent, and the CLI version is
  independent of the framework version (ADR 0025). `release.yml`'s release step is
  now idempotent, so a Release drafted in the GitHub UI works too.
- **Framework metrics.** A read-only metrics snapshot reporting counts and
  coverage across the framework surface, without touching project extensions.
- **CLI distribution docs.** `docs/cli-distribution-and-releases.md` — install via
  pipx / pip / npx, and how a release reaches the registries.

### Changed

- **Diagram convention modernized.** Hand-committed SVG companions are retired in
  favour of live-rendered Mermaid (ADR 0024 supersedes ADR 0012); the
  SVG-companion guardrail is removed.
- **`brainfactory` CLI republished as 0.1.1**, refreshing the PyPI and npm project
  pages with the corrected install instructions.

## [0.2.0] - 2026-06-24

A capability wave on the Phase 1 foundation: the down-sync now executes
end-to-end, the engine installs as a CLI, and releases are automated and
version-checked.

### Added

- **Down-sync execution.** A new `upgrade` engine — CLI `brainfactory upgrade`
  and the `upgrade-brain` adapter task — reconciles a brain's enabled core
  modules to the hub's current template, bumping `framework_version` and each
  refreshed module's `synced_from`, surfacing pre-existing (`adopted: false`)
  modules for manual review, and never touching extensions. Dry-run by default;
  `--apply` writes, `--force` repairs drift.
- **Installable CLI.** `brain-factory/adapters/python/pyproject.toml` packages the
  engine with a `brainfactory` console script (pipx / pip), and `installers/npm/`
  adds an `npx brainfactory` launcher that forwards to it.
- **Release automation.** A tag-triggered `release.yml` publishes a GitHub
  Release from the matching CHANGELOG section, and `check-version-parity.sh` (in
  the `CI gate`) keeps the CHANGELOG, `framework-version.json`, release-notes
  file, and changelog link in lockstep.
- **`tools`/`model` frontmatter** carried onto emitted `.agent.md` projections
  when the source command declares them (ADR 0022).
- **Adapter parity tests** covering the bash + PowerShell dispatcher seam against
  the Python source of truth.

### Changed

- The `<prefix>-upgrade` core command now drives the down-sync engine (dry-run →
  review → apply) instead of describing a manual delta application.
- `sync-public.sh` gained a `--via-pr` publishing mode for a protected public
  `main`.

## [0.1.0] - 2026-06-19

First public release: the Phase 1 foundation of Brain Factory — a hub that
provisions per-project "brain" repositories with an upgradeable core layer, a
project-owned extension layer, and a two-way improvement loop.

### Added

- **Executable layer (`brain-factory/`).** Onboarding engine (read-only
  inspector, plus provision and inspect-first adopt), the
  `brain.manifest.json` contract with schema validation, the registry
  (`framework-version.json`, release notes, learnings inbox) with an idempotent,
  extension-preserving down-sync, the cross-platform adapter seam
  (`run.sh`/`run.ps1` over a shared `tasks.json`, with bash, PowerShell, and
  Python implementations), and the core command catalog.
- **Documentation framework (`docs/`).** Operating model, adoption profiles and
  maturity model, setup-intent model, governance and release policies, metrics,
  operator runbooks, worked examples, and the ADR log.
- **Newcomer-facing docs.** A rewritten, newcomer-first README; a new
  `docs/how-brain-factory-works.md` overview; and architecture diagrams
  (hub↔brain topology and improvement loop, brain anatomy and the core/extension
  boundary, and the adapter seam) as Mermaid with rendered SVG companions.
- **Quality gates.** CI-enforced checks for markdown lint, SVG companion parity,
  mobile quick-action coverage, handoff-packet completeness, index parity,
  security guardrails, task-queue integrity, queue health, and brain-factory
  invariants, aggregated behind an always-on `CI gate` status check.

### Changed

- Rebranded the framework to **Brain Factory**.
- Hardened repository governance: branch protection via a ruleset, automatic
  deletion of merged head branches, and the consolidated `CI gate` required
  check.

[0.8.0]: https://github.com/izakl/brainforge/releases/tag/v0.8.0
[0.7.0]: https://github.com/izakl/brainforge/releases/tag/v0.7.0
[0.6.0]: https://github.com/izakl/brainforge/releases/tag/v0.6.0
[0.5.0]: https://github.com/izakl/brainforge/releases/tag/v0.5.0
[0.4.0]: https://github.com/izakl/brainforge/releases/tag/v0.4.0
[0.3.0]: https://github.com/izakl/brainforge/releases/tag/v0.3.0
[0.2.0]: https://github.com/izakl/brainforge/releases/tag/v0.2.0
[0.1.0]: https://github.com/izakl/brainforge/releases/tag/v0.1.0
