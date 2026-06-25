# brainfactory

The executable onboarding engine for [Brain Factory](https://github.com/izakl/brainforge)
— a single, standard-library-only Python package that provisions, adopts, and
upgrades project "brain" repositories, and backs the cross-platform adapter seam
(`bash`/`powershell` wrappers shell out to this).

## Install

```bash
# Isolated CLI (recommended) — installs the `brainfactory` command:
pipx install brainfactory

# Or with pip:
pip install brainfactory

# Stricter manifest validation (optional): pulls in jsonschema
pipx install "brainfactory[schema]"
```

Until the package is published to PyPI, install straight from the repo:

```bash
pipx install "git+https://github.com/izakl/brainforge#subdirectory=brain-factory/adapters/python"
```

## Use

```bash
brainfactory --help
brainfactory inspect --repo .            # read-only gap report
brainfactory provision --dest ./brain --name "Acme" --slug acme \
    --brain-repo acme/acme-autonomy-system --prefix ac
brainfactory upgrade --brain ./brain     # down-sync (dry-run; --apply to write)
```

`brainfactory <cmd>` is identical to `python -m brainfactory <cmd>`; the
`bash`/`powershell` adapters and the `run.sh`/`run.ps1` dispatchers call the same
CLI, so behaviour matches across runtimes.

Requires Python 3.10+. Licensed MIT.
