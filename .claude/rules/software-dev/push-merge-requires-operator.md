---
paths:
  - "**/docs/tulkas/**"
---

# Pull Requests Require the Operator; Merges Are the Operator's

| | |
|---|---|
| **ID** | `push-merge-requires-operator` |
| **Scope** | Context (applies everywhere) |
| **Binds** | [tech-lead](../../agents/software-dev-tech-lead.md), [product-owner](../../agents/software-dev-product-owner.md) |

Applies only to the roles listed under **Binds**; other roles can ignore it.

## Condition

Work would leave the local repository or reach a shared branch.

## Consequence

- **Allowed without asking:** pushing the case branch (`tulkas/<case-id>`) to the remote, as often as the work needs, without force. Once the case's pull request is open, these pushes update it.
- **One approval per case:** opening the case's pull request. The Product Owner asks the operator (approval request) with the branch, the target branch, and the title; in a `small` case this is part of the plan approval ([implementation-requires-approval](implementation-requires-approval.md)).
- **Always an approval naming the action:** deleting a branch; pushing any branch other than the case branch.
- **Never, by any role:** merging the case's pull request or branch (the operator merges it, normally after closing the case with `/close-case`); force-pushing, rebasing, or resetting any branch that was pushed.

Only an approved action is performed, exactly as approved.

## Check

Every push targets the case branch without force. Every pull-request opening is preceded by a human request (kind `approval`) naming that action, with an `approved` response. No role merges anything.
