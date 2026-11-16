---
name: software-dev-refactor-spec
description: "software-dev guide for business-analyst: Write the product spec for a refactor (problem, scope, invariants), with zero technical content."
user-invocable: false
---

# Refactor Spec

| | |
|---|---|
| **ID** | `refactor-spec` |
| **Used by** | [business-analyst](../../agents/software-dev-business-analyst.md) |

Guides shape how a role works; they are not enforced. Enforced constraints are rules.

## Purpose

Turn a refactor request into a product spec with: a title, an overview, motivation, scope, acceptance criteria, and important notes.

- **Motivation**: the problem the refactor is meant to relieve, stated as its consequences (the same change has to be made in several places, screens that should behave alike drift apart, a page is slow, a certain kind of bug keeps coming back).
- **Scope**: which product surfaces are in and out of scope, to keep the refactor focused.
- **Acceptance criteria**: what must be true for the refactor to be complete, starting with the invariant that the product behaves exactly as it did before.
- **Important notes**: critical information, risks, or considerations.

## Zero Technical Content

A refactor is by nature a change to the inside of the system, which is exactly why this document must stay on the outside of it. It states **the problem to be relieved and the outcome to be preserved**, and NEVER what the code should become. Apply [product-language](../software-dev-product-language/SKILL.md) in full. On top of it, for a refactor:

Naming a target design here is the most common way this document goes wrong: it commits the work to a shape chosen before anyone read the code. So also never write the target design: the pattern, structure, abstraction, or layering the code should end up with, or the steps of the migration towards it ("extract …", "move … into …", "replace … with …", "introduce a shared …", "consolidate … into a single …").

Write instead:

- Which product surfaces are affected, named by what the user sees.
- The problem, stated as its consequences: the same change has to be made in several places and one is always forgotten; two screens that should agree do not; a page takes too long; a certain kind of defect keeps recurring; a small change takes days.
- Why it is worth doing now, and what it unblocks.
- What must remain exactly as it is: above all, that users must not be able to tell the difference once the work is done.
- Acceptance criteria as observable outcomes: every affected surface still behaves as it does today, the recurring problem is gone, nothing users depend on changed.

The **solution test** for a refactor: does the sentence describe the shape the code should take, or the order in which it should be changed? If yes, delete it: the PRP designs. The distinction to hold on to: **the symptom belongs here, the cure belongs in the PRP.** "Changing how a currency value is displayed currently has to be repeated on every screen that shows one, and they have drifted apart" is a symptom and belongs here. "The formatting should be extracted into a shared helper" is a cure and does not.

Refactors are almost always requested in technical language, often as a ready-made plan. Work backwards from the proposal to the problem that motivated it, and write only that. Everything the requester proposed about the code is input for the PRP, where it will be weighed against what the codebase actually looks like.

## Naming and Location

- The document is named after the **case ID** (`<YYYYMMDDHHMMSS>-<slug>`), minted once when the case opened. Every later document of the pipeline (PRD, PRP, audit) reuses this exact name. Never read the clock to mint another.
- Save it where your task input says (by default, the case's `artifacts/` folder). Use hyphens, never underscores.
