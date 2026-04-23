# skillz

Custom skills for opencode CLI.

## Available Skills

- **code-review** - Code review best practices (security, performance, maintainability)
- **qa** - QA and testing best practices

## Setup

Symlink to opencode's skills directory. Replace `<path-to-skills>` with your actual skills folder path:

```bash
ln -s <path-to-skills> ~/.config/opencode/skills
```

For example, if your skills repo is at `~/Projects/skills`:

```bash
ln -s ~/Projects/skills ~/.config/opencode/skills
```

Or if you already have a skills symlink, update it:

```bash
rm ~/.config/opencode/skills
ln -s <path-to-skills> ~/.config/opencode/skills
```

## Usage

When working on a task that matches a skill, opencode will automatically load it:
- `code-review` skill - when reviewing code for security, performance, and best practices
- `qa` skill - when writing tests or ensuring code quality
