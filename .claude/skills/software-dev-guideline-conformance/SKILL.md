---
name: software-dev-guideline-conformance
description: "software-dev guide for qa-developer, tech-lead, software-architect: Check a plan or a change against the repository's own guidance (its CLAUDE.md), which no tool enforces."
user-invocable: false
---

# Guideline Conformance

| | |
|---|---|
| **ID** | `guideline-conformance` |
| **Used by** | [software-architect](../../agents/software-dev-software-architect.md) (plans against it), [tech-lead](../../agents/software-dev-tech-lead.md) (checks before asking Quality), [qa-developer](../../agents/software-dev-qa-developer.md) (audits) |

Guides shape how a role works; they are not enforced. Enforced constraints are rules.

## Purpose

Every repository that uses this context declares its own rules in its guidance, normally its `CLAUDE.md`: architecture, conventions, data, user-facing text, environment, and so on. Those rules are prose, enforced by no tool, and therefore invisible to a green test run: linters check formatting, not conventions, so passing CI is no evidence about them. This guide is how to check a plan or a change against them by hand.

- The **architect** uses it to find the rules a PRP must name and follow.
- The **tech lead** uses it to check the developer's change before asking Quality to verify it.
- The **QA developer** uses it in the implementation audit.

## Build the Checklist from the Guidance, Every Time

The guidance is a living document; any summary of it drifts out of date. So never work from memory or from an earlier checklist:

1. Read the repository's guidance in full and list its current sections.
2. For each section, decide whether the change surface triggers it, from what the work touches. For example: a section about data models applies when the work adds a model or a migration; one about external integrations when it calls an outside service; one about user-facing text when it touches a screen, message, or email; one about the environment when it adds a configuration variable or a system dependency.
3. Check the triggered sections, rule by rule.
4. **State which sections you skipped and why.** "Not applicable: no new model, no external call, no screen" tells the reader the dimension was considered rather than forgotten.

Where the guidance offers mechanical checks (searches, commands), run them rather than eyeballing.

## Check Both Directions of Every Parity Rule

Rules that require parity are the ones most often half-done: every user-facing string in every required language, every dependency in every environment definition, every configuration variable in its tracked template. Check both directions: a key added in one language and forgotten in another passes every test that only renders the default one. Diff the sets rather than spot-checking them.

## Judge Fairly

- **Judge a violation by who introduced it.** A rule broken *by this work* is a finding. A rule already broken in a file the work merely touched is a note at most: say which it is, rather than billing pre-existing debt to this work.
- **An established local deviation is not automatically a violation.** Where the surrounding code consistently does something else, report it as a deviation, name the pattern the neighbors use, and let the requester decide whether the guideline or the local convention wins. A lone conforming file in a directory of non-conforming ones is usually the worse outcome.
- **Cite the section by name** for every finding, so the reader can check it.
- **Place findings by consequence, not by category.** A rule broken so that a value the product produces is wrong is severe; a naming slip is cosmetic. Use the severity scale of the [implementation-audit](../software-dev-implementation-audit/SKILL.md#8-classify-and-report).

## When the Guidance Is Missing or Silent

If the repository has no guidance, or it says nothing about something the work needs, report that as a finding against the repository (not against the work), and say what assumption you made. Don't invent a convention and then hold the work to it.
