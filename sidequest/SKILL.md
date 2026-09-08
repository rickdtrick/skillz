---
name: sidequest
description: Capture topics to learn later without breaking focus during a session. Use when the user says "sidequest", "bookmark this to learn", "add to sidequest", or encounters a term/concept they want to understand later. Creates quick-read MD files using teach-me-senpai and maintains a checklist.
---

# Sidequest

Capture learning topics mid-session without losing focus. Save them for later and generate quick-read MD files with teach-me-senpai.

## Initial Setup (first time only)

1. **Ask save directory** — "Where should I save your sidequests? (e.g. `~/notes/sidequests`, `./sidequests`)"
2. **Create checklist** — create `SIDELIST.md` in that directory with this structure:

```md
---
title: Sidequest Checklist
---

# Sidequests

| # | Topic | Created | Status | File |
|---|-------|---------|--------|------|
```

3. **Confirm** — tell the user where their sidequest hub lives

## Capturing a Sidequest

When the user flags something to learn later:

1. **Capture topic** — what term, concept, or thing they want to learn
2. **Capture context** — pull the relevant surrounding context from the current conversation. Ask:
   - "What were you working on when this came up?"
   - "Any specific angle? (e.g. 'how does X relate to Y')"
3. **Save the sidequest MD file** — `{save_dir}/YYYY-MM-DD-{slug}.md` with:

```md
---
title: "{topic}"
created: {date}
status: pending
---

# {Topic}

## Context

{what the user was working on and why this matters}

## Quick Read

{1-2 sentence summary — what is this thing in plain language? just enough to know if you want to go deeper}

## Learn More

{teach-me-senpai content goes here when the user is ready}
```

4. **Update checklist** — append a row to `SIDELIST.md`:
```
| {n} | {topic} | {date} | pending | [{filename}]({filename}) |
```

5. **Confirm** — "Sidequest added: {topic}. Back to what you were doing?"

## Generating a Sidequest (learning time)

When the user wants to actually learn a sidequest topic:

1. **Load the sidequest MD** — read the file to get topic and context
2. **Call teach-me-senpai** — invoke the teach-me-senpai skill with:
   - The topic
   - The context from the sidequest file (so it knows the angle)
   - "Beginner" depth unless user says otherwise
3. **Update the sidequest MD** — after teach-me-senpai produces content, append the full lesson, references, and summaries to the existing MD file. Change status to `completed` in frontmatter.
4. **Update checklist** — change status column to `done` (or strikethrough if preferred)

## Listing Sidequests

When user says "sidequests" or "what's on my list":

- Read `SIDELIST.md` and display the table
- Highlight any `pending` ones

## Notes

- Keep it lightweight — sidequests are quick reads, not deep dives
- MD files are self-contained; each has context + summary + references
- Always use teach-me-senpai for generating the actual learning content
- References must be real, working links
- The checklist is the single source of truth for what exists
