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
- `branch` and `worktree` of the case, and the commit to verify.
- Paths of the accepted spec, experience design (if any), PRD, and PRP.
- Path of the accepted implementation output (`tasks/<task-id>/output.json`), and for later rounds the fix outputs and the findings they claim to close.
- The implementation must have an `accepted` validation event ([pipeline-order](../../../.claude/rules/software-dev/pipeline-order.md)).

## Expected Output

- `verdict`: `pass`, `pass-with-notes`, or `fail` (as defined in [verification-verdict](../../../.claude/skills/software-dev-verification-verdict/SKILL.md#verdict)).
- `round`.
- `audit`: the path of the accepted audit, written to `docs/tulkas/audits/<case-id>.md` in the case worktree (uncommitted; Engineering commits it), plus the source task of the accepted audit output.
- `security_review`: the source task of the accepted review, or `skipped` with the reason.
- `runs`: every suite and check run by Quality, `{command, result_line}`.
- `findings`: `{id, severity (1–4), what_breaks, evidence, basis: running|reading, fix_sketch, source}`. Severity 1 and 2 are blocking.
- `open_decisions`: deviations the PRP announced and left to the requester, `{decision, prd_requirement, fallback_cost}`.
- `probes_deleted`: true, with the probe files named.

## Outcomes

- `pass`: no findings, with evidence the checking was real.
- `pass-with-notes`: only severity 3 or 4 findings.
- `fail`: any blocking finding, any PRD requirement neither implemented nor declared as a deviation, a required suite that did not run, a bugfix without a failing-then-passing regression test, or a refactor that changed observable behavior.
- `cannot-determine`: Quality could not run what it needs (the environment does not start, a required command does not exist). Says what is missing.

## Rules

- [results-verified-by-running](../../../.claude/rules/software-dev/results-verified-by-running.md): a claim counts only with its quoted result line.
- [probes-deleted](../../../.claude/rules/software-dev/probes-deleted.md): no probe is left in the worktree.
- [bugfix-requires-regression-test](../../../.claude/rules/software-dev/bugfix-requires-regression-test.md) and [refactor-preserves-behavior](../../../.claude/rules/software-dev/refactor-preserves-behavior.md): applied to the verdict for those task types.
- Quality never fixes the code. Fixes go back to Engineering, which asks for a new round.
