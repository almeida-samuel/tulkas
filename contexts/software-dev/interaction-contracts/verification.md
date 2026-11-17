# Verification

| | |
|---|---|
| **ID** | `verification` |
| **Requester** | [tech-lead](../../../.claude/agents/software-dev-tech-lead.md) |
| **Provider** | [quality-lead](../../../.claude/agents/software-dev-quality-lead.md) |

## Purpose

Engineering asks Quality to verify an accepted, committed implementation independently: an implementation audit always, and a security review when the change calls for one. Each request is one verification round.

## Input

- Case ID, task type, and round (1 for the first verification, then 2, 3, ... after each fix).
- `branch` and `workspace` of the case, and the commit to verify (the case branch's latest commit).
- Paths of the accepted spec, experience design (if any), PRD, and PRP.
- Path of the accepted implementation task file (`tasks/<task-id>.json`), and for later rounds the fix outputs, the findings they claim to close, and the commit the last round verified. A later round verifies the diff since that commit, not the whole change again.
- The implementation must have an `accepted` validation event ([pipeline-order](../../../.claude/rules/software-dev/pipeline-order.md)).

## Expected Output

- `verdict`: `pass`, `pass-with-notes`, or `fail` (as defined in [verification-verdict](../../../.claude/skills/software-dev-verification-verdict/SKILL.md#verdict)).
- `round`.
- `audit`: the path of the accepted audit (`artifacts/audits/<case-id>.md` in the case folder, committed with the case), plus the source task of the accepted audit output.
- `security_review`: the source task of the accepted review, or `skipped` with the reason.
- `runs`: every suite and check run by Quality, `{command, result_line}`.
- `findings`: `{id, severity (1–4), what_breaks, evidence, basis: running|reading, fix_sketch, source}`. Severity 1 and 2 are blocking.
- `open_decisions`: questions the approved plan did not settle: deviations from the approved PRP found in the implementation, or decisions the plan left open. Deviations the operator already answered in the plan approval are cited with that request, never raised again; `{decision, prd_requirement, fallback_cost}`.
- `probes_deleted`: true, with the probe files named.
- `outside_case`: one-line observations outside the case (pre-existing defects no PRD requirement depends on, untouched code). Never findings, never part of the verdict.

## Outcomes

- `pass`: no findings, with evidence the checking was real.
- `pass-with-notes`: only severity 3 or 4 findings.
- `fail`: any blocking finding, any PRD requirement neither implemented nor declared as a deviation, a required suite that did not run, a bugfix without a failing-then-passing regression test, or a refactor that changed observable behavior.
- `cannot-determine`: Quality could not run what it needs (the environment does not start, a required command does not exist). Says what is missing.

## Rules

- [results-verified-by-running](../../../.claude/rules/software-dev/results-verified-by-running.md): a claim counts only with its quoted result line.
- [probes-deleted](../../../.claude/rules/software-dev/probes-deleted.md): no probe is left in the workspace.
- [bugfix-requires-regression-test](../../../.claude/rules/software-dev/bugfix-requires-regression-test.md) and [refactor-preserves-behavior](../../../.claude/rules/software-dev/refactor-preserves-behavior.md): applied to the verdict for those task types.
- Quality never fixes the code. Fixes go back to Engineering, which asks for a new round.
