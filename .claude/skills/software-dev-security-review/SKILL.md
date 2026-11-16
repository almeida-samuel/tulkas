---
name: software-dev-security-review
description: "software-dev guide for security-reviewer: Review an implementation for security gaps, verifying by running, without fixing."
user-invocable: false
---

# Security Review

| | |
|---|---|
| **ID** | `security-review` |
| **Used by** | [security-reviewer](../../agents/software-dev-security-reviewer.md) |

Guides shape how a role works; they are not enforced. Enforced constraints are rules.

## Purpose

Review the change for security gaps: what an attacker, a curious user, or an honest mistake could make it do that it must not. **Report; don't fix.** Fixes are proposed and applied, once approved, by the developer.

## Repository Guidance

This guide assumes no language, framework, or tool. The repository's guidance (normally its `CLAUDE.md`) names the security scanner, the dependency audit, how commands run, and any security rules of its own (how records are addressed, where outside calls may happen, how secrets are stored). Read it first; take every command from it.

## Scope

Start from the change: the complete diff and every new file. Then follow each entry point it adds or changes (a screen, an endpoint, a job, an import) to what it reads and writes. Defects live in the paths the change makes reachable, not only in the lines it adds.

## Checklist

For each item, decide whether the change triggers it, check the triggered ones, and say which you skipped and why.

1. **Who can do what.** Every new action checks that the person is signed in and allowed to do it, and that the record belongs to them (or their organization). Try it as another user and as no user. A check in the screen but not in the action does not count.
2. **Identifiers.** Records reachable from outside are addressed the way the repository says (e.g., non-sequential identifiers). Internal or sequential identifiers leaking into links, forms, responses, or files let anyone enumerate other people's data.
3. **Input.** Everything from people or other systems is validated, and never reaches a query, a command, a file path, a template, or a redirect without the repository's safe mechanism. Check uploads for type, size, and where they are stored and served from.
4. **Output.** What the product shows or returns contains only what the person may see: no other users' data, no internal fields, no stack traces, no secrets.
5. **Secrets and configuration.** No secret in the code, the tests, the fixtures, recorded test traffic, or the logs. New configuration has safe defaults.
6. **Outside services.** Calls happen where the repository says; data sent out is only what is needed; responses are treated as untrusted input; failures and timeouts don't leave records half-done.
7. **Sensitive data.** Personal or financial data is not logged, not exported beyond need, and removed when the product says it is removed.
8. **Dependencies.** New or upgraded packages are needed, maintained, and pass the repository's dependency audit.
9. **Abuse.** Actions that cost money, send messages, or do heavy work cannot be triggered in bulk by one person without limits, and repeated requests don't repeat side effects.

## Verify by Running

- Run the repository's security scanner and dependency audit; quote their result lines. A scanner that printed nothing may not have run.
- Confirm suspected holes with a throwaway probe test (another user's record, a missing permission, a crafted input), print what happened, and **delete the probe** before reporting. A confirmed finding is worth ten plausible ones.
- Say for every claim whether it was verified by running or by reading.

## Report

For each finding: what an attacker or mistake can do, the evidence (probe output, `file:line`), and the severity on the [implementation-audit](../software-dev-implementation-audit/SKILL.md#8-classify-and-report) scale (data reaching the wrong owner is severity 1; a protection that silently stops holding is 2). Judge by who introduced it: a hole that predates the change is a note, not a finding against this work. Close with a one-line fix sketch per finding. If you found nothing, show the evidence that the checking was real.
