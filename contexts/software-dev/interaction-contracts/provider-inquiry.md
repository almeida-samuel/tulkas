# Provider Inquiry

| | |
|---|---|
| **ID** | `provider-inquiry` |
| **Requester** | [product-owner](../../../.claude/agents/software-dev-product-owner.md), [tech-lead](../../../.claude/agents/software-dev-tech-lead.md), or [quality-lead](../../../.claude/agents/software-dev-quality-lead.md) |
| **Provider** | [external-provider](../../../.claude/agents/software-dev-external-provider.md) (external party) |

## Purpose

An orchestrator needs an outside provider's answer or judgment (an API vendor, a platform, a library's maintainers, an auditor) that a plain service call can't give: limits, guarantees, deprecations, terms, behavior that isn't obvious from one response. Specialists who need such an answer say so in their output; their orchestrator sends the request. A plain lookup a specialist can do with its own tools is not a contract request.

## Input

- Case ID.
- `provider`: who the External Provider stands for in this request.
- `question`: what must be answered, and what decision it feeds.
- `may_send`: exactly what may be sent to the provider (default: nothing from the repository or the case).
- `live_calls`: whether read-only calls to the provider's live service are allowed (default: documentation only).

## Expected Output

- `outcome` (below).
- `wrong_assumptions`: anything the question assumed that the provider's material contradicts.
- `claims`: `{claim, grade: documented|observed|inferred|unknown, source, read_at, quote}`. A `quote` is required for every claim that decides the work.
- `flags`: what the requester didn't ask but needs (deprecations, limits, costs, terms).
- `what_would_settle`: for `partial` or `cannot-determine`, what would answer the rest (often asking the provider's support, which only the operator can do).

## Outcomes

- `answered`: every part of the question has a documented or observed answer.
- `partial`: some parts are inferred or unknown; those are listed.
- `cannot-determine`: the provider's public material doesn't say.

## Rules

- [validate-external-outputs](../../../.claude/rules/software-dev/validate-external-outputs.md): the requester validates the answer; only `documented` or `observed` claims with a source count as facts.
- The provider is never committed to anything, nothing is created, changed, or deleted on its side, and no cost is triggered.
