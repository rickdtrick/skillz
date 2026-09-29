# skillz

Personal Claude Code skills. Each directory is one skill: a `SKILL.md` plus
optional `REFERENCE.md` / `EXAMPLES.md` companion files.

## Install

Files in this repo are hard-linked into `~/.claude/skills/`, so an edit here is live
immediately with no copy step. To add a new skill after creating its directory:

```bash
ln <skill-name>/SKILL.md ~/.claude/skills/<skill-name>/SKILL.md
```

## Skills

Run `ls -d */` for the current list, or `/<skill-name>` in Claude Code to invoke one.
Each skill's `description` frontmatter states what it covers and when it triggers —
that is the single source of truth; this file does not duplicate it.

`synced/` holds skills installed from elsewhere and is not maintained here.
