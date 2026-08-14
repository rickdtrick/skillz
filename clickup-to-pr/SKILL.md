---
name: clickup-to-pr
description: Fetch one or more ClickUp tickets by ID or URL and produce self-reviewed PRs end-to-end. Use when the user provides ClickUp task IDs (e.g. `86exr740d`) or task URLs (e.g. `https://app.clickup.com/t/86exr740d`) and wants the changes implemented, verified, code-reviewed, and submitted as PRs with no further interaction. Multiple tickets are isolated in git worktrees under `.worktrees/`, so concurrent Claude sessions on the same repo never collide. For related tickets it asks whether the PRs should be stacked. Pulls design context from Figma when the ticket references a design. Designed for the careers monorepo but generalizes to any Nx + ClickUp project.
---

# ClickUp → PR

Pipeline per ticket: fetch → worktree → design → plan → implement → verify → self-review → PR.

## Quick start

```
/clickup-to-pr 86exr740d
/clickup-to-pr 86exr740d 86exr8f2p https://app.clickup.com/t/86exr9k1c
```

One ticket → run the workflow once, in the current tree. Two or more → see **Multi-ticket mode** and `WORKTREES.md`. Return the PR URL(s).

## Attribution rule (applies everywhere)
Never add any indication that Claude, Claude Code, or an AI produced the work — no `Co-Authored-By: Claude` trailer, no "Generated with Claude Code" footer, no mention in commit messages, PR titles, PR bodies, branch names, or ClickUp comments. Output must be indistinguishable from hand-written work.

## Workflow (per ticket)

### 1. Parse the ticket references
- URL `https://app.clickup.com/t/<TASK_ID>` → strip to the ID. Bare ID → use as-is.
- Multiple IDs may be space- or comma-separated.

### 2. Fetch the ticket
Call `mcp__claude_ai_ClickUp__clickup_get_task` per ID. Capture title, description, custom fields, attachments, parent/linked tasks. If the description requires product judgment (copy text, UX trade-offs, unspecified behaviour) — **stop and ask the user**. Don't invent product decisions.

### 3. Set up the working tree
**Single ticket:**
```bash
git status                  # working tree must be clean
git branch --show-current
```
- Dirty tree → stop and ask. Don't stash or discard work.
- On `master`/`main` with a clean tree → create a branch. Copy the existing convention from `git branch -a` (e.g. `rick/<task-id>-<short-slug>`) and `git checkout -b` it.
- On any non-main branch → keep working there (assume the user picked it intentionally).

**Multiple tickets:** use worktrees — see `WORKTREES.md`. Never `checkout` between tickets in the main tree.

### 4. Fetch the design (whenever Figma is available)
If the ticket description, custom fields, or comments contain a `figma.com` URL — or the change is visual and a design exists — pull the design through the Figma MCP rather than guessing from the ticket text:
- Load the `figma:figma-design-to-code` skill **before** calling `get_design_context` (mandatory prerequisite).
- `get_design_context` for the node, `get_screenshot` for visual reference, `get_variable_defs` for tokens, `get_code_connect_map` to reuse existing components.
- Use design tokens and mapped components; never hardcode values that exist as variables.
- Figma unavailable or no design linked → note that in the PR body and implement from the ticket text.

### 5. Plan
- Read `GLOSSARY.md` to locate files for domain terms in the ticket.
- Use the `Explore` agent for symbols the glossary doesn't cover.
- Sketch: files to change, build/test targets, spec updates required.
- API surface changes (controllers/services/consumers/DTOs/entities under `apps/api/` or `apps/candidate-portal-api/`) **must** include matching `.spec.ts` updates in the same PR.
- Flow change or new feature → update `GLOSSARY.md` in the same PR.

### 6. Implement
Follow `CLAUDE.md` conventions strictly:
- Conventional Commits prefix on PR title (`feat:`, `fix:`, `chore:`, `refactor:`, `docs:`, `test:`).
- Server Actions over route-handler proxies on the frontend.
- New HubSpot constants → `libs/hubspot-client/`, never the deprecated `apps/api/src/lib/hubspot-client.ts`.
- No `console.*` in backend src — use NestJS `Logger`.
- Minimum change that makes the task work; no speculative abstractions.

### 7. Verify
Run from inside the ticket's worktree (or repo root in single-ticket mode):
```bash
nx build <project>            # required for any project touched
nx test <project>             # if any .spec.ts exists for touched files
nx affected -t lint           # always
```
- `jobs-board` has **only** a `build` target — no `typecheck`.
- For API changes, also run `nx test api` — DI changes cascade.
- Any failure → fix and re-run. Do not proceed with broken checks.

### 8. Self-review (required before PR)
Invoke `pr-review-toolkit:code-reviewer` with `git diff`.
- Address high-confidence findings inline, then re-run step 7.
- Note uncertain/style findings in the PR description rather than auto-fixing.
- If the diff touches error handling, also invoke `pr-review-toolkit:silent-failure-hunter`.

### 9. Commit and open PR
- **Commit message:** Conventional Commits, lowercase imperative subject. No attribution trailer (see **Attribution rule**).
- `git push -u origin <branch>`.
- **Always populate `.github/pull_request_template.MD`** as the PR body — read it, fill every section, pass to `gh pr create --body`. See `PR-BODY.md` for the section-by-section rules.
- If the change was built from a Figma design, put the Figma link in the Ticket / Context section and a screenshot in Screenshots.
- In multi-ticket mode, set the base branch per the stacking decision below.
- Title mirrors the lead commit.

Return the PR URL.

## Multi-ticket mode

1. Fetch all tickets first (step 2), then create one worktree per ticket — `WORKTREES.md`.
2. **Assess relatedness before any PR is opened.** Tickets are related when they share a parent task, are linked as dependencies in ClickUp, or their diffs touch overlapping files/modules. Present the evidence and ask whether to stack:
   > Tickets 86exr740d and 86exr8f2p both change `libs/hubspot-client/`. Open them as independent PRs off `main`, or stack the second on the first?

   **Default to independent PRs.** Only stack when the user confirms, or when one ticket's change genuinely does not compile/pass without the other's.
3. Process tickets **sequentially** — finish one ticket's PR before starting the next. If stacked, the parent PR must be pushed before the child branches off it.
4. For stacked PRs: branch the child from the parent branch, `gh pr create --base <parent-branch>`, and add a `Stacked on #<parent-PR>` line at the top of the PR body.
5. Clean up merged worktrees per `WORKTREES.md`.

## Stop conditions
Halt and ask the user before continuing if:
- Ticket description requires product/copy decisions not specified.
- Working tree is dirty (regardless of branch).
- Build/tests fail in a way you can't resolve from the diff alone.
- A ticket's change spans multiple logical concerns — split into separate PRs.
- A worktree or branch for the ticket already exists and you didn't create it (another session may own it) — see `WORKTREES.md`.
- Touching `apps/api/src/app/hubspot/consumer/job-alert.consumer.ts` or related job-alert code — that pipeline is paused; confirm intent first.
- `.github/pull_request_template.MD` is missing — fall back to Why / ClickUp link / Test plan and tell the user.
