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

- Every commit and push of the case branch `tulkas/<case-id>` (created with its workspace by the dispatcher): code and case folder, as often as the work needs.
- The case's engineering view (`state/engineering.json`): branch, workspace, PRP and implementation statuses, plan approval, commits, verification rounds.
- With the operator's recorded approval only: the case's single pull request. Never a merge: the operator merges.
