# Architecture Decision Records (ADR) Template Guide

An Architecture Decision Record (ADR) is a short document that captures one
significant technical or process decision and the reasoning behind it. This guide
shows how to write ADRs in Brain Factory and where to store them. It is for any
contributor who needs to record a decision that future readers will want to
understand. New to the project? Start with
[How Brain Factory works](how-brain-factory-works.md).

## Why ADRs belong in this framework

Brain Factory keeps prompts, decisions, and delivery context in the repository
rather than only in chat or meetings. ADRs are how decisions earn that durable
home.

An ADR captures:

- why a decision was made
- what alternatives were considered
- what constraints shaped the choice
- what consequences follow from the decision

This matters most in AI-assisted delivery, where implementation moves quickly and the reasoning behind a change is easily lost.

## When to create an ADR

Create an ADR when a decision materially affects:

- repository workflow or governance
- branching and PR policy
- AI agent operating boundaries
- automation behavior
- tool selection or contributor experience
- redevelopment or migration strategy
- architectural direction for a capability or platform

You do not need an ADR for every small change. Use them for decisions that future contributors are likely to ask about.

## Recommended ADR structure

Use the following sections:

1. **Title**
2. **Status**
3. **Date**
4. **Context**
5. **Decision**
6. **Alternatives considered**
7. **Consequences**
8. **Related artifacts**

## Suggested status values

Use one of these states:

- Proposed
- Accepted
- Superseded
- Deprecated

## How ADRs connect to the framework

### Prompts as artifacts

If a prompt, issue, or discussion led to a significant decision, capture the outcome in an ADR.

### Bounded work

If implementation constraints shaped the decision, preserve them in the ADR's context and consequences. ("Bounded work" means a change scoped tightly enough to review and validate cleanly.)

### Reviewability

Link ADRs from issues and pull requests whenever the decision affects execution or review expectations.

### Mobile and lightweight usage

If you are working from GitHub Mobile, open an issue first, discuss the decision there, then promote the agreed outcome into an ADR document later.

## Recommended repository convention

Store ADRs in:

- `docs/adr/`

Use a simple naming pattern such as:

- `0001-example-decision.md`
- `0002-agent-boundaries.md`
- `0003-branch-cleanup-policy.md`

Sequential numbering makes it easier to reference decisions over time.

## ADR authoring checklist

Before finalizing an ADR, make sure it answers:

- What problem or decision triggered this?
- What constraints mattered?
- What options were considered?
- Why was this choice made?
- What follow-on consequences should contributors know?
- What issue, PR, or document should be linked for context?

## Minimal ADR template

```md
# ADR 0001: Decision title

- Status: Accepted
- Date: YYYY-MM-DD

## Context
What situation or problem led to this decision?

## Decision
What was decided?

## Alternatives considered
What other options were considered and why were they not chosen?

## Consequences
What becomes easier, harder, required, or constrained because of this decision?

## Related artifacts
- Issue:
- PR:
- Docs:
```

## Practical recommendation

Start small. Use ADRs for the decisions that shape how contributors, GitHub-native
coding agents, external AI tools, and repository automation should behave. Over
time this builds a durable decision trail that complements the framework's issue
templates, PR template, and documentation set.

## Related docs

- [How Brain Factory works](how-brain-factory-works.md) — five-minute tour for newcomers.
- [Operating model](operating-model.md) — how the framework runs day-to-day.
- [Product support and improvement loop](product-support-and-improvement-loop.md) — how signals flow back into the framework.
- [Framework continuity and memory](framework-continuity-and-memory.md) — what the framework remembers across sessions.
- [Branching and cleanup](branching-and-cleanup.md) — branch lifecycle and stale-branch handling.
- [Governance checklist](governance-checklist.md) — periodic audit items.
