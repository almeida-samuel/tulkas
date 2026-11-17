---
name: software-dev-technical-acceptance
description: "software-dev guide for tech-lead: Plan the engineering work and accept or reject the PRP and the implementation before asking Quality to verify."
user-invocable: false
---

# Technical Acceptance

| | |
|---|---|
| **ID** | `technical-acceptance` |
| **Used by** | [tech-lead](../../agents/software-dev-tech-lead.md) |

Guides shape how a role works; they are not enforced. Enforced constraints are rules.

## Purpose

Run the engineering half of the pipeline: get a PRP from the architect, get it implemented by the developer, check both before anything reaches Quality, and send fixes back when Quality finds gaps. The tech lead does not write the PRP or the code; it decides whether they are good enough to move on.

## Plan

0. **Environment**: the dispatcher already created the case branch (`tulkas/<case-id>`) and its workspace (see the case's `metadata.json`); every engineering and quality task of the case works there. Make sure the workspace can run the repository's suites: start the documented environment, install declared dependencies, and prepare the test database, as [environment-setup](../../rules/software-dev/environment-setup.md) allows.
1. **PRP**: Software Architect, from the accepted PRD (and experience design, when there is one). Pass the case's size: a `small` case gets a short PRP (the [prp](../software-dev-prp/SKILL.md) guide's size target).
2. **Accept the PRP** (below), then return `plan-ready` to Product, with every deviation the PRP announces and its options. Nothing is implemented until the operator approves the plan ([implementation-requires-approval](../../rules/software-dev/implementation-requires-approval.md)).
   - The operator's answer comes back in one `engineering-change` `continue`. `approved`: go on. `change`: apply every note in one pass (one PRP revision task carrying the notes and any revised product documents, then one acceptance turn on its revision section) and return `plan-ready` again. `stop`: return without implementing.
3. **Implementation**: Software Developer, from the approved PRP.
4. **Accept the implementation** (below), then **commit** it on the case branch with the case folder's current state ([case-branch-only](../../rules/software-dev/case-branch-only.md)), with a message that states the change in product terms, and push the branch. Commit as often as the work needs; never rewrite the branch's history.
5. **Verification**: ask Quality through its contract, passing the PRD, the PRP, and the implementation task file.
6. **Fixes**: when Quality's verdict has blocking gaps, create a fix task for the developer with the findings, accept it, commit and push it, then ask Quality to verify again (the round diffs against the commit it last verified). Each round counts as a retry. Quality's *outside this case* observations are not fixed here; pass them on to Product.
7. **Return** to Product: commit the accepted audit and push, then return the branch, its commits, the pull request (if open), Quality's verdict, and the open notes ([one-pull-request-per-case](../../rules/software-dev/one-pull-request-per-case.md)). Opening the case's pull request needs the operator's approval ([push-merge-requires-operator](../../rules/software-dev/push-merge-requires-operator.md)): in a `small` case whose plan approval included it, open it now and return its URL with `delivered`. Pushing the case branch needs no approval; merging is never yours (the operator merges).
8. **Changes on the same case**: until the operator closes the case, Product may send a `continue` with changes to the delivered work (open notes to fix, or a change to what was agreed, with the revised product documents). Plan it like the first pass but only for the change: a PRP revision when the plan changes (approved again by the operator), the implementation, a verification round scoped to the change (diffed against the last verified commit), and new commits pushed to the same branch, which updates the case's pull request.

## Accept the PRP

- It has every item the [prp](../software-dev-prp/SKILL.md) guide requires, adapted to the task type (root cause for a bugfix, before/after shape and behavior lock for a refactor).
- It is grounded in the codebase: the files, models, and patterns it names exist (or are clearly new). Spot-check several.
- Every PRD requirement is covered by at least one decision or task; every decision names the requirements it implements.
- Every deviation from the PRD is announced explicitly. An unannounced one is a reason to reject.
- It names the repository rules the work touches ([guideline-conformance](../software-dev-guideline-conformance/SKILL.md)), and its commands come from the repository's guidance.
- For a bugfix, it requires a failing-then-passing regression test (or says why the defect is not testable).
- It is no bigger than the PRD needs: no unrequested features, no tidying outside scope.

## Accept the Implementation

- Every task and checklist item of the PRP is done, or its absence is explained.
- **Result lines are quoted** for every suite and check the developer ran. A claim of "tests pass" with no result line counts as not run.
- **Don't re-run the developer's suites.** Acceptance checks the report, the diff, and the result lines; Quality runs the suites independently in its round. Run a command yourself only when a result line is missing, implausible (counts that don't match the change), or contradicted by the diff, and then the narrowest command that settles it, never the full suites. The same holds for the PRP: spot-check by reading the code, not by running it.
- For a bugfix, the regression test is reported failing before the fix and passing after.
- For a refactor, the full suite result is reported, and no public behavior or interface changed.
- Generated files hold only this task's changes; anything foreign was removed and reported.
- Steps left to the developer (migrations, installs, configuration, production secrets) are listed with exact commands.
- The change conforms to the repository's guidance: run [guideline-conformance](../software-dev-guideline-conformance/SKILL.md) on the diff. Fix obvious breaks before Quality spends time on them.

Reject with the specific items that failed. After 3 failed attempts, escalate.

## When to Escalate to the Operator

- The architect and the PRD disagree in a way that changes the product (a requirement is infeasible, far more costly than expected, or conflicts with the repository's rules).
- The environment the repository requires cannot run (tests cannot be executed at all) even after the setup [environment-setup](../../rules/software-dev/environment-setup.md) allows was tried and failed. A pre-existing defect that stops the suite (a broken test on the base branch) is not an environment problem: bring it to Product as a decision, with the options.
- Quality and Engineering disagree on a finding after one round of fixes.
