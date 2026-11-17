---
name: close-case
description: Close a case on the framework at the operator's word - delivered or abandoned - whether or not its branch is merged or its pull request is still open, record the closure in the case files, and clean up its workspace.
argument-hint: [case-id] [--abandon] [--keep-workspace] [note]
disable-model-invocation: true
---

# Close a Case

You are the **dispatcher** closing a case. The user is the **operator**, and running this skill is the operator's decision to close it: you don't ask again whether to close, only about what closing would lose. Closing is **mechanical**: no role is invoked, nothing is judged, and no business state (`state/`, records, artifacts) changes. Before starting, read:

- the `case-protocol` skill (`.claude/skills/case-protocol/SKILL.md`): case folder, workspace, events, closed cases;
- `contexts/<context>/CLAUDE.md` of the case's context: its **Closing a Case** instructions, if it has them (what to record, whether to commit the case folder).

Arguments: `$ARGUMENTS`: optionally the case ID, `--abandon`, `--keep-workspace`, and a short note (the rest of the arguments).

## Steps

1. **Find the case.** Open cases are case folders whose `metadata.json` has no `closed_at`; look in `.tulkas/worktrees/*/docs/tulkas/cases/*/` and in `docs/tulkas/cases/*/` of the current checkout. With a case ID (or an unambiguous part of one), take that case. Without one: the case of the current branch if it is a case branch, else the only open case, else list the open cases (ID, workspace, last event) and ask which. If the case is already closed, say when and how, and stop.
2. **Read its status.** From `metadata.json` and `tasks.json` only (not task files or artifacts):
   - **Reason**: `abandoned` with `--abandon`, else `delivered`.
   - **Open tasks**: tasks in `pending`, `ready`, `running`, `waiting`, `awaiting-human`, or `escalated`. They stay as they are; closing ends them.
   - **Branch** (only when the case has a case branch): whether it is merged into its base (`git branch --merged <base>` lists it), and anything the context's instructions say to look up (e.g., the pull request).
3. **Confirm only what closing would lose.** If there are open tasks (including unanswered human requests), or the reason is `delivered` and no case response was ever sent (no `case-response` event), list them and ask the operator to confirm. Otherwise proceed.
   **Nothing left uncommitted** (only when the context's instructions commit at closing): run `git -C <workspace> status --porcelain`. Anything outside the case folder (modified, staged, or untracked) is listed for the operator, who chooses one per file or for all: **commit** it in the closing commit, **discard** it (`git restore` / delete the untracked file), or **cancel** the close. Change nothing before the operator answers.
4. **Record the closure.** In `metadata.json` add `closed_at` (the real UTC time, from `date -u +%Y-%m-%dT%H:%M:%SZ`, also used as the event's `ts`) and `closure`: `{"reason": "delivered | abandoned", "note": "<note or null>", "open_tasks": [<IDs>], "branch_merged": true | false | null}`, plus the fields the context's instructions add. Append event `case-closed` (actor `dispatcher`) with the same `closure` as `data`.
5. **Context closing steps.** Do exactly what the context's **Closing a Case** instructions say (e.g., commit the case folder on its branch and push it). When they commit, the workspace **must be clean afterwards**: `git status --porcelain` empty. If it is not, or the commit fails, remove the closure you recorded (the `closed_at` and `closure` fields and the `case-closed` line) so the case stays open, show the operator the error or the leftover files, and stop. If only the push fails, the case stays closed: report the error and that the closing commit is local.
6. **Clean up the workspace** (skip with `--keep-workspace`, or when the mode is `none`):
   - `worktree`: `git worktree remove <worktree>` (never `--force`; the worktree is clean after step 5). In a context that does not commit at closing, if the worktree is not clean, list what would be discarded and remove it with `--force` only if the operator agrees; otherwise keep it.
   - `branch`: if the checkout is clean, offer to switch back to the base branch (`git switch <base>`).
   The case branch is **never deleted**, and nothing is pushed, merged, or closed on the remote unless the context's instructions say so.
7. **Report** in a few lines: case ID, reason, open tasks ended, branch and its merge state (and pull request, if the context records one), commit made at closing (if any), and whether the workspace was removed. Remind the operator that further work on the same subject is a **new case** (`/run-case <request>`).

## Rules for You

- Never invoke a role agent, edit a task file, `state/`, records, or artifacts, or change a task's status.
- Never delete a branch, force-push, rebase, merge, or close a pull request.
- Write `metadata.json` and `events.jsonl` with your file tools (Edit, or appending a literal JSON line); no scripts.
