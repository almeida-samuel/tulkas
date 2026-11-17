---
paths:
  - "data/software-dev/**"
---

# Agents Prepare the Environment Themselves

| | |
|---|---|
| **ID** | `environment-setup` |
| **Scope** | Context (applies everywhere) |
| **Binds** | [tech-lead](../../agents/software-dev-tech-lead.md), [quality-lead](../../agents/software-dev-quality-lead.md), [software-architect](../../agents/software-dev-software-architect.md), [software-developer](../../agents/software-dev-software-developer.md), [qa-developer](../../agents/software-dev-qa-developer.md), [security-reviewer](../../agents/software-dev-security-reviewer.md) |

Applies only to the roles listed under **Binds**; other roles can ignore it.

## Condition

A role with the shell finds the case's environment not ready (the environment is not running, declared dependencies are missing, a test database does not exist or is out of date), or is about to run a command that prepares it rather than the code.

## Consequence

**Allowed on the role's own initiative, without asking the operator**, when every point holds:

- It is a setup command the repository's guidance documents, or the tool's standard form for what the repository declares (e.g., installing exactly the dependencies in its manifest and lockfile).
- It runs inside the environment the guidance requires (container, virtual environment, toolchain manager), from the case worktree.
- It is **local and additive**: start the documented environment; install declared dependencies; create, load, or migrate a **test** database; build assets or caches the test run needs.

**Never without the operator's approval** (an approval request through the Product Owner): installing anything on the host or changing a global toolchain; dropping, resetting, or migrating any database that is not a test database (development data, shared data); stopping, removing, or rebuilding containers or services other than starting the documented ones; changing credentials or secrets; anything that reaches outside the machine except fetching declared dependencies from their registries.

Missing setup is not a reason to stop: the role runs it first. A role may report the environment as unable to run (`cannot-determine`, blocking finding) **only** after the allowed setup was tried and failed, quoting the failure. A setup command outside the allowed list → the output is **rejected**.

If the repository's guidance says the environment is shared across worktrees (one database, one container), the role says in its output which shared state its setup changed.

## Check

Every setup command appears in the output's `setup_runs` as `{command, where, result_line}`; none targets the host, a non-test database, or a remote system other than a dependency registry without an `approved` human request; every "environment cannot run" claim cites a failed `setup_runs` entry.
