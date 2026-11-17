# Quality

Verifies Engineering's work independently and gives the verdict Product relies on. Engineering never approves its own work.

- **Status:** active
- **Orchestrator:** [quality-lead](../../../.claude/agents/software-dev-quality-lead.md)
- **Reports to:** the operator (no cross-unit orchestrator; the operator holds that function)

## Members

- [qa-developer](../../../.claude/agents/software-dev-qa-developer.md)
- [security-reviewer](../../../.claude/agents/software-dev-security-reviewer.md)

## Records Owned

Only this unit's orchestrator changes these.

- The verification verdict of each round.
- The accepted audit (`artifacts/audits/<case-id>.md` in the case folder, committed with the case).
- The case's quality view (`state/quality.json`).
