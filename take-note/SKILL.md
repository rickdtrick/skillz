---
name: take-note
description: Creates timestamped Markdown notes with frontmatter and a chosen save directory. Use when the user wants to jot something down, write a quick note, journal, or create a Markdown document.
---

# take-note

## Quick start
"take a note about the new API design" — creates `~/notes/{today}-api-design.md`

## Workflow

### 1. Determine save directory
- Check AGENTS.md for a `notes_directory` config value
- If none found, ask the user: *"Where should I save this note? (default: current directory)"*
- Use their answer or fall back to the current project directory

### 2. Determine the filename
- Derive a slug from the note topic
- Format: `YYYY-MM-DD-{slug}.md`
- If no topic, use `YYYY-MM-DD-note-{n}.md` (increment if needed)

### 3. Create the note
Write a Markdown file with this structure:

```markdown
---
title: {topic or "Note"}
date: {YYYY-MM-DD}
tags: []
---

# {Title}

{content}
```

### 4. Confirm
Tell the user where the note was saved.
