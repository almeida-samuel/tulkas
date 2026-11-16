---
paths:
  - "data/software-dev/**"
---

# Deviations and Open Decisions Go to the Operator

| | |
|---|---|
| **ID** | `deviations-go-to-operator` |
| **Scope** | Context (applies everywhere) |
| **Binds** | [product-owner](../../agents/software-dev-product-owner.md), [tech-lead](../../agents/software-dev-tech-lead.md), [quality-lead](../../agents/software-dev-quality-lead.md) |

Applies only to the roles listed under **Binds**; other roles can ignore it.

## Condition

A PRP announces a deviation from the PRD, or an audit lists an open decision.

## Consequence

No role settles it. It is carried to the operator as a **judgment** request through the Product Owner, with the options and what each one costs. Until answered, the affected requirement is not accepted.

## Check

Every announced deviation and open decision has a human request (kind `judgment`) and a recorded response before the case response with a deliverable.
