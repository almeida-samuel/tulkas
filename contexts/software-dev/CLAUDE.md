# Software Development Context

Guidance for the **software-dev** context: a software development team running on the framework described in the root `CLAUDE.md`. Use the framework vocabulary (units, roles, contracts, rules, guides, expected outputs, cases); this file maps it to the team's own terms.

- [Current State](#current-state)
- [Overview](#overview)
- [Vocabulary Mapping](#vocabulary-mapping)
- [Live Integrations](#live-integrations)
- [Organizational Map](#organizational-map)
- [Roadmap and Future](#roadmap-and-future)

## Current State

Design phase. The role lineup, guides, and rules are drafted for review; the organizational map files (organization, units, contracts, agents) are not drafted yet.

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

## Repository, Branches, and Documents

The **repository** a case runs in is the one the operator works from; its own guidance (its `CLAUDE.md`) supplies everything technology-specific: stack, commands, environment, conventions, protected branches. Guides never assume a language or framework.

| Action | Treated as | Who |
|---|---|---|
| Create the case branch `<type>/<case-id>` and its worktree (default `.tulkas/worktrees/<case-id>`, git-ignored) | State change | Tech Lead |
| Edit files in the case worktree | Work product (like `artifacts/`) | Software Developer; QA Developer and Security Reviewer only for throwaway probes, deleted before reporting |
| Commit on the case branch | State change, within authority | Tech Lead, after accepting the implementation ([case-branch-only](../../.claude/rules/software-dev/case-branch-only.md)) |
| Publish accepted documents to `docs/tulkas/<kind>/<case-id>.md` | State change, part of a commit | Tech Lead (spec, experience design, PRD, PRP); Quality Lead writes the audit, Tech Lead commits it |
| Push, pull request, merge, or anything touching a shared branch | Outward-facing, hard to reverse | Only with the operator's approval ([push-merge-requires-operator](../../.claude/rules/software-dev/push-merge-requires-operator.md)) |

Specialists never change version control ([specialists-dont-commit](../../.claude/rules/software-dev/specialists-dont-commit.md)). One branch and worktree per case keeps parallel cases from writing the same files and leaves the operator's own checkout untouched.

Document kinds under `docs/tulkas/`: `features`, `bugfixes`, `refactors`, `experience`, `prds`, `prps`, `audits`. Every document of a case is named after the case ID.

A repository is prepared with `/tulkas-init software-dev`, which checks its `CLAUDE.md` against [repository-requirements.md](repository-requirements.md) (what the roles need from it, the conflicts to resolve, and the Tulkas section to add).

## Guides and Rules

| Role | Guides |
|---|---|
| Product Owner | [work-intake](../../.claude/skills/software-dev-work-intake/SKILL.md), [product-language](../../.claude/skills/software-dev-product-language/SKILL.md) |
| Business Analyst | [feature-spec](../../.claude/skills/software-dev-feature-spec/SKILL.md), [bugfix-spec](../../.claude/skills/software-dev-bugfix-spec/SKILL.md), [refactor-spec](../../.claude/skills/software-dev-refactor-spec/SKILL.md), [prd](../../.claude/skills/software-dev-prd/SKILL.md), [product-language](../../.claude/skills/software-dev-product-language/SKILL.md) |
| UX Designer | [experience-design](../../.claude/skills/software-dev-experience-design/SKILL.md), [product-language](../../.claude/skills/software-dev-product-language/SKILL.md) |
| Tech Lead | [technical-acceptance](../../.claude/skills/software-dev-technical-acceptance/SKILL.md), [guideline-conformance](../../.claude/skills/software-dev-guideline-conformance/SKILL.md) |
| Software Architect | [prp](../../.claude/skills/software-dev-prp/SKILL.md), [guideline-conformance](../../.claude/skills/software-dev-guideline-conformance/SKILL.md) |
| Software Developer | [prp-implementation](../../.claude/skills/software-dev-prp-implementation/SKILL.md) |
| Quality Lead | [verification-verdict](../../.claude/skills/software-dev-verification-verdict/SKILL.md) |
| QA Developer | [implementation-audit](../../.claude/skills/software-dev-implementation-audit/SKILL.md), [guideline-conformance](../../.claude/skills/software-dev-guideline-conformance/SKILL.md) |
| Security Reviewer | [security-review](../../.claude/skills/software-dev-security-review/SKILL.md) |
| External Provider | [provider-inquiry](../../.claude/skills/software-dev-provider-inquiry/SKILL.md) |

Rules live in `.claude/rules/software-dev/` (each lists the roles it binds): `product-docs-no-technical-content`, `pipeline-order`, `case-id-naming`, `results-verified-by-running`, `bugfix-requires-regression-test`, `refactor-preserves-behavior`, `delivery-requires-verification-pass`, `deviations-go-to-operator`, `validate-external-outputs`, `probes-deleted`, `case-branch-only`, `push-merge-requires-operator`, `specialists-dont-commit`.

## Roadmap and Future

**Next task:** the user reviews the guides and rules; then draft the organizational map files (organization, units, contracts, agent files).
