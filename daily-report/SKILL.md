---
name: daily-report
description: Produce a single consolidated stand-up report across the user's configured repos for a given day — git commits, ticket IDs from branch names, PR states, and uncommitted work — then deliver it via the user's chosen channel (terminal, Slack, Discord, PDF, etc.). Use when the user wants a daily/end-of-day summary, "what did I ship today", or stand-up notes. Runs from any directory. Defaults to today; accepts `yesterday`, `last N days`, or an ISO date. On first invocation, asks the user for the repo list, line format, and delivery target and saves them to local memory.
---

# Daily Report

A repo-agnostic, tracker-agnostic, delivery-agnostic daily report skill. All user-specific configuration lives in local memory; nothing organization-identifying is hard-coded here.

## Configuration (read on every run)

Pull these from local project memory:

- `[[daily-report-repos]]` — absolute paths to the repos to scan.
- `[[daily-report-format]]` — the line template + ticket-tracker URL pattern + status labels.
- `[[daily-report-delivery]]` — where the report goes (terminal, Slack, Discord, PDF file, etc.).

If **any** of these are missing, run the **First-run setup** below before continuing.

## First-run setup (only when memory is missing)

Ask the user the following, then save each answer as the corresponding memory above. Don't proceed to the report until they're all set.

### Q1 — Repos to scan
> "Which local repos should this report cover? Give me absolute paths, one per line."

Validate each path exists and is a git repo. Skip and warn for any that aren't.

### Q2 — Report format
Show the defaults below and ask: **"Use these defaults, or customize?"** Only drill into the sub-questions if they want to customize.

**Defaults:**
- Line template: `- {ticket_link} {summary} [{status}]`
- Tracker URL pattern: ask the user (no portable default). Examples: `https://app.clickup.com/t/{id}`, `https://linear.app/{workspace}/issue/{id}`, `https://github.com/{owner}/{repo}/issues/{id}`. They can also say `none` to skip ticket enrichment.
- Tracker MCP tool: derived from the URL host. ClickUp → `mcp__claude_ai_ClickUp__clickup_get_task`, Linear → search via `ToolSearch linear get issue`, GitHub Issues → `mcp__github__get_issue`. Store the resolved tool name in `[[daily-report-format]]` so the runtime doesn't have to re-search.
- Branch-name pattern: take the segment between the first `/` and the next `-` (matches `<prefix>/<id>-<slug>`, `feature/<id>-...`, etc.).
- Status labels: `DONE` / `CODE REVIEW` / `WIP`.

**Available placeholders:** `{id}`, `{ticket_link}`, `{summary}`, `{status}`, `{pr_url}`, `{repo}`.

If they customize, ask one focused question at a time (URL pattern → branch pattern → labels → template). Save each answer to `[[daily-report-format]]` as you go.

### Q3 — Delivery target
> "Where should the report go?"

Options:
- `terminal` — print only, no external delivery.
- `slack:<channel-or-id>` — post via Slack MCP (kicks off OAuth if not yet authorized).
- `discord:<channel-id>` — post via Discord MCP.
- `pdf:<path>` — render to a PDF at the given path.
- Any other channel the user has an MCP for — use `ToolSearch` to find a `send`/`post` tool that matches.

Whatever they pick, save it verbatim. The runtime resolves the right tool at delivery time.

## Workflow (after configuration is in place)

### 1. Resolve the date range
- `today` (default) → midnight local → now.
- `yesterday` → previous midnight → midnight today.
- `last N days` → N×24h window ending now.
- ISO date → that calendar day in local TZ.

Compute `SINCE` and `UNTIL` as ISO 8601 strings.

### 2. For each configured repo, collect signals
Use `git -C <repo>` so the skill works from any cwd. Run repos in parallel where possible.

**Commits:**
```bash
git -C "$REPO" log --author="$(git -C "$REPO" config user.email)" \
    --since="$SINCE" --until="$UNTIL" \
    --pretty=format:'%h%x09%s%x09%D' --all
```

Extract ticket IDs using the configured branch-name pattern and from commit subjects (the configured tracker regex, if any).

**Open/recent PRs:**
```bash
gh -R <owner>/<repo> pr list --author "@me" --state all \
   --json number,title,url,state,createdAt,updatedAt,headRefName,mergedAt,isDraft \
   --limit 50
```

Derive `<owner>/<repo>` from the remote URL. Handles HTTPS, SSH, and SSH host aliases; repo names may contain dots:

```bash
OWNER_REPO=$(git -C "$REPO" remote get-url origin \
  | sed -E 's#\.git$##; s#.*[:/]([^/]+/[^/]+)$#\1#')
```

Filter to PRs whose `createdAt`, `updatedAt`, **or** `mergedAt` falls inside the window.

**Uncommitted local work:**
```bash
git -C "$REPO" status --short
git -C "$REPO" diff --stat
```
Capture file count and a one-line summary. Do **not** include the full diff.

### 3. Enrich tickets (skip if tracker URL pattern is `none`)
Call the tracker MCP tool stored in `[[daily-report-format]]` (resolved during first-run setup). If the memory only has the URL pattern and not the tool name, derive the tool name from the host:

- `app.clickup.com` → `mcp__claude_ai_ClickUp__clickup_get_task`
- `linear.app` → `ToolSearch select:<linear-get-issue-tool>` (load first, then call)
- `github.com` → `mcp__github__get_issue`
- Anything else → `ToolSearch` with `<tracker-name> get task` / `get issue` and pick the closest match. Save the resolved tool name back to `[[daily-report-format]]` so future runs skip the search.

For each unique ticket ID, call the resolved tool. Capture title, status, priority. Dedupe by ID. Failed lookups → mark `(not found)` and continue.

If unique IDs > 20, ask the user before fanning out (cost guardrail).

### 4. Compose the consolidated report

One message. Flat list, one line per ticket, using the user's configured format template.

#### Status derivation (per ticket)
Pick the **highest-progress** state across everything tied to that ticket in-window. Evaluate top-to-bottom and take the first match:

| Signal in window | Status |
|---|---|
| Any PR is **merged** | `DONE` |
| Any PR is open and the title contains `[WIP]`, `WIP:`, or `(WIP)` (case-insensitive) | `WIP` |
| Any PR is open as a draft (`isDraft: true`) | `WIP` |
| Any PR is open and non-draft | `CODE REVIEW` |
| Commits exist but no PR yet, or only uncommitted local changes | `WIP` |

The `[WIP]`-in-title override exists because many teams use draft state for "not ready to push" and a `[WIP]` title prefix for "open but not ready to review."

Tie a PR to a ticket by matching the ID in the PR's `headRefName` or title/body.

#### Final message shape (using the default format)
```
- {ticket_link} {summary} [DONE]
- {ticket_link} {summary} [CODE REVIEW]
- {ticket_link} {summary} [WIP]
```

No date/title header by default — chat platforms timestamp the message themselves. If the user has explicitly opted into a header line via `[[daily-report-format]]`, prepend it; otherwise omit.

Always emit **standard markdown** (`**bold**`, `[label](url)`, `_italic_`). The delivery MCP handles platform-specific translation (Slack-native, Discord-native, etc.). Don't pre-translate — that breaks MCPs that expect standard markdown.

Order entries: `DONE` first, then `CODE REVIEW`, then `WIP`.

If no tickets land in any status, the message is a single line: `No tracked activity for {date}.`

Footer (only when applicable): `_Skipped repos (missing on disk): <count>_` — give a count, not the paths.

#### Edge cases
- Commits/PRs with no extractable ticket ID → group under a final `- no-ticket: <summary> [STATUS]` line (plain text prefix, not a markdown link). Do not invent IDs.
- Same ticket touched in multiple repos → one line; include `{repo}` placeholder content in the summary for disambiguation.

### 5. Preview in the terminal (always)
Print the full composed message inside a fenced block.

If `delivery = terminal`: stop here. The preview *is* the delivery. No confirmation prompt.

For all other delivery targets, ask:

> Send this to `<delivery target>`? (yes / no / edit)

- `no` → stop.
- `edit` → ask what to change, revise, re-preview, ask again.
- `yes` → proceed to step 6.

Never deliver to an external target until the user has answered `yes` to the current version.

### 6. Deliver (only after explicit "yes")
Dispatch based on `[[daily-report-delivery]]`:

- **`terminal`** — already shown in the preview; print a separator and a "Done." line.
- **`slack:<channel>`** — load a Slack send tool via `ToolSearch slack send`. If none load, run the Slack MCP OAuth flow first (`authenticate` → share URL → `complete_authentication`), then re-search. Post to `<channel>`.
- **`discord:<channel-id>`** — load a Discord send tool via `ToolSearch discord send`. Post to `<channel-id>`.
- **`pdf:<path>`** — render the markdown to PDF (e.g. via `pandoc` if available, else fall back to writing the markdown file alongside and tell the user).
- **Other** — `ToolSearch` for a tool matching the prefix, use the closest send/post primitive.

On any delivery failure, print the message to stdout and tell the user it wasn't delivered.

### 7. Confirm and stop
One-line receipt: `Delivered to <target> ({permalink if available})` or `Printed to terminal (<target> unavailable)`. No follow-ups, no scheduling.

## Stop conditions
- Configuration memory is missing **and** the user declines to set it → stop.
- All configured repo paths missing on disk → report the error, stop.
- Ticket fan-out > 20 → confirm before proceeding.
- User declines an MCP OAuth flow → fall back to terminal output.

## Notes
- Local timezone for date math.
- Read-only: no `git` writes, no ticket updates, no `gh pr edit`.
- Commit author email is **not** a filter — the configured repo list is the work-vs-personal discriminator.
- All organization/identity specifics live in the user's local memory, not in this skill.
