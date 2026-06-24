# Apply Framework Setup

## When to use this runbook

This is a short pointer page. Use it when you searched for "apply framework
setup" and need to find the real procedure for applying a setup intent and
confirming a coherent "ready to work" state. The full steps live in
[`apply-setup.md`](apply-setup.md) — go there to do the work.

It exists to make the setup flow easy to discover, and links to:

- [`apply-setup.md`](apply-setup.md) — the full apply-and-verify procedure
- [`../../scripts/apply-setup.sh`](../../scripts/apply-setup.sh) — applies a setup intent
- [`../../scripts/check-setup-readiness.sh`](../../scripts/check-setup-readiness.sh) — validates readiness

## Procedure

Follow the complete operator steps in [`apply-setup.md`](apply-setup.md),
including:

1. choosing or creating a setup intent,
2. applying it with `apply-setup.sh`,
3. validating readiness with `check-setup-readiness.sh`,
4. running baseline checks, and
5. capturing deferred items as durable follow-up artifacts.

## Mobile quick action

- **Use when:** you need to quickly find the setup-application runbook and hand
  off to the executable scripts.
- **Do from mobile:**
  - Open [`apply-setup.md`](apply-setup.md) from this entrypoint.
  - Confirm the intended setup scripts are `apply-setup.sh` and
    `check-setup-readiness.sh`.
  - Add a comment on the linked setup issue/PR if the setup path is unclear.
- **Do not do from mobile:**
  - Execute setup scripts from mobile.
  - Perform schema debugging in mobile web UI.
  - Edit large setup-intent JSON payloads.
- **Escalate to desktop/cloud when:**
  - The setup intent fails validation.
  - You need to run the readiness script or baseline checks.
  - You need to update setup defaults or profile selections.
- **Primary artifact to update:**
  - The setup issue/PR that links the applied setup intent.

## Related docs

- [Apply setup](apply-setup.md)
- [Prompt-to-setup bootstrap](prompt-to-setup-bootstrap.md)
- [Framework setup intent schema and application model](../framework-setup-intent-schema-and-application-model.md)
- [Framework setup profiles and intent examples](../framework-setup-profiles-and-intent-examples.md)
