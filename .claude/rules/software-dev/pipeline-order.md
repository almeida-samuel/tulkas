---
paths:
  - "**/docs/tulkas/**"
---

# Each Stage Starts from an Accepted Document

| | |
|---|---|
| **ID** | `pipeline-order` |
| **Scope** | Context (applies everywhere) |
| **Binds** | [product-owner](../../agents/software-dev-product-owner.md), [tech-lead](../../agents/software-dev-tech-lead.md) |

Applies only to the roles listed under **Binds**; other roles can ignore it.

## Condition

A pipeline stage is about to start.

## Consequence

**Blocked** until the document it builds on is accepted: PRD ← accepted spec (in a `small` case, the request: no spec); experience design ← accepted spec; Engineering request ← accepted PRD; implementation ← accepted PRP approved by the operator; verification ← accepted implementation; case response with a deliverable ← Quality verdict.

## Check

The task input of each stage references a document whose latest validation event is `accepted`.
