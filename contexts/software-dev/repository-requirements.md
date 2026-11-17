# Repository Requirements (software-dev)

What a repository's guidance (its `CLAUDE.md`) must tell the software-dev roles before Tulkas can run cases there. The guides assume no language, framework, or tool; everything below comes from the repository. The `tulkas-init` skill checks a repository's `CLAUDE.md` against this list and proposes the changes.

Status: **required** (cases run poorly or unsafely without it), **recommended** (the guides fall back to a weaker default), **optional**.

## Requirements

| ID | What the guidance must say | Used by | Status |
|---|---|---|---|
| `product` | What the product is, who uses it, the domain process and its vocabulary, the main product surfaces (modules, screens) | business-analyst, ux-designer, product-owner (feature, bugfix, refactor specs, PRD, experience design) | required |
| `branding` | The product name users see, and any internal names that must never reach a user | ux-designer, security-reviewer, qa-developer | recommended |
| `stack` | Language, framework, database, frontend, background work, storage, and the architectural rules that constrain every change (what may not be introduced without a PRP arguing for it) | software-architect (prp) | required |
| `conventions` | House rules for how code is written, stated as checkable rules (MUST / MUST NOT), each in its own named section so it can be cited | software-architect, tech-lead, qa-developer (guideline-conformance) | required |
| `ui` | UI conventions: layout, supported screen sizes, components, destructive-action confirmation, accessibility expectations | ux-designer, qa-developer | recommended (required if the product has a UI) |
| `languages` | Supported languages for user-facing text, the default, how text is externalized, and the parity rule | ux-designer, software-developer, qa-developer | recommended (required if more than one language) |
| `testing` | Test framework, where tests live, test-data rules, how outside services are faked in tests, what a model/unit test must cover | software-developer, qa-developer | required |
| `environment` | Where and how commands run (host, container, virtual environment, toolchain manager), the exact command wrapper, how to start the environment, how to prepare it for tests (install dependencies, create the test database), and what must never be done on the host. Agents run that preparation themselves ([environment-setup](../../.claude/rules/software-dev/environment-setup.md)) | software-developer, qa-developer, security-reviewer | required |
| `commands` | Exact commands to: set up, run the app, run the full suite, one file, one test, tests by name, the system/end-to-end suite, linters (and autocorrect), security scanner, dependency audit | software-architect, software-developer, qa-developer, security-reviewer | required |
| `ci` | What CI runs, where it is defined, and which suites it excludes | qa-developer | required |
| `configuration` | How configuration and secrets are supplied, the tracked template new variables must be added to, and what lives outside the repository (production secrets) | software-developer, security-reviewer | required |
| `dependencies` | Where system and language dependencies are declared, and every environment definition a new one must reach (local, CI, production) | software-developer, qa-developer | recommended |
| `generated-files` | Files generated from shared state (schema dumps, lockfiles, snapshots), what may change them, and state shared across worktrees (databases, ports, caches) | software-developer, qa-developer | required if any exist |
| `git` | The base branch for new work, protected branches (never committed to), commit message conventions, and anything that breaks with several worktrees at once | tech-lead | required |
| `security` | Security rules of the codebase: how records are addressed externally, where outside calls may happen, authentication and authorization patterns, sensitive data | security-reviewer | recommended |
| `irreversible-failures` | The failures that are irreversible in this domain (e.g., a wrong amount filed or billed), so audits rank them at severity 1 | qa-developer, security-reviewer, quality-lead | recommended |
| `audit-sweeps` | Mechanical checks worth running on every audit (searches or commands whose failures are silent) | qa-developer, security-reviewer | optional |
| `deployment` | How production is deployed, stated so agents know it is out of their scope | tech-lead | optional |
| `known-drift` | Known inconsistencies between the repository and its documentation | software-architect, qa-developer | optional |

## Conflicts to Resolve

The guidance must not contradict Tulkas. `tulkas-init` flags, and proposes rewriting:

- **A competing development pipeline**: skills or workflow sections that make documents Tulkas now produces (specs, PRDs, PRPs, audits) in other locations or under other rules. Tulkas runs the pipeline; the guidance keeps the house rules the pipeline works within.
- **Document locations**: references to pipeline documents outside `docs/tulkas/`. Earlier documents stay where they are as an archive; new ones go under `docs/tulkas/`.
- **Rules that cite pipeline documents** (e.g., "comments must not cite `docs/prps/`") must name `docs/tulkas/` too.
- **Instructions that break the Tulkas branch rules**: committing to the base branch, opening pull requests, merging, or deploying without the operator.
- **Duplicated knowledge**: restatements of what the Tulkas guides already hold (the zero-technical-content rule and its litmus tests, the PRP contents, the audit method). The guidance keeps only what is specific to this repository.

## Tulkas Section

The section `tulkas-init` adds to the guidance, filled in for the repository (placeholders in angle brackets):

```markdown
## Tulkas

This repository is run with the **Tulkas** framework, context `software-dev` (set in `.claude/tulkas.json`). Work arrives as cases, opened with `/run-case <request>`: Product turns the request into a spec and a PRD, Engineering writes the PRP and implements it, and Quality audits the result. The operator approves anything beyond the agents' authority.

- **Cases**: each case lives in `docs/tulkas/cases/<case-id>/` (its `metadata.json` names the context and workspace) and is committed with the change: the spec, experience design, PRD, PRP, and audit under its `artifacts/`, plus the case's task log. They are the record of why each change was made. Code comments never cite them.
- **Branches**: each case works on `tulkas/<case-id>`, branched from `<base branch>`, in its own worktree under `.tulkas/worktrees/` (git-ignored; or in this checkout with `/run-case --branch`), and reaches the base branch through **one pull request**. The operator approves the plan before anything is implemented. Agents commit and push only the case branch, never commit to <protected branches>, never open a pull request without the operator's approval, and never merge: the operator merges.

### Repository Profile

Where the Tulkas roles find what they need in this file:

| Need | Section |
|---|---|
| Product and domain | <link> |
| ... one row per requirement ID that this file covers ... | <link> |

<Requirements this file does not cover yet, and what the roles assume meanwhile.>
```
