# Framework Prompt Library and Execution Queue

This is the in-repo catalog of major, reusable prompts for GitHub coding agents working on Brain Factory's shared framework. Keeping these high-signal prompts in one curated place means the next big task does not depend on chat history. New to the project? Start with [Brain Factory: how it works](how-brain-factory-works.md).

## Why this exists

The framework already has:

- roadmap ordering (`framework-roadmap-next-prompts.md`)
- machine-readable queue state (`.github/framework-task-queue.json`)
- queue governance and drift recovery (`framework-queued-execution-memory.md`)
- onboarding, release, adoption, and maintenance guidance

What was still missing is a reusable prompt library that:

- captures the next major prompt packets in one durable artifact
- makes execution order and dependency logic easy to scan
- provides copy-ready prompt text and bounded-scope guardrails

## How to use this library

1. Start from the ordered prompt table below.
2. Pick the highest-priority dependency-ready entry.
3. Open one bounded issue using the suggested prompt text.
4. Keep one prompt entry per implementation PR.
5. Record queue/continuity/health writeback expectations in the issue and PR.
6. If execution changes queue state, update `.github/framework-task-queue.json`.

## Relationship to existing queue artifacts

- Canonical queue state and dependency truth:
  [`.github/framework-task-queue.json`](../.github/framework-task-queue.json)
- Human-readable roadmap companion:
  [`framework-roadmap-next-prompts.md`](framework-roadmap-next-prompts.md)
- Queue schema/linkage/governance model:
  [`framework-queued-execution-memory.md`](framework-queued-execution-memory.md)

This library is a durable prompt catalog and execution guide. It complements (does not
replace) queue-state governance artifacts.

## Ordered prompt catalog

| Order | Prompt id | Prompt title | Primary dependencies | Run when |
| --- | --- | --- | --- | --- |
| 1 | `release-summary-operations-system` | Release notes / upgrade summary operations system | Release/versioning + release-summary model docs are already in place | Next time a multi-artifact framework change lands |
| 2 | `profile-automation-bundle-presets` | Automation bundles by profile: executable preset packs | Existing automation-bundle and profile-pack docs | You need less guesswork for profile-based rollout |
| 3 | `downstream-adoption-worked-examples-pack` | Downstream adoption worked examples expansion | Starter kit + profile packs + portability guidance | Adopters need copyable traces, not just policy docs |
| 4 | `framework-readiness-certification-checklist` | Framework readiness/certification checklist | Health, governance, onboarding, release, and queue layers | You need a reusable readiness gate for adopters |
| 5 | `profile-specific-starter-presets` | Profile-specific starter presets | Starter kit + profile packs + automation bundles | Teams need faster profile-based bootstrap packets |
| 6 | `queue-analytics-and-reporting-packets` | Queue analytics/reporting packet layer | Queue-health checks + metrics/cadence docs | You need recurring queue telemetry and trend writeback |
| 7 | `prompt-library-queue-integration-pass` | Prompt library ↔ queue integration hardening | Prompt library + roadmap + queue schema docs | Prompt entries and queue items need tighter parity |
| 8 | `prompt-execution-automation-guardrails` | Prompt execution automation (safety-bounded) | Integration pass + governance decision in issue/ADR | You want stronger automation without autonomous merge chains |

## Prompt entries

### 1) Release notes / upgrade summary operations system

- **Prompt id:** `release-summary-operations-system`
- **Why it matters:** The release model exists, but recurring publication discipline can
  still drift unless operators have a bounded execution packet.
- **When to run:** After meaningful framework updates (`MINOR`/`MAJOR`) or whenever
  release-summary quality becomes inconsistent.
- **Dependencies / prerequisites:**
  - [`framework-release-versioning-and-deprecation.md`](framework-release-versioning-and-deprecation.md)
  - [`framework-release-notes-and-upgrade-summaries.md`](framework-release-notes-and-upgrade-summaries.md)
  - [`framework-release-notes.md`](framework-release-notes.md)
- **Suggested GitHub agent prompt text:**

  > "Create a bounded release-summary operations pass for this framework: tighten when/how
  > release summaries are published, align summary classification fields across docs and
  > templates, and ensure release-note index updates are explicit and reviewable."

- **Expected deliverables:**
  - refined release-summary operating guidance (if needed)
  - any required template/runbook cross-link updates
  - one clear checklist for maintainers
- **Continuity/health/writeback expectations:** Update continuity and health docs if
  lifecycle/writeback expectations materially change.
- **Queue/issue updates expected:** Yes — open one bounded `agent-task` issue; update queue
  state if this is executed from a queue-backed item.
- **Scope boundaries for reviewable PR:** docs/templates/runbook linkage only; no broad
  workflow redesign in the same PR.

### 2) Automation bundles by profile: executable preset packs

- **Prompt id:** `profile-automation-bundle-presets`
- **Why it matters:** Bundle guidance is present, but teams may still need concrete
  profile-ready preset packets to reduce interpretation overhead.
- **When to run:** When adopters repeatedly ask which bundle to apply first.
- **Dependencies / prerequisites:**
  - [`framework-automation-bundles-by-profile.md`](framework-automation-bundles-by-profile.md)
  - [`framework-profile-packs.md`](framework-profile-packs.md)
- **Suggested GitHub agent prompt text:**

  > "Add bounded profile-specific automation preset packets (minimum/recommended/advanced)
  > that map directly to existing bundle guidance and keep least-privilege rollout guardrails
  > explicit."

- **Expected deliverables:**
  - profile preset matrix with explicit enable/defer paths
  - adoption notes for profile + maturity combinations
  - discoverability updates in entrypoint docs
- **Continuity/health/writeback expectations:** Likely — update continuity/health references
  when preset artifacts become part of durable operator flow.
- **Queue/issue updates expected:** Yes, if treated as roadmap/queue-backed work.
- **Scope boundaries for reviewable PR:** Guidance/presets only; avoid implementing many
  net-new workflows in one pass.

### 3) Downstream adoption worked examples expansion

- **Prompt id:** `downstream-adoption-worked-examples-pack`
- **Why it matters:** Adoption guidance improves durability, but worked traces make reuse
  practical for operators who need concrete issue→PR flows.
- **When to run:** When onboarding friction shows teams still need concrete adoption traces.
- **Dependencies / prerequisites:**
  - [`framework-portability-and-adoption.md`](framework-portability-and-adoption.md)
  - [`framework-starter-kit.md`](framework-starter-kit.md)
  - [`framework-profile-packs.md`](framework-profile-packs.md)
- **Suggested GitHub agent prompt text:**

  > "Add 1-2 bounded downstream adoption worked examples (starter profile and one heavier
  > profile) with explicit artifact linkage, validation evidence expectations, and follow-up
  > decision notes."

- **Expected deliverables:**
  - new worked examples for high-value adoption paths
  - updated examples index and cross-links
  - clear adoption decisions and non-goals
- **Continuity/health/writeback expectations:** Likely — health/continuity docs may need
  artifact-map updates.
- **Queue/issue updates expected:** Yes, if this work claims a queue item.
- **Scope boundaries for reviewable PR:** examples + index/discoverability updates only.

### 4) Framework readiness/certification checklist

- **Prompt id:** `framework-readiness-certification-checklist`
- **Why it matters:** Adopters need a durable way to decide whether they are "framework
  ready" without relying on informal interpretation.
- **When to run:** Before broad downstream transplant or formal adoption review cycles.
- **Dependencies / prerequisites:**
  - [`framework-health.md`](framework-health.md)
  - [`governance-checklist.md`](governance-checklist.md)
  - [`framework-adoption-maturity-model.md`](framework-adoption-maturity-model.md)
- **Suggested GitHub agent prompt text:**

  > "Create a bounded framework readiness/certification checklist that maps core invariants
  > and operational controls to objective pass/fail evidence, with profile-aware and
  > maturity-aware interpretation guidance."

- **Expected deliverables:**
  - reusable readiness/certification checklist
  - evidence expectations and optional scoring mode
  - links to health/governance/upgrade workflows
- **Continuity/health/writeback expectations:** Yes — this is a charter-level operational
  artifact and should be reflected in health/discoverability surfaces.
- **Queue/issue updates expected:** Yes.
- **Scope boundaries for reviewable PR:** Checklist + references only; do not introduce
  enforcement automation in the same change.

### 5) Profile-specific starter presets

- **Prompt id:** `profile-specific-starter-presets`
- **Why it matters:** Starter-kit guidance is strong, but profile-tailored first-day presets
  would reduce setup variance for new adopters.
- **When to run:** When onboarding repeatedly asks for "which files first for my context?"
- **Dependencies / prerequisites:**
  - [`framework-starter-kit.md`](framework-starter-kit.md)
  - [`framework-profile-packs.md`](framework-profile-packs.md)
  - [`framework-automation-bundles-by-profile.md`](framework-automation-bundles-by-profile.md)
- **Suggested GitHub agent prompt text:**

  > "Add profile-specific starter presets that convert starter-kit guidance into bounded
  > copy/adapt bundles for common contexts, with explicit non-goals and defer paths."

- **Expected deliverables:**
  - starter preset packets by profile
  - profile-specific first PR suggestions
  - cross-links from onboarding and portability docs
- **Continuity/health/writeback expectations:** Likely.
- **Queue/issue updates expected:** Yes when queue-backed.
- **Scope boundaries for reviewable PR:** Preset documentation only; no broad template/workflow
  rewrites in the same PR.

### 6) Queue analytics/reporting packet layer

- **Prompt id:** `queue-analytics-and-reporting-packets`
- **Why it matters:** Queue integrity exists, but operators also need repeatable reporting on
  throughput, staleness, and drift signals.
- **When to run:** When queue operations become frequent enough to require trend visibility.
- **Dependencies / prerequisites:**
  - [`framework-queued-execution-memory.md`](framework-queued-execution-memory.md)
  - [`runbooks/run-queue-health-check.md`](runbooks/run-queue-health-check.md)
  - [`framework-metrics-and-feedback.md`](framework-metrics-and-feedback.md)
  - [`framework-reporting-and-review-cadence.md`](framework-reporting-and-review-cadence.md)
- **Suggested GitHub agent prompt text:**

  > "Create a bounded queue analytics/reporting packet model that operationalizes recurring
  > queue health writeback (throughput, blocked age, drift incidents, closure hygiene) without
  > introducing heavy orchestration."

- **Expected deliverables:**
  - queue reporting packet template
  - cadence/ownership/writeback guidance
  - linkage to existing metrics and health audits
- **Continuity/health/writeback expectations:** Yes.
- **Queue/issue updates expected:** Yes, especially for cadence and ownership decisions.
- **Scope boundaries for reviewable PR:** Reporting model/templates only; avoid major workflow
  implementation expansion in the same PR.

### 7) Prompt library ↔ queue integration hardening

- **Prompt id:** `prompt-library-queue-integration-pass`
- **Why it matters:** Prompt catalogs and queue state can drift unless mapping and
  synchronization expectations are explicit.
- **When to run:** After this library is in use and drift is observed between prompt entries
  and queue/backlog state.
- **Dependencies / prerequisites:**
  - [`framework-prompt-library.md`](framework-prompt-library.md)
  - [`framework-roadmap-next-prompts.md`](framework-roadmap-next-prompts.md)
  - [`framework-queued-execution-memory.md`](framework-queued-execution-memory.md)
- **Suggested GitHub agent prompt text:**

  > "Run a bounded integration hardening pass so prompt-library entries and queue-backed
  > execution items stay synchronized, with explicit update triggers and ownership."

- **Expected deliverables:**
  - synchronization guidance between prompt library and queue artifacts
  - explicit owner and update triggers
  - drift-recovery note for prompt catalog parity
- **Continuity/health/writeback expectations:** Likely.
- **Queue/issue updates expected:** Yes.
- **Scope boundaries for reviewable PR:** Governance/linkage updates only.

### 8) Prompt execution automation guardrails (optional follow-on)

- **Prompt id:** `prompt-execution-automation-guardrails`
- **Why it matters:** Operators may want more automation around prompt preparation, but safety
  boundaries must remain explicit to avoid autonomous merge chains.
- **When to run:** Only when maintainers explicitly request stronger preparation automation.
- **Dependencies / prerequisites:**
  - Prompt-library and queue integration guidance
  - durable governance decision in issue/ADR if automation boundaries change
- **Suggested GitHub agent prompt text:**

  > "Design a bounded prompt-execution automation guardrail layer that improves preparation and
  > routing ergonomics while preserving human-in-the-loop execution, review, and merge
  > decisions."

- **Expected deliverables:**
  - automation boundary proposal and safety constraints
  - clear non-goals (no autonomous PR merge chaining)
  - optional runbook updates for operator controls
- **Continuity/health/writeback expectations:** Yes.
- **Queue/issue updates expected:** Yes, plus ADR linkage if policy semantics change.
- **Scope boundaries for reviewable PR:** Proposal/policy only unless explicitly scoped
  implementation is requested in a separate issue.

## Prompt-library maintenance rules

- Keep this list curated; do not turn it into an unbounded backlog.
- Keep prompt entries execution-ready and dependency-aware.
- Keep one bounded objective per prompt execution PR.
- Keep prompt entry updates linked to durable issues/PRs when execution context changes.
- Keep discoverability links current in `README.md`, `docs/README.md`, and `AGENTS.md`.

## Mobile quick action

- **Use when:** you need to pick the next major reusable prompt from mobile.
- **Do from mobile:**
  - check the ordered table for the next dependency-ready entry
  - open one bounded issue using the suggested prompt text
  - assign owner and link related queue/roadmap artifacts
- **Do not do from mobile:**
  - rewrite multiple prompt entries and dependencies in one pass
  - execute broad cross-document harmonization without desktop validation
- **Escalate to desktop/cloud when:**
  - selection requires queue-state reconciliation
  - execution requires coordinated updates across many docs/templates/scripts
- **Primary artifact to update:**
  - the issue or PR claiming the selected prompt entry

## Related docs

- [Framework roadmap: next GitHub agent prompts](framework-roadmap-next-prompts.md)
- [Framework queued execution memory](framework-queued-execution-memory.md)
- [Operate the framework task queue](runbooks/operate-framework-task-queue.md)
- [Run the queue health check](runbooks/run-queue-health-check.md)
- [Framework continuity and memory](framework-continuity-and-memory.md)
- [Operator onboarding pack](operator-onboarding-pack.md)
- [Framework release/versioning/deprecation model](framework-release-versioning-and-deprecation.md)
- [Framework release notes and upgrade summaries](framework-release-notes-and-upgrade-summaries.md)
- [Framework automation bundles by profile](framework-automation-bundles-by-profile.md)
- [Framework portability and adoption](framework-portability-and-adoption.md)
