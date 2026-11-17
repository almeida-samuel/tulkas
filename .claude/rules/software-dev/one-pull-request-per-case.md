---
paths:
  - "**/docs/tulkas/**"
---

# One Branch and One Pull Request per Case

| | |
|---|---|
| **ID** | `one-pull-request-per-case` |
| **Scope** | Context (applies everywhere) |
| **Binds** | [tech-lead](../../agents/software-dev-tech-lead.md), [product-owner](../../agents/software-dev-product-owner.md) |

Applies only to the roles listed under **Binds**; other roles can ignore it.

## Condition

The Tech Lead commits or publishes, Engineering responds `delivered` or `published`, or the Product Owner sends a deliverable.

## Consequence

Everything a case changes reaches the base branch through **its own branch and a single pull request**. Commit as often as the work needs, each commit on the case branch and citing its source (an accepted output, or the audit), with the case folder's current state included. **No loose commits**: nothing of the case is committed anywhere else, and at delivery nothing of the case's code is left uncommitted. The case's pull request is opened once; later commits are pushed to the same branch and update it. Never a second pull request for the same case, and never a rewrite of the branch's history (squash, rebase, force-push). A delivery that breaks this is **rejected** by the Product Owner and sent back.

## Check

Tech Lead: every commit is on `tulkas/<case-id>`; at delivery, `git status --porcelain` in the workspace lists nothing outside the case folder; at most one pull request exists for the case branch. Product Owner: the `delivered` response names the case branch, its commits, and its pull request (if one is open), and no other branch or pull request for the case.
