# brainfactory — npx launcher

A thin Node launcher so JS-ecosystem users can run Brain Factory's Python engine
with `npx`:

```bash
npx brainfactory --help
npx brainfactory inspect --repo .
```

The engine itself is the Python `brainfactory` package — this launcher only
locates and forwards to it, trying in order: an installed `brainfactory` console
script, then `python3 -m brainfactory`, then `pipx run brainfactory`. **Python
3.10+ is required.**

Most users should install the Python CLI directly instead — it is the real
package and needs no Node:

```bash
pipx install brainfactory
```

See [`brain-factory/adapters/python/`](../../brain-factory/adapters/python/README.md)
for the engine and its install options.

## Publishing (maintainer)

This package is published to npm automatically when a GitHub Release is cut:
`.github/workflows/publish.yml` builds and publishes it (with provenance). To ship
a new launcher build, bump `version` here in step with the Python package, then
cut a release — unchanged versions are skipped. `npx brainfactory` resolves the
Python engine from PyPI (via `pipx run brainfactory`), so the two ship together.
