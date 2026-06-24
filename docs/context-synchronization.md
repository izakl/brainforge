# Context Synchronization and External Context Handling

Real work often starts as notes, screenshots, or chat transcripts that live outside GitHub. This guide explains how to handle that material while keeping GitHub as the single place that controls delivery — so nothing the team executes against depends on private notes or chat memory. It is for contributors and agents preparing work in a brain (a per-project repository); for the bigger picture, see [how Brain Factory works](how-brain-factory-works.md).

## Goals

- allow local and external context collection without losing traceability
- make agent handoffs consistent across the desktop, cloud, CLI, and mobile surfaces
- ensure implementation depends on durable GitHub artifacts, not private chat memory

## Context Tiers

### Tier 1: Local private working context

Examples:

- local machine folders for draft notes
- temporary screenshots and exports
- working transcripts and brainstorming notes

This tier is useful for fast iteration but is not durable for team execution.

Example local structure:

```text
work/
  customer-portal-auth/
    2026-05-24-notes.md
    screenshots/
      login-timeout.png
      error-banner.png
    exports/
      support-ticket-raw.csv
```

### Tier 2: Connector-friendly shared context

Examples:

- Google Drive folders
- OneDrive folders
- approved shared document systems

Use this tier when an AI agent needs connector-accessible material.

Example connector-friendly structure:

```text
Shared Drive/
  ai-framework-context/
    customer-portal-auth/
      01-source/
        support-summary.md
        qa-observations.md
      02-synthesized/
        draft-problem-summary.md
      03-ready-to-normalize/
        issue-packet-v1.md
```

### Tier 3: Durable GitHub artifacts (required for execution)

Examples:

- issues
- docs
- ADRs
- pull requests
- comments with linked evidence

Repository execution must rely on Tier 3 artifacts.

## Synchronization Pattern

To *normalize* context is to distill raw material into a clear, self-contained GitHub artifact that someone else can act on. Move context up the tiers in this order:

1. Capture raw material locally (Tier 1).
2. If a connector-based AI agent needs it, sync selected files to Tier 2.
3. Produce normalized summaries and task packets.
4. Publish those normalized outputs into Tier 3 artifacts before implementation starts.
5. Reference source links where useful, without requiring private access for core decisions.

## Example: Source material to normalized issue packet

Example packet fields before opening implementation work:

- **Title**: `Intermittent login timeout after 15 minutes of inactivity`
- **Objective**: reduce failed re-auth attempts without weakening security controls
- **Context**: support ticket export + QA screenshots + session timeout notes
- **Constraints**: maintain existing token rotation and audit logging requirements
- **Acceptance criteria**: timeout behavior is predictable and user-visible messaging is clear
- **Validation**: repro steps, test account results, and environment notes recorded
- **Source links**: pointer links to Tier 2 files (or summarized Tier 1 evidence)

## What Stays Local vs Synced vs Normalized

### Keep local only

- personal notes with no project relevance
- sensitive raw exports not approved for sharing
- secrets, credentials, private keys, and token-bearing logs
- exploit details or payloads not yet approved for sharing
- transient working drafts

### Can be synced to connector-friendly storage

- approved screenshots for discovery
- workshop notes and structured exports
- source documents needed for synthesis

### Must be normalized into GitHub

- objectives and constraints used for implementation
- acceptance criteria and validation expectations
- key assumptions, decisions, and risks
- security impact and risk summary (sanitized, no secret values)
- final task breakdown for agent execution

## Naming and versioning guidance for synced context

- Use stable slugs per topic (for example `customer-portal-auth`).
- Date-stamp working files (`YYYY-MM-DD-topic.md`) to keep discovery simple.
- Version synthesized packets (`issue-packet-v1.md`, `issue-packet-v2.md`) when assumptions change.
- In GitHub issue or ADR bodies, reference the latest packet version and note superseded versions.

## Normalization Checklist

Before assigning implementation:

- [ ] Problem statement captured in issue
- [ ] Objective and constraints captured
- [ ] Acceptance criteria listed
- [ ] Validation steps listed
- [ ] Source context summarized in durable form
- [ ] Sensitive or non-shareable data removed/redacted

## Agent Handoff Rules

- External AI agents may analyze Tier 1/Tier 2 context but should output structured packets.
- Human lead reviews and approves normalization into GitHub artifacts.
- GH agents execute only from repository-visible context.
- Mobile participants should be able to understand status and next step from issue/project alone.
- Project status updates must be backed by durable artifact updates (issue/PR/handoff), not private chat state.

## Worked artifact chain example

1. Capture local notes and screenshots in Tier 1 (`2026-05-24-notes.md`, `screenshots/login-timeout.png`).
2. Optionally sync approved files into Drive/OneDrive Tier 2 folder for connector-assisted synthesis.
3. Publish normalized **Support Intake** or **Defect** issue with objective/context/constraints/acceptance/validation.
4. If policy/process decision is needed, open linked ADR issue.
5. Implement via PR linked to routed issue (`Closes #...`) with validation evidence.

For a concrete end-to-end trace of this pattern, see the
[worked example: external context normalization flow](https://github.com/izakl/brainforge/blob/main/examples/worked-example-external-context-normalization.md).

## Security and Governance

- Follow data classification and sharing rules before syncing local context to connector platforms.
- Route suspected vulnerabilities through private reporting in `SECURITY.md` before public issue filing.
- Avoid storing secrets in issues, docs, prompts, handoffs, or PR comments.
- Keep links and references explicit so reviewers can verify provenance.
- See [`security-and-secure-delivery.md`](security-and-secure-delivery.md) for secure-delivery guardrails.
- Use [`github-projects-setup.md`](github-projects-setup.md) to keep project state synchronized with normalized artifact state.
- Use [`framework-profile-packs.md`](framework-profile-packs.md) to scale
  context-normalization operational depth by team/repository profile without
  changing normalization invariants.

## Mobile quick action

- **Use when:** you are deciding whether external context is normalized enough to proceed from mobile.
- **Do from mobile:**
  - Confirm whether context belongs in Tier 1, Tier 2, or Tier 3.
  - Add or request a normalized summary in the issue or ADR artifact.
  - Link source evidence so reviewers can trace provenance.
- **Do not do from mobile:**
  - Post sensitive raw exports or unredacted transcripts.
  - Start implementation from chat-only or private context.
- **Escalate to desktop/cloud when:**
  - Redaction or data classification is uncertain.
  - Large context packets need structured synthesis before normalization.
- **Primary artifact to update:**
  - The normalized GitHub issue or ADR that carries objective, constraints, and validation.
