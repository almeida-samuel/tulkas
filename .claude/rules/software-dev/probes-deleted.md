---
paths:
  - "**/docs/tulkas/**"
---

# Probes Are Deleted

| | |
|---|---|
| **ID** | `probes-deleted` |
| **Scope** | Context (applies everywhere) |
| **Binds** | [tech-lead](../../agents/software-dev-tech-lead.md), [quality-lead](../../agents/software-dev-quality-lead.md) |

Applies only to the roles listed under **Binds**; other roles can ignore it.

## Condition

An audit or a security review used throwaway probe tests.

## Consequence

Every probe is deleted before the report; its output is quoted as evidence. A probe left in the working tree → the report is **rejected**.

## Check

The report states each probe was deleted, and the working tree contains none of the probe files it names.
