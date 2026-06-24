#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
queue_file="${repo_root}/.github/framework-task-queue.json"

python3 - "$queue_file" "$repo_root" <<'PY'
import json
import os
import re
import sys
from pathlib import Path
from urllib.error import HTTPError, URLError
from urllib import parse, request

queue_path = Path(sys.argv[1])
repo_root = Path(sys.argv[2])

if not queue_path.exists():
    raise SystemExit(f"Queue file missing: {queue_path}")

with queue_path.open("r", encoding="utf-8") as f:
    data = json.load(f)

errors = []
warnings = []

tasks = data.get("tasks", [])
if not isinstance(tasks, list):
    raise SystemExit("Queue 'tasks' is not a list; run check-framework-task-queue.sh first.")

task_by_id = {
    task["id"]: task
    for task in tasks
    if isinstance(task, dict) and isinstance(task.get("id"), str)
}

# ── Check 1: related_docs paths must exist in the repository ──────────────────
# Stale related_docs references indicate the queue entry is drifting from repo reality.
for task in tasks:
    if not isinstance(task, dict):
        continue
    task_id = task.get("id", "<unknown>")
    related_docs = task.get("related_docs", [])
    if not isinstance(related_docs, list):
        continue
    for doc_path in related_docs:
        if not isinstance(doc_path, str) or not doc_path.strip():
            continue
        full_path = repo_root / doc_path
        if not full_path.exists():
            errors.append(
                f"Task '{task_id}': related_doc '{doc_path}' does not exist in the "
                f"repository. Update or remove the stale reference."
            )

# ── Check 2: blocked tasks whose deps are all done (should be pending) ────────
# A task that is still 'blocked' after all its dependencies reach 'done' has drifted
# from the state model. It should have been promoted to 'pending'.
for task in tasks:
    if not isinstance(task, dict):
        continue
    task_id = task.get("id", "<unknown>")
    status = task.get("status")
    deps = task.get("depends_on", [])
    if status != "blocked" or not isinstance(deps, list) or not deps:
        continue
    all_deps_done = all(
        task_by_id.get(dep, {}).get("status") == "done"
        for dep in deps
        if isinstance(dep, str)
    )
    if all_deps_done:
        errors.append(
            f"Task '{task_id}' is 'blocked' but all its dependencies are 'done'. "
            f"Reconcile queue state: promote this task to 'pending'."
        )

# ── Check 3: pending tasks with unresolved dependencies (should be blocked) ───
# A task that is 'pending' while its dependencies are not yet 'done' violates the
# state model. Merge-triggered preparation could select the wrong task.
for task in tasks:
    if not isinstance(task, dict):
        continue
    task_id = task.get("id", "<unknown>")
    status = task.get("status")
    deps = task.get("depends_on", [])
    if status != "pending" or not isinstance(deps, list):
        continue
    unresolved = [
        dep
        for dep in deps
        if isinstance(dep, str) and task_by_id.get(dep, {}).get("status") != "done"
    ]
    if unresolved:
        errors.append(
            f"Task '{task_id}' is 'pending' but has unresolved dependencies: "
            f"{', '.join(unresolved)}. Promote those deps to 'done' first, or set "
            f"this task back to 'blocked'."
        )

# ── Check 4: non-terminal tasks that depend on superseded tasks ───────────────
# A superseded task cannot satisfy a dependency (only 'done' satisfies deps in
# the state model). Tasks that depend on superseded items can never become ready.
terminal_statuses = {"done", "superseded"}
for task in tasks:
    if not isinstance(task, dict):
        continue
    task_id = task.get("id", "<unknown>")
    status = task.get("status")
    if status in terminal_statuses:
        continue
    deps = task.get("depends_on", [])
    if not isinstance(deps, list):
        continue
    superseded_deps = [
        dep
        for dep in deps
        if isinstance(dep, str)
        and task_by_id.get(dep, {}).get("status") == "superseded"
    ]
    if superseded_deps:
        errors.append(
            f"Task '{task_id}' (status: '{status}') depends on superseded task(s): "
            f"{', '.join(superseded_deps)}. Superseded tasks cannot satisfy dependencies; "
            f"update or replace the dependency reference."
        )

# ── Check 5: multiple in_progress tasks simultaneously (warning) ──────────────
# Multiple concurrent in_progress entries are unusual and may indicate drift or
# a missed state transition after a merge.
in_progress = [
    task.get("id", "<unknown>")
    for task in tasks
    if isinstance(task, dict) and task.get("status") == "in_progress"
]
if len(in_progress) > 1:
    warnings.append(
        f"Multiple tasks are 'in_progress' simultaneously: {', '.join(in_progress)}. "
        f"Verify this is intentional — if one has merged, update its status to 'done'."
    )

# ── Check 6: optional GitHub API closure/linkage drift checks ──────────────────
# When GITHUB_TOKEN + GITHUB_REPOSITORY are available (for example in CI), detect
# open queue-linked issues that already have merged implementation PRs but were
# not closed (or were linked without close keywords).
issue_backed_model = (
    data.get("issue_backed_queue_model", {})
    if isinstance(data.get("issue_backed_queue_model"), dict)
    else {}
)
marker_prefix = issue_backed_model.get("prepared_issue_marker_prefix", "framework-task-queue-id:")
prepared_issue_label = issue_backed_model.get("prepared_issue_label", "agent-task")

github_token = os.environ.get("GITHUB_TOKEN")
github_repository = os.environ.get("GITHUB_REPOSITORY")
github_api_url = os.environ.get("GITHUB_API_URL", "https://api.github.com").rstrip("/")
strict_github_drift = os.environ.get("QUEUE_HEALTH_STRICT_GITHUB_DRIFT", "true").lower() not in {
    "0",
    "false",
    "no",
}
github_drift_errors = []

if github_token and github_repository and "/" in github_repository:
    owner, repo = github_repository.split("/", 1)
    marker_re = re.compile(rf"<!--\s*{re.escape(marker_prefix)}(?P<task_id>[^>\s]+)\s*-->")

    def build_close_keyword_regex(issue_number):
        """Return regex matching GitHub close keywords for a specific issue number."""
        return re.compile(
            rf"(?im)\b(close[sd]?|closing|fix(?:e[sd]?|ing)?|resolve[sd]?|resolving)\s*:?\s+#{issue_number}\b"
        )

    def api_get(path, params=None):
        url = f"{github_api_url}{path}"
        if params:
            url += "?" + parse.urlencode(params)
        req = request.Request(
            url,
            headers={
                "Accept": "application/vnd.github+json",
                "Authorization": f"Bearer {github_token}",
                "User-Agent": "framework-queue-health-check",
            },
        )
        try:
            with request.urlopen(req) as response:
                return json.loads(response.read().decode("utf-8"))
        except HTTPError as exc:
            raise RuntimeError(
                f"GitHub API HTTP error for '{path}': {exc.code} {exc.reason}"
            ) from exc
        except URLError as exc:
            raise RuntimeError(
                f"GitHub API network error for '{path}': {exc.reason}"
            ) from exc

    try:
        open_queue_issues = []
        page = 1
        while True:
            issues_page = api_get(
                f"/repos/{owner}/{repo}/issues",
                {
                    "state": "open",
                    "labels": prepared_issue_label,
                    "per_page": 100,
                    "page": page,
                },
            )
            if not isinstance(issues_page, list) or not issues_page:
                break

            for issue in issues_page:
                if not isinstance(issue, dict):
                    continue
                if "pull_request" in issue:
                    continue
                body = issue.get("body") or ""
                if not isinstance(body, str):
                    continue
                marker_match = marker_re.search(body)
                if not marker_match:
                    continue
                open_queue_issues.append((issue, marker_match.group("task_id")))

            if len(issues_page) < 100:
                break
            page += 1

        for issue, queue_task_id in open_queue_issues:
            issue_number = issue.get("number")
            issue_title = issue.get("title", "<unknown>")
            if not isinstance(issue_number, int):
                continue

            queue_status = task_by_id.get(queue_task_id, {}).get("status")
            if queue_status == "done":
                github_drift_errors.append(
                    f"Queue-linked issue #{issue_number} ('{issue_title}') is open, but queue task "
                    f"'{queue_task_id}' is already 'done'. Close the issue or reconcile queue status."
                )

            merged_pr_search = api_get(
                "/search/issues",
                {
                    "q": f'repo:{owner}/{repo} is:pr is:merged "#{issue_number}"',
                    "per_page": 20,
                },
            )
            if not isinstance(merged_pr_search, dict):
                continue

            merged_items = merged_pr_search.get("items", [])
            if not isinstance(merged_items, list) or len(merged_items) == 0:
                continue

            merged_pr_numbers = []
            merged_prs_with_close_keywords = []
            close_re = build_close_keyword_regex(issue_number)

            for item in merged_items:
                if not isinstance(item, dict):
                    continue
                pr_number = item.get("number")
                if not isinstance(pr_number, int):
                    continue

                merged_pr_numbers.append(pr_number)
                pr = api_get(f"/repos/{owner}/{repo}/pulls/{pr_number}")
                pr_body = pr.get("body", "") if isinstance(pr, dict) else ""
                if isinstance(pr_body, str) and close_re.search(pr_body):
                    merged_prs_with_close_keywords.append(pr_number)

            if merged_pr_numbers and not merged_prs_with_close_keywords:
                github_drift_errors.append(
                    f"Queue-linked issue #{issue_number} ('{issue_title}') is still open, but merged PR(s) "
                    f"{', '.join(f'#{n}' for n in merged_pr_numbers)} reference it without a close keyword. "
                    "Use `Closes #...` for the canonical queue-backed issue, then manually close/reconcile this issue."
                )
            elif merged_prs_with_close_keywords:
                github_drift_errors.append(
                    f"Queue-linked issue #{issue_number} ('{issue_title}') is still open even though merged PR(s) "
                    f"{', '.join(f'#{n}' for n in merged_prs_with_close_keywords)} include a close keyword. "
                    "Close/reconcile the issue and queue state."
                )
    except Exception as exc:
        warnings.append(
            "Skipped GitHub API closure/linkage checks due to API error: "
            f"{exc}. Run the manual closure/linkage checklist in "
            "docs/runbooks/run-queue-health-check.md."
        )
else:
    warnings.append(
        "Skipped GitHub API closure/linkage checks (set GITHUB_TOKEN and "
        "GITHUB_REPOSITORY to enable). Run the manual closure/linkage checklist "
        "in docs/runbooks/run-queue-health-check.md."
    )

if github_drift_errors:
    if strict_github_drift:
        errors.extend(github_drift_errors)
    else:
        warnings.extend(
            [
                "Queue health drift findings from GitHub API checks were downgraded "
                "to warnings (QUEUE_HEALTH_STRICT_GITHUB_DRIFT=false):",
                *[f"  - {finding}" for finding in github_drift_errors],
            ]
        )

# ── Report ────────────────────────────────────────────────────────────────────
if warnings:
    print("Queue health warnings:")
    for w in warnings:
        print(f"  ⚠ {w}")

if errors:
    print("Queue health drift detected:")
    for err in errors:
        print(f"  - {err}")
    raise SystemExit(1)

task_count = len(tasks)
warning_count = len(warnings)
print(
    f"OK: queue health check passed ({task_count} tasks, {warning_count} warning(s))."
)
PY
