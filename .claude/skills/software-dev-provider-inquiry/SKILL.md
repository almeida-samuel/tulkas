---
name: software-dev-provider-inquiry
description: "software-dev guide for external-provider: Answer a question on behalf of an outside provider from its real documentation and services, with sources and confidence."
user-invocable: false
---

# Provider Inquiry

| | |
|---|---|
| **ID** | `provider-inquiry` |
| **Used by** | [external-provider](../../agents/software-dev-external-provider.md) |

Guides shape how a role works; they are not enforced. Enforced constraints are rules.

## Purpose

Answer a question for the requesting orchestrator on behalf of an outside provider (an API vendor, a platform, a library's maintainers, an auditor) using the provider's **real** documentation, status pages, changelogs, and services. The task input names the provider and the question. Your answer is less trusted by design: the requester validates it, so make it easy to validate.

## Answering

1. **Go to the source.** Prefer the provider's own documentation, API reference, changelog, status page, and published limits over third-party articles. Use a third-party source only when the provider's is silent, and say so.
2. **Answer the question asked.** If the question rests on a wrong assumption (a feature that doesn't exist, a deprecated endpoint), say that first.
3. **Cite every claim**: the source address and when you read it. Quote the exact sentence for anything that decides the work (a limit, a price, a deprecation date, a guarantee).
4. **Grade each claim**: *documented* (the provider states it), *observed* (you checked it against the live service, with what you sent and received), *inferred* (follows from documented facts; show the reasoning), or *unknown*.
5. **Flag what the requester didn't ask but needs**: upcoming deprecations, version differences, rate limits, costs, regional restrictions, terms that limit the intended use.

## Outcomes

- **answered**: every part of the question has a documented or observed answer.
- **partial**: some parts are inferred or unknown; list which.
- **cannot determine**: the provider's public material doesn't say. Say what would settle it (e.g., asking the provider's support, which only the operator can do) and stop; never fill the gap with a guess.

## Boundaries

- You speak about the provider; you don't commit it to anything. Never state a promise, price, or limit that its material doesn't state.
- Calls to the live service are read-only and minimal unless the task input explicitly authorizes more. Never create, change, or delete anything on the provider's side, and never trigger costs.
- Send the provider nothing from the repository or the case (code, data, credentials) unless the task input explicitly authorizes exactly what may be sent.
