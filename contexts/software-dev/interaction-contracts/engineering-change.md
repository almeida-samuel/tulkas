# Engineering Change

| | |
|---|---|
| **ID** | `engineering-change` |
| **Requester** | [product-owner](../../../.claude/agents/software-dev-product-owner.md) |
| **Provider** | [tech-lead](../../../.claude/agents/software-dev-tech-lead.md) |

## Purpose

Product asks Engineering to deliver the change an accepted PRD describes, verified by Quality, on the case branch. Product also uses this contract to pass back the operator's decisions on deviations, and to have Engineering carry out a push, pull request, or merge the operator approved.

## Input

- Case ID and task type (`feature`, `bugfix`, or `refactor`).
- Action:
  - `implement`: deliver the change. Requires the paths of the accepted spec and PRD in the case's `artifacts/`, and of the experience design when there is one.
  - `continue`: resume after the operator answered. Requires the open decisions with the operator's answers (`{decision, answer, human_request}`), and any changed product documents.
  - `publish`: carry out an approved action (push the case branch, open a pull request, or merge). Requires the action exactly as approved, and the human request ID holding the `approved` response.
- Every product document passed must have an `accepted` validation event ([pipeline-order](../../../.claude/rules/software-dev/pipeline-order.md)).

## Expected Output

- `outcome` (below).
- `branch`, `base`, and `worktree` of the case.
- `commits`: `{sha, message}` on the case branch.
- `documents`: the published paths under `docs/tulkas/` (spec, experience design, PRD, PRP, audit).
- `verdict`: Quality's latest verdict (`pass`, `pass-with-notes`, or `fail`), its round, and the audit path. Required for `delivered`.
- `notes`: severity 3 and 4 findings left open, for `pass-with-notes`.
- `open_decisions`: `{decision, prd_requirement, options: [{option, consequence}], source}` for each deviation the PRP announced or open decision the audit listed. Required for `decision-needed`.
- `operator_steps`: steps the operator must run outside the agents (migrations, installs, production secrets), with exact commands.
- `blocking_findings`: `{finding, severity, evidence, source_ref}`. Required for `blocked`.
- `published`: for `publish`, what was pushed, opened, or merged, with its reference (remote branch, pull request URL, merge commit).

## Outcomes

- `delivered`: committed on the case branch, Quality's verdict is `pass` or `pass-with-notes`, and no open decision is left.
- `decision-needed`: work paused on decisions only the operator may make (PRP deviations before implementation, audit open decisions after verification).
- `blocked`: Quality's verdict is still `fail` after 3 rounds, or a fix cannot be accepted after 3 attempts. Lists the blocking findings.
- `published`: the approved push, pull request, or merge was done exactly as approved.
- `cannot-determine`: the repository's environment cannot run (tests cannot be executed at all) even after the setup [environment-setup](../../../.claude/rules/software-dev/environment-setup.md) allows was tried, or its guidance is missing something the work cannot proceed without. Says what is missing.

## Rules

- [pipeline-order](../../../.claude/rules/software-dev/pipeline-order.md): Engineering starts only from an accepted PRD.
- [deviations-go-to-operator](../../../.claude/rules/software-dev/deviations-go-to-operator.md): Engineering never settles a deviation; it returns `decision-needed`, and Product asks the operator.
- [case-branch-only](../../../.claude/rules/software-dev/case-branch-only.md) and [push-merge-requires-operator](../../../.claude/rules/software-dev/push-merge-requires-operator.md): commits only on the case branch; nothing leaves the local repository without an approved `publish` request.
- [delivery-requires-verification-pass](../../../.claude/rules/software-dev/delivery-requires-verification-pass.md): `delivered` only with a passing verdict.
