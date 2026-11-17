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
- **Size the item.** One case should fit one PRD of up to about 25 requirements and one round of implementation. A request bigger than that ("refactor every screen") is several items: propose the split now, in the same request as any other question, rather than after the documents grew.

## 2. Check the Repository Is Ready

The technical roles depend on the repository's own guidance (normally its `CLAUDE.md`). If it is missing or says nothing about how to run tests, note it in the case response: the work can start, but the PRP and the audit will be weaker and will say so.

## 3. Plan the Product Pipeline

1. **Spec**: Business Analyst, with the spec guide for the type.
2. **Experience design**: UX Designer, only when the work adds or changes something people see or do (screens, messages, emails, flows). Not for most refactors, and not for bugfixes whose correct behavior is already obvious from the spec. It can run in parallel with the PRD once the spec is accepted, and the PRD's Experience section then draws on it.
3. **PRD**: Business Analyst, from the accepted spec (and the experience design, when there is one).
4. **Engineering request**: once the PRD is accepted, ask Engineering for the change through its contract, passing the PRD (and the experience design). Engineering comes back with `plan-ready` before implementing anything.
5. **Plan approval**: send the operator one **approval** request for the plan ([implementation-requires-approval](../../rules/software-dev/implementation-requires-approval.md)): the PRD in brief (what changes for whom, requirement count), the PRP's approach, files, tasks, and tests in a few lines, every deviation with its options, and the paths of the full documents. Options: approve; change, with notes; stop. Put any other open question in the same request.
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
- approval to open the case's pull request, or to merge, when the work is delivered.

Never answer a product question yourself by guessing what the operator would want. A recorded assumption is acceptable only when the question is minor and the document says it is an assumption.

**Ask early, ask once.** Every operator answer that changes a document sets off a revision downstream, so gather the questions before the documents multiply: ask the business analyst to list, with the spec, every open product question it can foresee for the PRD as well, and send them all in the first request. A question that only surfaces later still goes with everything else open at that moment.

## 6. Apply an Operator Answer

An answer that changes product documents is applied in **one revision pass**, not one stage at a time:

- One task per specialist whose documents change, in parallel: the business analyst revises the spec and the PRD together in one task; the UX designer revises the experience design, if it changes. Each revises in place with a revision section (see *Revising an artifact* in the `case-protocol` skill), and the input names only the answer and what it changes.
- One acceptance turn for all of them, reading the revision sections.
- If Engineering already has the work, one `engineering-change` `continue` carrying the answers and the revised documents together.

## 7. After Delivery

The case stays open for changes **until the operator closes it** (`/close-case`), whether or not its branch is merged. After the deliverable is sent, the operator may ask for more on the same case: fix the open notes, adjust something, or change what was agreed.

- A change to what was agreed goes through the product documents first: one revision pass (§6), then one `engineering-change` `continue` carrying the change and the revised documents. Engineering plans it, and a changed PRP comes back for approval (§3.5) before it is implemented.
- Fixing open notes, or an adjustment inside the agreed PRD, goes straight to Engineering in one `continue`.
- Either way Engineering adds commits to the same branch (updating the case's pull request, if open) and returns `delivered` again; send the new deliverable.
- Once the case is closed, anything further is a **new case**, even while its pull request is open (a closed case is never resumed). If the operator asks for more on a case that is still open but already merged, the work cannot go on the merged branch: answer with an `information-needed` case response proposing it, with a one-line request the operator can open it with.
- Quality's *outside this case* observations are never worked on in this case; list them in the deliverable so the operator can open cases for them.
