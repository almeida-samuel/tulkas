---
name: tulkas-init
description: Prepare the current repository to run a Tulkas context - audit its CLAUDE.md against what the context needs, propose a refactor (including a Tulkas section), and apply it once the operator approves.
argument-hint: [context]
disable-model-invocation: true
---

# Initialize a Repository for Tulkas

The operator runs this in a repository that will use a Tulkas context. You read the repository's guidance (its `CLAUDE.md`), compare it with what the context's roles need, propose a refactor, and apply it **only after the operator approves**. You never commit.

## 1. Pick the Context

The context is `$ARGUMENTS` if given; otherwise the `context` in the repository's `.claude/tulkas.json`; otherwise ask. It must be a folder in `contexts/`. Read:

- `contexts/<context>/CLAUDE.md`: what the context is;
- `contexts/<context>/repository-requirements.md`: what the repository's guidance must provide, the conflicts to resolve, and the Tulkas section to add. If the context has no such file, it needs nothing from the repository: only create `.claude/tulkas.json` (step 6) and stop.

## 2. Read the Repository

- `CLAUDE.md` at the repository root, **in full**, plus every file it imports or links as guidance. List its sections with their anchors. If there is none, you will propose one from scratch.
- The repository's own skills, agents, and rules (`.claude/`), to find competing pipelines. Read competing skills **in full**: they often hold repository-specific knowledge the guidance lacks (exact commands, environment quirks, shared-state hazards, the domain's irreversible failures, mechanical checks, convention details). The Tulkas guides are technology-neutral, so that knowledge is lost unless it moves into the guidance.
- Enough of the repository to **verify** what the guidance claims and to find what it leaves out: build and dependency manifests, scripts and binaries, CI configuration, environment definitions (container files, compose files, tool-version files), configuration templates, test layout, and the git setup (default branch, existing branch names).

Never invent a fact. Everything you propose to write is either already in the guidance, verified in the repository (say where), or a question for the operator.

## 3. Audit

For every requirement in `repository-requirements.md`, record:

| Requirement | Status | Where | Notes |
|---|---|---|---|
| `<id>` | covered / partial / missing / wrong | section anchor, or the file you verified it in | what is missing, or what the repository contradicts |

A requirement is **covered** only if an agent reading the guidance alone could act on it: exact commands, not "run the tests"; named rules, not "follow the style". **Wrong** means the guidance says something the repository contradicts (a command that doesn't exist, a path that moved).

Then list every **conflict** the requirements file names (competing pipeline, document locations, rules citing old document paths, branch-rule breaks, knowledge duplicated from the Tulkas guides), with the exact passages.

## 4. Propose

Present to the operator, in this order:

1. **The audit table** and the conflicts.
2. **The refactor plan**, as a list of concrete edits:
   - **Add** the Tulkas section from the requirements file, filled in for this repository, with its Repository Profile mapping each requirement to the section that covers it.
   - **Fill** partial and missing requirements with what you verified, each in the section it belongs to (create a section only when none fits).
   - **Fix** wrong statements, citing what the repository actually shows.
   - **Harvest** repository-specific knowledge found only in competing skills into the guidance, in the section each piece belongs to (e.g., an environment quirk under the environment section, the domain's irreversible failures and audit sweeps under their requirements). Name the skill and passage each piece came from.
   - **Resolve** each conflict: rewrite, point to Tulkas, or remove. Removing anything that is not a duplicate of Tulkas knowledge needs an explicit yes.
   - **Keep** everything else as it is: house rules, examples, rationale. This is a refactor, not a rewrite; preserve the author's wording and structure.
   - **Table of contents**: if the file has one, keep it in sync.
3. **Questions**: everything you could not verify (protected branches, whether case data is committed, domain facts), each with what you would assume and what it changes. Use AskUserQuestion for the ones with clear options.
4. **Repository changes outside `CLAUDE.md`**: `.claude/tulkas.json`, `.gitignore` entries (`.tulkas/worktrees/`, and `data/<context>/` if case data is not committed), and what to do with competing skills (keep, or remove after the operator confirms). Propose removing a competing skill only once everything repository-specific in it has been harvested.

Wait for approval. The operator may approve all, some, or none.

## 5. Apply

Apply exactly what was approved:

- Edit `CLAUDE.md` in place. Keep the author's sections and wording outside the approved edits; keep the table of contents in sync.
- Re-read the result against the requirements table and confirm each approved item landed.

## 6. Configure

- Write `.claude/tulkas.json` with `{"context": "<context>"}` (if it isn't there already).
- Add the approved `.gitignore` entries.
- Remove competing skills only if the operator approved it.

## 7. Report

Show what changed (files and sections), the requirements still missing and what the roles will assume meanwhile, and remind the operator that nothing was committed. Suggest the first case: `/run-case <request>`.

## Boundaries

- Never commit, push, or create branches.
- Never change code, tests, or configuration other than `CLAUDE.md`, `.claude/tulkas.json`, and `.gitignore`, and approved removals of competing skills.
- Earlier pipeline documents (old specs, PRDs, PRPs, audits) are an archive: never move or rewrite them.
