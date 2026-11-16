---
paths:
  - "data/software-dev/**"
---

# Delivery Requires a Passing Verdict

| | |
|---|---|
| **ID** | `delivery-requires-verification-pass` |
| **Scope** | Context (applies everywhere) |
| **Binds** | [product-owner](../../agents/software-dev-product-owner.md), [quality-lead](../../agents/software-dev-quality-lead.md) |

Applies only to the roles listed under **Binds**; other roles can ignore it.

## Condition

The Product Owner is about to send a case response with a deliverable.

## Consequence

Only with a Quality verdict of `pass` or `pass with notes` on the final implementation, and every open decision answered by the operator. A `fail` verdict → the case response is `blocking-findings`, never `deliverable`.

## Check

`case_response.type == 'deliverable'` → the latest Quality verdict for the implementation is `pass` or `pass-with-notes`, and every open decision has a recorded human response.
