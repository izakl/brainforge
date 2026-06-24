"""Command-line interface for the onboarding engine.

Usage:
    python -m brainfactory inspect --repo PATH [--out gap-report.md] [--json out.json]
    python -m brainfactory provision --dest DIR --name NAME --slug SLUG \\
        --brain-repo owner/repo --prefix wg [--platforms bash,powershell,python] \\
        [--profile platform-team]
    python -m brainfactory adopt --repo PATH [--apply] [--force] \\
        [--name ...] [--slug ...] [--brain-repo ...] [--prefix ...] \\
        [--gap-report PATH] [--json out.json]
    python -m brainfactory capabilities [--brain DIR] (--check | --write) [--json out.json]
    python -m brainfactory docs-mesh [--brain DIR] [--json out.json]
    python -m brainfactory intent-gate [--brain DIR] [--json out.json]
    python -m brainfactory mcp

``adopt`` defaults to DRY-RUN and prints the plan; pass ``--apply`` to write.
``mcp`` runs a Model Context Protocol server (stdio) for any MCP-capable agent.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

from . import apply as apply_mod
from . import capabilities as capabilities_mod
from . import docsmesh as docsmesh_mod
from . import emit as emit_mod
from . import inspect as inspect_mod


def _split_csv(value: str) -> list[str]:
    return [v.strip() for v in value.split(",") if v.strip()]


def cmd_inspect(args: argparse.Namespace) -> int:
    result = inspect_mod.inspect_repo(args.repo)
    md = inspect_mod.render_markdown(result)

    if args.out:
        Path(args.out).write_text(md, encoding="utf-8")
        print(f"Wrote gap report: {args.out}")
    if args.json:
        Path(args.json).write_text(
            json.dumps(result.to_dict(), indent=2) + "\n", encoding="utf-8")
        print(f"Wrote JSON summary: {args.json}")
    if not args.out and not args.json:
        print(md)
    else:
        # Always echo a compact module summary to stdout for quick feedback.
        for m in result.modules:
            print(f"  {m.module:22} {m.status:8} -> {m.action}")
        if result.risks:
            print(f"  RISKS: {len(result.risks)} (see report)")
    return 0


def cmd_provision(args: argparse.Namespace) -> int:
    platforms = _split_csv(args.platforms) if args.platforms else None
    result = apply_mod.provision(
        dest=args.dest,
        project_name=args.name,
        project_slug=args.slug,
        brain_repo=args.brain_repo,
        command_prefix=args.prefix,
        platforms=platforms,
        profile=args.profile,
        summary=args.summary,
    )
    print(apply_mod.render_apply_text(result))
    return 0


def cmd_adopt(args: argparse.Namespace) -> int:
    summary = None
    if args.summary_json:
        summary = json.loads(Path(args.summary_json).read_text(encoding="utf-8"))
    platforms = _split_csv(args.platforms) if args.platforms else None
    result = apply_mod.adopt(
        target=args.repo,
        summary=summary,
        project_name=args.name,
        project_slug=args.slug,
        brain_repo=args.brain_repo,
        command_prefix=args.prefix,
        platforms=platforms,
        profile=args.profile,
        apply=args.apply,
        force=args.force,
        gap_report=args.gap_report,
    )
    print(apply_mod.render_apply_text(result))
    if args.json:
        Path(args.json).write_text(
            json.dumps(result.to_dict(), indent=2) + "\n", encoding="utf-8")
        print(f"\nWrote JSON plan: {args.json}")
    return 0


def cmd_capabilities(args: argparse.Namespace) -> int:
    brain = args.brain or "."
    if args.write:
        path = capabilities_mod.write(brain)
        print(f"Wrote capabilities map: {path}")
        return 0
    # Default (and --check): regenerate in-memory and diff.
    result = capabilities_mod.check(brain)
    if args.json:
        Path(args.json).write_text(
            json.dumps(result.to_dict(), indent=2) + "\n", encoding="utf-8")
        print(f"Wrote JSON result: {args.json}")
    if result.ok:
        print("capabilities --check: OK (CAPABILITIES.md matches code).")
        return 0
    if result.missing_file:
        print("capabilities --check: FAIL — CAPABILITIES.md is missing. "
              "Run with --write to generate it.")
    else:
        print("capabilities --check: FAIL — CAPABILITIES.md has drifted from "
              "code. Run with --write to regenerate.\n")
        print(result.diff)
    return 1


def cmd_docs_mesh(args: argparse.Namespace) -> int:
    brain = args.brain or "."
    result = docsmesh_mod.check_docs_mesh(brain)
    if args.json:
        Path(args.json).write_text(
            json.dumps(result.to_dict(), indent=2) + "\n", encoding="utf-8")
        print(f"Wrote JSON result: {args.json}")
    print(docsmesh_mod.render_report(result))
    return 0 if result.ok else 1


def cmd_intent_gate(args: argparse.Namespace) -> int:
    brain = args.brain or "."
    result = capabilities_mod.intent_gate(brain)
    if args.json:
        Path(args.json).write_text(
            json.dumps(result.to_dict(), indent=2) + "\n", encoding="utf-8")
        print(f"Wrote JSON result: {args.json}")
    if result.ok:
        print("intent-gate: OK (every command has a row in CAPABILITIES.md).")
        return 0
    print("intent-gate: FAIL — a feature cannot land without the brain growing "
          "with it.\n")
    print(result.diff)
    return 1


def cmd_mcp(args: argparse.Namespace) -> int:
    from . import mcpserver
    return mcpserver.serve_stdio()


def cmd_emit(args: argparse.Namespace) -> int:
    result = emit_mod.emit_targets(args.brain or ".")
    if args.json:
        Path(args.json).write_text(
            json.dumps(result.to_dict(), indent=2) + "\n", encoding="utf-8")
        print(f"Wrote JSON result: {args.json}")
    print(emit_mod.render_report(result))
    return 0 if result.ok else 1


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="brainfactory",
        description="Onboarding engine for the brain-factory.",
    )
    sub = parser.add_subparsers(dest="command", required=True)

    # inspect
    p_ins = sub.add_parser(
        "inspect", help="Read-only audit of a target repo (gap report).")
    p_ins.add_argument("--repo", required=True, help="Path to the target repo.")
    p_ins.add_argument("--out", help="Write the markdown gap report here.")
    p_ins.add_argument("--json", help="Write the JSON summary here.")
    p_ins.set_defaults(func=cmd_inspect)

    # provision
    p_prov = sub.add_parser(
        "provision", help="Instantiate the brain-template into a new directory.")
    p_prov.add_argument("--dest", required=True, help="Empty destination dir.")
    p_prov.add_argument("--name", required=True, help="Human project name.")
    p_prov.add_argument("--slug", required=True, help="Lowercase slug.")
    p_prov.add_argument("--brain-repo", required=True, dest="brain_repo",
                        help="owner/repo of the brain.")
    p_prov.add_argument("--prefix", required=True, help="Command prefix (e.g. wg).")
    p_prov.add_argument("--platforms",
                        help="Comma-separated (default bash,powershell,python).")
    p_prov.add_argument("--profile", help="Adoption profile.")
    p_prov.add_argument("--summary", help="One-line project summary.")
    p_prov.set_defaults(func=cmd_provision)

    # adopt
    p_ad = sub.add_parser(
        "adopt", help="Adopt the brain into an existing repo (DRY-RUN by default).")
    p_ad.add_argument("--repo", required=True, help="Path to the target repo.")
    p_ad.add_argument("--summary-json", dest="summary_json",
                      help="Path to a saved inspector JSON summary (else inspect now).")
    p_ad.add_argument("--apply", action="store_true",
                      help="Actually write files (default is dry-run).")
    p_ad.add_argument("--force", action="store_true",
                      help="Overwrite existing files / manifest.")
    p_ad.add_argument("--name", help="Human project name.")
    p_ad.add_argument("--slug", help="Lowercase slug.")
    p_ad.add_argument("--brain-repo", dest="brain_repo", help="owner/repo of brain.")
    p_ad.add_argument("--prefix", help="Command prefix.")
    p_ad.add_argument("--platforms", help="Comma-separated platforms.")
    p_ad.add_argument("--profile", help="Adoption profile.")
    p_ad.add_argument("--gap-report", dest="gap_report",
                      help="Path to the gap report to record in the manifest.")
    p_ad.add_argument("--json", help="Write the JSON plan here.")
    p_ad.set_defaults(func=cmd_adopt)

    # capabilities
    p_cap = sub.add_parser(
        "capabilities",
        help="Regenerate (or --check) 01-docs/CAPABILITIES.md from code.")
    p_cap.add_argument("--brain", help="Brain directory (default: cwd).")
    cap_mode = p_cap.add_mutually_exclusive_group()
    cap_mode.add_argument("--check", action="store_true",
                          help="Diff regenerated map vs disk; non-zero if drifted "
                               "(default).")
    cap_mode.add_argument("--write", action="store_true",
                          help="Regenerate and write CAPABILITIES.md.")
    p_cap.add_argument("--json", help="Write the JSON result here.")
    p_cap.set_defaults(func=cmd_capabilities)

    # docs-mesh
    p_dm = sub.add_parser(
        "docs-mesh",
        help="Read-only docs anti-drift checks (links, mermaid, freshness).")
    p_dm.add_argument("--brain", help="Brain directory (default: cwd).")
    p_dm.add_argument("--json", help="Write the JSON result here.")
    p_dm.set_defaults(func=cmd_docs_mesh)

    # intent-gate
    p_ig = sub.add_parser(
        "intent-gate",
        help="Fail if a command dir has no row in the committed CAPABILITIES.md.")
    p_ig.add_argument("--brain", help="Brain directory (default: cwd).")
    p_ig.add_argument("--json", help="Write the JSON result here.")
    p_ig.set_defaults(func=cmd_intent_gate)

    # mcp
    p_mcp = sub.add_parser(
        "mcp",
        help="Run the Model Context Protocol server (stdio) exposing read-only "
             "registry/onboarding tools to any MCP-capable agent.")
    p_mcp.set_defaults(func=cmd_mcp)

    # emit-commands
    p_emit = sub.add_parser(
        "emit-commands",
        help="Emit each authored command to the standard agent discovery "
             "locations: .claude/skills, .github/skills, .github/agents.")
    p_emit.add_argument("--brain", help="Brain directory (default: cwd).")
    p_emit.add_argument("--json", help="Write the JSON result here.")
    p_emit.set_defaults(func=cmd_emit)

    return parser


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv if argv is not None else sys.argv[1:])
    return args.func(args)
