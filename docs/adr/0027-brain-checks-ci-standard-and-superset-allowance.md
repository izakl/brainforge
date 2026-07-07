# ADR 0027: Codify brain-checks as the inherited CI standard, with a superset-generator allowance

- Status: Accepted
- Date: 2026-07-07

## Context

The self-extending brain depends on a CI gate — the **`brain-checks`** workflow —
to stay honest as it grows. The workflow ships in the hub at
`brain-template/.github/workflows/brain-checks.yml`, is inherited by every
provisioned brain, and runs on every `pull_request` and `push` to `main`. It
enforces three invariants:

1. `capabilities --check` — the committed `01-docs/CAPABILITIES.md` must match
   what the generator derives from code (command directories + manifest). No
   drift.
2. `intent-gate` — every command directory under `core/` and `extensions/` must
   have a row in `CAPABILITIES.md`. A feature cannot land without the brain
   growing with it.
3. `docs-mesh` — links, wikilinks, and mermaid blocks must resolve and balance,
   and freshness stamps must parse.

Two gaps made this fragile as a governed standard:

- The gate's contract was only *implicit* — a workflow file plus generator
  behavior. Nothing stated which checks are blocking, whether a lane may make a
  check non-blocking, or what an honest response looks like when a brain cannot
  fully satisfy the mesh. Without that, a lane could quietly set a check to
  `continue-on-error`, or "fake-pass" the mesh by repointing a link to something
  it does not mean or by editing an append-only log (`05-logs/`, the decision
  board) until it resolves — defeating the gate instead of satisfying it.
- Some lanes generate a **richer, system-wide** capability map. Northwind's
  `08-ops/generate-capabilities.ps1` inventories app API routes, broker adapters,
  config keys, and workflows — not just brain command directories — and
  drift-checks *that* map. It was ambiguous whether shipping a bespoke generator
  instead of the stock `python -m brainfactory` generator is a deviation from the
  standard or a legitimate superset of it.

## Decision

Codify two decisions and add a hub guard so the standard cannot be silently
removed.

1. **`brain-checks` is THE inherited CI standard.** A new inherited policy,
   `brain-template/04-policies/ci-checks-standard.md`, states the contract:
   `capabilities --check` and `intent-gate` are **always blocking** with no escape
   hatch; `docs-mesh` is **blocking by default**. A lane MAY mark **one** check
   `continue-on-error` **only** for a pre-existing, unresolvable finding it cannot
   fix within the current change's scope, and only if it leaves a
   `TODO(<lane>-docs-mesh)` and emits a `::warning::` so the soft-fail is loud.
   It may **never** fake-pass by repointing links or editing append-only logs.
   Contoso's `TODO(contoso-docs-mesh)` is the reference precedent for the honest
   escape hatch. Inheritance is explicit: the gate ships in
   `brain-template/.github/workflows/brain-checks.yml`; brains keep it in sync and
   document any local wiring deviation rather than silently forking it.

2. **Bless the superset-generator allowance.** A lane MAY ship a richer, bespoke
   capabilities generator in place of the stock `python -m brainfactory` generator
   **provided its CI still enforces the same three invariants** (PR-time
   capabilities drift-check, intent parity, docs-mesh). A generator that covers
   *more* than brain commands is a valid **superset**, not a violation. Northwind's
   `08-ops/generate-capabilities.ps1` — a system-wide map over app routes,
   adapters, config keys, and workflows — is the reference superset; it complies
   **via the allowance**, not by running the stock generator.

3. **Guard the standard in the hub.** Extend `scripts/check-brain-factory.sh` to
   assert the template still ships `.github/workflows/brain-checks.yml` and that
   it still wires the two blocking invocations (`capabilities … --check` and
   `intent-gate`). This makes silent removal or regression of the inherited gate a
   hub CI failure.

Compliance snapshot: Acme and Contoso satisfy the standard with the stock gate
(Contoso with one tracked escape-hatch soft-fail); Northwind satisfies it via the
superset allowance. This is a policy, not a core module — `core_modules` is left
unchanged.

## Consequences

Positive:

- The gate's contract is explicit and governed: every lane knows which checks are
  blocking and what the single legitimate soft-fail looks like.
- The hub guard prevents silent removal or regression of the inherited gate from
  the template — the standard is now self-defending, the same way the bare-name
  command guard defends command naming.
- The superset allowance legitimizes richer, system-wide generators (Northwind)
  without weakening the floor: more coverage, same three invariants.

Trade-offs:

- The escape hatch is a judgment call a lane could abuse. It is mitigated by
  requiring a visible `TODO(<lane>-docs-mesh)` plus a `::warning::`, by forbidding
  fake-pass outright, and by naming the *only* acceptable trigger (a pre-existing,
  unresolvable finding that is genuinely out of scope).
- The hub guard is structural (the workflow exists and contains the two blocking
  invocations), not a semantic proof that each brain's gate runs correctly.
  Per-brain enforcement still lives in each brain's own CI; the guard defends the
  template that seeds it.

## Follow-ups

- As lanes adopt richer generators, feed genuinely portable improvements back
  toward the stock `python -m brainfactory` generator through the normal up-sync.
- Consider a periodic audit that a provisioned brain's `brain-checks.yml` has not
  drifted from the hub template beyond documented wiring deviations.
