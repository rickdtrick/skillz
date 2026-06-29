---
name: clickup-to-pr
description: Fetch a ClickUp ticket by ID or URL and produce a self-reviewed PR end-to-end. Use when the user provides a ClickUp task ID (e.g. `86exr740d`) or task URL (e.g. `https://app.clickup.com/t/86exr740d`) and wants the change implemented, verified, code-reviewed, and submitted as a PR with no further interaction. Designed for the careers monorepo but generalizes to any Nx + ClickUp project.
---

# ClickUp → PR

End-to-end pipeline: ticket → branch check → plan → implement → verify → self-review → PR.

## Quick start

User invokes: `/clickup-to-pr 86exr740d` or `/clickup-to-pr https://app.clickup.com/t/86exr740d`

Run the workflow below and return the PR URL.

## Workflow

### 1. Parse the ticket reference
- URL: `https://app.clickup.com/t/<TASK_ID>` — strip everything but the ID.
- Bare ID: use as-is.

### 2. Fetch the ticket
Call `mcp__claude_ai_ClickUp__clickup_get_task` with the task ID. Capture title, description, custom fields, parent/linked tasks. If the description requires product judgment (copy text, UX trade-offs, behavioral choices not specified) — **stop and ask the user**. Don't invent product decisions.

### 3. Verify environment
```bash
git status                  # working tree must be clean
git branch --show-current
```
- Dirty tree → stop and ask. Don't stash or discard work.
- On `master`/`main` with a clean tree → **create a new branch for the ticket**. Look at `git branch -a` to copy the existing prefix/slug convention (e.g. `rick/<task-id>-<short-slug>`) and `git checkout -b` it. Note this overrides the older "never create a branch" rule for the main/master case only; on any other branch, keep working there.
- On any non-main branch → keep working on the current branch (assume the user picked it intentionally).

### 4. Plan
- Read `GLOSSARY.md` to locate relevant files for any domain term in the ticket.
- Use the `Explore` agent for symbols/files the glossary doesn't cover.
- Sketch an internal plan: files to change, build/test targets, spec updates required.
- API surface changes (controllers/services/consumers/DTOs/entities under `apps/api/` or `apps/candidate-portal-api/`) **must** include matching `.spec.ts` updates in the same PR (per `feedback_api_changes_require_spec_updates`).
- Flow change or new feature → update `GLOSSARY.md` in the same PR (per `feedback_keep_glossary_in_sync`).

### 5. Implement
Follow `CLAUDE.md` conventions strictly:
- Conventional Commits prefix on PR title (`feat:`, `fix:`, `chore:`, `refactor:`, `docs:`, `test:`).
- Server Actions over route-handler proxies on the frontend.
- New HubSpot constants → `libs/hubspot-client/`, never the deprecated `apps/api/src/lib/hubspot-client.ts`.
- No `console.*` in backend src — use NestJS `Logger`.
- Minimum change that makes the task work; no speculative abstractions.

### 6. Verify
```bash
nx build <project>            # required for any project touched
nx test <project>             # if any .spec.ts exists for touched files
nx affected -t lint           # always
```
Notes:
- `jobs-board` has **only** a `build` target — no `typecheck` (per memory observation 1108).
- For API changes, also run `nx test api` — DI changes cascade.
- Any failure → fix and re-run. Do not proceed with broken checks.

### 7. Self-review (required before PR)
Invoke the `pr-review-toolkit:code-reviewer` agent with the unstaged diff:
```bash
git diff
```
- Address high-confidence findings inline. Re-run verify step after edits.
- For uncertain/style findings, note them in the PR description rather than auto-fixing.
- For diffs that touch error handling, also invoke `pr-review-toolkit:silent-failure-hunter`.

### 8. Commit and open PR
- **Commit message:** Conventional Commits, lowercase imperative subject. **Omit the `Co-Authored-By: Claude` trailer** (per `feedback_no_claude_coauthor_trailer`).
- Push branch with `git push -u origin <branch>`.
- **Always populate `.github/pull_request_template.MD`** as the PR body. Read the file, fill every section, then pass the result to `gh pr create --body`. Do not invent a different structure.
  - **Summary:** one or two bullets stating the _why_ (from the ticket), not a play-by-play of files touched.
  - **Type of Change:** tick the single checkbox that matches the conventional-commit prefix (`fix:` → Bug fix, `feat:` → New feature, `refactor:` → Refactor, `chore:`/`docs:` → Chore / dependency update). Leave the other boxes empty.
  - **Ticket / Context:** a bullet with the ClickUp link: `- https://app.clickup.com/t/<TASK_ID>`. If there's a Sentry/GitHub issue tied to the work, add it as a second bullet.
  - **Testing:** tick the checkboxes you actually completed (`Tested locally` if you ran the dev server / smoke-tested, `Added/updated unit tests` if specs changed, `Tested on staging` only if you actually did). Add a markdown checklist under the section for any post-merge verification you couldn't do locally (e.g. "Watch Sentry rate after deploy").
  - **Screenshots:** omit the section if the change is server-only; keep it with `_N/A_` if the template requires it visually.
  - **Swagger:** include only when API surface changed; otherwise drop or mark `_N/A_`.
- Title mirrors the lead commit.
- **Do not include** any "Generated with Claude Code" footer.

Return the PR URL.

## Stop conditions
Halt and ask the user before continuing if:
- Ticket description requires product/copy decisions not specified.
- Working tree is dirty (regardless of branch).
- Build/tests fail in a way you can't resolve from the diff alone.
- The change spans multiple logical concerns — split into separate PRs (one logical change per PR per `CLAUDE.md`).
- Touching `apps/api/src/app/hubspot/consumer/job-alert.consumer.ts` or related job-alert code — that pipeline is paused (per `project_job_alerts_disabled`); confirm intent first.
- `.github/pull_request_template.MD` is missing — fall back to the previous body format (Why / ClickUp link / Test plan) and tell the user.
