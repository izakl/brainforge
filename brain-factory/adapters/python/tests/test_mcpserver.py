"""Tests for brainfactory.mcpserver (the stdlib MCP stdio server)."""

import io
import unittest

from brainfactory import mcpserver as mcp


def call(method, params=None, mid=1):
    msg = {"jsonrpc": "2.0", "method": method}
    if mid is not None:
        msg["id"] = mid
    if params is not None:
        msg["params"] = params
    return mcp._handle(msg)


class McpTest(unittest.TestCase):
    def test_initialize_echoes_protocol(self):
        r = call("initialize", {"protocolVersion": "2025-06-18"})
        self.assertEqual(r["result"]["serverInfo"]["name"], "brain-factory")
        self.assertEqual(r["result"]["protocolVersion"], "2025-06-18")

    def test_tools_list(self):
        names = {t["name"] for t in call("tools/list")["result"]["tools"]}
        self.assertEqual(
            names, {"framework_version", "inspect_repo", "version_status"})

    def test_framework_version_tool(self):
        r = call("tools/call", {"name": "framework_version", "arguments": {}})
        self.assertFalse(r["result"]["isError"])
        self.assertIn("framework_version", r["result"]["content"][0]["text"])

    def test_version_status_pending(self):
        r = call("tools/call",
                 {"name": "version_status", "arguments": {"framework_version": "0.0.1"}})
        self.assertIn('"up_to_date": false', r["result"]["content"][0]["text"])

    def test_unknown_tool_is_in_band_error(self):
        r = call("tools/call", {"name": "nope", "arguments": {}})
        self.assertTrue(r["result"]["isError"])

    def test_unknown_method_returns_jsonrpc_error(self):
        self.assertEqual(call("bogus/x", mid=9)["error"]["code"], -32601)

    def test_notification_gets_no_response(self):
        self.assertIsNone(call("notifications/initialized", mid=None))

    def test_serve_stdio_roundtrip(self):
        inp = io.StringIO(
            '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{}}\n'
            '{"jsonrpc":"2.0","id":2,"method":"tools/list"}\n')
        out = io.StringIO()
        mcp.serve_stdio(inp, out)
        lines = [ln for ln in out.getvalue().splitlines() if ln.strip()]
        self.assertEqual(len(lines), 2)


if __name__ == "__main__":
    unittest.main()
