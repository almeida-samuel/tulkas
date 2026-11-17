# Engineering Change

| | |
|---|---|
| **ID** | `engineering-change` |
| **Requester** | [product-owner](../../../.claude/agents/software-dev-product-owner.md) |
| **Provider** | [tech-lead](../../../.claude/agents/software-dev-tech-lead.md) |

## Purpose

Product asks Engineering to deliver the change an accepted PRD describes, verified by Quality, on the case branch and through a single pull request. Product also uses this contract to pass back the operator's answer on the plan and on open decisions, to ask for changes to delivered work (until the operator closes the case), and to have Engineering open the case's pull request, once the operator approved it. Merging is never part of the contract: the operator merges.

## Input

- Case ID, task type (`feature`, `bugfix`, or `refactor`), and size (`small` or `standard`).
- Action:
  - `implement`: plan the change. Requires the paths of the accepted spec and PRD in the case's `artifacts/`, and of the experience design when there is one. Engineering returns `plan-ready` before implementing anything.
  - `continue`: resume after the operator answered. Carries, all in one request, whichever applies:
    - the operator's answer on the plan (`approved`, `change` with notes, or `stop`), with its human request ID; in a `small` case, also whether the pull request is to be opened at delivery;
    - the open decisions with the operator's answers (`{decision, answer, human_request}`);
    - after `delivered` and until the case is closed: the changes the operator asked for (open notes to fix, or a change to what was agreed);
    - any revised product documents, with their revision sections.
  - `publish`: open the case's pull request, once approved. Pushing the case branch needs no request: Engineering pushes after each commit. Requires the human request ID holding the `approved` response. Not needed in a `small` case whose plan approval already approved the pull request: Engineering opens it at delivery.
- Every product document passed must have an `accepted` validation event ([pipeline-order](../../../.claude/rules/software-dev/pipeline-order.md)).

## Expected Output

- `outcome` (below).
- `branch`, `base`, and `workspace` of the case (from `metadata.json`).
- `plan`: for `plan-ready`, the PRP path and revision, a short summary (approach, files, tasks, tests), and `deviations`: `{decision, prd_requirement, options: [{option, consequence}]}`.
- `commits`: `{sha, message}` on the case branch, all pushed, and `verified_commit` (the commit Quality's last round verified). Required for `delivered` and `published`.
- `pull_request`: the case's pull request URL, once opened.
- `verdict`: Quality's latest verdict (`pass`, `pass-with-notes`, or `fail`), its round, and the audit path. Required for `delivered`.
- `notes`: severity 3 and 4 findings left open, for `pass-with-notes`.
- `outside_case`: Quality's one-line observations outside the case, passed on unchanged.
- `open_decisions`: `{decision, prd_requirement, options: [{option, consequence}], source}` for each open decision the audit listed. Required for `decision-needed`.
- `operator_steps`: steps the operator must run outside the agents (migrations, installs, production secrets), with exact commands.
- `blocking_findings`: `{finding, severity, evidence, source_ref}`. Required for `blocked`.
- `published`: for `publish`, the pull request URL.

## Outcomes

- `plan-ready`: the PRP is accepted; nothing is implemented until the operator approves it ([implementation-requires-approval](../../../.claude/rules/software-dev/implementation-requires-approval.md)).
- `delivered`: committed and pushed on the case branch, Quality's verdict is `pass` or `pass-with-notes`, and no open decision is left.
- `decision-needed`: work paused on decisions only the operator may make (audit open decisions after verification, a pre-existing defect that stops the suite).
- `blocked`: Quality's verdict is still `fail` after 3 rounds, or a fix cannot be accepted after 3 attempts. Lists the blocking findings.
- `stopped`: the operator answered `stop` on the plan; nothing was implemented.
- `published`: the approved pull request was opened.
- `cannot-determine`: the repository's environment cannot run (tests cannot be executed at all) even after the setup [environment-setup](../../../.claude/rules/software-dev/environment-setup.md) allows was tried, or its guidance is missing something the work cannot proceed without. Says what is missing.

## Rules

- [pipeline-order](../../../.claude/rules/software-dev/pipeline-order.md): Engineering starts only from an accepted PRD.
- [implementation-requires-approval](../../../.claude/rules/software-dev/implementation-requires-approval.md): nothing is implemented before the operator approves the plan.
- [deviations-go-to-operator](../../../.claude/rules/software-dev/deviations-go-to-operator.md): Engineering never settles a deviation or an open decision; Product asks the operator.
- [case-branch-only](../../../.claude/rules/software-dev/case-branch-only.md), [one-pull-request-per-case](../../../.claude/rules/software-dev/one-pull-request-per-case.md), and [push-merge-requires-operator](../../../.claude/rules/software-dev/push-merge-requires-operator.md): commits only on the case branch, pushed freely; one pull request per case, opened only with the operator's approval, never merged by Engineering.
- [delivery-requires-verification-pass](../../../.claude/rules/software-dev/delivery-requires-verification-pass.md): `delivered` only with a passing verdict.
