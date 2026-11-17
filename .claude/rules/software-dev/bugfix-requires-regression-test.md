---
paths:
  - "**/docs/tulkas/**"
---

# A Bugfix Requires a Failing-Then-Passing Regression Test

| | |
|---|---|
| **ID** | `bugfix-requires-regression-test` |
| **Scope** | Context (applies everywhere) |
| **Binds** | [tech-lead](../../agents/software-dev-tech-lead.md), [quality-lead](../../agents/software-dev-quality-lead.md) |

Applies only to the roles listed under **Binds**; other roles can ignore it.

## Condition

The case's task type is bugfix.

## Consequence

The implementation must include a regression test reported **failing before** the fix and **passing after** it, unless the accepted PRP states the defect is not testable and why. Otherwise the Tech Lead **rejects** the implementation and Quality's verdict is **fail**.

## Check

Task type `bugfix` → the implementation output names a regression test with a `before` result line showing failure and an `after` result line showing success, or the PRP has a `not testable` statement with a reason.
