---
name: software-dev-prd
description: "software-dev guide for business-analyst: Expand a feature, bugfix, or refactor spec into a PRD, with zero technical content."
user-invocable: false
---

# PRD (Product Requirements Document)

| | |
|---|---|
| **ID** | `prd` |
| **Used by** | [business-analyst](../../agents/software-dev-business-analyst.md) |

Guides shape how a role works; they are not enforced. Enforced constraints are rules.

## Purpose

Expand a spec into a PRD. The input spec is one of three task types: a feature ([feature-spec](../software-dev-feature-spec/SKILL.md)), a bugfix ([bugfix-spec](../software-dev-bugfix-spec/SKILL.md)), or a refactor ([refactor-spec](../software-dev-refactor-spec/SKILL.md)). Identify which one it is from its sections, and adapt the PRD framing accordingly.

## Definition of PRD

A Product Requirements Document is a guide written by product managers that outlines the purpose, functionality, and user experience of a unit of work. For features it describes what is being built, for whom, and why. For bugfixes it describes the defect, its impact, and the behavior expected once it is corrected. For refactors it describes the problem being relieved, the product surfaces in scope, and the invariants that must be preserved, above all that users cannot tell the difference. A well-crafted PRD ensures that all stakeholders have a clear understanding of the work and its requirements.

## Zero Technical Content

The PRD is a **product document, written by a product manager for stakeholders**. It is not an implementation plan, not a design document, and not a diagnosis: it defines *what must be true* when the work is done, never *how the code will do it*. Apply [product-language](../software-dev-product-language/SKILL.md) in full. In particular, never write an implementation approach, a root cause or diagnosis of a defect, or a target structure or migration path for a refactor.

The input spec was written under the same rule. Expanding it into a PRD means adding **product depth** (users, rules, edge cases, measurable outcomes), never filling the technical gap. If you find yourself inferring an implementation because the spec "left it out", stop: it was left out deliberately.

## Sections

These sections apply to all task types; adapt their content to the type. Every section is written in product language.

1. **Title**: derived from the spec's title, human-readable. Prefix with the task type when helpful ("Bugfix: ...", "Refactor: ...").
2. **What**: what is being delivered, in terms of the product.
   - Feature: the new capability and how users interact with it.
   - Bugfix: the defect being corrected, including the wrong behavior the user observes vs. the behavior they should get.
   - Refactor: the problem being relieved and the product surfaces it affects, named by what the user sees.
3. **Why**: the rationale and the value.
   - Feature: the user or business problem solved.
   - Bugfix: the user or business impact of the defect and the cost of leaving it unfixed.
   - Refactor: the consequences being lived with today (repeated changes, drifting screens, slow pages, recurring defects) and what fixing them unblocks.
4. **Experience**: how the work presents itself to the people using the product: the end-to-end journey, screen by screen and step by step, including what they see when things go wrong. This section describes **behavior, never mechanism**.
   - Bugfix: the reproduction path from the spec, and the outcome expected at each step once corrected.
   - Refactor: normally "no change: every affected surface behaves exactly as it does today"; call out anything users would notice.
5. **Scope**: what is included and what is out of scope, in product surfaces and user journeys. For refactors, state explicitly that observable behavior must remain unchanged unless otherwise specified.
6. **Requirements**: numbered functional and non-functional requirements, each stated as an observable outcome.
   - Feature: what the capability must do, the rules it must obey, and the edge cases it must handle.
   - Bugfix: acceptance criteria for the fix, including the reproduction conditions that must no longer produce the wrong result, and the requirement that the defect must not be able to come back unnoticed.
   - Refactor: the invariants that must hold (every affected surface behaves as before, nothing users depend on changes), plus the quality outcome the work is meant to achieve.
7. **Success metrics**: how success is measured. For bugfixes, typically "the documented reproduction no longer produces the wrong result" and "nothing else in the affected area regressed". For refactors, typically "no difference is observable to users" and the reduction of the problem stated in Why.
8. **Constraints**: business, product, timing, or resource constraints: deadlines, rules the business must follow, surfaces that must not be touched, users who must not be disrupted. For bugfixes, call out urgency and anything at risk while the defect is live. For refactors, call out what the work must not disturb. Technical constraints are discovered and recorded in the PRP, not here.

## Naming and Location

1. **The PRD's name is identical to the spec's**: the case ID (`<YYYYMMDDHHMMSS>-<slug>`), copied verbatim. Do not read the clock, and do not strip the prefix and add a new one.
2. The shared name is what ties the pipeline together: spec, PRD, PRP, and audit share one name, so any one of them leads to the others. A PRD stamped with its own creation time silently breaks that link.
3. Use hyphens, never underscores. Save it where your task input says (by default, the case's `artifacts/` folder).
4. Within its case, a PRD is revised in place, with a revision section (see *Revising an artifact* in the `case-protocol` skill): change only the requirements the revision touches, give new requirements the next free number, and strike removed ones rather than renumbering. Only a PRD superseding one from another case or outside the pipeline gets a fresh UTC timestamp of its own.
5. **Keep it proportionate.** A PRD is read by every later step and every round. State each requirement once, in one or two sentences; don't restate the spec or the experience design, refer to them. If the work needs more than about 25 requirements, it is probably several work items: say so in your output so the product owner can propose a split.
