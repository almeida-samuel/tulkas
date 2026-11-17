# Software Development Context

Guidance for the **software-dev** context: a software development team running on the framework described in the root `CLAUDE.md`. Use the framework vocabulary (units, roles, contracts, rules, guides, expected outputs, cases); this file maps it to the team's own terms.

- [Current State](#current-state)
- [Overview](#overview)
- [Vocabulary Mapping](#vocabulary-mapping)
- [Live Integrations](#live-integrations)
- [Organizational Map](#organizational-map)
- [Roadmap and Future](#roadmap-and-future)

## Current State

Design phase. The role lineup, guides, rules, and the organizational map (organization, units, contracts, agents) are drafted for review. A first case (a multi-screen refactor in a Rails repository) ran 84 tasks over about 11 hours; the cost-control guidance (small revision sections, later audit rounds scoped to the fix diff, no acceptance re-runs, one revision pass per operator answer, a new case for work after merge, size targets for PRD, PRP, and audit) came from it. A review of that run then added: case data in `docs/tulkas/cases/<case-id>/` committed with the case, `worktree` or `branch` workspace mode, the operator's approval of the plan before implementation, audits kept inside the case, changes on the same case until merge, and one branch and one pull request per case.

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

The organizational map (draft) lives in separate files; this section only summarizes it.

- [organization.md](organization.md): organization diagram, interaction matrix, tools, escalation paths, handoff scenarios, and open questions. Start here.
- `units/<unit>.md`: one per team: orchestrator, members, and what it owns.
- Roles: each active non-human role is a Claude Code agent, `.claude/agents/software-dev-<role-id>.md`, holding its full spec, tools, and expected outputs. Release/Ops roles are inactive and get agent files when activated.
- `interaction-contracts/<contract-id>.md`: [engineering-change](interaction-contracts/engineering-change.md), [verification](interaction-contracts/verification.md), [provider-inquiry](interaction-contracts/provider-inquiry.md).

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
| Create the case branch `tulkas/<case-id>` and its workspace: a worktree under `.tulkas/worktrees/` (default) or the operator's clean checkout (`branch` mode, from `/run-case --branch` or `.claude/tulkas.json`) | Mechanical, at case opening | Dispatcher |
| Prepare the environment: start it, install declared dependencies, create or load the test database ([environment-setup](../../.claude/rules/software-dev/environment-setup.md)) | Work, no approval needed | Any role with the shell, inside the environment the guidance requires |
| Edit files in the case workspace | Work product (like `artifacts/`) | Software Developer; QA Developer and Security Reviewer only for throwaway probes, deleted before reporting |
| Start the implementation | Needs the operator's approval of the plan | Tech Lead, after the Product Owner's approval request ([implementation-requires-approval](../../.claude/rules/software-dev/implementation-requires-approval.md)) |
| Commit on the case branch | State change, within authority | Tech Lead: as often as the work needs, code and case folder, only on the case branch ([case-branch-only](../../.claude/rules/software-dev/case-branch-only.md)) |
| Push the case branch | Allowed, never forced | Tech Lead, after each commit ([push-merge-requires-operator](../../.claude/rules/software-dev/push-merge-requires-operator.md)) |
| Open the case's pull request (**one per case**), merge, or anything touching another branch | Outward-facing, hard to reverse | Only with the operator's approval ([push-merge-requires-operator](../../.claude/rules/software-dev/push-merge-requires-operator.md), [one-pull-request-per-case](../../.claude/rules/software-dev/one-pull-request-per-case.md)) |

Specialists never change version control ([specialists-dont-commit](../../.claude/rules/software-dev/specialists-dont-commit.md)). In `worktree` mode, one worktree per case keeps parallel cases from writing the same files and leaves the operator's own checkout untouched; `branch` mode runs one case at a time in the operator's checkout. **A case closes when its branch is merged** (an approved `publish` merge, or the operator saying it merged it) **or when it is abandoned**, not when a deliverable is accepted: until then, the operator can add fixes and changes to it. After the merge, further work is a new case.

Each case lives in `docs/tulkas/cases/<case-id>/` inside its workspace and is committed whole with the case. Its documents are under `artifacts/<kind>/`, with kinds `features`, `bugfixes`, `refactors`, `experience`, `prds`, `prps`, `audits`; every document is named after the case ID.

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

Rules live in `.claude/rules/software-dev/` (each lists the roles it binds): `product-docs-no-technical-content`, `pipeline-order`, `case-id-naming`, `results-verified-by-running`, `bugfix-requires-regression-test`, `refactor-preserves-behavior`, `delivery-requires-verification-pass`, `deviations-go-to-operator`, `implementation-requires-approval`, `one-pull-request-per-case`, `validate-external-outputs`, `probes-deleted`, `case-branch-only`, `push-merge-requires-operator`, `specialists-dont-commit`, `environment-setup`.

## Roadmap and Future

**Next task:** the user reviews the organizational map draft (with the guides and rules), then runs a first case in a repository prepared with `/tulkas-init software-dev`. Open questions are listed in [organization.md](organization.md#open-questions).
