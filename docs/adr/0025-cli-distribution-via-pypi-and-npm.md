# ADR 0025: CLI distribution via PyPI and npm

- Status: Accepted
- Date: 2026-06-25

## Context

The `brainfactory` CLI — the onboarding engine and the backend the cross-platform
adapters shell out to — needs a first-class install path for people who do not
clone the repo. It targets two ecosystems: Python (the real engine) and Node (a
thin `npx` launcher that forwards to it). Publishing should be automated,
reproducible, and avoid long-lived credentials on a maintainer's machine.

## Decision

Publish `brainfactory` to **PyPI** and **npm**, automated by
`.github/workflows/publish.yml` on the `release: published` event:

- **PyPI** uses **OIDC Trusted Publishing** — no stored API token.
- **npm** publishes with an automation token (`NPM_TOKEN`) and attaches build
  **provenance**.
- Publishes are **idempotent** (PyPI `skip-existing`; npm checks the registry
  first), so re-runs and CLI-unrelated releases are clean no-ops.
- The **CLI package version is independent of the framework version**: the CLI is
  versioned in its own package metadata and shipped only when those versions are
  bumped.

`release.yml` and `publish.yml` are decoupled: the first cuts the GitHub Release
(notes from the matching `CHANGELOG.md` section); the second reacts to the Release
being published. Cutting a release from a pushed tag or from the GitHub UI both
work — `release.yml` is idempotent.

## Alternatives considered

- **A stored PyPI API token** — rejected; OIDC Trusted Publishing removes the
  long-lived secret entirely.
- **npm OIDC trusted publishing instead of a token** — more secure, but npm
  requires the package to already exist before a trusted publisher can be
  attached. The automation token lets a brand-new package publish on its first
  release with no manual bootstrap; trusted publishing is recorded as a later
  hardening step once the package exists.
- **Tying the CLI version to the framework version** — rejected; the CLI evolves on
  its own cadence and most framework releases do not touch it.
- **Manual `twine` / `npm publish` from a maintainer machine** — rejected; not
  reproducible and depends on local credentials.

## Consequences

- A published GitHub Release is the single trigger for distribution; there is no
  separate manual upload.
- The PyPI Trusted Publisher and the `NPM_TOKEN` secret are one-time setup on the
  publishing repository.
- Shipping a new CLI build means bumping both package versions together (Python
  `__version__` and `installers/npm/package.json`); keeping them in step is a
  release habit.
- `npx brainfactory` depends on the Python package being on PyPI (it resolves the
  engine via `pipx run brainfactory`), so the two ship together.

## Related artifacts

- Workflows: `.github/workflows/publish.yml`, `.github/workflows/release.yml`
- Docs: `docs/cli-distribution-and-releases.md`
- Packages: [`brainfactory` on PyPI](https://pypi.org/project/brainfactory/),
  [`brainfactory` on npm](https://www.npmjs.com/package/brainfactory)
