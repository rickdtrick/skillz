---
name: delegate
description: Take a list of tasks, rate the effort each one needs, group tasks that would conflict if run in parallel, get the user's approval on the plan, then write a prompt per group and run the groups as parallel subagents at their assigned effort level. Use when the user lists several tasks to hand off at once, says "delegate these", "split these across agents", "run these in parallel", or invokes /delegate with a task list.
---

# Delegate

Pipeline: parse → scope → rate → group → approve → dispatch → verify → report.

## Quick start

```
/delegate
1. Fix the typo in the signup email subject
2. Add pagination to GET /jobs
3. Rename `fetchJobs` to `listJobs` everywhere
4. Write unit tests for the jobs service
```

Output is an approval table. Nothing runs until the user approves it.

## Workflow

### 1. Parse the task list
- One numbered task per item the user gave. Keep the user's wording as the task title.
- Split an item only if it holds two unrelated changes. Never merge here; merging happens in step 4.
- A task too vague to scope (no target, no done signal) → ask about that task only. Scope the rest meanwhile.

### 2. Scope each task
For each task, find what it touches before rating it. Rating by title alone misses conflicts.
- Code tasks: locate the files, modules, and shared resources (schema, migrations, lockfiles, config, generated code, i18n catalogs, shared types). Use `Grep`/`Glob` for known targets; use one `Explore` agent for the whole list when targets are unknown.
- Non-code tasks (docs, research, tickets): note the output location and any shared doc or tracker item.
- Record per task: files/resources, depends-on (another task's output), and a one-line done signal.

### 3. Rate effort
Assign one level per task from the rubric in `REFERENCE.md`: `low`, `medium`, `high`, `xhigh`, `max`. Rate on difficulty and risk, not on size alone. `max` only when the user asks for it.

### 4. Group
Apply the rules in `REFERENCE.md` → **Grouping rules**. Summary:
- **Must merge**: tasks that touch the same file or shared resource, or where one depends on another's output.
- **Group effort = highest effort of its tasks.** Note every task that got raised.
- **May merge**: small tasks at the same effort in the same area, to cut agent count.
- Everything else gets its own group. Groups must be safe to run at the same time.

### 5. Ask for approval
Show the plan in this shape, then stop and wait:

```md
| Group | Tasks | Effort | Touches | Why grouped |
|---|---|---|---|---|
| A | 3. Rename fetchJobs, 4. Jobs service tests | high (4 raised from medium) | src/jobs/* | both edit jobs.service.ts |
| B | 2. Paginate GET /jobs | medium | src/api/jobs.route.ts | none |
| C | 1. Signup email typo | low | templates/signup.html | none |

3 agents in parallel. Shared tree. Final check: `npm test`.
Approve, or tell me what to change (effort, grouping, drop a task).
```

- Edits from the user → re-run steps 3 and 4 for affected tasks, show the table again.
- The user can override any rating. If an override puts conflicting tasks at different levels, keep them merged and use the higher level; say so in one line.

### 6. Dispatch
- Write one prompt per group from the template in `REFERENCE.md` → **Prompt template**.
- Send every `Agent` call in a single message so groups run in parallel. Set `effort` to the group's level. Use `general-purpose` unless a listed agent type fits better.
- More than 5 groups → run in waves of 5 and say so in the approval table.
- Isolation: see `REFERENCE.md` → **Shared tree or worktrees**.

### 7. Verify
After all agents return:
- Read each agent's report. Check the claimed files actually changed (`git diff --stat`).
- Run the repo's build, tests, and linter once across everything touched. Use the real script names from `package.json`, the Makefile, or equivalent.
- A failure caused by one group → resume that agent with `SendMessage` and the failing output. Do not fix it inline unless it is a one-line fix.

### 8. Report

```md
| Group | Effort | Result | Files changed |
|---|---|---|---|
| A | high | done | src/jobs/jobs.service.ts, src/jobs/jobs.service.spec.ts |
| B | medium | done | src/api/jobs.route.ts |
| C | low | blocked: template is generated, edit source in cms/ | none |

Checks: build pass, tests 142/142, lint pass.
```

List anything blocked or skipped with its reason. Do not commit, push, or open PRs unless the user asked.

## Rules
- Never dispatch before approval.
- Never split conflicting tasks across groups, whatever their effort levels.
- Agents do not run state-changing git commands (`commit`, `checkout`, `stash`, `reset`, `rebase`) in a shared tree.
- No AI attribution in anything an agent writes (commits, comments, docs).
