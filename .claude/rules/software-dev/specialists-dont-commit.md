---
paths:
  - "data/software-dev/**"
---

# Specialists Don't Change Version Control

| | |
|---|---|
| **ID** | `specialists-dont-commit` |
| **Scope** | Context (applies everywhere) |
| **Binds** | [software-developer](../../agents/software-dev-software-developer.md), [software-architect](../../agents/software-dev-software-architect.md), [qa-developer](../../agents/software-dev-qa-developer.md), [security-reviewer](../../agents/software-dev-security-reviewer.md), [ux-designer](../../agents/software-dev-ux-designer.md), [business-analyst](../../agents/software-dev-business-analyst.md) |

Applies only to the roles listed under **Binds**; other roles can ignore it.

## Condition

A specialist works in the case's worktree.

## Consequence

Specialists edit files only (the Software Developer: code; the QA Developer and Security Reviewer: throwaway probes, deleted before reporting). They **never** commit, push, create or switch branches, stash, reset, or rebase. A change to version control in a specialist's work → the output is **rejected**.

## Check

Between the start and end of a specialist's task, the case branch's commit history and the current branch are unchanged.
