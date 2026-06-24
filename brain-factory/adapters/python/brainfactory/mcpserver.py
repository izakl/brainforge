"""A minimal Model Context Protocol (MCP) server for Brain Factory.

Exposes the registry and read-only onboarding operations over MCP so any
MCP-capable agent (Claude, Copilot, Codex, ...) can use them — no bash wrappers,
no vendor lock-in. This is the agent-neutral surface called for by ADR 0020.

Implemented in the **standard library only**: newline-delimited JSON-RPC 2.0 over
stdio (the MCP stdio transport). No third-party dependencies, consistent with the
rest of ``brainfactory`` and the "runs anywhere, no install" principle.

Start it with::

    python -m brainfactory mcp

then point an MCP client's server config at that command.

Tools (all read-only and deterministic; judgment stays with the calling agent):

- ``framework_version`` — current hub framework version and core modules.
- ``inspect_repo``      — read-only gap report for a target repo path.
- ``version_status``    — compare a framework version against the hub's latest.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path
from typing import Any, Callable

from . import inspect as inspect_mod
from . import manifest as manifest_mod

SERVER_NAME = "brain-factory"
# MCP protocol revision we implement; we echo the client's if it sends one.
DEFAULT_PROTOCOL = "2025-06-18"


def _hub_root() -> Path:
    """.../brain-factory/adapters/python/brainfactory/mcpserver.py -> .../brain-factory"""
    return Path(__file__).resolve().parents[3]


def _server_version() -> str:
    try:
        return manifest_mod.read_framework_version(_hub_root())
    except Exception:  # pragma: no cover - defensive
        return "0"


def _semver_key(value: str) -> tuple[int, int, int]:
    parts = (value or "").strip().split(".")
    try:
        nums = [int(p) for p in parts[:3]]
    except ValueError:
        return (0, 0, 0)
    while len(nums) < 3:
        nums.append(0)
    return (nums[0], nums[1], nums[2])


# ---------------------------------------------------------------------------
# Tool handlers (return a plain-text string; raise to signal a tool error)
# ---------------------------------------------------------------------------

def _tool_framework_version(_args: dict[str, Any]) -> str:
    data = json.loads(
        (_hub_root() / "registry" / "framework-version.json").read_text(encoding="utf-8"))
    return json.dumps(data, indent=2)


def _tool_inspect_repo(args: dict[str, Any]) -> str:
    repo = args.get("repo")
    if not repo:
        raise ValueError("'repo' is required (path to the target repository)")
    result = inspect_mod.inspect_repo(repo)
    fmt = str(args.get("format") or "markdown").lower()
    if fmt == "json":
        return json.dumps(result.to_dict(), indent=2)
    return inspect_mod.render_markdown(result)


def _tool_version_status(args: dict[str, Any]) -> str:
    given = args.get("framework_version")
    if not given:
        raise ValueError("'framework_version' is required (e.g. '0.1.0')")
    root = _hub_root()
    latest = manifest_mod.read_framework_version(root)
    releases_dir = root / "registry" / "releases"
    releases = sorted(
        (p.stem for p in releases_dir.glob("*.md")), key=_semver_key)
    pending = [v for v in releases if _semver_key(v) > _semver_key(given)]
    out = {
        "given": given,
        "latest": latest,
        "up_to_date": _semver_key(given) >= _semver_key(latest),
        "pending_releases": pending,
    }
    return json.dumps(out, indent=2)


class _Tool:
    def __init__(self, description: str, schema: dict[str, Any],
                 handler: Callable[[dict[str, Any]], str]) -> None:
        self.description = description
        self.schema = schema
        self.handler = handler


_TOOLS: dict[str, _Tool] = {
    "framework_version": _Tool(
        "Return the current hub framework version and the core modules it ships.",
        {"type": "object", "properties": {}, "additionalProperties": False},
        _tool_framework_version,
    ),
    "inspect_repo": _Tool(
        "Read-only audit of a target repo: returns a gap report of what "
        "governance, CI, commands, continuity, and docs already exist versus "
        "what a brain would add. Changes nothing.",
        {
            "type": "object",
            "properties": {
                "repo": {"type": "string",
                         "description": "Path to the target repository."},
                "format": {"type": "string", "enum": ["markdown", "json"],
                           "description": "Output format (default markdown)."},
            },
            "required": ["repo"],
            "additionalProperties": False,
        },
        _tool_inspect_repo,
    ),
    "version_status": _Tool(
        "Compare a framework version against the hub's latest and list the "
        "release versions still pending for a brain on that version.",
        {
            "type": "object",
            "properties": {
                "framework_version": {
                    "type": "string",
                    "description": "The brain's current framework_version, e.g. '0.1.0'."},
            },
            "required": ["framework_version"],
            "additionalProperties": False,
        },
        _tool_version_status,
    ),
}


# ---------------------------------------------------------------------------
# JSON-RPC plumbing
# ---------------------------------------------------------------------------

def _send(out: Any, message: dict[str, Any]) -> None:
    out.write(json.dumps(message) + "\n")
    out.flush()


def _result(req_id: Any, result: dict[str, Any]) -> dict[str, Any]:
    return {"jsonrpc": "2.0", "id": req_id, "result": result}


def _error(req_id: Any, code: int, message: str) -> dict[str, Any]:
    return {"jsonrpc": "2.0", "id": req_id, "error": {"code": code, "message": message}}


def _tool_listing() -> list[dict[str, Any]]:
    return [
        {"name": name, "description": t.description, "inputSchema": t.schema}
        for name, t in _TOOLS.items()
    ]


def _handle(message: dict[str, Any]) -> dict[str, Any] | None:
    """Return a response dict, or None for notifications (no reply expected)."""
    method = message.get("method")
    req_id = message.get("id")

    if method == "initialize":
        params = message.get("params") or {}
        return _result(req_id, {
            "protocolVersion": params.get("protocolVersion", DEFAULT_PROTOCOL),
            "capabilities": {"tools": {}},
            "serverInfo": {"name": SERVER_NAME, "version": _server_version()},
        })

    if method == "ping":
        return _result(req_id, {})

    if method == "tools/list":
        return _result(req_id, {"tools": _tool_listing()})

    if method == "tools/call":
        params = message.get("params") or {}
        name = params.get("name")
        arguments = params.get("arguments") or {}
        tool = _TOOLS.get(name)
        if tool is None:
            return _result(req_id, {
                "content": [{"type": "text", "text": f"Unknown tool: {name!r}"}],
                "isError": True,
            })
        try:
            text = tool.handler(arguments)
            return _result(req_id, {
                "content": [{"type": "text", "text": text}], "isError": False})
        except Exception as exc:  # surface tool errors in-band, per MCP
            return _result(req_id, {
                "content": [{"type": "text", "text": f"Error: {exc}"}],
                "isError": True,
            })

    # Notifications (no id) we don't handle are silently ignored.
    if req_id is None:
        return None
    return _error(req_id, -32601, f"Method not found: {method}")


def serve_stdio(stdin: Any = None, stdout: Any = None) -> int:
    """Run the MCP server over newline-delimited JSON-RPC on stdio."""
    stdin = stdin or sys.stdin
    stdout = stdout or sys.stdout
    for raw in stdin:
        line = raw.strip()
        if not line:
            continue
        try:
            message = json.loads(line)
        except json.JSONDecodeError:
            _send(stdout, _error(None, -32700, "Parse error"))
            continue
        response = _handle(message)
        if response is not None:
            _send(stdout, response)
    return 0
