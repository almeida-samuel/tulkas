---
paths:
  - "**/docs/tulkas/**"
---

# Pull Requests and Merges Require the Operator

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
- **One approval per case:** opening the case's pull request. The Product Owner asks the operator (approval request) with the branch, the target branch, and the title.
- **Always an approval naming the action:** merging; deleting a branch; pushing any branch other than the case branch.
- **Never:** force-pushing, rebasing, or resetting any branch that was pushed.

Only an approved action is performed, exactly as approved.

## Check

Every push targets the case branch without force. Every pull-request opening and every merge is preceded by a human request (kind `approval`) naming that action, with an `approved` response.
