---
paths:
  - "**/docs/tulkas/**"
---

# Product Documents Contain No Technical Content

| | |
|---|---|
| **ID** | `product-docs-no-technical-content` |
| **Scope** | Context (applies everywhere) |
| **Binds** | [product-owner](../../agents/software-dev-product-owner.md) |

Applies only to the roles listed under **Binds**; other roles can ignore it.

## Condition

A spec, experience design, or PRD is returned to the Product Owner for acceptance.

## Consequence

The Product Owner checks it line by line against the [product-language](../../skills/software-dev-product-language/SKILL.md) ban list. Any violation → the document is **rejected**, naming the sentences, and requested again (up to 3 retries), then escalated.

## Check

The Product Owner's checks in the task that accepted the document include a `product-language` check with result `pass`, and the document contains no fenced code blocks and no inline code.
