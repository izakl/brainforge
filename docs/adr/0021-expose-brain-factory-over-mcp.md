# ADR 0021: Expose Brain Factory over MCP (standard-library stdio server)

- Status: Accepted
- Date: 2026-06-19

## Context

[ADR 0020](./0020-portable-core-additive-enterprise.md) established that brains
are runtime-agnostic and that core capabilities should reach agents through open
standards rather than any one vendor. The Model Context Protocol (MCP) is now the
universal standard for that: it is governed under the Linux Foundation and is
natively supported by Claude, GitHub Copilot, Codex, Gemini, and Cursor.

We want any MCP-capable agent to use the hub registry and the read-only
onboarding engine directly, without bash/PowerShell wrappers or a vendor-specific
integration.

Two implementation options:

- **Official MCP SDK** — batteries included, but pulls in third-party
  dependencies (pydantic, anyio). The rest of `brainfactory` is deliberately
  standard-library only (the `check-brain-factory` invariant notes "no
  third-party deps required"), which keeps the "runs anywhere, no install"
  property that matters most to budget-constrained, portable adopters.
- **A small standard-library server** — slightly more code, but zero
  dependencies and fully under our control.

## Decision

Implement the MCP surface as a standard-library JSON-RPC 2.0 server over stdio
(`brainfactory/mcpserver.py`), started with `python -m brainfactory mcp`.

- No third-party dependencies; consistent with the rest of the package.
- Expose **read-only, deterministic** tools only; the judgment stays with the
  calling agent:
  - `framework_version` — current hub framework version and core modules.
  - `inspect_repo` — read-only gap report for a target repo path.
  - `version_status` — compare a framework version against the hub's latest.
- Tool execution errors are reported in-band (`isError`), unknown methods return
  JSON-RPC `-32601`, per the protocol.

## Consequences

Positive:

- Any MCP client (Claude, Copilot, Codex, Gemini, Cursor, …) can use Brain
  Factory with a one-line server config — the agent-neutral surface ADR 0020
  called for.
- Zero new dependencies; nothing to install beyond Python 3.

Trade-offs:

- We track the MCP protocol revision manually rather than getting it from the SDK.
- The initial tool set and the stdio transport are intentionally minimal.

## Follow-ups

- Add tools as backing logic lands: a capabilities drift check, and an
  upgrade-plan tool once a propagation engine exists.
- Consider an SDK-based or HTTP-transport variant only if a hosted, multi-client
  server is ever needed.
- Document per-agent client configs alongside the adapters README.

## References

- [ADR 0020: Portable core, additive enterprise](./0020-portable-core-additive-enterprise.md)
- [`brain-factory/adapters/README.md`](../../brain-factory/adapters/README.md)
- [`brain-factory/adapters/python/brainfactory/mcpserver.py`](../../brain-factory/adapters/python/brainfactory/mcpserver.py)
- [Model Context Protocol](https://modelcontextprotocol.io)
