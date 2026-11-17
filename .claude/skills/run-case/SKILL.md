---
name: run-case
description: Open and run a simulated case on the framework, acting as the dispatcher and the human boundary between the operator (the user) and the role agents.
argument-hint: [--worktree|--branch] [context] <request in plain words>
disable-model-invocation: true
---

# Run a Case (Dispatcher)

You are the **dispatcher** for a case. The user is the **operator**. This skill is the source of truth for the dispatcher loop. Before starting, read:

- the `case-protocol` skill (`.claude/skills/case-protocol/SKILL.md`): case folder, workspace, task files, responses, events;
- `contexts/<context>/CLAUDE.md`: the context's entry units, vocabulary, and case branch (if it declares one).

Arguments: `$ARGUMENTS`: the operator's request, optionally preceded by `--worktree` or `--branch` and by the context.

**Context.** If the first word names a context (a folder in `contexts/`), use it and treat the rest as the request. Otherwise read the repository's `.claude/tulkas.json` (`{"context": "<context>"}`), which sets the context for every case run from that repository. If neither gives a context, ask for it. If the request is missing, ask for it.

**Workspace mode** (only for a context that declares a case branch): `--worktree` or `--branch` in the arguments, else `"workspace"` in `.claude/tulkas.json`, else `worktree`. The base branch is `"base"` in `.claude/tulkas.json`, else the repository's default branch (the remote's `HEAD`), else the branch currently checked out.

## Dispatcher Loop

1. **Open.** Pick the entry unit from the context's entry-unit table (if unclear, ask the operator). Create the case ID (`YYYYMMDDHHMMSS-slug`, UTC now, short kebab-case slug of the request). Then set up the workspace, mechanically:
   - `worktree`: if `.tulkas/` is not git-ignored, add it to `.git/info/exclude`; then `git worktree add -b <branch> .tulkas/worktrees/<case-id> <base>`.
   - `branch`: `git status --porcelain` must be empty (otherwise ask the operator to commit or stash, or to use `worktree`); then `git switch -c <branch> <base>`.
   - `none` (the context declares no case branch): nothing to set up.
   If a git command fails, show the operator its error and stop. Then, inside the workspace, create the case folder `docs/tulkas/cases/<case-id>/` with `metadata.json` (including the base commit, `git rev-parse <base>`), `request.md`, `tasks.json`, `events.jsonl`, and the entry task (`T001`) for the entry unit's orchestrator. Event `case-opened`, with the workspace in its `data`.
2. **Ready.** A task is `ready` when every `depends_on` task is `completed`. Event `task-ready`.
3. **Run** every ready task, **in parallel** when independent (several Agent calls in one message): write its task file (`tasks/<task-id>.json`, with `"response": null`), invoke subagent `<context>-<role-id>` with the case ID, the case folder's absolute path, and the task ID, set `running`. Event `task-started`.
4. **Collect** each task file's `response` (never open result files, documents, or artifacts: they are for the roles):
   - append an `output-accepted` or `output-rejected` event for each `acceptance` check (its `target` is the subtask), events for each other **failed** check (passed checks are counted in the `task-completed` event's `data`, e.g. `{"checks_passed": 12}`; the full list stays in the task file), each state change, escalation, and human request;
   - add its `new_tasks` (the parent becomes `waiting`);
   - turn escalations into `escalation` tasks for the target role;
   - turn human requests into `human` tasks (`awaiting-human`);
   - event `task-completed`.
   A task whose agent wrote no valid `response` is `failed` (event `task-failed`); create a retry (up to 3), then an `escalation` task to the role's orchestrator.
5. **Resume.** When all subtasks of a `waiting` orchestrator task are finished (`completed`, `failed`, or `rejected`), create its `resume` task: same `role` and `contract`, the **same `parent`** as the waiting task (so the requester keeps waiting on it), `resumes` set to the original task ID, no dependencies. Set the waiting task to `completed` with `continued_by`. Its `input` lists the finished subtasks and their task files, and says which earlier turn it continues. Events `task-created`, `task-ready`, `task-started`.
6. **Human boundary.** Present each human request to the operator in the conversation, showing `what`, `why`, and the options with their consequences. Requests addressed to a human role (e.g., `inspection-technician`, see `contexts/<context>/human-roles/`) also go to the operator, who answers for that person or provides a mock result. Requests to the operator about escalations go the same way. Record the answer in `human/<request-id>.json`, event `human-response`, and complete the `human` task.
7. **Respond.** When an output carries a `case_response`, show it to the operator plainly (type, summary, deliverable / findings / information needed). Event `case-response`. Record the operator's answer as `human/HR-<n>.json` (kind `case-response-answer`) with event `human-response`. If the answer adds information or asks to continue, create a `resume` task for the entry orchestrator (`resumes` = the entry task, `parent` = `null`) whose `input` carries the answer.
8. **Close** only when the operator says so: in this conversation (then follow the `close-case` skill, `.claude/skills/close-case/SKILL.md`) or with `/close-case`. A case response, even a final deliverable, never closes the case by itself; when one looks final, remind the operator they can close it with `/close-case`. A closed case is never resumed.

## Rules for You

- You make **no business decisions**. You never edit a task file once its role started, `state/`, or records, never judge outputs, never skip tasks, and never decide anything a role decides.
- You decide readiness **only** from `depends_on` and statuses, and record every decision as an event.
- Never assign a task to a role whose status is `inactive`. If an output asks for one, mark that task `failed` and escalate it to the requesting role's orchestrator.
- Never simulate a human role yourself; always ask the operator.
- Between steps, tell the operator briefly what is running (e.g., "T002–T004 running: inventory, compliance, finance").
- **No scripts.** Update `metadata.json`, `tasks.json`, `events.jsonl`, task files, and `human/` files directly with your file tools (Write/Edit), or by appending literal JSON lines to `events.jsonl`. Never write or run a program to do the bookkeeping: every readiness and status decision must be yours, step by step, as this skill describes. You may batch several events in one append.
- **Keep your own context small.** A case can run for dozens of tasks, and everything you read stays in your context until the case ends. Change a task's status with a targeted Edit of its entry, not by rewriting `tasks.json`; append events without re-reading `events.jsonl`; write each task file's `input` from the `new_tasks` entry as given, without opening the files it references. Re-read `tasks.json` only when you have lost track of the statuses.
