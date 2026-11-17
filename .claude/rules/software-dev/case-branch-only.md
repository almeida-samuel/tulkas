---
paths:
  - "**/docs/tulkas/**"
---

# Commits Only on the Case Branch

| | |
|---|---|
| **ID** | `case-branch-only` |
| **Scope** | Context (applies everywhere) |
| **Binds** | [tech-lead](../../agents/software-dev-tech-lead.md) |

Applies only to the roles listed under **Binds**; other roles can ignore it.

## Condition

The Tech Lead is about to commit.

## Consequence

Commits happen **only** on the case's own branch, `tulkas/<case-id>`, in the case's workspace (both in the case's `metadata.json`). **Never** commit to `main`, `master`, `develop`, `development`, or any branch the repository's guidance marks as protected. If the current branch is not the case branch, the commit is **blocked** and the Tech Lead escalates.

## Check

At commit time, the current branch is the `workspace.branch` of `metadata.json` (`tulkas/<case-id>`) and is not `main`, `master`, `develop`, `development`, or a protected branch named in the repository's guidance.
