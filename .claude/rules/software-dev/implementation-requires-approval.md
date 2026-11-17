---
paths:
  - "**/docs/tulkas/**"
---

# Implementation Requires the Operator's Approval

| | |
|---|---|
| **ID** | `implementation-requires-approval` |
| **Scope** | Context (applies everywhere) |
| **Binds** | [product-owner](../../agents/software-dev-product-owner.md), [tech-lead](../../agents/software-dev-tech-lead.md) |

Applies only to the roles listed under **Binds**; other roles can ignore it.

## Condition

The Tech Lead is about to create an implementation task for the Software Developer, for the first implementation or for a change after an accepted PRP was revised. Fix tasks for Quality's findings that leave the PRP unchanged are not covered.

## Consequence

**Blocked** until the operator has approved the plan: the Tech Lead returns `plan-ready` to Product with the accepted PRP, and the Product Owner sends one **approval** request covering what will be built (the PRD in brief, the PRP's approach, files, tasks, and tests, and every deviation with its options). In a `small` case the same request also lists the PRD's assumptions and asks whether to open the case's pull request at delivery. Answers: approve (in a `small` case, with or without opening the pull request at delivery); change, with notes (the PRP or the product documents are revised and the plan is presented again); or stop. Only an `approved` answer for the current PRP revision unblocks implementation.

## Check

The input of every implementation task cites a human request (kind `approval`) with an `approved` response whose request names the PRP revision being implemented.
