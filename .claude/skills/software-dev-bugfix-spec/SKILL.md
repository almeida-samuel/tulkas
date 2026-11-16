---
name: software-dev-bugfix-spec
description: "software-dev guide for business-analyst: Write the product-level defect report for a bug, with zero technical content."
user-invocable: false
---

# Bugfix Spec

| | |
|---|---|
| **ID** | `bugfix-spec` |
| **Used by** | [business-analyst](../../agents/software-dev-business-analyst.md) |

Guides shape how a role works; they are not enforced. Enforced constraints are rules.

## Purpose

Turn a bug report into a product-level defect report with: a title, an overview, steps to reproduce, expected behavior, impact, acceptance criteria, and important notes.

- **Overview**: the defect as the user experiences it.
- **Steps to reproduce**: clear step-by-step bullet points that let anyone reliably trigger the bug, followed by what actually happens.
- **Expected behavior**: what should have happened instead.
- **Impact**: who is affected, how often, and what it costs them.
- **Acceptance criteria**: what must be observably true for the bug to be considered fixed.
- **Important notes**: critical information, such as related behavior that must keep working.

## Zero Technical Content

This is the first document of the pipeline and a **product-level defect report**: it describes what the user does, what the product wrongly does in response, and what it should do instead, and NEVER where the defect lives in the code or how it will be corrected. Apply [product-language](../software-dev-product-language/SKILL.md) in full. On top of it, for a defect report:

**It contains no root cause and no fix.** Both are technical findings and belong to the PRP. A guessed root cause written here is especially damaging: it is stated before anyone has read the code, and everything downstream inherits it as fact. So also never write:

- A root cause, a diagnosis, a theory about why the bug happens, or which part of the system is "at fault".
- A proposed fix, a correction, a patch, or an approach to solving it ("the fix is to …", "we should change …", "this happens because the code …").

Write instead:

- The exact user journey that triggers the defect, from signing in onward, in the words the user would use, enough that a stranger can reproduce it unaided.
- What the user observes going wrong, precisely: wrong number, wrong screen, wrong message, missing record, nothing happens, a wait that never ends.
- The conditions under which it appears and does not appear, described as user-facing circumstances (which screen, which kind of record, how many files, which browser, which role).
- Whether it reproduces every time or intermittently, and since when if known.
- Acceptance criteria stated as observable outcomes, including the documented reproduction no longer producing the wrong result.

Add a fourth litmus test. **Diagnosis test:** does the sentence assert *why* it happens or *where* it comes from, rather than *what* happens? If yes, delete it: the PRP diagnoses. Observation and diagnosis are easy to confuse. "It only happens when the user switches tabs before the uploads finish" is an observation and belongs here. "It happens because the upload finishing triggers a page navigation" is a diagnosis and does not.

Reporters often paste an error, a log excerpt, or their own theory of the cause. Convert it into what was observed on screen and under which circumstances, and drop the rest: a theory carried in here would be treated as an established fact and can send the fix in the wrong direction entirely.

## Naming and Location

- The document is named after the **case ID** (`<YYYYMMDDHHMMSS>-<slug>`), minted once when the case opened. Every later document of the pipeline (PRD, PRP, audit) reuses this exact name. Never read the clock to mint another.
- Save it where your task input says (by default, the case's `artifacts/` folder). Use hyphens, never underscores.
