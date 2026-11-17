# Product

Entry unit for every case. It turns the operator's request into product documents, asks Engineering for the change, and answers the operator.

- **Status:** active
- **Orchestrator:** [product-owner](../../../.claude/agents/software-dev-product-owner.md)
- **Reports to:** the operator (no cross-unit orchestrator; the operator holds that function)

## Members

- [business-analyst](../../../.claude/agents/software-dev-business-analyst.md)
- [ux-designer](../../../.claude/agents/software-dev-ux-designer.md)

## Records Owned

Only this unit's orchestrator changes these. The context keeps no shared records under `data/software-dev/records/`: everything a case produces lives in its case folder and its branch.

- The case's work item (`state/product.json`): task type, document statuses, operator answers.
- Accepted product documents (spec, experience design, PRD) in the case's `artifacts/`, until Engineering publishes them to `docs/tulkas/`.
