---
paths:
  - "data/software-dev/**"
---

# Push and Merge Require the Operator

| | |
|---|---|
| **ID** | `push-merge-requires-operator` |
| **Scope** | Context (applies everywhere) |
| **Binds** | [tech-lead](../../agents/software-dev-tech-lead.md), [product-owner](../../agents/software-dev-product-owner.md) |

Applies only to the roles listed under **Binds**; other roles can ignore it.

## Condition

Work would leave the local repository or reach a shared branch: push, open or update a pull request, merge, rebase or reset a shared branch, delete a branch, or force-push.

## Consequence

**Never** done on a role's own authority. The Product Owner asks the operator (approval request) with what would be pushed or merged and where. Only an approved action is performed, exactly as approved.

## Check

Every push, pull request, or merge event is preceded by a human request (kind `approval`) naming that action, with an `approved` response.
