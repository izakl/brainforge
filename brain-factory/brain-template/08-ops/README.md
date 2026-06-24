# 08-ops

Operational scripts for the brain, invoked through the hub's cross-platform
adapter seam (`brain-factory/adapters/`). A brain installs only the entrypoints
for the platforms listed in its `brain.manifest.json` `platforms` array.

Tasks that land here as core modules are built out: the capabilities generator,
the docs-mesh checks, the SessionEnd mechanical sync, and the inspector/applier.
Each arrives as shared `python` logic with `bash` and `powershell` wrappers.
