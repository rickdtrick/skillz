---
name: task-breakdown
description: Decompose vague goals or large tasks into small, concrete, actionable checklist items. Use when the user shares a goal, task, or project idea and wants it broken down into manageable steps.
---

# Task Breakdown

Turn vague goals into actionable checklists.

## Workflow

### 1. Evaluate vagueness

If the goal is too vague to produce meaningful steps, ask clarifying questions before proceeding. Red flags:

- Abstract outcome ("get better at coding", "make it production-ready")
- Missing scope ("build an app", "fix the project")
- Missing context ("add auth", "deploy it")
- Ambiguous success ("make it fast", "clean up the codebase")

Ask 2-3 targeted questions covering: **what**, **for whom**, **scope**, and **done criteria**. Then wait for answers before breaking down.

### 2. Decompose

Break the goal into the smallest steps that are each:

- **Concrete** — describes a single action, not a category
- **Independent** — can be done without blocking on another item in the list
- **Verifiable** — has a clear "how do I know this is done" signal

Rules:

- Aim for items that take 5 min to 2 hours each
- Order items by dependency (prerequisites first)
- Group related items under a parent heading if the list exceeds 10 items
- Include a "Verify / Done" step at the end of each group

### 3. Output as markdown checklist

Return the result as a markdown checklist. Format:

```md
# [Goal Title]

## [Group Name] (if applicable)

- [ ] Step description
- [ ] Step description
  - [ ] Sub-step if needed
- [ ] Verify: how to confirm this group is done

## [Next Group]

- [ ] Step description
```

## Examples

**Vague input → clarifying questions:**

> User: "Add authentication to my app"
>
> You: Before I break this down — a few questions:
> 1. What kind of auth? (email/password, OAuth/SSO, magic links?)
> 2. What framework/stack are you using?
> 3. Do you need roles/permissions or just login/logout?

**Concrete input → checklist:**

> User: "Set up a new Next.js 14 project with Tailwind, Prisma, and PostgreSQL, and deploy to Vercel"

Output:

```md
# Set Up Next.js 14 Project

## Project Init

- [ ] Create Next.js 14 app with App Router (`npx create-next-app@14`)
- [ ] Install and configure Tailwind CSS
- [ ] Set up ESLint and Prettier
- [ ] Verify: `npm run dev` starts without errors

## Database

- [ ] Install Prisma (`npm install prisma @prisma/client`)
- [ ] Initialize Prisma (`npx prisma init`)
- [ ] Define schema (User model or whatever is needed)
- [ ] Set up PostgreSQL connection string in `.env`
- [ ] Run `npx prisma db push`
- [ ] Verify: `npx prisma studio` opens and shows schema

## Deploy

- [ ] Push repo to GitHub
- [ ] Import project in Vercel dashboard
- [ ] Set environment variables in Vercel
- [ ] Trigger deploy and verify build succeeds
- [ ] Check live URL loads correctly
```

## Tips

- When in doubt, err toward more granularity — the user can always combine steps
- If the user says "that's too detailed" or "simplify", merge related items and remove sub-steps
- For very large goals (>20 items), suggest breaking it into phases and tackling one phase at a time
