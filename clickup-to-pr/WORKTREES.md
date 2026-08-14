# Worktrees: one ticket, one tree

Multiple tickets never share a working tree. Each ticket gets its own git worktree under `.worktrees/<TASK_ID>/` with its own branch, so builds, node_modules state, and dirty files can't leak between tickets — and a **second Claude session working on the same repo can run at the same time without collision**.

## Layout

```
~/Projects/careers/              # main tree, stays on main and stays clean
  .worktrees/
    86exr740d/                   # branch rick/86exr740d-fix-alert-copy
    86exr8f2p/                   # branch rick/86exr8f2p-add-consent-field
```

## One-time setup per repo

`.worktrees/` must be ignored. Prefer the local, non-committed exclude so no repo change is needed:

```bash
grep -qxF '.worktrees/' .git/info/exclude || echo '.worktrees/' >> .git/info/exclude
```

If the repo already ignores it in `.gitignore`, leave that alone.

## Creating a worktree

```bash
git fetch origin
git worktree add .worktrees/<TASK_ID> -b <branch-name> origin/main
```

- `<branch-name>` follows the repo's existing convention (check `git branch -a`), e.g. `rick/<task-id>-<short-slug>`.
- For a **stacked** ticket, base it on the parent's branch instead of `origin/main`:
  ```bash
  git worktree add .worktrees/<TASK_ID> -b <child-branch> <parent-branch>
  ```
- Install deps in the new tree if the project needs per-tree `node_modules` (`npm ci` / `pnpm install`). Nx caches are shared via the repo root, so this is usually fast.

Run every command for a ticket (`nx build`, `nx test`, `git diff`, `git commit`, `gh pr create`) **from inside that worktree directory**.

## Concurrent sessions: claim before you use

Another session may already own a worktree or branch for the ticket. Before creating anything:

```bash
git worktree list          # existing trees and their branches
git branch -a | grep <TASK_ID>
```

Rules:
- **Path or branch already exists and you didn't create it in this session → stop and ask the user.** Do not reuse, reset, or delete it. Another session may be mid-flight, and `git worktree add` on a checked-out branch fails anyway.
- Only ever `git commit`, `git push`, or `git worktree remove` inside worktrees this session created.
- Never `git checkout` in the main tree while worktrees are live — that's what caused the collision the worktrees exist to prevent.
- If a worktree directory exists but `git worktree list` doesn't show it (stale from a killed session), run `git worktree prune` first, then report it to the user before recreating.

## Cleanup

After a PR is merged, or when the user says the ticket is done:

```bash
git worktree remove .worktrees/<TASK_ID>
git branch -d <branch-name>          # only after merge
git worktree prune
```

Do not remove a worktree with uncommitted changes. `git worktree remove` refuses by default — never pass `--force` without asking.
