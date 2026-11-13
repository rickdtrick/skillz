# Weekly report

A Done / Doing / Next summary of the week. It reuses the daily signals (commits, PRs, uncommitted work) and adds three sources that catch work with no commits: PR reviews you gave, Claude Code sessions in the configured repos, and tracker tasks assigned to you.

Read SKILL.md's **Configuration** and **First-run setup** first. Everything below runs after configuration is in place.

## 1. Resolve the window

| Argument | Window |
|---|---|
| `week`, `this week`, `weekly` (default) | Monday 00:00 local → now |
| `last week` | previous Monday 00:00 → this Monday 00:00 |
| `week of <ISO date>` | the Monday on or before that date, for 7 days |

```bash
# macOS
SINCE=$(date -v-mon -v0H -v0M -v0S +%s)
# GNU
SINCE=$(date -d "$(date +%F) -$(( $(date +%u) - 1 )) days" +%s)
UNTIL=$(date +%s)
SINCE_DATE=$(date -r "$SINCE" +%F)          # GNU: date -d "@$SINCE" +%F
SINCE_ISO=$(date -u -r "$SINCE" +%FT%TZ)    # GNU: date -u -d "@$SINCE" +%FT%TZ
```

For `last week`, subtract 7 days from `SINCE` and set `UNTIL` to this Monday 00:00. `sessions.sh` takes epoch seconds, `git` takes `@$SINCE`, and `gh` takes `$SINCE_DATE`.

## 2. Collect signals

Run every repo in parallel. All steps are read-only.

### 2a. Commits, PRs, uncommitted work
Run SKILL.md step 2 with the weekly window. Git accepts `--since="@$SINCE"`.

### 2b. PR reviews you gave
```bash
gh search prs --reviewed-by=@me --repo "$OWNER_REPO" --updated ">=$SINCE_DATE" \
   --json number,title,url,state,author,updatedAt --limit 50
```
Drop PRs you authored. `--updated` also returns PRs you reviewed before the window, so confirm each one:
```bash
gh pr view <number> -R "$OWNER_REPO" --json reviews \
   --jq "[.reviews[] | select(.author.login == \"$ME\" and .submittedAt >= \"$SINCE_ISO\")] | length"
```
`$ME` is `gh api user --jq .login`. Keep PRs where the count is above 0.

### 2c. Claude Code sessions
```bash
<skill_dir>/sessions.sh "$REPO" "$SINCE" "$UNTIL"
```
It prints one JSON object per session that had a human prompt in the window, including sessions run from the repo's worktrees:

| Field | Use |
|---|---|
| `title` | Topic of the session |
| `branches` | Ticket IDs via the configured branch pattern |
| `prompts` | First three and last prompt, truncated. What you asked for. |
| `urls` | Tracker URLs in prompts. The ID is the last path segment, after any workspace segment (`/t/<workspace>/<id>`). |
| `mcp_ids` | IDs passed to MCP tools. Keep only values that match the ticket regex and came from tracker tools. |
| `tools` | Tool names and call counts. Shows what kind of work happened (tracker updates, Sentry triage, Figma, Slack). |
| `committed`, `opened_pr` | Whether the session wrote to git |
| `last_reply` | Last assistant message in the window. Says whether the work finished or stopped waiting on something. |

If `sessions.sh` prints nothing for a repo, that repo had no sessions this week. Skip it without a note.

### 2d. Tracker tasks assigned to you (ClickUp)
Skip if the tracker is `none` or isn't ClickUp. For other trackers, use the equivalent "assigned to me" search from the tracker's MCP.

1. Resolve your user ID once with `clickup_resolve_assignees(["me"])` and save it to `[[daily-report-format]]` as `Tracker user ID`.
2. Closed this week: `clickup_filter_tasks(assignees=[id], include_closed=true, date_closed_from=<Monday>)`.
3. Still open: `clickup_filter_tasks(assignees=[id], order_by="updated")`. Follow `next_page` until `has_more` is false.

Each task carries a status and a status type. Use the type, since status names differ per list: `closed` or `done` is finished, `custom` is in progress (in progress, code review, testing), and `open` is not started.

## 3. Attribute work to tickets

Build one entry per ticket, then one entry per non-ticket action.

1. **Primary ticket per session:** from `branches` (configured pattern), then `urls`. If neither yields an ID, use `mcp_ids` only when there is exactly one.
2. **Subtasks:** when a session touched many `mcp_ids` under one primary ticket (for example, moving 13 QA subtasks to testing), report the primary ticket once and mention the count. Don't give each subtask its own line.
3. **Merge:** a session and a commit or PR with the same ticket are one entry. The session adds context only.
4. **Non-ticket actions:** a session with no ticket, no commit, and no PR becomes its own entry. Merge sessions on the same topic. Skip sessions with one or two prompts that only asked a quick question and produced nothing to report.
5. **Enrich:** look up titles and statuses for primary tickets only (SKILL.md step 3). Reuse names already returned by `clickup_filter_tasks`. Ask before more than 30 lookups.

## 4. Assign each entry to one section

Each ticket appears in exactly one section. Take the first match:

| Signal in window | Section |
|---|---|
| A PR merged | Done |
| Tracker task closed (status type `closed` or `done`) | Done |
| PR reviews you submitted | Done, one line per repo |
| Session with no commit whose `last_reply` reports a finished outcome (file produced, ticket written or updated, root cause found, report delivered) | Done |
| An open PR (draft, WIP, or in review) | Doing |
| Commits with no PR, or uncommitted changes | Doing |
| Session whose `last_reply` ends waiting on something (plan awaiting approval, blocked, needs info) | Doing |
| Assigned tracker task, status type `custom`, updated this week | Doing |
| Assigned tracker task, status type `open` | Next |

**Next** holds at most 5 lines: open assigned tasks by priority, then due date. If fewer than 5 qualify, add the one concrete follow-up named in a Doing entry's `last_reply` (for example, "Get review on PR #96"). Don't repeat a Doing entry as-is.

## 5. Compose

```
**Week of Oct 5**

**Done**
- {ticket_link} {summary} ({label})
- Reviewed 3 PRs: #46 {title}, #37 {title}, #36 {title} ({label})
- {summary of a no-commit action} ({label})

**Doing**
- {ticket_link} {summary}, PR #96 in review ({label})

**Next**
- {ticket_link} {summary} ({label})
```

- Lead with the ticket link when there is one, using `{ticket_link}` from `[[daily-report-format]]`.
- `{label}` is the repo's label from `[[daily-report-repos]]`, or the repo directory name when it has no label.
- Summaries are 12 words or fewer. Done lines are past tense and start with a verb ("Fixed", "Shipped", "Investigated").
- Order Done and Doing by label, then ticket. Order Next by priority.
- Omit an empty section. If all three are empty: `No tracked activity for the week of {Monday}.`
- Emit standard markdown, as in the daily report.

**Privacy:** session prompts and replies can hold customer names, Slack links, and local paths. Summarize the action. Never copy prompt text, URLs other than ticket and PR links, or file paths into the report.

## 6. Preview and deliver

Same as SKILL.md steps 5 to 7. The target is `[[daily-report-delivery]]`'s `weekly:` entry if one is set, otherwise the daily target. The preview step is where you can drop sessions that weren't work for this report.
