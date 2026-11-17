---
paths:
  - "**/docs/tulkas/**"
---

# Validate External Outputs

| | |
|---|---|
| **ID** | `validate-external-outputs` |
| **Scope** | Context (applies everywhere) |
| **Binds** | [product-owner](../../agents/software-dev-product-owner.md), [tech-lead](../../agents/software-dev-tech-lead.md), [quality-lead](../../agents/software-dev-quality-lead.md) |

Applies only to the roles listed under **Binds**; other roles can ignore it.

## Condition

The External Provider returns an answer, or a specialist relies on a result from a live outside service.

## Consequence

The requesting orchestrator validates it before using it: every claim that decides the work is graded `documented` or `observed` and cited. `inferred` or `unknown` claims are not treated as facts; `cannot determine` is not an answer. Invalid outputs are **rejected** and requested again (up to 3 retries), then escalated.

## Check

Every External Provider output is followed by an `accepted` or `rejected` validation event from the requester, and each claim the requester relies on has grade `documented` or `observed` and a source.
