# Local-First Quickstart (Solo Developer)

## When to use this runbook

Use this runbook when you are a solo developer setting up Brain Factory locally
for the first time and want the shortest path to a ready-to-work state.

It gives you:

- the recommended default setup profile for a solo/local context,
- the minimum fields to customize before running setup,
- the exact command sequence to apply setup and confirm readiness, and
- a clear list of what to safely defer on the first run.

A *setup profile* is a named bundle of sensible defaults (here,
`solo_prototype`). A *setup intent* is the JSON file that records your chosen
configuration. For the bigger picture of how the hub and per-project repos fit
together, see [How Brain Factory works](../how-brain-factory-works.md).

If you instead need the full natural-language to profile to apply to readiness
bridge, use [`prompt-to-setup-bootstrap.md`](prompt-to-setup-bootstrap.md).

## Recommended default profile

For a solo developer working locally, use the **`solo_prototype`** setup profile.

It provides sensible defaults:

| Axis | Default |
| --- | --- |
| `deployment.model` | `local_only` |
| `automation.bundle` / `automation.stage` | `A` / `minimum` |
| `governance.evidence_level` | `lightweight` |
| `security.posture` | `standard` |
| `execution_surfaces` | `vscode_local`, `github_cloud_agent` |

The ready-to-use example intent for this profile is:

```text
examples/setup-intent/solo-prototype.intent.json
```

## Step 1 — Clone the repository

```bash
git clone https://github.com/izakl/brainforge.git
cd brain-factory
```

If you have already cloned the repo, pull the latest main:

```bash
git checkout main
git pull origin main
```

## Step 2 — Confirm local tools

You need these tools available in your terminal:

```bash
python3 --version   # 3.8 or later
node --version      # any recent LTS
bash --version      # any recent version
git --version       # any recent version
```

If a tool is missing, install it before continuing.

## Step 3 — Copy the solo-prototype example intent

Copy the example intent file to a working location:

```bash
cp examples/setup-intent/solo-prototype.intent.json /tmp/my-setup-intent.json
```

## Step 4 — Customize the minimum required fields

Open `/tmp/my-setup-intent.json` and update these three fields first:

| Field | What to set | Example |
| --- | --- | --- |
| `setup_id` | A unique identifier for this setup run | `"setup-2026-solo-myproject"` |
| `project.name` | Your project or repository name | `"my-project"` |
| `team.owners` | Your GitHub handle | `["@yourhandle"]` |

Everything else can remain at the `solo_prototype` defaults for first run.

**Optional on first run** — change these only if the defaults do not fit:

| Field | Default | Override when |
| --- | --- | --- |
| `project.primary_work_types` | `["enhancement", "docs"]` | You know you need other types now |
| `execution_surfaces` | `["vscode_local", "github_cloud_agent"]` | You are not using one of these |
| `preferences.mobile_surface` | `false` | You actively use GitHub Mobile |
| `deferred[].item` | handoff packet enforcement | You want to enable it immediately |

## Step 5 — Dry-run the setup

Preview what the setup script will do without writing any files:

```bash
bash scripts/apply-setup.sh --intent /tmp/my-setup-intent.json --dry-run
```

Review the output summary. Confirm:

- [ ] Project name and owners match your intent.
- [ ] Bundle `A` / stage `minimum` is correct for a solo/local start.
- [ ] Deployment model is `local_only`.
- [ ] Deferred items are listed with reasons.

Fix any validation errors before continuing. The script will print the failing
fields explicitly.

## Step 6 — Apply the setup

When the dry-run output looks correct, apply the setup:

```bash
bash scripts/apply-setup.sh --intent /tmp/my-setup-intent.json
```

This writes your intent to `.github/framework-setup-intent.json` — the
canonical path read by all downstream scripts and checks.

## Step 7 — Confirm readiness

Run the readiness check:

```bash
bash scripts/check-setup-readiness.sh
```

A passing result means the canonical intent is schema-valid and all required
dimensions are satisfied.

## Step 8 — Run baseline validation

Run the standard baseline checks:

```bash
npx -y markdownlint-cli2 "**/*.md"
bash scripts/check-framework-task-queue.sh
bash scripts/check-queue-health.sh
bash scripts/check-security-guardrails.sh
bash scripts/check-index-parity.sh
```

A clean pass here confirms the repository is coherent.

## Readiness confirmation

You are ready to work when:

- [ ] `check-setup-readiness.sh` passes with no errors.
- [ ] `.github/framework-setup-intent.json` exists and names your project and owner.
- [ ] Baseline checks all pass.
- [ ] Deferred items are recorded (in the intent file) with a reason and owner.

## Safe deferrals for first run

The following are intentionally deferred in the `solo_prototype` defaults.
Leave them deferred until the indicated trigger fires.

| Deferred item | Safe to defer until |
| --- | --- |
| Handoff packet enforcement workflow | Handoff volume increases or a second contributor joins |
| Mobile quick-action surface | You actively use GitHub Mobile as an operating surface |
| GitHub Projects setup | You need structured board-based tracking |
| Elevated security posture | Project moves from prototype to production service |
| Stricter governance / evidence level | You need audit trails or compliance evidence |
| Full automation bundle B or C | You are ready to add more automated checks and workflows |

Add a `deferred[]` entry with a reason and owner for each item you skip. Do
not leave deferrals implicit — the readiness check enforces this.

## What to do next

After readiness passes:

1. Open a bounded bootstrap issue documenting this setup. Link it to
   `.github/framework-setup-intent.json`.
2. Open one follow-up issue per deferred item, with the owner and enablement
   criteria noted.
3. Start your first bounded issue → PR flow using
   [`docs/operating-model.md`](../operating-model.md).

## Mobile quick action

- **Use when:** you need to confirm setup progress or capture a deferred-item
  issue from mobile before returning to desktop.
- **Do from mobile:**
  - Review the bootstrap issue and confirm setup intent is linked.
  - Open a follow-up issue for any deferred item that lacks a durable artifact.
  - Comment on the bootstrap issue with any clarifications or missing owner info.
- **Do not do from mobile:**
  - Run `apply-setup.sh` or `check-setup-readiness.sh` (requires terminal).
  - Edit `.github/framework-setup-intent.json` directly.
  - Start a new setup intent from scratch on mobile.
- **Escalate to desktop/cloud when:**
  - Schema validation fails and the intent needs editing.
  - Baseline checks need to be run and evidence captured.
  - A new setup profile or bundle change is needed.
- **Primary artifact to update:**
  - The bootstrap issue documenting this setup application.

## Related docs

- [Prompt-to-setup bootstrap](prompt-to-setup-bootstrap.md) — full
  natural-language → profile → apply → readiness path.
- [Apply setup](apply-setup.md) — complete step-by-step setup procedure.
- [Framework setup profiles and intent examples](../framework-setup-profiles-and-intent-examples.md)
- [Framework setup intent schema and application model](../framework-setup-intent-schema-and-application-model.md)
- [Framework automation bundles by profile](../framework-automation-bundles-by-profile.md)
- [Operator onboarding pack](../operator-onboarding-pack.md)
- [Framework starter kit / bootstrap pack](../framework-starter-kit.md)
- [Operating model](../operating-model.md)
