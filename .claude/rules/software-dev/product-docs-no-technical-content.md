---
paths:
  - "data/software-dev/**"
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

The acceptance event for the document records a `product-language` check with result `passed`, and the document contains no fenced code blocks and no inline code.
