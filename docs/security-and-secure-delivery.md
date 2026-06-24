# Security and Secure Delivery Guardrails

This guide defines lightweight, reusable guardrails for handling security-sensitive work in Brain Factory: how to report vulnerabilities, where sensitive context may live, how to keep AI agents safe, and what to verify before, during, and after delivery. Read it before filing or reviewing anything security-adjacent. New to the project? Start with [how it works](how-brain-factory-works.md).

Use it with:

- [`SECURITY.md`](https://github.com/izakl/brainforge/blob/main/SECURITY.md) for the private vulnerability reporting path
- [Context synchronization](context-synchronization.md) for Tier 1/2/3 context handling
- [Operating model](operating-model.md) for execution-surface decisions
- [Governance checklist](governance-checklist.md) for review/audit expectations

## Reporting and intake guardrails

Use this decision path first:

1. **Security vulnerability or potential exploit path?**
   - Do **not** open a public issue.
   - Use private reporting via the repository Security tab (`SECURITY.md`).
2. **Security hardening idea without sensitive exploit detail?**
   - Open a public issue using the framework templates.
   - Keep exploit detail and sensitive evidence out of the issue body.
3. **Not sure whether it is sensitive?**
   - Treat as sensitive first.
   - Route privately, then decide whether a sanitized public artifact is appropriate.

## Public artifacts vs private reporting

| Scenario | Public issue/PR | Private advisory |
| --- | --- | --- |
| Confirmed or suspected vulnerability | ❌ | ✅ Required |
| Secrets/credentials may be exposed | ❌ | ✅ Required |
| Security process improvement (no exploit detail) | ✅ | Optional |
| Documentation hardening guidance (sanitized) | ✅ | Optional |
| Dependency/tooling update from Dependabot | ✅ | Optional unless exploit-sensitive |

Rule: when in doubt, start private and publish sanitized follow-up context later.

## Sensitive context handling by tier

Apply the context-tier model with explicit security handling:

### Tier 1 (local private working context)

Can contain raw sensitive material while triaging:

- raw logs with tokens, secrets, or credentials
- full vulnerability reproduction artifacts
- unredacted exports with customer or internal sensitive data

Tier 1 content must not be pasted directly into public GitHub artifacts.

### Tier 2 (connector-friendly shared context)

Use only when approved and access-controlled.

- redact tokens, credentials, and direct exploit payloads
- keep minimum detail required for synthesis/review
- maintain provenance links to audited sources

### Tier 3 (durable GitHub artifacts)

Required for execution, but sanitized:

- include objective, constraints, acceptance criteria, and validation expectations
- include impact/risk summary without secret values or weaponizable detail
- link to private advisory where maintainers permit and visibility allows

## Agent safety guardrails

When using AI agents (local, GitHub-native, or external):

- never paste secrets, private keys, auth tokens, or credential dumps into prompts
- never request unsafe disclosure (for example “print all env secrets”)
- never accept remediation that weakens controls as a “temporary shortcut” without explicit approval and follow-up tracking
- require redaction before normalizing external transcripts into issues/docs/PRs
- keep remediation scoped to the approved issue/advisory packet

## Dependency and security-alert handling

- Triage Dependabot updates weekly using
  [`docs/runbooks/handle-a-dependabot-pr.md`](runbooks/handle-a-dependabot-pr.md).
- Treat code scanning and secret scanning findings as intake signals that must be routed with explicit ownership.
- Use private advisory flow when an alert contains exploitable detail or secret material.
- Track remediation and validation evidence in bounded PRs.

## Secure delivery checks

Before implementation:

- [ ] Reporting path selected correctly (public issue vs private advisory)
- [ ] Sensitive evidence classified and redacted
- [ ] Work packet includes explicit security constraints and non-goals
- [ ] Validation includes security-relevant checks where applicable

During PR review:

- [ ] No secrets, credentials, or sensitive payloads committed
- [ ] Security/permission implications reviewed for changed workflows/config/docs
- [ ] Constraint preservation verified against issue/advisory packet
- [ ] Deferred security follow-up captured as linked issue(s)

After merge:

- [ ] Follow-up communication posted with safe detail level
- [ ] Residual risk tracked as backlog item when needed
- [ ] Continuity/health artifacts updated for framework-level changes

## Mobile quick action

- **Use when:** you need to quickly decide if a security-related signal can be handled publicly or must be routed privately.
- **Do from mobile:**
  - Route suspected vulnerabilities to private advisory reporting immediately.
  - Request redaction when sensitive values appear in issue or PR text.
  - Leave a routing note that points to the correct private/public path.
- **Do not do from mobile:**
  - Post exploit detail, credentials, or raw sensitive exports in comments.
  - Approve security-sensitive remediation without visible validation evidence.
- **Escalate to desktop/cloud when:**
  - Triage requires deeper evidence review or multi-artifact updates.
  - Security controls, permissions, or workflow behavior must be changed.
- **Primary artifact to update:**
  - The private advisory (for sensitive findings) or sanitized GitHub issue/PR (for non-sensitive hardening work).

## Related docs

- [SECURITY.md](https://github.com/izakl/brainforge/blob/main/SECURITY.md) — private vulnerability reporting path.
- [Context synchronization](context-synchronization.md) — Tier 1/2/3 context normalization model.
- [Operating model](operating-model.md) — execution-surface routing and work packet baseline.
- [Prompt cookbook](prompt-cookbook.md) — prompt patterns and anti-patterns for safe agent use.
- [Governance checklist](governance-checklist.md) — recurring governance and review checks.
