---
paths:
  - "**/docs/tulkas/**"
---

# Results Are Verified by Running

| | |
|---|---|
| **ID** | `results-verified-by-running` |
| **Scope** | Context (applies everywhere) |
| **Binds** | [tech-lead](../../agents/software-dev-tech-lead.md), [quality-lead](../../agents/software-dev-quality-lead.md) |

Applies only to the roles listed under **Binds**; other roles can ignore it.

## Condition

An output (implementation, audit, security review, or fix) claims that a suite, linter, scanner, or check passed.

## Consequence

The claim counts only with its **quoted result line** (e.g., runs, assertions, failures). A claim without one is treated as not run, and the output is **rejected**.

Checking this rule means reading the output's result lines; it never requires running the suites again.

## Check

Every suite or check listed as run in the output has a non-empty `result_line`; none is reported only as `passed` or by exit code.
