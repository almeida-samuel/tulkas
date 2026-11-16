---
name: software-dev-work-intake
description: "software-dev guide for product-owner: Turn the operator's case request into a classified work item and plan the product pipeline."
user-invocable: false
---

# Work Intake

| | |
|---|---|
| **ID** | `work-intake` |
| **Used by** | [product-owner](../../agents/software-dev-product-owner.md) |

Guides shape how a role works; they are not enforced. Enforced constraints are rules.

## Purpose

Turn the operator's case request into one classified work item, plan who does what, and decide what the operator must answer before work starts.

## 1. Classify the Request

Every case is exactly one of three task types. Decide which from what the request asks for, not from the words it uses:

| Type | The request... | Spec guide |
|---|---|---|
| **Feature** | asks for something the product cannot do today | [feature-spec](../software-dev-feature-spec/SKILL.md) |
| **Bugfix** | says the product does something wrong, or fails to do what it already promises | [bugfix-spec](../software-dev-bugfix-spec/SKILL.md) |
| **Refactor** | asks to change the inside of the system with no change users can see | [refactor-spec](../software-dev-refactor-spec/SKILL.md) |

- "It should also do X" about existing behavior that never did X is a **feature**, not a bug.
- A refactor that changes anything users can see is not a refactor: it is a feature (or contains one). Say so.
- A request that mixes several work items (two features, a fix plus a refactor) is **one case per item**. Ask the operator to split it, proposing the split; don't run several items through one pipeline.
- If the type is genuinely ambiguous, ask the operator (judgment request) with the options and what each one leads to.

## 2. Check the Repository Is Ready

The technical roles depend on the repository's own guidance (normally its `CLAUDE.md`). If it is missing or says nothing about how to run tests, note it in the case response: the work can start, but the PRP and the audit will be weaker and will say so.

## 3. Plan the Product Pipeline

1. **Spec**: Business Analyst, with the spec guide for the type.
2. **Experience design**: UX Designer, only when the work adds or changes something people see or do (screens, messages, emails, flows). Not for most refactors, and not for bugfixes whose correct behavior is already obvious from the spec. It can run in parallel with the PRD once the spec is accepted, and the PRD's Experience section then draws on it.
3. **PRD**: Business Analyst, from the accepted spec (and the experience design, when there is one).
4. **Engineering request**: once the PRD is accepted, ask Engineering for the change through its contract, passing the PRD (and the experience design).
5. **Publishing**: accepted product documents stay in the case's `artifacts/` until Engineering creates the case branch; Engineering then publishes them to `docs/tulkas/` and commits them with the change.
6. **Case response**: when Engineering returns, with Quality's verdict, send the deliverable, the blocking findings, or the information still needed.

## 4. Accept Product Documents

Accept a spec, experience design, or PRD only when:

- it has every section its guide requires, for its task type;
- it passes [product-language](../software-dev-product-language/SKILL.md): read it line by line against the ban list. Reject a document with any violation and name the sentences;
- every acceptance criterion or requirement is observable (someone could check it by using the product);
- its open product questions are either answered or carried to the operator.

## 5. What Goes to the Operator

Collect into **one** request, rather than asking several times:

- open product questions the documents could not settle (rules, priorities, edge cases only a person can decide);
- the task type, when ambiguous;
- a split, when the request holds several work items;
- scope trade-offs Engineering raises later (e.g., a requirement that costs far more than its value);
- approval to push the case branch, open a pull request, or merge, when the work is delivered.

Never answer a product question yourself by guessing what the operator would want. A recorded assumption is acceptable only when the question is minor and the document says it is an assumption.
