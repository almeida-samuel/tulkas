---
paths:
  - "**/docs/tulkas/**"
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

No role settles it. It is carried to the operator through the Product Owner, with the options and what each one costs: a PRP deviation inside the plan's **approval** request ([implementation-requires-approval](implementation-requires-approval.md)), an audit open decision as a **judgment** request. Until answered, the affected requirement is not accepted.

## Check

Every announced PRP deviation appears in an answered plan approval request, and every audit open decision has an answered human request (kind `judgment`), before the case response with a deliverable.
