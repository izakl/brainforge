# ADR 0026: Promote the QA-twin pattern as an inheritable core primitive

- Status: Accepted
- Date: 2026-07-07

## Context

The Northwind System brain runs an autonomous **QA twin** (`xs-qa`): a digital
stand-in for the operator's own checking, testing, validation, and fixing. It
sweeps every surface of the live running system, cross-checks displayed values
against the source of truth, runs behavioral scenarios, fixes what it safely can
(review-gated) or routes gaps onward, and emits a phone-friendly report card. The
discipline has accreted eleven hard-won, non-negotiable lessons — each learned
from a real wrong verdict.

This is a genuinely valuable, portable **pattern**, and other lanes want it. But
two things must not be conflated:

- The `xs-qa` **harness** is **product-scoped**. It reads Northwind's `/api`,
  Expert tabs, broker scenarios, and Veylor orchestration. Inheriting the harness
  itself into every brain would be a false abstraction — those surfaces do not
  exist in another product.
- The QA **pattern** (stages, cadence, taxonomy, lessons) is product-agnostic and
  is exactly the kind of discipline the hub exists to standardize and inherit.

Separately, "twin" is overloaded: the cross-lane **orchestrator twin** (the
control plane) is a different thing from a per-lane **product QA twin**, and the
taxonomy was undocumented in the hub.

## Decision

Promote only the **pattern** into the hub, as two inherited artifacts, and leave
the harness per-lane:

1. **A core `qa` command** under
   `brain-template/03-templates/agent-commands/core/qa/` (SKILL + prompt, invoked
   `<prefix>-qa`). It is a **generic scaffold** encoding the stages
   (map → sweep → validate → behavioral → report → fix-route), the
   fast / deep / scenario cadence, and the FIX / IMPROVE / FLAG taxonomy. Each
   lane instantiates it into its own harness (Northwind keeps `xs-qa`; another lane
   points it at its own surfaces).
2. **An inherited QA standard** at `brain-template/04-policies/qa-standard.md`
   capturing the discipline and the eleven lessons (generalized, with the
   original product-specific failure cited for each so the reasoning is
   preserved).

Place it in **core, not extensions.** Core commands are hub-owned, inherited by
every brain via the down-sync (`<prefix>-upgrade`), and instantiated per-lane —
which is precisely the contract for an inheritable primitive. It sits naturally
in the "Quality and security" group alongside `test`, `verify`, and `security`.
Extensions are project-specific and are *not* inherited, so they would be the
wrong home for a primitive every lane should get.

Document the **twin taxonomy** in the core-commands catalog: the orchestrator
twin (e.g. Atlas) is the control plane; `<prefix>-qa` is the per-lane product QA
twin.

The Northwind `xs-qa` harness is **not modified** by this change.

## Consequences

Positive:

- Every brain inherits a proven QA discipline and a ready scaffold, instead of
  re-deriving it (and re-learning the eleven lessons the hard way).
- The capabilities generator discovers `qa` automatically; each brain's map gains
  a `<prefix>-qa` row on regenerate, and the intent gate keeps it honest.
- The pattern/harness split prevents a false abstraction: no lane inherits another
  lane's product surfaces.

Trade-offs:

- The core command is a scaffold, not a runnable harness — a lane gets no value
  until it instantiates the harness for its own surfaces. The standard's
  instantiation checklist and the release notes make this explicit.
- The eleven lessons are generalized; the vivid product-specific detail lives on
  only as a cited parenthetical. This is the intended trade for portability.

## Follow-ups

- As lanes instantiate `<prefix>-qa`, feed genuinely product-agnostic lessons back
  to this standard through the normal up-sync (`<prefix>-learn`).
- Consider a companion `report-card` emission helper in the adapters if multiple
  lanes converge on the same report-card shape.
