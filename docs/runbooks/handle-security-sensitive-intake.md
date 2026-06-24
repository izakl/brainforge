# Handle Security-Sensitive Intake

Triage an inbound report that may involve a vulnerability, an exposed secret, a
permission weakness, or an unsafe delivery pattern. Use it the moment something
looks security-sensitive, so it reaches the right people without leaking exploit
details in public.

New to the project? See
[How Brain Factory works](../how-brain-factory-works.md) for the five-minute
tour. A *brain* is the per-project repository you operate from; a *private
advisory* is GitHub's confidential channel for reporting a vulnerability before
any public disclosure.

## Scope

The goal is to route sensitive findings safely, preserve durable context, and
avoid public-disclosure mistakes.

## 1) Classify the intake first

Choose one primary route:

- **Security-sensitive vulnerability signal** — a suspected exploit path, secret exposure, or permission bypass. Route privately via a GitHub Security Advisory.
- **Non-sensitive security hardening** — a sanitized docs, process, or workflow improvement. Route publicly via the framework issue templates.
- **Unclear sensitivity** — default to private routing first.

Classification checklist:

- [ ] Sensitivity assessed before any details are posted publicly.
- [ ] Correct route chosen (private advisory vs. public issue).
- [ ] Initial owner assigned for triage.

## 2) Route and capture durable artifacts

If security-sensitive:

1. File a private advisory as described in [`SECURITY.md`](https://github.com/izakl/brainforge/blob/main/SECURITY.md).
2. Capture reproduction context with redacted detail only.
3. Do not open public issues that contain exploit detail or secrets.

If non-sensitive hardening:

1. Open a public issue with objective, constraints, acceptance, and validation fields.
2. Keep the context sanitized and non-weaponizable.
3. Link supporting docs and runbooks as needed.

Routing checklist:

- [ ] An advisory or issue link exists.
- [ ] Sensitive values are removed or redacted.
- [ ] Provenance and owner are explicit.

## 3) Prepare execution packet

Before implementation starts:

- [ ] Objective and constraints are explicit.
- [ ] Security constraints and non-goals are documented.
- [ ] Validation includes security-relevant checks.
- [ ] Execution surface is selected based on risk and scope.

For private advisory work, mirror only sanitized, minimally required context into
public artifacts, and only once maintainers approve.

## 4) Execute remediation safely

During implementation and review:

- [ ] Keep PR scope bounded to approved remediation.
- [ ] Confirm no secrets or sensitive payloads are committed.
- [ ] Review permission/security implications for changed workflows/config/docs.
- [ ] Capture deferred risk as follow-up issue(s), not hidden TODOs.

## 5) Close out with safe communication

After merge or resolution:

- [ ] Record validation evidence in the linked artifact.
- [ ] Publish only sanitized outcome detail in public artifacts.
- [ ] Track residual risk and hardening follow-ups.

## Mobile quick action

- **Use when:** a new issue, comment, or alert looks security-sensitive and needs fast, safe routing.
- **Do from mobile:**
  - Route a suspected vulnerability to private advisory reporting.
  - Ask for immediate redaction if secrets or exploit detail appear.
  - Leave a concise routing note naming the next owner.
- **Do not do from mobile:**
  - Post sensitive evidence in public comments.
  - Approve remediation without visible validation and scope control.
- **Escalate to desktop/cloud when:**
  - Triage requires a deep evidence review.
  - Remediation spans workflows, permissions, or multiple artifacts.
- **Primary artifact to update:**
  - The private advisory (if sensitive), or the sanitized public issue or PR (if non-sensitive hardening).

## Related docs

- [Security and secure delivery guardrails](../security-and-secure-delivery.md)
- [Operating model](../operating-model.md)
- [Context synchronization](../context-synchronization.md)
- [Respond to Support Intake](respond-to-support-intake.md)
- [Open an Issue](open-an-issue.md)
