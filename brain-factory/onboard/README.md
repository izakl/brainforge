<!-- mobile-quick-action: How the hub stands up a brain for a new project, or adopts an existing one inspect-first. -->

# Onboarding engine

The onboarding engine provisions a brain for a project. It has two modes. New to
the model? Start with [how it works](../../docs/how-brain-factory-works.md).

## Mode A — Provision (new project)

For a project with little or no existing governance.

1. **Collect intent.** Project name, slug, profile, platforms, app repos. (Reuses
   the framework's setup-intent thinking; see
   `docs/framework-setup-intent-schema-and-application-model.md`.)
2. **Create the brain repo** `<slug>-autonomy-system` from `brain-template/`.
3. **Write `brain.manifest.json`** with `framework_version` = the hub's current
   version and the selected core modules + platforms.
4. **Install hooks and core commands** for the selected platforms.
5. **Seed the capability map** with a first `<prefix>-capabilities` run.
6. **Commit and push;** open the brain for its first session.

## Mode B — Adopt (existing project) — inspect-first

For a project that already has code, docs, CI, or its own conventions.
**Never clobber working artifacts.**

### Step 1 — Inspect

Run the inspector against the target repo. It audits and reports, read-only:

- **Governance:** operating contract / AGENTS.md / CLAUDE.md present?
- **Continuity:** session logs, decision records, context docs, external
  source-of-truth (e.g. a Drive-only context that must migrate to GitHub)?
- **Commands/automation:** existing scripts, skills, Copilot prompts, hooks?
- **CI:** workflows, guardrails, linting (blocking vs non-blocking)?
- **Docs:** ADRs, diagrams, capability/inventory docs?
- **Naming/drift:** obvious version/name drift across docs vs code, including
  runtime-vs-doc config drift checks.

Output: a **gap report** (`05-logs/onboarding-gap-report-<date>.md`) listing,
per core module: `present` | `partial` | `missing`, with the evidence and a
recommended action (`keep`, `augment`, `add`).

### Step 2 — Decide

The operator (or the engine, for unambiguous gaps) decides per item. Things the
project already does well are **kept** and recorded in the manifest as
`adopted: false` (project-owned, not hub-overwritable). Missing or weak items are
**added** or **augmented** from the template.

### Step 3 — Apply

Apply only the agreed additions/augmentations. Migrate any external
source-of-truth into the brain/GitHub. Write the manifest reflecting what is
hub-owned vs pre-existing. Land it as a PR in the brain repo.

## Codified no-loss migration rules

When migrating non-text artifacts during onboarding (code, binaries, images):

1. Move them through a **base64 transport path** (not a text/Markdown reader).
2. Decode and **assert byte-exact size** against source metadata.
3. Retry (chunked if needed) until byte size and representative content checks
   match.
4. Treat migration as incomplete until those checks pass.

This is a hard no-loss rule for inspect-first onboarding.

## Approval and boundary checkpoint

Before apply, record an explicit approval checkpoint in the onboarding packet:

- scope and objective for this onboarding pass,
- `keep`/`augment`/`add` decisions per module,
- boundary mapping (`adopted: false` for pre-existing project-owned assets),
- acceptance and validation evidence expectations.

## Inspect-first is the default for any repo with prior history

If the inspector finds substantial existing structure, the engine refuses to run
a blind provision and requires Mode B. This protects real work — the operator's
explicit instruction.

## Implementation

The inspector and applier are provided per platform under
`brain-factory/adapters/` (see that directory's README). The logic is shared in
`python/` where possible; `bash/` and `powershell/` wrap it for their
environments.

## Cross-lane onboarding contract

Lane onboarding now uses one shared artifact so a proven pattern in one lane is
codified once and inherited everywhere else:

- [`lane-onboarding-contract.md`](lane-onboarding-contract.md) — reusable
  contract packet, transfer loop, and approval/boundary/no-loss gates.

This artifact keeps inspect-first discipline explicit and makes the autonomy
transfer path concrete: **Northwind proves → Brain Factory codifies → Contoso and
Acme inherit**.
