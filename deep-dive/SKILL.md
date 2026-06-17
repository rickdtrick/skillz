---
name: deep-dive
description: Deep, multi-session mastery of a topic with workspace scaffolding, concept maps, project milestones, and spaced repetition. Use when the user wants genuine long-term retention and depth beyond a quick explanation — e.g. "I want to really understand monads", "teach me data-oriented design properly", "help me get good at system design interviews over the next month". Not for quick answers or one-off tutoring.
---

# Deep Dive

## Overview

Deep Dive is a structured, multi-session teaching workflow. It uses a **workspace** to track what you know, what you're learning, and what's next. Sessions are grounded in a **mission** and follow a **research → map → lesson → apply → review** cycle.

## Quick Start

When the user says they want to learn something deeply:

1. If no workspace exists: ask about their **mission** (why, what success looks like, constraints), then create the workspace
2. If a workspace exists: read `MISSION.md`, `PROGRESS.md`, and check the `learning-records/` and `maps/` directories to determine the zone of proximal development
3. Run one full teaching cycle per session

## Workspace Structure

```
topic-deep-dive/
├── MISSION.md          # Why they're learning, success criteria, constraints
├── PROGRESS.md         # Overview of where we are (updated every session)
├── CONCEPT-MAP.md      # Evolving map of concepts and their relationships
├── GLOSSARY.md         # Canonical terms (populated as concepts are learned)
├── REFERENCES.md       # Curated, annotated resources (knowledge & communities)
├── learning-records/   # 0001-slug.md — key insights, corrected misconceptions, milestones
├── lessons/            # 0001-slug.html — beautiful self-contained single-concept lessons
└── projects/           # Real-world application challenges tied to mission
```

## Teaching Cycle

Each session runs through these phases:

### 1. Research (before teaching)
For every sub-topic you plan to teach, find **3+ authoritative sources** (docs, papers, books, expert posts) using Context7 or web search. Extract specific facts, code snippets, and citations. Do not rely on parametric knowledge alone.

### 2. Map the territory
Check or update `CONCEPT-MAP.md`. Before teaching a new concept, show how it fits into the existing map. Use a short Mermaid diagram if the relationships are complex.

### 3. Teach the lesson
Create one `lessons/000N-slug.html` file per session. A lesson must:
- Cite **every claim** to a source in `REFERENCES.md` (inline links)
- Include an **interactive element**: quiz, live coding prompt, or step-by-step exercise with a feedback loop
- End with a **comprehension check** — 1–3 questions the user answers before the session ends
- Be **beautiful** — clean typography, printable, the user will revisit it

### 4. Apply through projects
When the user has enough foundation (3+ lessons on a sub-topic), create a `projects/` challenge that forces them to apply it. The project should map directly to their mission.

### 5. Review and solidify
Every session begins with a **retrieval warm-up**: 2–3 questions from previous lessons (spaced repetition). If they answer correctly, record it in `learning-records/`. If they don't, revisit the concept before advancing.

## Phase Details

### Research Phase
- For each concept, collect: canonical definition, concrete example (code, diagram, scenario), edge cases / common mistakes, and counter-examples
- Add every source to `REFERENCES.md` with a `Use for:` annotation
- If a concept has no authoritative source you can find, note it in `CONCEPT-MAP.md` as a `[uncertain]` node

### Map Phase
`CONCEPT-MAP.md` uses this format:
```md
## Core
- **Concept A** — definition. Depends on: —. Opens up: Concept B, Concept C. Status: learned | in-progress | planned
## Depends on
- **Concept 0** — prerequisite for A. Status: learned
```

### Lesson Phase
Each lesson HTML must include:
- Title, mission link, concept-map context
- Explanations with inline `[source]` citations
- Interactive element (code block to run, quiz, fill-in blanks)
- "Ask your agent" reminder at the bottom
- Reference to the glossary for any terms used

### Project Phase
A project spec at `projects/NNN-slug.md` contains:
- Goal tied to mission
- Requirements in plain language
- Success criteria (how the user knows they're done)
- Hints (rot13'd or behind a spoiler) — only revealed if stuck
- Suggested timebox

## Session Flow

1. **Retrieval warm-up** — 2–3 questions from prior lessons
2. **Update PROGRESS.md** — mark completed items, note what's next
3. **Research** — collect sources for today's topic
4. **Map** — update or review `CONCEPT-MAP.md`
5. **Teach** — create the lesson, work through it with the user
6. **Check** — comprehension questions
7. **Record** — write learning record for any breakthrough or corrected misconception
8. **Set next** — one sentence in `PROGRESS.md` on what the next session covers

## Constraints

- Never teach a concept you haven't researched first (minimum 3 sources)
- Never advance past a concept the user can't explain back to you
- Keep lessons tightly scoped — one concept, completable in a single session
- `GLOSSARY.md` terms are only added when the user demonstrates understanding, not when introduced
- If a session ends without a comprehension check, do not mark the concept as learned
- References must be real: author, title, URL. If you can't find one, say so.
