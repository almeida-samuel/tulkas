# Engineering

Turns an accepted PRD into a technical plan and working code, on the case's own branch.

- **Status:** active
- **Orchestrator:** [tech-lead](../../../.claude/agents/software-dev-tech-lead.md)
- **Reports to:** the operator (no cross-unit orchestrator; the operator holds that function)

## Members

- [software-architect](../../../.claude/agents/software-dev-software-architect.md)
- [software-developer](../../../.claude/agents/software-dev-software-developer.md)

## Records Owned

Only this unit's orchestrator changes these.

- The case branch `<type>/<case-id>` and its worktree (default `.tulkas/worktrees/<case-id>`): creation and every commit.
- The published pipeline documents under `docs/tulkas/<kind>/<case-id>.md` on the case branch (it commits them, including Quality's audit).
- The case's engineering view (`state/engineering.json`): branch, worktree, PRP and implementation statuses, commits, verification rounds.
- With the operator's recorded approval only: pushes, pull requests, and merges of the case branch.
