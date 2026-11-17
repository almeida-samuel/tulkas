---
name: software-dev-prp-implementation
description: "software-dev guide for software-developer: Implement a feature, bugfix, or refactor by following its PRP and the repository's guidance."
user-invocable: false
---

# PRP Implementation

| | |
|---|---|
| **ID** | `prp-implementation` |
| **Used by** | [software-developer](../../agents/software-dev-software-developer.md) |

Guides shape how a role works; they are not enforced. Enforced constraints are rules.

## Purpose

Implement a feature, bugfix, or refactor from its PRP. The PRP combines the intent of a PRD with the implementation context needed to produce working output with less guesswork: the user journey, technical details, edge cases, expected outputs, constraints, data models, architectural choices, design patterns, ordered tasks, files to create, modify, or delete, automated tests, checklist, and commands. Follow it.

## Repository Guidance

This guide assumes no language, framework, or tool. Everything specific to the repository comes from its own guidance, normally its `CLAUDE.md`: technology stack, architecture, conventions, how and where commands run (containers, virtual environments, toolchains), the test and lint commands, and how configuration, dependencies, and generated files are handled. Read it before changing anything.

## Approach by Task Type

- **Feature**: implement the new capability following the ordered tasks; add tests for the new behavior.
- **Bugfix**: first reproduce the bug if possible, then write a regression test that fails because of the bug, then apply the smallest change that addresses the root cause described in the PRP, and finally confirm the regression test passes and no other tests regress. Do not expand scope beyond the documented fix.
- **Refactor**: preserve existing behavior at all costs. Verify the affected code path has test coverage before changing structure (add characterization tests if it does not). Apply the structural change as described in the PRP without altering behavior or public APIs, and confirm the full test suite still passes.

## Notes

1. **Run commands exactly as the repository's guidance says.** If it says tools run inside a container or a specific environment, run them there, and never work around it (installing dependencies on the host, prefixing ad-hoc environment variables, starting or killing processes it doesn't tell you to manage). Resolve names (containers, services, environments) from what is running; don't assume them. If the environment is not ready (not running, dependencies missing, no test database), prepare it yourself with the setup the guidance documents, inside that environment, as [environment-setup](../../rules/software-dev/environment-setup.md) allows, and report each setup command with its result line. Only what that rule reserves for the operator (the host, non-test databases, anything leaving the machine) is reported instead of run.
2. **Follow the repository's guidance, not just the PRP.** The PRP decides the approach; the repository's guidance still governs how the code is written. Its rules are the ones most often broken under time pressure, so check the change against them before finishing.
3. **Apply what the change needs locally, and hand over the rest.** Install the dependencies you add and apply your migrations to the test database yourself (as [environment-setup](../../rules/software-dev/environment-setup.md) allows). Everything that must still happen elsewhere (the development database, other environments, production secrets) is part of the output: write the exact commands. A step nobody knows to run is an unfinished task.
4. **Configuration and dependencies reach every place that needs them.** A new environment variable goes into the tracked template the guidance names (with a safe placeholder), in the same change. A new system dependency goes into every environment definition the guidance lists (local, CI, production). Say which files you touched and what still has to be done outside the repository (e.g., production secrets).
5. **User-facing text follows the repository's rules** (translation layer, required locales, formatting). A change that ships text in only some of the required languages is not done.
6. **Generated files change only because of this task.** Files generated from shared state (schema dumps, lockfiles, snapshots) can pick up changes from other work on the same machine. Before finishing, check every hunk of a generated file traces back to this task's own changes; remove the ones that don't, and report what you removed and where it seems to come from. Never "fix" drift by rolling back shared state.
7. **For bugfixes, a failing-then-passing regression test is required** unless the PRP explicitly states the defect is not testable. Write it first, watch it fail for the documented root cause, then fix.
8. **For refactors, no behavior change and no public API change** unless the PRP explicitly authorizes it. If the affected path has thin coverage, add characterization tests before touching structure.
9. **Comments never cite pipeline documents** (spec, PRD, PRP, audit, or their requirement numbers). Those documents get superseded and the citation rots.
10. **Report what you actually ran.** Quote the result line of each suite rather than summarizing it as passing, and say plainly which commands you could not run and why. An unrun test is not a passing test.

## Fixing Audit Findings

When the task is to fix findings from an implementation audit:

- Make the smallest change that closes the hole; don't tidy surrounding code.
- Add a regression test per finding, derived from the probe that proved it, and mutation-check it (break the guard, see the test fail, restore) so you know it is load-bearing.
- Re-run the full suite and every check the repository's guidance lists (linters, security scanners, system tests), and report the counts again.
- Record in your output what was found and how it was closed, so the PRP's open questions can be updated (struck, not deleted).
