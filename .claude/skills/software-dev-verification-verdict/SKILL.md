---
name: software-dev-verification-verdict
description: "software-dev guide for quality-lead: Plan verification (audit and security review) and turn the findings into a pass or fail verdict."
user-invocable: false
---

# Verification Verdict

| | |
|---|---|
| **ID** | `verification-verdict` |
| **Used by** | [quality-lead](../../agents/software-dev-quality-lead.md) |

Guides shape how a role works; they are not enforced. Enforced constraints are rules.

## Purpose

When Engineering asks for verification, get the implementation audited (and security-reviewed when it matters), then turn the findings into a verdict Engineering and Product can act on.

## Plan

- **Implementation audit**: always. QA Developer, with the PRD, the PRP, and the implementation output. In a later round, scope it to the round (the implementation audit guide's *Later Rounds*): pass the earlier findings, the fix outputs, and the commit the last round audited. A security review runs again in a later round only when the fixes touch what triggered it.
- **Security review**: Security Reviewer, in parallel with the audit, when the change touches any of:
  - who can see or do what (authentication, permissions, ownership of records);
  - input from people or other systems (forms, uploads, imports, parameters);
  - calls to outside services, or data sent to them;
  - secrets, credentials, or configuration;
  - new or upgraded dependencies;
  - personal or sensitive data (storage, display, logs, exports).

  When none apply, record that the review was skipped and why.

## Accept the Reports

Accept an audit or a security review only when:

- every claim says whether it was **verified by running** or by reading, and suites are reported with their **result lines** (a suite without one did not run);
- every PRD requirement has its own row in the audit (no collapsed ranges);
- every finding has evidence (probe output, `file:line`) and a severity on the audit's scale;
- the conformance check says which repository sections were checked and which were skipped, with reasons;
- probes were deleted.

- every finding is inside the case (about the change, a PRD requirement, or a regression it caused); anything else is only listed under *Outside this case*, without a severity.

Otherwise reject with what is missing. The accepted audit stays in the case folder (`artifacts/audits/<case-id>.md`) and is committed with the case.

Findings listed under *Outside this case* never affect the verdict and are not sent back to Engineering for fixing; the response passes them on as `outside_case`, for the operator to open as new cases if wanted.

## Verdict

| Verdict | When |
|---|---|
| **fail** | Any severity 1 or 2 gap (a wrong value; a guarantee that silently stops holding); any PRD requirement neither implemented nor declared as a deviation; a required suite that did not run; a bugfix without a failing-then-passing regression test; a refactor that changed observable behavior. |
| **pass with notes** | Only severity 3 or 4 findings. List them; Engineering decides whether to fix them now. |
| **pass** | No findings, with the evidence that the checking was real. |

Separately from the verdict, list the **open decisions**: questions the approved plan did not settle: deviations from the approved PRP found in the implementation, or decisions the plan left open. Deviations the operator already answered in the plan approval are cited with that request, never raised again. They are not defects, but nobody below the operator may settle them; they go to the operator through Product.

A **fail** goes back to Engineering with the blocking findings and the fix sketches. After 3 rounds of fail on the same findings, escalate.

## Conflicts

When the QA developer and the security reviewer disagree on a finding's severity, or a finding conflicts with the PRP's announced decision, don't pick a side silently: state both positions with their evidence, and escalate as a judgment request when it changes the verdict.
