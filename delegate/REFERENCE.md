# Delegate reference

## Effort rubric

Pick the lowest level that a careful engineer would trust for the task.

| Level | Use for | Examples |
|---|---|---|
| `low` | Mechanical change, known location, no judgment | Fix a typo, bump a config value, add a log line, rename a local variable |
| `medium` | Clear spec, 1 to 3 files, follows an existing pattern | Add a field to a form, small bug with known cause, add a test next to similar tests |
| `high` | Needs investigation or design choices, several files, new tests | Bug with unknown cause, new endpoint with validation, cross-file rename with call sites |
| `xhigh` | Cross-cutting or high-risk | Refactor across modules, concurrency, auth/security, data migrations, performance work |
| `max` | Only when the user asks | Architecture-level change where a wrong call is expensive |

Raise one level when:
- The area has no tests and the task changes behavior.
- The task touches auth, payments, PII, or migrations.
- Scoping in step 2 could not find where the change goes.

## Grouping rules

Build a conflict graph: one node per task, an edge for each reason below. Each connected component becomes one group.

Edge (must merge) when two tasks:
1. Edit the same file.
2. Edit the same shared resource: DB schema or migrations, lockfile or dependency manifest, shared config, generated code, i18n catalogs, a shared type or interface file, a barrel `index` file.
3. Have an output dependency: one task needs the other's result (rename then test the renamed code, add an API then call it).
4. Change the same public symbol, even from different files (one renames `fetchJobs`, another adds a caller of `fetchJobs`).
5. Write to the same doc, ticket, or tracker item.

Group effort is the highest level among its tasks. In the approval table, mark each raised task: `4 raised from medium`.

Optional merge (affinity), only if all hold:
- Same effort level.
- Same directory or feature area.
- Each task is `low` or `medium`.
- The merged group stays under about 5 tasks.

Do not merge for affinity across effort levels. That would raise a cheap task for no safety gain.

If one component swallows most of the list, say so in the approval table. Offer to run it as one group or in sequence after the parallel groups finish.

## Shared tree or worktrees

Default: shared working tree. Grouping already keeps file sets disjoint.

Use `isolation: "worktree"` for every group when any of these hold:
- Two or more groups run builds or test suites that write to the same output dirs or ports.
- The user wants one branch or PR per group.
- The user asks for isolation.

With worktrees, the verify step merges each worktree's changes into the main tree before running the final checks. Report any merge conflict instead of resolving it silently.

## Prompt template

Each agent sees only its prompt. Fill every field; delete a section only if it does not apply.

```md
You are working on group <letter> of a parallel batch. Other agents are editing other files in this repo at the same time.

## Tasks
1. <task title as the user wrote it>
   Done when: <done signal>
2. ...

## Context
- Repo: <path>. Conventions: read CLAUDE.md / AGENTS.md / CONTRIBUTING.md if present and follow them.
- Relevant files: <paths found in scoping>
- Notes from scoping: <anything learned, e.g. "template is generated from cms/signup.mjml">

## Boundaries
- Edit only these files or areas: <list>. If the task needs a file outside this list, stop and report it instead of editing it.
- Do not run git commands that change state (commit, checkout, stash, reset, rebase, push).
- Do not add AI attribution anywhere.
- Do not install or upgrade dependencies unless a task says to.

## Checks
Run before reporting: <targeted test/lint command for this group's files>.

## Report back
- Per task: done / blocked, and why if blocked.
- Files changed.
- Check results with the failing line if any failed.
- Anything the other groups or the user should know.
```
