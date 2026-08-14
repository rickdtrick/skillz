# Filling the PR template

Always read `.github/pull_request_template.MD` and fill every section it defines. Do not invent a different structure. If the file is missing, fall back to Why / ClickUp link / Test plan and tell the user.

## Section rules

**Stacked on** (multi-ticket stacked PRs only)
- First line of the body: `Stacked on #<parent-PR>`. Also confirm the PR base branch is the parent branch, not `main`.

**Summary**
- One or two bullets stating the _why_ (from the ticket), not a play-by-play of files touched.

**Type of Change**
- Tick the single checkbox matching the conventional-commit prefix: `fix:` → Bug fix, `feat:` → New feature, `refactor:` → Refactor, `chore:`/`docs:` → Chore / dependency update. Leave the other boxes empty.

**Ticket / Context**
- `- https://app.clickup.com/t/<TASK_ID>`
- Add the Figma link as a second bullet if the change was built from a design.
- Add a Sentry or GitHub issue link if one is tied to the work.

**Testing**
- Tick only what you actually completed: `Tested locally` if you ran the dev server or smoke-tested, `Added/updated unit tests` if specs changed, `Tested on staging` only if you genuinely did.
- Add a markdown checklist for post-merge verification you couldn't do locally (e.g. "Watch Sentry rate after deploy").

**Screenshots**
- Server-only change → omit the section, or keep it with `_N/A_` if the template requires it visually.
- UI change with a Figma design → include a screenshot of the implemented result. Note any deliberate deviation from the design and why.

**Swagger**
- Include only when the API surface changed; otherwise drop or mark `_N/A_`.

## Never include
No `Co-Authored-By: Claude` trailer, no "Generated with Claude Code" footer, no AI/assistant mention anywhere in the title, body, or commits.
