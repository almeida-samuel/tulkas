---
name: software-dev-prp
description: "software-dev guide for software-architect: Turn a PRD into a PRP, the only technical document of the pipeline, grounded in the repository's codebase and guidance."
user-invocable: false
---

# PRP (Product Requirements Prompt)

| | |
|---|---|
| **ID** | `prp` |
| **Used by** | [software-architect](../../agents/software-dev-software-architect.md) |

Guides shape how a role works; they are not enforced. Enforced constraints are rules.

## Purpose

Turn a PRD into a PRP. The PRD corresponds to one of three task types:

- **Feature**: a new capability.
- **Bugfix**: a corrective change for a defect.
- **Refactor**: a structural or quality change with no behavior change.

Identify which one the PRD describes and adapt the PRP's framing, scope, and validation strategy accordingly.

## Definition of PRP

A PRP is an AI-oriented specification: a structured prompt that combines the intent of a PRD with the implementation context an AI agent needs to produce working output with less guesswork. It is PRD + codebase context + execution guidance: it tells the implementer not only what to build, but enough about how to build it in this environment. A PRP should remove the implementer's need to guess.

## Repository Guidance

This guide assumes no language, framework, or tool. Everything specific to the repository (technology stack, architecture, conventions, environment, commands, CI) comes from the repository's own guidance, normally its `CLAUDE.md`. Read it before writing anything technical. If it is missing or silent on something the PRP needs, say so in the PRP rather than inventing a convention.

## The PRP Is the Only Technical Document in the Pipeline

The spec and the PRD are product documents, written under a hard rule that forbids technical content of any kind: no file paths, no code, no patterns, no data models, no root cause for a defect, no target structure for a refactor. **This is deliberate, not an omission.** Every technical decision in this pipeline is made here, and nowhere else.

So don't expect the PRD to hand you an approach, and never treat a stray technical phrase in it as a decision already made. Derive the technical content yourself:

- Read the actual codebase before writing anything technical; ground every file path, model, and pattern you name in what is there today, not in what the PRD's wording implies.
- For bugfixes, reproduce the defect and diagnose the real root cause from the code. The spec and PRD describe only the observed behavior; the cause is yours to find and to state here.
- For refactors, inspect the current structure and choose the target shape and migration path here. The spec and PRD describe only the problem and the invariants.
- If a product requirement is ambiguous in a way that changes the technical approach, record the ambiguity and the assumption you are proceeding under rather than silently resolving it.

## What a PRP Must Contain

1. **Repository guidance followed.** The architecture, conventions, and constraints from the repository's guidance that this work touches, found with [guideline-conformance](../software-dev-guideline-conformance/SKILL.md). Name the specific rules rather than citing the file as a whole.
2. **A precise, step-by-step or command-based guide** for the implementer, including validation, testing, and error handling. Commands come from the repository's guidance, never from memory.
3. **A detailed user journey with technical details**, edge cases, and expected outputs, so the implementer understands the full scope.
   - Bugfixes: the documented reproduction steps from the PRD, the root cause, and the expected post-fix behavior. The reproduction must demonstrably stop triggering the bug after the fix.
   - Refactors: the before/after code shape and an explicit "behavior must not change" requirement, with the regression-prevention strategy (which existing tests cover the affected code path; which new tests, if any, lock down behavior before the refactor).
4. **Constraints and limitations** that keep the solution feasible, avoiding both over- and under-engineering. For bugfixes, the smallest fix that addresses the root cause unless the PRD explicitly authorizes a broader change. For refactors, internal structure only (no behavior changes, no public API changes) unless the PRD says otherwise.
5. **Data models**: the models used, with their attributes, relationships, and relevant business logic. For bugfixes and refactors that don't introduce models, document the existing models touched and the invariants that must be preserved.
6. **Architectural choices and design patterns** relevant to the work, including any specific libraries or tools to use and the architectural constraints to follow, consistent with the repository's guidance.
7. **Decisions** (`D-1`, `D-2`, ...), each naming the PRD requirement numbers it implements. A decision that deviates from a PRD requirement says so explicitly ("⚠️ Deviation from PRD req. N") and is left open for the requester.
8. **Ordered implementation tasks**, sequenced so dependencies between components are clear.
   - Bugfixes: reproduce → write a failing regression test → fix the root cause → confirm the test passes → run the full suite.
   - Refactors: lock down behavior with tests if coverage is thin → apply the structural change in small steps → run the full suite after each step → verify no public API or behavior change.
9. **Files** created, modified, or deleted. For refactors, be especially explicit, since the change surface tends to be wide and shallow.
10. **Automated tests** to create or modify.
    - Bugfixes: a regression test that fails before the fix and passes after is REQUIRED.
    - Refactors: which existing tests cover the affected code, and characterization tests to add if coverage is insufficient before changing structure.
11. **Constraints to verify and open questions**: anything the implementer must confirm during implementation, worded so an auditor can check whether it was closed.
12. **Checklist**, readable by people and agents, covering code quality, testing, documentation, and deployment, tailored to the task type ("regression test added" for bugfixes; "no behavioral change verified" for refactors).
13. **Commands** to get the work done (terminal commands, snippets, or other instructions), taken from the repository's guidance.

## Naming and Location

1. **The PRP's name is identical to the PRD's**: the case ID (`<YYYYMMDDHHMMSS>-<slug>`), copied verbatim. Do not read the clock, and do not strip the prefix and add a new one.
2. The shared name ties the pipeline together: spec, PRD, PRP, and audit share one name. A PRP stamped with its own creation time silently breaks that link.
3. Use hyphens, never underscores. Save it where your task input says (by default, the case's `artifacts/` folder).
4. Within its case, a PRP is revised in place, with a revision section (see *Revising an artifact* in the `case-protocol` skill): change only the decisions, tasks, and files the revision touches, give new decisions the next free `D-n`, and strike dropped ones rather than renumbering. Only a PRP superseding one from another case or outside the pipeline gets a fresh UTC timestamp of its own.
5. **Keep it proportionate** (aim under about 40 KB). Name files and patterns and point to the code that shows them instead of pasting it; give code only where the implementer could not otherwise get it right. Don't restate the PRD: cite its requirement numbers. A PRP that cannot fit is a sign the work item is too big: say so in your output so it can be split.
