---
name: deep-dive
description: Deep, multi-session mastery of a topic with workspace scaffolding, concept maps, project milestones, and spaced repetition. Use when the user wants genuine long-term retention and depth beyond a quick explanation — e.g. "I want to really understand monads", "teach me data-oriented design properly", "help me get good at system design interviews over the next month". Generates the entire course in one go, then teaches it session by session. Not for quick answers or one-off tutoring.
---

# Deep Dive

## Overview

Deep Dive builds a self-study course inside a **workspace**, then walks you through it session by session. Two modes:

- **Build** — research the whole topic and generate every lesson in one pass. This is the default when starting fresh.
- **Teach** — run one session against a workspace that already exists. Never re-generates lessons.

## Quick Start

1. **Ask the kickoff questions** — format and location. Always first, before any research or file writes.
2. **Ask about the mission** — why, what success looks like, constraints.
3. **Build** the whole course in one go, then hand off to the Teach phase.

## Kickoff

Always ask these two before anything else, in a single message. Do not create directories or write files until both are answered.

### 1. Format

Ask: **Markdown or HTML?**

- **Markdown** (default) — fast to write, diff-able, editable anywhere, renders on GitHub/Obsidian/any static site generator.
- **HTML** — self-contained and printable, styled properly, can ship interactive JS (auto-graded quizzes, runnable snippets, collapsibles).

Recommend **Markdown** unless the user wants something beautiful to read and re-read, or wants interactive widgets. Store the choice in `MISSION.md` frontmatter — never ask twice.

### 2. Location

Ask: **where should the course live?**

- Default: `./{topic-slug}-deep-dive` in the current directory
- Offer: `~/deep-dives/{topic-slug}`, inside an existing notes repo, or a path the user names

Echo the resolved absolute path back to the user before writing anything.

### Resuming

If a workspace already exists, read the `format` and `location` from `MISSION.md` frontmatter and skip both questions unless the user asks to change something.

## Workspace Structure

```
{workspace}/
├── MISSION.md          # why, success criteria, constraints + format config in frontmatter
├── CURRICULUM.md       # the full lesson plan: tracks, order, dependencies
├── PROGRESS.md         # where we are (updated every session)
├── CONCEPT-MAP.md      # concepts and how they relate
├── GLOSSARY.md         # canonical terms (added as concepts are demonstrated)
├── REFERENCES.md       # curated, annotated sources
├── learning-records/   # 0001-slug.md — insights, corrected misconceptions
├── lessons/            # 0001-slug.md or 0001-slug.html
└── projects/           # 000N-slug.md — application challenges
```

## Build Phase — generate the whole course in one go

Run steps 1–6 without stopping, then hand off to the Teach phase.

### 1. Research the whole topic

For every lesson you plan to write, find **3+ authoritative sources** (official docs, papers, books, expert posts) using Context7 and web search. Extract the canonical definition, a concrete example, edge cases, common mistakes, and counter-examples. Never rely on parametric knowledge alone.

Add every source to `REFERENCES.md` with a `Use for:` annotation as you go. If a concept has no authoritative source, mark it `[uncertain]` in the concept map rather than inventing one.

### 2. Map the territory

Write `CONCEPT-MAP.md` — concepts as nodes with `Depends on:` / `Opens up:` edges and a status. Use a Mermaid diagram when the relationships are non-trivial.

### 3. Plan the curriculum

Write `CURRICULUM.md`: ordered tracks, one line per lesson (title, what the learner can do afterwards, concepts covered, prerequisite lesson), and where each project lands. Keep each lesson scoped to **one concept, completable in a single session**. This is the contract you generate against — do not deviate without updating it.

### 4. Write every lesson

Generate **all** lessons in one pass, numbered in curriculum order, in the format chosen at kickoff. Every lesson must:

- Explain one concept, scoped to a single session
- Cite **every claim** inline to a source in `REFERENCES.md`
- Include an **interactive element** — quiz, fill-in-the-blank, prediction exercise, or a snippet to run
- End with a **comprehension check** — 1–3 questions the learner answers
- Link back to the concept map, and to the glossary for every term used
- Close with an "ask your agent" prompt

Report progress as you go (`lesson 3/12 …`) so long builds don't look stalled.

### 5. Scaffold projects

For every 3+ lessons on a sub-topic, write a `projects/` challenge that forces application of that material and ties to the mission. Include goal, requirements, success criteria, spoiler-wrapped hints, and a timebox. Build all of them now — don't gate on the learner having finished the lessons.

### 6. Seed the tracking files

- `PROGRESS.md` — nothing completed, current focus = lesson 0001, up next = lesson 0002
- `GLOSSARY.md` — header only. Terms are added during teaching, never pre-populated
- `CONCEPT-MAP.md` — every concept `planned`
- `learning-records/` — empty

Then report the lesson count, the format, and the path, and ask whether to start the first session.

## Teach Phase — one session at a time

Run exactly one cycle per session. This phase reads whatever lessons already exist on disk and never regenerates them.

1. **Retrieval warm-up** — 2–3 questions from prior lessons (spaced repetition). Wrong answers mean revisit before advancing.
2. **Update `PROGRESS.md`** — mark completed, set current focus.
3. **Map** — show where today's concept sits in `CONCEPT-MAP.md`.
4. **Teach** — work through the lesson file with the learner.
5. **Check** — the comprehension questions from the lesson.
6. **Record** — write a `learning-records/` entry for breakthroughs and corrected misconceptions.
7. **Glossary** — add terms only the learner has demonstrated understanding of.
8. **Set next** — one sentence in `PROGRESS.md` about the next session.

Mark a concept `learned` in the map only after the learner explains it back unprompted.

## Lesson Formats

Full specs in `REFERENCE.md`. In short:

- **Markdown** — frontmatter (lesson number, concept-map link, prereqs, status, source keys) plus a body with inline citations, an interactive element behind a `<details>` answer key, a comprehension check, and an "ask your agent" prompt.
- **HTML** — one self-contained file: inline `<style>`, optional inline `<script>` for interactive elements, no external assets, prints cleanly to PDF.

## Constraints

- Never ship a lesson you haven't researched first — minimum 3 sources per concept
- Never generate a lesson in a format different from the one chosen at kickoff
- Never pre-populate `GLOSSARY.md` — terms are earned, not given
- Never mark a concept `learned` without a passed comprehension check
- Never mix formats inside a single workspace
- Keep each lesson to one concept, completable in a single session
- References must be real: author, title, URL. If you can't find one, say so
