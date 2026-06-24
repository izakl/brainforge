# ADR 0023: Documentation site on GitHub Pages (MkDocs Material)

- Status: Accepted
- Date: 2026-06-19

## Context

The framework is documentation-heavy and the docs are now external-ready. A
browsable site makes them far easier to consume than navigating Markdown in the
repo, and the visual-diagrams plan already anticipated adopting a docs site once
the repo warranted one.

Constraints:

- **Cost.** The operator runs on GitHub Pro; the site must be free (GitHub Pages
  and GitHub Actions).
- **Diagrams.** Docs use Mermaid heavily; the site must render Mermaid.
- **Zero runtime deps preserved.** The `brainfactory` package stays standard
  library only; any site tooling is build-time only.
- **Do not publish prematurely.** The repository is still private and a public
  release (and name-scrub) is deferred to a future repo move. A Pages site from a
  private repo is publicly visible, so publishing must be a deliberate, gated act.

## Decision

Adopt **MkDocs with the Material theme**, configured in `mkdocs.yml`, building
from the existing `docs/` directory.

- Mermaid renders via `pymdownx.superfences` (Material's built-in Mermaid
  support), so the `## Diagram` blocks and inline diagrams render on the site as
  they do on github.com.
- Navigation is auto-generated from `docs/` for now; files outside `docs/`
  (`AGENTS.md`, `brain-factory/`, `examples/`) are linked out to GitHub, and link
  validation is set to not fail the build on them.
- Deployment is a GitHub Actions workflow (`.github/workflows/docs-site.yml`)
  using the standard Pages flow, **triggered manually only** (`workflow_dispatch`).
  It does nothing until GitHub Pages is enabled in repository settings, so the
  private repo is not published until the operator chooses to.
- `mkdocs-material` is installed only inside the workflow; it is not a runtime
  dependency of the framework.

## Consequences

Positive:

- A clean, searchable, mobile-friendly site with rendered diagrams, free on
  GitHub Pro.
- Publishing is a single deliberate step (enable Pages, run the workflow) the
  operator controls — ideally taken at the public-release / repo move.

Trade-offs:

- The executable layer (`brain-factory/`) and `examples/` are linked out to
  GitHub rather than rendered in the site (they live outside `docs_dir`).
- Auto-generated navigation is functional but not curated/ordered yet.

## Follow-ups

- Curate the navigation order and group sections once the site is live.
- Optionally include `brain-factory/` READMEs and `examples/` in the site via a
  build-time copy step so their links resolve on the site too.
- Set a custom domain and flip the trigger to deploy on merge to `main` at the
  public-release / repo move.

## References

- [`mkdocs.yml`](https://github.com/izakl/brainforge/blob/main/mkdocs.yml)
- [`.github/workflows/docs-site.yml`](https://github.com/izakl/brainforge/blob/main/.github/workflows/docs-site.yml)
- [`docs/visual-diagrams-plan.md`](../visual-diagrams-plan.md)
- [ADR 0009: Mermaid as primary diagram format](./0009-mermaid-as-primary-diagram-format.md)
