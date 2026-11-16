# Software Development Context

Guidance for the **software-dev** context: a software development team running on the framework described in the root `CLAUDE.md`. Use the framework vocabulary (units, roles, contracts, rules, guides, expected outputs, cases); this file maps it to the team's own terms.

- [Current State](#current-state)
- [Overview](#overview)
- [Vocabulary Mapping](#vocabulary-mapping)
- [Live Integrations](#live-integrations)
- [Organizational Map](#organizational-map)
- [Roadmap and Future](#roadmap-and-future)

## Current State

Design phase. The role lineup below is agreed; the organizational map files (units, contracts, agents, guides, rules) are not drafted yet.

## Overview

A software development team meant for **real use**, not a simulation: cases produce real requirements, designs, code, and test results. The operator is a software engineer who opens cases and approves anything beyond agent authority. The context keeps the smallest set of roles that still separates product, engineering, and quality work.

## Vocabulary Mapping

| Framework | Software development |
|---|---|
| Unit | Team |
| Operator | Software engineer (orchestrates cases, top authority, and the approver) |
| Case | Feature request, bug report, or other piece of development work |
| Entry unit | Product |
| Cross-unit orchestrator | None: assigned to the operator. Conflicts and escalations between teams go straight to the operator |
| External party | External Provider (vendor support, outside auditor, contractor...) |
| Human | None: every human request goes to the operator |

Escalation chain: specialist → team orchestrator → operator.

## Live Integrations

This context declares live integrations: specialists call real services directly over HTTP or MCP when their work needs it (APIs, documentation, package registries, and so on). Calling a service is a tool use, not a role. The orchestrator validates whatever comes back, like any other output. Which roles may use which tools is listed in each agent file.

## Organizational Map

| Unit | Status | Orchestrator | Specialists |
|---|---|---|---|
| **Product** (entry) | active | Product Owner | Business Analyst, UX Designer |
| **Engineering** | active | Tech Lead | Software Architect, Software Developer |
| **Quality** | active | Quality Lead | QA Developer, Security Reviewer |
| **Release/Ops** | inactive | Release Manager | DevOps / SRE |

- **External Provider** (external party, active): one generic role, reached through a contract when a case needs a provider's answer or judgment (not a plain service call). Each case says which provider it stands for. It is an agent with live access to the provider's services and documentation; the requesting orchestrator always validates its response.
- Work flow: Product asks Engineering for a change through a contract; Engineering asks Quality to verify it; Product accepts the result only if Quality's report passes. Engineering never approves its own work.

## Roadmap and Future

**Next task:** draft the organizational map files once the user provides the guides (skills) and says which roles use them.
