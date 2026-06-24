#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
queue_file="${repo_root}/.github/framework-task-queue.json"

python3 - "$queue_file" <<'PY'
import json
import sys
from pathlib import Path

queue_path = Path(sys.argv[1])

if not queue_path.exists():
    raise SystemExit(f"Queue file missing: {queue_path}")

with queue_path.open("r", encoding="utf-8") as f:
    data = json.load(f)

errors = []

if not isinstance(data, dict):
    errors.append("Queue root must be a JSON object.")

def get_required_non_empty_array(container, key, context, errors_list):
    value = container.get(key) if isinstance(container, dict) else None
    if not isinstance(value, list) or len(value) == 0:
        errors_list.append(f"{context} must include non-empty '{key}' array.")
        return None
    return value

tasks = data.get("tasks")
if not isinstance(tasks, list) or len(tasks) == 0:
    errors.append("Queue must include a non-empty 'tasks' array.")
    tasks = []

required_fields = {
    "id",
    "title",
    "status",
    "depends_on",
    "why_now",
    "suggested_prompt",
    "continuity_writeback_expected",
    "labels",
    "related_docs",
}

if not isinstance(data.get("version"), int):
    errors.append("Queue must include integer 'version'.")

status_model = data.get("status_model")
if not isinstance(status_model, list):
    errors.append("Queue must include 'status_model' array.")

writeback_model = data.get("continuity_writeback_model")
if not isinstance(writeback_model, list):
    errors.append("Queue must include 'continuity_writeback_model' array.")

default_issue_template = data.get("default_issue_template")
if not isinstance(default_issue_template, str) or not default_issue_template.strip():
    errors.append("Queue must include non-empty 'default_issue_template' string.")

schema_reference = data.get("schema_reference")
if not isinstance(schema_reference, str) or not schema_reference.strip():
    errors.append("Queue must include non-empty 'schema_reference' string.")

issue_backed_queue_model = data.get("issue_backed_queue_model")
issue_required_statuses = None
allow_issueless_statuses = None
if not isinstance(issue_backed_queue_model, dict):
    errors.append("Queue must include object 'issue_backed_queue_model'.")
else:
    marker_prefix = issue_backed_queue_model.get("prepared_issue_marker_prefix")
    if not isinstance(marker_prefix, str) or not marker_prefix.strip():
        errors.append(
            "Queue issue_backed_queue_model must include non-empty "
            "'prepared_issue_marker_prefix' string."
        )

    prepared_issue_label = issue_backed_queue_model.get("prepared_issue_label")
    if not isinstance(prepared_issue_label, str) or not prepared_issue_label.strip():
        errors.append(
            "Queue issue_backed_queue_model must include non-empty "
            "'prepared_issue_label' string."
        )

    prepared_issue_template = issue_backed_queue_model.get("prepared_issue_template")
    if not isinstance(prepared_issue_template, str) or not prepared_issue_template.strip():
        errors.append(
            "Queue issue_backed_queue_model must include non-empty "
            "'prepared_issue_template' string."
        )

    issue_required_statuses = get_required_non_empty_array(
        issue_backed_queue_model,
        "issue_required_statuses",
        "Queue issue_backed_queue_model",
        errors,
    )
    allow_issueless_statuses = get_required_non_empty_array(
        issue_backed_queue_model,
        "allow_issueless_statuses",
        "Queue issue_backed_queue_model",
        errors,
    )

allowed_statuses = {"blocked", "pending", "in_progress", "done", "superseded"}
if isinstance(status_model, list):
    unknown_statuses = [s for s in status_model if s not in allowed_statuses]
    if unknown_statuses:
        errors.append(
            "Queue status_model contains unsupported status values: "
            + ", ".join(unknown_statuses)
        )

allowed_writeback = {"yes", "likely", "no"}
if isinstance(writeback_model, list):
    unknown_writeback = [s for s in writeback_model if s not in allowed_writeback]
    if unknown_writeback:
        errors.append(
            "Queue continuity_writeback_model contains unsupported values: "
            + ", ".join(unknown_writeback)
        )

if isinstance(issue_backed_queue_model, dict):
    if issue_required_statuses is not None:
        unknown_required = [
            s for s in issue_required_statuses if s not in allowed_statuses
        ]
        if unknown_required:
            errors.append(
                "Queue issue_backed_queue_model issue_required_statuses contains "
                "unsupported status values: " + ", ".join(unknown_required)
            )

    if allow_issueless_statuses is not None:
        unknown_issueless = [
            s for s in allow_issueless_statuses if s not in allowed_statuses
        ]
        if unknown_issueless:
            errors.append(
                "Queue issue_backed_queue_model allow_issueless_statuses contains "
                "unsupported status values: " + ", ".join(unknown_issueless)
            )

    if issue_required_statuses is not None and allow_issueless_statuses is not None:
        required_set = set(issue_required_statuses)
        issueless_set = set(allow_issueless_statuses)
        overlap = sorted(required_set.intersection(issueless_set))
        if overlap:
            overlap_text = ", ".join(overlap)
            errors.append(
                "Queue issue_backed_queue_model status sets overlap between "
                f"issue_required_statuses and allow_issueless_statuses: {overlap_text}"
            )
        covered = required_set.union(issueless_set)
        missing = sorted(allowed_statuses - covered)
        if missing:
            errors.append(
                "Queue issue_backed_queue_model status sets must cover all queue statuses; "
                f"missing: {', '.join(missing)}"
            )
task_ids = []
for idx, task in enumerate(tasks):
    where = f"tasks[{idx}]"
    if not isinstance(task, dict):
        errors.append(f"{where}: each task must be an object.")
        continue

    missing = sorted(required_fields - set(task.keys()))
    if missing:
        errors.append(f"{where}: missing required field(s): {', '.join(missing)}")

    task_id = task.get("id")
    if not isinstance(task_id, str) or not task_id.strip():
        errors.append(f"{where}: 'id' must be a non-empty string.")
    else:
        task_ids.append(task_id)

    status = task.get("status")
    if status not in allowed_statuses:
        errors.append(f"{where}: unsupported status '{status}'.")

    depends_on = task.get("depends_on")
    if not isinstance(depends_on, list):
        errors.append(f"{where}: 'depends_on' must be an array.")
    else:
        for dep in depends_on:
            if not isinstance(dep, str) or not dep.strip():
                errors.append(f"{where}: every dependency id must be a non-empty string.")
                break

    prompt = task.get("suggested_prompt")
    if not isinstance(prompt, str) or not prompt.strip():
        errors.append(f"{where}: 'suggested_prompt' must be a non-empty string.")

    why_now = task.get("why_now")
    if not isinstance(why_now, str) or not why_now.strip():
        errors.append(f"{where}: 'why_now' must be a non-empty string.")

    writeback = task.get("continuity_writeback_expected")
    if writeback not in allowed_writeback:
        errors.append(
            f"{where}: unsupported continuity_writeback_expected '{writeback}'."
        )

    labels = task.get("labels")
    if not isinstance(labels, list) or len(labels) == 0:
        errors.append(f"{where}: 'labels' must be a non-empty array.")
    else:
        for label in labels:
            if not isinstance(label, str) or not label.strip():
                errors.append(f"{where}: every label must be a non-empty string.")
                break

    related_docs = task.get("related_docs")
    if not isinstance(related_docs, list) or len(related_docs) == 0:
        errors.append(f"{where}: 'related_docs' must be a non-empty array.")
    else:
        for doc in related_docs:
            if not isinstance(doc, str) or not doc.strip():
                errors.append(f"{where}: every related_docs entry must be a non-empty string.")
                break

if len(task_ids) != len(set(task_ids)):
    errors.append("Task ids must be unique.")

task_by_id = {task["id"]: task for task in tasks if isinstance(task, dict) and "id" in task}

for task in tasks:
    task_id = task.get("id")
    if not isinstance(task_id, str):
        continue
    deps = task.get("depends_on", [])
    for dep in deps:
        if dep not in task_by_id:
            errors.append(f"Task '{task_id}' depends on unknown task id '{dep}'.")
        if dep == task_id:
            errors.append(f"Task '{task_id}' cannot depend on itself.")

    if task.get("status") == "blocked" and not deps:
        errors.append(f"Task '{task_id}' is blocked but has no dependencies.")

ready_pending = []
for task in tasks:
    if task.get("status") != "pending":
        continue
    deps = task.get("depends_on", [])
    if all(task_by_id.get(dep, {}).get("status") == "done" for dep in deps):
        ready_pending.append(task.get("id"))

if len(ready_pending) > 1:
    errors.append(
        "Queue must have at most one dependency-ready pending task for deterministic "
        f"merge-driven preparation; found: {', '.join(ready_pending)}"
    )

if errors:
    print("Framework task queue validation failed:")
    for err in errors:
        print(f"  - {err}")
    raise SystemExit(1)

print(
    "OK: framework task queue validation passed "
    f"({len(tasks)} tasks, {len(ready_pending)} dependency-ready pending task)."
)
PY
