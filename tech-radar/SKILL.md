---
name: tech-radar
description: Researches current tech trends across the full stack spectrum and produces a personal radar report with learn-now/watch/skip verdicts. Use when the user wants to check what's new and worth learning in web development, devops, AI tooling for developers, databases, or any area of the full stack. Triggered by prompts like "what should I learn next", "what's new in the ecosystem", "any new tech worth picking up", or "run my tech radar".
---

# Tech Radar

Researches what's trending in tech right now and produces a personal radar report with clear, actionable verdicts.

## Developer Profile (baseline context)

Current stack: Ruby/Rails, TypeScript, React, Next.js, NestJS, React Query, Tailwind CSS, Postgres, MongoDB, Prisma, REST, gRPC, Docker, AWS, DigitalOcean, Ansible, Sentry, Grafana.

Use this as context for relevance scoring — but surface tech from **any** area of the full stack, including things outside this stack. The goal is to find genuinely new or accelerating tech, not just updates to what's already known.

## Workflow

### Step 1 — Research (run these searches in parallel)

Use **Tavily** for all web research (`mcp__claude_ai_Tavily__tavily_search` for broad searches, `mcp__claude_ai_Tavily__tavily_research` for deep dives on specific items, `mcp__claude_ai_Tavily__tavily_extract` to pull content from specific URLs). Run all category searches in parallel. Target current, dated sources (GitHub trending, dev blogs, release announcements, Hacker News, ThoughtWorks radar, etc.):

- **Frontend**: new frameworks, rendering patterns, build tools, UI libraries
- **Backend**: new runtimes, frameworks, API patterns, ORMs
- **Infra/DevOps**: container orchestration, CI/CD tools, observability, IaC
- **Databases**: new engines, query layers, vector/embedded DBs
- **AI tooling for devs**: coding assistants, LLM-powered dev tools, agentic workflows
- **Web platform**: new browser APIs, standards, WASM developments

For each category, find 2–4 items that are **new, recently accelerating, or newly production-ready** in the last 6–12 months.

### Step 2 — Score each item

For each item, assess:
- **Momentum**: Is adoption actually growing or is it hype?
- **Relevance**: Does it complement or replace something in the developer's current stack, or open a new capability?
- **Time-to-value**: Can skills transfer quickly, or is it a steep investment?

### Step 3 — Assign verdict

| Verdict | Meaning |
|---------|---------|
| **LEARN NOW** | High momentum, clear career value, transfers well to existing stack. Worth investing time in soon. |
| **WATCH** | Promising but early, niche, or uncertain — revisit in 3–6 months. |
| **SKIP** | Hype-heavy, low relevance, redundant with existing tools, or declining. |

### Step 4 — Output the radar report

Format:

```
## Tech Radar — [Month Year]

### [Category]

**[Technology Name]** — LEARN NOW / WATCH / SKIP
[1–2 sentence description of what it is.]
Relevant because: [why it matters given this developer's profile]
Verdict reason: [1 sentence on why this verdict]
References:
- [Official docs / GitHub](url)
- [Intro video or talk](youtube-or-conf-url)  ← include if a good one exists
- [Article or blog post](url)  ← prefer recent, high-signal posts (e.g. from the creator, a core team member, or a well-known practitioner)

---
```

**Reference guidelines:**
- Include 1–3 links per item. Don't pad with low-quality links.
- Prefer: official docs, GitHub repo, creator's blog post, a conference talk, or a well-known practitioner's writeup.
- For YouTube: link to a specific video (not a channel). Prefer talks under 30 min where possible.
- Only include links you found during research — do not fabricate URLs.

End the report with a **"Top 3 picks"** section — the three highest-signal items across all categories, with a one-line action for each (e.g. "Build a small project with X", "Read the docs for Y", "Bookmark Z's GitHub").

## Notes

- Prefer signal over volume: 12–18 well-researched items beats 30 shallow ones.
- If a user provides a focus area (e.g. "focus on AI tooling" or "just backend"), narrow the search accordingly.
- Always include the research date in the report header so it's clear when the snapshot was taken.
