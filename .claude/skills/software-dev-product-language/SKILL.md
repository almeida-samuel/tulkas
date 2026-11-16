---
name: software-dev-product-language
description: "software-dev guide for business-analyst, ux-designer, product-owner: Keep product documents (spec, PRD, experience design) free of technical content."
user-invocable: false
---

# Product Language

| | |
|---|---|
| **ID** | `product-language` |
| **Used by** | [business-analyst](../../agents/software-dev-business-analyst.md) (writes), [ux-designer](../../agents/software-dev-ux-designer.md) (writes), [product-owner](../../agents/software-dev-product-owner.md) (checks) |

Guides shape how a role works; they are not enforced. Enforced constraints are rules.

## Purpose

Product documents (the spec, the PRD, and the experience design) contain **ZERO technical content**. This guide holds that rule once; each document's guide adds only what is specific to it ([feature-spec](../software-dev-feature-spec/SKILL.md), [bugfix-spec](../software-dev-bugfix-spec/SKILL.md), [refactor-spec](../software-dev-refactor-spec/SKILL.md), [prd](../software-dev-prd/SKILL.md)). Writers apply it before saving; the Product Owner applies it when accepting a document.

## Why

Each stage of the pipeline has one job:

| Document | Contains |
| --- | --- |
| Spec (feature, bugfix, or refactor) | Product intent and acceptance criteria. **No technical content** |
| PRD | Product requirements, expanded. **Still no technical content** |
| PRP | **The only place technical decisions are allowed**: the approach, the root cause of a defect, the target structure of a refactor, the data model, the files touched, the tests |

A product document defines *what must be true* when the work is done, never *how the code will do it*. Anything technical written in one leaks downstream, freezes a solution before anyone has looked at the codebase, and pre-empts the PRP's job: the PRP is left rubber-stamping a decision instead of making it.

## Never Write

- File paths, directory names, or file names.
- Class, module, method, function, variable, constant, database table, or column names.
- Code, queries, markup, templates, configuration, shell commands, stack traces, log lines, diffs, or pseudo-code, in fenced blocks, in inline backticks, or paraphrased in prose.
- Language, framework, library, package, service, or tool names, and version numbers.
- Architecture, layering, or design patterns: background jobs, caching, queues, streams, redirects, requests, responses, service objects, mixins, base classes, migrations, indexes, feature flags, and so on.
- Data models: schemas, attributes, relationships, validations, state machines, enum values, defaults.
- API surface: endpoints, routes, HTTP verbs, status codes, parameter names, payload shapes.
- Tests: test names, test types, frameworks, or where tests should live.
- Implementation tactics or performance techniques (pagination strategy, eager loading, debouncing, polling, batching, retries, timeouts).
- A solution of any kind: sentences of the shape "we will add / extract / introduce / refactor / store / query / render …", "the fix is to …", "move … into …", "replace … with …".

## Write This Instead

- Who the work is for and the problem it solves for them.
- What people do and see, step by step, in the words they would use, and what the product must produce as a result.
- The rules the product must obey (permissions, validation *outcomes*, edge cases, what happens when things go wrong), always as observable behavior.
- Product surfaces named by what the user sees (the payments list, the monthly report, the file upload area), not by the code behind them.
- What is explicitly out of scope.
- Open product questions that a person, not an engineer, must answer.

When a technical term is the only way you can think to express a requirement, you are describing the solution, not the requirement. State the observable effect instead: not "cache the totals", but "the totals appear without a noticeable wait when the user reopens the page"; not "add an index so the list loads fast", but "the list opens without a noticeable wait at the largest volume a user handles today".

## Litmus Tests: Apply to Every Sentence Before Keeping It

1. **Rewrite test.** Would this sentence still be true and useful if the whole application were rewritten from scratch in a different language and framework? If no, it is a technical detail: delete it.
2. **Reader test.** Could the person who requested the work (or a business stakeholder) read the sentence and confirm or reject it? If they would have to ask an engineer what it means, delete it.
3. **Solution test.** Does the sentence narrow *how* the work will be done rather than *what* must be true when it is done? If yes, delete it: the PRP decides how.

## When the Requester Hands You Technical Details

Requesters often describe work in terms of the code: a suggested implementation, an error or log excerpt, a theory of the cause, a ready-made refactoring plan. **Do not copy any of it into the document.** Translate every such statement into the user-visible outcome or the observed behavior it is aiming at, and drop whatever does not translate. The engineer writing the PRP will inspect the codebase and decide; a hint carried in here would be treated as a requirement, or as an established fact.

The only exception is a genuine *product* constraint the requester imposed: a deadline, urgency, a rule the business must follow, a workflow or surface that must not change, data that must not be touched. State it in plain product language under Important Notes (or Constraints), never as an instruction about the code.

An input document was written under this same rule. Expanding it means adding **product depth** (users, rules, edge cases, measurable outcomes), never filling the technical gap: it was left out deliberately.

## Before Saving (and Before Accepting)

Re-read the document line by line against the ban list and delete every violation. A document that is shorter because the technical content was removed is correct; one that keeps it "for context" is not. A reviewer who finds a violation rejects the document and names the sentences.
