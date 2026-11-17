---
paths:
  - "**/docs/tulkas/**"
---

# Pipeline Documents Share the Case ID

| | |
|---|---|
| **ID** | `case-id-naming` |
| **Scope** | Context (applies everywhere) |
| **Binds** | [product-owner](../../agents/software-dev-product-owner.md), [tech-lead](../../agents/software-dev-tech-lead.md), [quality-lead](../../agents/software-dev-quality-lead.md) |

Applies only to the roles listed under **Binds**; other roles can ignore it.

## Condition

A spec, experience design, PRD, PRP, or audit is returned for acceptance.

## Consequence

Its name must be the case ID (`<YYYYMMDDHHMMSS>-<slug>`), saved under `artifacts/<kind>/` in the case folder. A revision within the case edits the same file. The only exception is a document superseding one from another case: same slug, newer timestamp. Otherwise it is **rejected**.

## Check

File name == `<case-id>.md`, or it has the case's slug and a timestamp later than the document it supersedes.
