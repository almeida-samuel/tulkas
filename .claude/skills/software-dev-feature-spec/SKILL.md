---
name: software-dev-feature-spec
description: "software-dev guide for business-analyst: Write the product spec for a new feature, with zero technical content."
user-invocable: false
---

# Feature Spec

| | |
|---|---|
| **ID** | `feature-spec` |
| **Used by** | [business-analyst](../../agents/software-dev-business-analyst.md) |

Guides shape how a role works; they are not enforced. Enforced constraints are rules.

## Purpose

Turn a feature request into a product spec: a title, an overview, acceptance criteria, and important notes. The acceptance criteria are clear step-by-step bullet points that state what must be true for the feature to be complete. The important notes highlight critical information or considerations.

## Zero Technical Content

This is the first document of the pipeline and a **product specification**: it describes the capability from the point of view of the people who use the product (what they can do, what they see, and what must be true for the feature to be considered done) and NEVER how the code will do it. Apply [product-language](../software-dev-product-language/SKILL.md) in full: its ban list, its litmus tests, and how to handle technical details the requester hands you.

## Naming and Location

- The document is named after the **case ID** (`<YYYYMMDDHHMMSS>-<slug>`), minted once when the case opened. Every later document of the pipeline (PRD, PRP, audit) reuses this exact name, so they line up and each is reachable from the others. Never read the clock to mint another.
- Save it where your task input says (by default, the case's `artifacts/` folder). Use hyphens, never underscores.
