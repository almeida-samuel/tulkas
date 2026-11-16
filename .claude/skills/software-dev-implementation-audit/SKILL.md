---
name: software-dev-implementation-audit
description: "software-dev guide for qa-developer: Audit an implementation against its spec, PRD, and PRP, verifying every claim by running the code, and record the audit."
user-invocable: false
---

# Implementation Audit

| | |
|---|---|
| **ID** | `implementation-audit` |
| **Used by** | [qa-developer](../../agents/software-dev-qa-developer.md) |

Guides shape how a role works; they are not enforced. Enforced constraints are rules.

## Purpose

Audit the work implemented for a case against the documents that planned it, report the delta, and record it as an audit document (§9). This is the closing counterpart to PRD → PRP → implementation: those produce and execute a plan; the audit asks whether the plan was actually carried out, and what the plan itself failed to anticipate.

**The audit reports and records; it does not fix.** Present the findings and write the audit document. Fixes are proposed in your output and applied, once approved, by the developer. The one exception is a throwaway probe used to confirm a finding (§4), which is always deleted before reporting.

## Repository Guidance

This guide assumes no language, framework, or tool. Everything specific to the repository comes from its own guidance, normally its `CLAUDE.md`: how and where commands run, the test, system-test, lint, and security-scan commands, what CI runs, the conventions the code must follow, and any mechanical checks worth running on every audit. Read it before you start. **Take every command from the repository, never from memory.** If a documented command does not exist, say so in the report rather than substituting your own.

## 1. Assemble the Documents and the Change Surface

Each case produces up to three planning documents sharing one name (the case ID): the **spec** (acceptance criteria and the decisions behind them), the **PRD** (numbered requirements, scope boundaries, success metrics, constraints), and the **PRP** (the only technical document: files, decisions `D-n`, the ordered task list, the test plan, constraints, open questions, checklist). Finding one finds the others. A document whose timestamp does not match its siblings is either a supersession (the newest under that slug is the live one) or a naming mistake; say which in the report.

Read all of them **in full** before looking at any code. They are not redundant: the spec carries intent, the PRD carries the numbered requirements you will trace, and the PRP carries the plan you will check line by line. A requirement that only exists in the spec still counts.

Then inventory what was actually built with version control (working-tree status and diff). Read the complete diff of the touched files, and the full contents of every new one. Do not sample.

### When the shape is not the happy path

- **The work is already committed**: find the commits on the branch and diff against the merge base with the main branch.
- **The tree holds unrelated changes**: scope the audit to the files named in the PRP, and state which changed files you excluded and why. An unexplained exclusion is indistinguishable from an oversight.
- **There is no PRP**: the PRD's numbered requirements become the checklist. Say so: the audit is weaker without a recorded technical plan.
- **Several PRP revisions share one slug**: audit against the newest, then check whether the implementation actually matches an older one. An implementation faithful to a superseded plan is itself a finding.

## 2. Build the Planned-Versus-Implemented Matrix

Walk the PRP's checklist and file list item by item, and record for each: implemented, partially implemented, missing, or deviated. Report this as a table: it is the backbone of the audit and the part the reader scans first.

Then trace the PRD's numbered requirements **individually**. One row per requirement: the requirement, the `file:line` or test name that satisfies it, and whether you verified it by running or by reading. Do not collapse ranges: "reqs 1-7 ✅" is exactly where a missing requirement hides.

A requirement is not satisfied by prose in the PRP promising it will be. It is satisfied by code that does it, or a test that proves it.

**Announced deviation, or defect?** Read the PRP's decisions (`D-n`) against the PRD requirements they claim to implement. A deviation the PRP declared ("⚠️ Deviation from PRD req. N") is an **open decision** belonging to the requester, and is reported as one. A deviation with no such declaration is a **defect**. Without this distinction, deliberate choices get filed as bugs and silent drift gets excused as intent.

## 3. Verify by Running, Never by Reading Alone

Reading tells you what the code intends. Only running tells you what it does. Run, the way the repository's guidance says:

1. The focused suites named in the PRP's commands.
2. The full suite, because the risk is not only "did the new tests pass" but "did the new behavior break something the plan never mentioned".
3. The system or end-to-end suite, when the work touched the user interface or added such a test.
4. The linters and the security scanner.

**Check what CI actually runs, too**: a suite excluded from CI has never run there, so a test added to it may never have been executed at all.

**Establish the baseline before attributing anything.** A failure that predates the work is not a finding about the work. If the suite is red, check whether it is red at the merge base too before reporting a single failure against this implementation.

**A command that prints no failures has not necessarily passed.** A command can exit 0 having produced no test output at all (wrong environment, wrong working directory, toolchain not found), and piping through `tail` or similar hides it behind a clean exit code. Always confirm you saw a real result line (runs, assertions, failures) before believing a suite passed. If you did not see one, the suite did not run.

**Confirm the new tests are in the run at all.** A test file in a location the default run does not sweep never runs and therefore never fails. Check discovery explicitly: running by a distinctive new test name must report one run, not zero.

**Mutation-check the guards.** A regression test is load-bearing only if it fails without the fix. For each guard the work added, break it deliberately, run just that test, confirm it goes red, and restore. A guard whose test still passes when the guard is gone is not covered, however many assertions it carries.

Report counts, not adjectives: "2470 runs, 7004 assertions, 0 failures", not "tests pass".

## 4. Probe the Invariants the Plan Asserts

Every PRP states invariants: "a record in this state has zero children", "this status is terminal", "this value is counted nowhere". Those are claims, and a passing test suite only proves the claims someone thought to test.

For each invariant that would be expensive to get wrong, write a **throwaway probe test** that attacks it from a direction the existing tests do not, run it, and read what it prints. Prefer printing state over assertions: you are collecting evidence, not defining behavior. Keep probes in a clearly disposable location (a `probes` folder next to the tests) and run only that file. **Delete the probe before reporting**, and delete it even if the audit is abandoned half-way, since a stray probe is swept up by the next full run. If a probe confirms a real hole, its content becomes the basis for the regression test proposed with the fix.

An empirically confirmed finding ("verified: one update lifted the record back out of its terminal status and the access check then returned true") is worth ten plausible ones.

## 5. Read the New Tests Adversarially

A test that passes while bypassing the mechanism it claims to cover is worse than no test: it manufactures confidence. Read every test the work added and ask **does this exercise the real path, or a shortcut to the same end state?** A test that arrives at the expected state by calling a setter, flipping a status, or stubbing past the guard has asserted the requirement's letter and skipped its mechanism, and it will keep passing after the mechanism breaks.

Watch for the resolution step in particular. When a requirement says a problem is cleared *by removing the offending record*, a test that clears it by updating a field has tested nothing about removal, and may be exercising the very hole the requirement exists to close.

Then check **coverage parity across parallel files.** Where the work touched N sibling implementations, the N test files should carry the same cases. Diff their test names. An asymmetry is either a deliberate choice or an omission, and it is almost always an omission.

## 6. Where the Gaps Actually Are

Two categories produce nearly every real finding. Search both deliberately.

**Gaps the PRP itself flagged.** The PRP's constraints and open questions routinely contain items worded as ⚠️ *verify this during implementation* or *confirm before shipping*. These are the highest-yield findings in the audit, because the implementer was told about them and the code shows whether they were closed. Check every one against the code, and never accept the PRP's own framing as fact: it may have understated the problem.

**Gaps the PRP never anticipated.** The plan reasons about the paths it introduces; defects live in the paths it never considered. For any new state, field, or guarantee, search for what *else* in the codebase writes it, and check each hit: callbacks and hooks, bulk updates that filter on some states but not the new one, endpoints that set the state directly, background work, a retried job replaying a transition a second time, soft-delete and restore paths, display maps, labels, and helpers that count by state. A new terminal status is only terminal if no other write path can lift it.

Run the mechanical sweeps the repository's guidance lists for every audit; their failures are usually silent.

**Generated files that belong to other work.** Files generated from shared state (schema dumps, lockfiles, snapshots) can carry changes from other work on the same machine. Check every hunk against the changes this work made. A hunk with no source in this work is a level-2 gap (§8): merging it would commit something no change on the main branch creates. Name the foreign hunk and, where you can, where it comes from. The fix is offered, not applied: remove those hunks, never roll shared state back.

## 7. Check Conformance with the Repository's Guidance

The repository's guidance is prose, enforced by no tool, so a green run in §3 says nothing about it. Check the change against it by hand, following [guideline-conformance](../software-dev-guideline-conformance/SKILL.md), and carry its results into the report: findings placed by consequence (§8), and the sections you skipped with the reason.

## 8. Classify and Report

Group findings so the reader knows what needs their attention versus what is merely noted:

1. **Verification runs**: the commands and their result lines, up front.
2. **Planned and implemented**: the matrices from §2.
3. **Gaps**, ordered by consequence (scale below). For each: what breaks, the evidence (probe output, `file:line`), and whether the plan had flagged it.
4. **Open decisions**: deviations the PRP announced and left to the requester. Not defects; unanswered questions that stay open until the requester answers. Say what the fallback costs.
5. **Minor deviations**: naming, wording, uneven coverage between parallel files. Note them; don't inflate them.

Order the gaps by consequence:

1. **A value the product produces is wrong**, irreversibly: money miscalculated, double-counted, or lost to rounding; data persisted that the source does not contain; data reaching the wrong owner or another party. The repository's guidance may name its own irreversible failures; they belong here.
2. **A stated guarantee silently stops holding**: a state reachable or escapable by a path the plan did not consider; a retry replaying a non-idempotent side effect; a protective flag cleared as a side effect of an unrelated transition; an internal identifier leaking where it can be enumerated. *Silent* is the operative word: no error, no log, nothing anyone would notice.
3. **The person is misled**: the state is right, but the wording or the affordance points at the wrong remedy, including text that exists in only some of the required languages.
4. **Cosmetic**: naming, register, coverage asymmetry.

Cite the guidance section by name for any finding that is a conformance break, and place it by consequence rather than by category.

Be exact about the basis of each claim. "Verified by running" and "verified by reading the diff" are different confidence levels and must not be presented as the same thing.

Close by proposing the fixes for the gaps, with a one-line sketch of each.

## 9. Record the Audit

An audit that lives only in a conversation is gone when it ends, and the next person to touch this code cannot tell a deliberate deviation from an unnoticed one. So every audit is also written as a document:

- Its name is **the case ID** shared by the spec, PRD, and PRP it audits, copied verbatim. Where the source documents disagree on the prefix (one was re-minted to supersede an earlier one), take the prefix of the newest document you audited against, and name all source documents in the header so the mismatch is on the record.
- If an audit with that name already exists, you are re-auditing: mint a fresh UTC timestamp so both sort oldest to newest under the same slug.
- Save it where your task input says (by default, the case's `artifacts/` folder).
- Open it with a short header naming the source documents, so the audit says what it was measured against.

**Write the document with the same content you report, not a summary.** The value of the record is the evidence: the result lines, the probe output, the mutation-check counts, the `file:line` citations.

**It records the implementation as found.** If fixes are later applied, don't rewrite it: append a dated section recording which findings were closed and how, and strike the resolved entries in place rather than deleting them. An audit whose gaps quietly vanish is worth nothing to the person reading it in six months.

Probe files are still deleted (§4); their **output** belongs in the audit, quoted as evidence.

## Notes

1. **Run commands exactly as the repository's guidance says** (containers, environments, services). Reading files, searching, and version control can run directly. A suite that fails to connect to a service may be an environment problem rather than a finding about the work: establish which before reporting it.
2. **Confirm the command actually ran.** If you did not see a real result line, the suite did not run; say so rather than reporting silence as success. Never report a suite as passing on the strength of an exit code: quote the result line.
3. **Run long suites in the background** and keep auditing while they do. Don't skip them to save time, and don't report a conclusion that depends on a run you have not seen finish.
4. **If the audit finds nothing, say so plainly and show the evidence that the checking was real**: which invariants were probed, which tests were mutation-checked, which suites ran, what the counts were. A clean audit with no visible work behind it is indistinguishable from no audit.
