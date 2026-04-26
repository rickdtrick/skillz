---
name: write-a-skill
description: Create new agent skills with proper structure, progressive disclosure, and bundled resources. Use when user wants to create, write, or build a new skill.
---

# Writing Skills

## Process

1. **Gather requirements** - ask about:
   - What task/domain does the skill cover?
   - What specific use cases should it handle?
   - Does it need executable scripts or just instructions?
   - Any reference materials to include?

2. **Assess usefulness** — before drafting, evaluate whether a skill is actually warranted:
   - If the agent can handle this task well with no extra guidance (e.g. "write a commit message", "explain this code"), say so and recommend against creating a skill
   - A skill is worth creating when: the task has a non-obvious process, requires a specific output format, needs domain knowledge the agent wouldn't have by default, or will be invoked repeatedly with consistent expectations
   - If borderline, flag the concern and let the user decide

3. **Draft the skill** - create:
   - `SKILL.md` with concise instructions (under 100 lines)
   - Additional reference files if content exceeds 100 lines
   - Utility scripts if deterministic operations are needed

4. **Review with user** - confirm:
   - Does this cover your use cases?
   - Anything missing or unclear?

## Skill Structure

```
skill-name/
├── SKILL.md           # Main instructions (required)
├── REFERENCE.md       # Detailed docs (if needed)
├── EXAMPLES.md        # Usage examples (if needed)
└── scripts/           # Utility scripts (if needed)
```

## SKILL.md Template

```md
---
name: skill-name
description: Brief description. Use when [specific triggers].
---

# Skill Name

## Quick start
[Minimal working example]

## Workflows
[Step-by-step processes]

## Advanced features
[Link to separate files if needed]
```

## Description Requirements

The description is the **only thing the agent sees** when deciding to load this skill. Make it specific.

- Max 1024 chars, written in third person
- First sentence: what capability it provides
- Second sentence: `Use when [specific triggers]`

Good: `Extract text and tables from PDF files. Use when working with PDFs, forms, or document extraction.`
Bad: `Helps with documents.`

## When to Add Scripts

Add scripts when the operation is deterministic (validation, formatting) or the same code would be generated repeatedly.

## Review Checklist

- [ ] Description includes "Use when..." triggers
- [ ] SKILL.md under 100 lines
- [ ] No time-sensitive info
- [ ] Concrete examples included
- [ ] Split into separate files if content is large
