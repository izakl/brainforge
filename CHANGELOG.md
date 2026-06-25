# Changelog

All notable changes to Brain Factory are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project aims to follow [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

The framework version that brains stamp and sync against is tracked separately in
[`brain-factory/registry/framework-version.json`](brain-factory/registry/framework-version.json).

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

[0.3.0]: https://github.com/izakl/brainforge/releases/tag/v0.3.0
[0.2.0]: https://github.com/izakl/brainforge/releases/tag/v0.2.0
[0.1.0]: https://github.com/izakl/brainforge/releases/tag/v0.1.0
