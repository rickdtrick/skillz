# Deep Dive Reference

## Workspace File Formats

### MISSION.md
```
# Mission: {Topic}
## Why
{1–3 sentences. Concrete real-world goal.}

## Success looks like
- {Observable outcome}
- {Another outcome}

## Constraints
- {Time, budget, prior commitments}

## Out of scope
- {Adjacent topics not chasing right now}
```

### PROGRESS.md
```
# Progress: {Topic}

## Completed
- LR-0001: {concept} (2025-01-15)
- Lesson 0001: {title} (2025-01-15)

## Current focus
{What we're working on this session}

## Up next
{What the next session will cover}
```

### CONCEPT-MAP.md
```
## {Sub-topic}
- **Concept** — {one-line definition}. Depends on: {prereq}. Opens up: {next}. Status: learned | in-progress | planned | uncertain
```

### GLOSSARY.md
```
## {Term}
{1–2 sentence definition. What it IS, not what it does.}

_Avoid_: {synonyms to discourage}
```

### REFERENCES.md
```
## Knowledge
- [Type: Title — Author](URL)
  Use for: {when to reach for this}

## Wisdom (Communities)
- [Name](URL) — {what it's good for}

## Gaps
- {Missing resources needed for mission}
```

### Learning Record (`learning-records/0001-slug.md`)
```
# {Title}
{1–3 sentences: what was learned, why it matters for future sessions.}
```
Optional frontmatter: `Status: superseded by LR-NNNN`

### Lesson (`lessons/0001-slug.html`)
A single, self-contained HTML file. Must cite every claim. Include at minimum: title, explanation with citations, interactive element, comprehension check, "ask your agent" prompt.

### Project (`projects/0001-slug.md`)
```
# {Title}
## Goal
{Link to mission}
## Requirements
- {list}
## Success criteria
- {how to verify}
## Hints
<details><summary>Hint 1</summary>{hint}</details>
## Timebox
{recommended duration}
```
