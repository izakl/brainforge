<!-- markdownlint-disable-file MD041 -->

## Summary

<!-- One or two sentences: what does this PR change and why? -->

## Linked source artifact

<!-- Use explicit close/link syntax to preserve durable linkage and queue hygiene. -->
<!-- Replace <issue-number> placeholders below with real issue numbers. -->

- Closes #<issue-number> <!-- Required: canonical source issue (for queue-backed work, this is the queue-marked issue). -->
- Relates-to #<issue-number> <!-- Optional: supporting issues/PRs/ADRs linked without closing. -->

## Queue closure/linkage hygiene

<!-- Complete this section when work originated from a queue-prepared issue marker. -->
<!-- Post-merge: if auto-close was missed after merge, follow the closure recovery steps in docs/runbooks/maintain-framework-alignment.md. -->

- [ ] If queue-backed, this PR closes the canonical queue-linked issue using `Closes #...`.
- [ ] If additional artifacts are linked, they use `Relates-to #...` (or equivalent non-closing references).
- [ ] If automatic issue closure is intentionally not used, I documented manual closeout owner + follow-up step in this PR.

## Scope

<!-- List every file this PR touches. PRs should stay small and bounded. -->

- <!-- Add changed file paths here. -->

## Type of change

<!-- Check all that apply. -->

- [ ] Docs / runbook / example
- [ ] ADR
- [ ] Automation / CI / workflow
- [ ] Governance / community-health file
- [ ] Issue template / reusable entrypoint harmonization
- [ ] Other (describe)

## Framework change communication

<!-- Complete for framework/process/lifecycle-impact changes. Use N/A if not applicable. -->

- **Lifecycle impact (`PATCH` / `MINOR` / `MAJOR` / `N/A`):**
- **Adopter action level (`Informational` / `Recommended` / `Required` / `N/A`):**
- **Applicability (`Universal` / `Profile-specific` / `Maturity-gated` / `Optional` / `N/A`):**
- **Release/upgrade summary artifact link (or N/A + rationale):**

## Work packet carry-forward

<!-- Preserve the source issue packet in this PR so reviewers can confirm continuity. -->
<!-- Canonical field contract: Objective, Context, Constraints and non-goals, Acceptance criteria, Validation expectations, Related artifacts. -->
<!-- References: docs/framework-continuity-and-memory.md, docs/work-type-matrix.md, docs/framework-starter-kit.md -->

- **Objective:**
- **Context:**
- **Constraints and non-goals preserved:**
- **Acceptance criteria addressed:**
- **Validation expectations and evidence summary:**
- **Related artifacts:**

## Continuity check

<!-- The framework's continuity charter requires these stay in sync. -->

- [ ] I read the relevant section of [`docs/framework-continuity-and-memory.md`](../docs/framework-continuity-and-memory.md).
- [ ] I verified packet terminology and rigor against [`docs/work-type-matrix.md`](../docs/work-type-matrix.md) and starter-kit assumptions in [`docs/framework-starter-kit.md`](../docs/framework-starter-kit.md).
- [ ] Source issue/template packet fields were preserved (objective, context, constraints, acceptance criteria, validation).
- [ ] Source-issue closure semantics are explicit (`Closes` for canonical source issue; `Relates-to` for non-closing links).
- [ ] If this PR adds or removes a durable artifact, I updated [`docs/framework-health.md`](../docs/framework-health.md) — or I opened a follow-up issue to do so.
- [ ] If this PR adds or changes navigable docs content, I updated [`docs/README.md`](../docs/README.md) where needed.
- [ ] If this PR adds a runbook, it is indexed in [`docs/runbooks/README.md`](../docs/runbooks/README.md).
- [ ] If this PR adds an ADR, it is indexed in [`docs/adr/README.md`](../docs/adr/README.md).
- [ ] If this PR adds a worked example, it is indexed in [`examples/README.md`](../examples/README.md).
- [ ] Cross-links use **relative** repo-internal paths (no bare GitHub UI URLs).

## CI expectations

- [ ] Markdown lint/link checks are expected to pass (`markdown.yml`).
- [ ] Any applicable framework check scripts (handoff, mobile quick action, security guardrails, index parity, SVG companions) are expected to pass.
- [ ] Any new workflow file uses least-privilege `permissions:`.
- [ ] Security-sensitive context (if any) is sanitized and routed per [`SECURITY.md`](../SECURITY.md).

## Out-of-scope / follow-up

<!-- Explicitly capture what was deferred so scope stays bounded. -->

- Deferred follow-up issue(s):

## Expected auto-labels

<!-- The path-based labeler at `.github/labeler.yml` will tag this PR based on changed files. -->
<!-- List the labels you expect to see applied. -->

- <!-- Add expected labels here. -->

## Reviewer notes

<!-- Anything reviewers should focus on, risks, follow-ups, or out-of-scope items. -->
