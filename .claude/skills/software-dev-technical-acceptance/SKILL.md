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

0. **Case branch and worktree**: create the branch `<type>/<case-id>` (`feature/`, `bugfix/`, or `refactor/`) from the branch the repository's guidance names as the base (by default the default branch), checked out in its own worktree (by default `.tulkas/worktrees/<case-id>`, git-ignored). Every engineering and quality task of the case works there. Never work in the operator's own checkout.
1. **PRP**: Software Architect, from the accepted PRD (and experience design, when there is one).
2. **Accept the PRP** (below). Deviations it announces from the PRD go back to Product before implementation, because they change what was agreed.
3. **Implementation**: Software Developer, from the accepted PRP.
4. **Accept the implementation** (below), then **commit** it on the case branch ([case-branch-only](../../rules/software-dev/case-branch-only.md)), with a message that states the change in product terms. In the same commit, publish the accepted pipeline documents to `docs/tulkas/<kind>/<case-id>.md`: the spec (`features`, `bugfixes`, or `refactors`), the experience design (`experience`), the PRD (`prds`), and the PRP (`prps`).
5. **Verification**: ask Quality through its contract, passing the PRD, the PRP, and the implementation output.
6. **Fixes**: when Quality's verdict has blocking gaps, create a fix task for the developer with the findings, then ask Quality to verify again. Each round counts as a retry.
7. **Return** to Product: the implementation output, the commits on the case branch, and Quality's verdict. Pushing, opening a pull request, and merging are never yours to do on your own: they need the operator's approval ([push-merge-requires-operator](../../rules/software-dev/push-merge-requires-operator.md)).

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
- For a bugfix, the regression test is reported failing before the fix and passing after.
- For a refactor, the full suite result is reported, and no public behavior or interface changed.
- Generated files hold only this task's changes; anything foreign was removed and reported.
- Steps left to the developer (migrations, installs, configuration, production secrets) are listed with exact commands.
- The change conforms to the repository's guidance: run [guideline-conformance](../software-dev-guideline-conformance/SKILL.md) on the diff. Fix obvious breaks before Quality spends time on them.

Reject with the specific items that failed. After 3 failed attempts, escalate.

## When to Escalate to the Operator

- The architect and the PRD disagree in a way that changes the product (a requirement is infeasible, far more costly than expected, or conflicts with the repository's rules).
- The environment the repository requires cannot run (tests cannot be executed at all).
- Quality and Engineering disagree on a finding after one round of fixes.
