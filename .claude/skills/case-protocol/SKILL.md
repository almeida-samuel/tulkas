---
name: case-protocol
description: The framework's case protocol - case folder layout, workspace, who may write which file, task fields, the task file and role response, and events. Preloaded by every role agent; read by the run-case dispatcher.
user-invocable: false
---

# Case Protocol

Status: **draft**. How agents read and write a case. This skill is the source of truth for the protocol. The procedures that use it are in two other skills: `run-case` (the dispatcher loop) and `orchestrator-turn` (an orchestrator's turn). Concepts (case, task, event, orchestrator...) are defined in the root `CLAUDE.md`.

## Actors

- **Dispatcher**: the component that runs a case (the `run-case` skill). It is not a role and makes no business decisions. It creates and updates tasks, decides which tasks are ready (from dependencies and states only), invokes the assigned role, appends events, and carries the human boundary (presents human requests and case responses to the operator and records the answers).
- **Role agents**: one invocation per task. Each reads what it needs, writes **only** the files this protocol allows it, and returns.

## Case Folder

Everything the framework writes in a repository lives under `docs/tulkas/`. The context is not part of the path: each case names it in its `metadata.json`.

```text
docs/tulkas/cases/<case-id>/
  metadata.json             # context, workspace, opening time (dispatcher only)
  request.md                # the operator's case request (dispatcher only)
  tasks.json                # task list and statuses (dispatcher only)
  events.jsonl              # append-only event log (dispatcher only)
  state/<unit>.json         # the unit's view of the case (that unit's orchestrator only)
  tasks/<task-id>.json      # one file per task: its input (dispatcher) and its response (the assigned role)
  tasks/<task-id>.result.json  # the full expected output, only when it is long (the assigned role)
  human/<request-id>.json   # human request or operator answer to a case response, with the recorded response (dispatcher); IDs HR-001, HR-002, ...
  documents/                # input documents (read-only for agents)
  artifacts/                # produced artifacts (the role that produces them)
```

Shared records live in `docs/tulkas/records/<unit>/` and are changed **only** by that unit's orchestrator. External parties' mock data lives in `docs/tulkas/external/<party>/` and is read **only** by that external party.

`metadata.json`:

```json
{
  "case_id": "20261117120000-short-slug",
  "context": "software-dev",
  "opened_at": "2026-11-17T12:00:00Z",
  "workspace": {"mode": "worktree | branch | none", "branch": "tulkas/20261117120000-short-slug", "base": "main", "base_commit": "<sha>", "path": ".tulkas/worktrees/20261117120000-short-slug"},
  "closed_at": "2026-11-18T09:00:00Z",
  "closure": {"reason": "delivered | abandoned", "note": null, "open_tasks": [], "branch_merged": false}
}
```

`closed_at` and `closure` appear only once the case is closed. **A case is closed only by the operator** (the `close-case` skill), whatever state its tasks, branch, or pull request are in: a merge is not required, and an open pull request stays open. A closed case is never resumed; further work is a new case.

**Workspace.** A context whose cases change the repository declares a **case branch** in its `CLAUDE.md` (its name, built from the case ID only). The dispatcher then creates it when it opens the case, in one of two modes:

- `worktree` (default): the case branch is checked out in its own worktree, `.tulkas/worktrees/<case-id>`; the operator's checkout is untouched, and several cases can run at once.
- `branch`: the case branch is checked out in the operator's own checkout, which must be clean; one case at a time.

The case folder lives inside the workspace (`<workspace path>/docs/tulkas/cases/<case-id>/`), so it travels with the case branch. A context without a case branch uses mode `none`: the case folder lives in the current checkout. All paths in a case are relative to the workspace; the dispatcher gives every role the case folder's path.

**One writer per file.** That is what makes parallel tasks safe. A task file has two writers in turn, never at once: the dispatcher writes it before the role starts, and the role fills its `response` once; the dispatcher never writes it again.

**Revising an artifact.** When a task revises an artifact that already exists in the case (after a rejection, an operator answer, or a new round), edit it in place and add a short `Revision N` section at its end: what changed, by section or item ID, and why (the task, finding, or human request behind it). Leave unchanged parts as they are; never rewrite the whole artifact or copy it under a new name. Readers can then read only the revision section to see what moved.

## Task

An entry in `tasks.json`:

| Field | Meaning |
|---|---|
| `id` | `T001`, `T002`, ... in creation order |
| `role` | Role ID assigned to the task |
| `type` | `work` (do the work), `contract` (serve a contract request; `contract` names it), `resume` (orchestrator continues after its subtasks finished), `escalation`, `human` |
| `parent` | Task that created it (the requester), or `null` for the entry task |
| `depends_on` | Task IDs that must be `completed` first |
| `status` | `pending`, `ready`, `running`, `waiting` (on its subtasks), `awaiting-human`, `escalated`, `completed`, `rejected`, `failed` |
| `attempt` | 1 for the first try; a retry is a new task with `attempt` + 1 (max 4: 3 retries) |
| `contract` | For `contract` tasks (and their resumes): the contract served |
| `resumes` | For `resume` tasks: the ID of the original task this turn continues (e.g., `T001`) |
| `continued_by` | On a `waiting` task once it is resumed: the ID of the `resume` task that continues it |

## Task File

`tasks/<task-id>.json`:

```json
{
  "task_id": "T004",
  "role": "stock-manager",
  "input": { },
  "response": null
}
```

The dispatcher writes `task_id`, `role`, and `input` (the `input` of the `new_tasks` entry that created the task) with `"response": null`, then invokes the role. The role replaces `null` with its response, once, and never changes `input`.

## Role Response

```json
"response": {
  "status": "completed | failed",
  "output": { },
  "new_tasks": [ ],
  "state_changes": [ ],
  "escalations": [ ],
  "human_requests": [ ],
  "case_response": null,
  "checks": [ ],
  "summary": "One line for the event log."
}
```

- `output`: the expected output, with the fields its expected-output definition lists. When it is long (more than about 3 KB: long lists, findings, run logs, records), write it whole to `tasks/<task-id>.result.json` and keep in `output` only `{"result": "tasks/<task-id>.result.json"}` plus the few fields the requester decides on (an outcome, a verdict, a document path, counts). Documents go to `artifacts/`, as the expected output says; never copy a document into `output`.
- `new_tasks` (orchestrators only): `{role, type, contract?, input, depends_on?}`. Specialists in the orchestrator's own unit, or the provider orchestrator / external party of a contract the orchestrator may request.
- `state_changes` (orchestrators only): changes it **already applied** to its `state/<unit>.json` or its unit's records, each `{file, field, from, to, source}`.
- `escalations` (orchestrators only): `{to, reason, evidence}`; `to` is the next level in the reporting line.
- `human_requests` (orchestrators only): in the shape of the Human Request in the `orchestrator-turn` skill.
- `case_response` (entry-unit orchestrator only): in the shape of the Case Response in the `orchestrator-turn` skill.
- `checks`: every rule or acceptance check performed: `{check, target, result: pass|fail, detail}`. An orchestrator records its decision on each subtask output as one check named `acceptance`, with the subtask's ID as `target` (`pass` = accepted, `fail` = rejected). Keep `detail` to one line (a result line, a `file:line`, the reason for a fail); longer evidence belongs in the result file or the document.

**Keep the response small** (aim under 4 KB). The dispatcher reads it after every task, so every byte in it is paid again in the dispatcher's context for the rest of the case. `summary` is one line.

**Task inputs reference, they don't copy.** A `new_tasks` input names the paths of documents, task files, and results the task needs, and states only what is new for this task (what to fix, the operator's answer). Never paste a document or an earlier response into an input.

Specialists and external parties leave every list empty except `checks`, and never write anything but their task file's `response` (and its result file).

## Rules for Every Role Agent

- The dispatcher gives you the case folder and your task ID. Read your task file's `input` and the case's `request.md`.
- Your context's rules load on their own when you work in the case folder. Open a rule, contract, or other shared context file only when your task needs its exact wording, and read the documents your input names only as far as your task needs them.
- Never write `metadata.json`, `tasks.json`, `events.jsonl`, another task's file, or anything another role owns.
- If the input is insufficient, still write your response: say what is missing in `output` and `summary`; don't invent data.
- If the mock data you need doesn't exist, report it; don't make it up.

## Event

One JSON object per line in `events.jsonl`:

```json
{"ts": "2026-11-09T19:22:10Z", "actor": "sales-orchestrator", "type": "task-completed", "task_id": "T001", "data": {}}
```

`ts` is the real UTC time the event was written, read from the system clock (`date -u +%Y-%m-%dT%H:%M:%SZ`), never estimated.

Types: `case-opened`, `task-created`, `task-ready`, `task-started`, `task-completed`, `task-failed`, `output-accepted`, `output-rejected`, `check`, `state-changed`, `escalation-raised`, `escalation-resolved`, `human-request`, `human-response`, `case-response`, `case-closed`.
