---
paths:
  - "data/software-dev/**"
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

Commits happen **only** on the case's own branch, `<type>/<case-id>` (`feature/`, `bugfix/`, or `refactor/`), in the case's worktree. **Never** commit to `main`, `master`, `develop`, `development`, or any branch the repository's guidance marks as protected. If the current branch is not the case branch, the commit is **blocked** and the Tech Lead escalates.

## Check

At commit time, the current branch matches `^(feature|bugfix|refactor)/<case-id>$` and is not `main`, `master`, `develop`, `development`, or a protected branch named in the repository's guidance.
