---
name: software-dev-experience-design
description: "software-dev guide for ux-designer: Design the screens, states, and flows of a work item in product language, feeding the PRD's Experience section."
user-invocable: false
---

# Experience Design

| | |
|---|---|
| **ID** | `experience-design` |
| **Used by** | [ux-designer](../../agents/software-dev-ux-designer.md) |

Guides shape how a role works; they are not enforced. Enforced constraints are rules.

## Purpose

From an accepted spec, design how the work presents itself to the people using the product: the journeys, the screens, every state each screen can be in, and what the product says. The result feeds the PRD's **Experience** section and gives the architect and developer an unambiguous target. It is a product document: apply [product-language](../software-dev-product-language/SKILL.md) in full.

## Start from What Exists

Before designing anything new, look at how the product already does similar things: the screens, patterns, wording, and conventions people already know. The repository's guidance (its `CLAUDE.md`) may describe UI conventions (layout, supported screen sizes, components, languages); follow them, describing the outcome in product terms. Consistency with the existing product beats a better idea used once. When you deviate on purpose, say why.

## Sections

1. **People and goals**: who uses this, and what they are trying to get done.
2. **Journeys**: each path step by step, in the user's words, from where they start to where they end, including the unhappy paths (they cancel, they lack permission, something fails, they come back later).
3. **Screens and states**: for each screen or surface touched, what it shows and what people can do, in every state:
   - empty (nothing yet), loading or waiting, success, partial (some items failed), error, no permission;
   - long or unusual content (very long names, many items, zero items);
   - what happens after each action (where they land, what they see confirmed).
4. **Wording**: the intent of every message people see (titles, labels, confirmations, errors, empty states). Errors say what happened and what the person can do next. If the product supports several languages, every message is needed in each one.
5. **Layout sketches** (optional): text wireframes showing arrangement and hierarchy (what is prominent, what is grouped, what is secondary). They show the product, never the implementation.
6. **Accessibility**: everything reachable without a mouse, nothing conveyed by color alone, readable contrast, meaningful labels for assistive technology.
7. **Destructive and irreversible actions**: how the person is warned and asked to confirm, and whether they can undo.
8. **Open questions**: design choices only a person can decide, with the options and the trade-off of each.

## Bugfixes and Refactors

- **Bugfix**: usually only needed when the correct behavior is not obvious (which message to show, where the person should land). Describe just the corrected states.
- **Refactor**: usually not needed. If it is requested, the design is "every affected surface stays exactly as it is"; list the surfaces and their current states so the audit can check nothing changed.

## Naming and Location

Named after the **case ID**, like the other pipeline documents. Save it where your task input says (by default, the case's `artifacts/` folder).
