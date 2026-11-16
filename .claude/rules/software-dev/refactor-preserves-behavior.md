---
paths:
  - "data/software-dev/**"
---

# A Refactor Preserves Behavior

| | |
|---|---|
| **ID** | `refactor-preserves-behavior` |
| **Scope** | Context (applies everywhere) |
| **Binds** | [tech-lead](../../agents/software-dev-tech-lead.md), [quality-lead](../../agents/software-dev-quality-lead.md) |

Applies only to the roles listed under **Binds**; other roles can ignore it.

## Condition

The case's task type is refactor.

## Consequence

No observable behavior and no public interface may change, unless the PRD explicitly authorizes it. Any unauthorized change → the implementation is **rejected** and Quality's verdict is **fail**.

## Check

Task type `refactor` → the implementation output reports the full-suite result line, and the audit states `no observable behavior change` with evidence, or cites the PRD requirement authorizing each change.
