---
name: sentry-cleanup
description: Check Sentry errors, investigate grouped issues, and create tickets in ClickUp or GitHub Issues with severity labels and tags. Use when reviewing application errors, triaging Sentry backlog, cleaning up before a release, or creating bug tickets from recurring Sentry events.
---

# Sentry Cleanup

## Quick Start

1. **Log usage** — append one JSONL line to `~/.claude/skills/_usage.jsonl`:
   `{"skill":"sentry-cleanup","ts":"<ISO timestamp>","project":"<repo name>","outcome":"<summary>","duration_min":<minutes>}`
2. Get Sentry auth token (ask user or check `SENTRY_AUTH_TOKEN`) + org slug
3. Fetch unresolved issues from Sentry API
4. Investigate each error group
5. Ask: ClickUp (default) or GitHub Issues?
6. Create tickets with severity labels and tags

## Fetch Errors

Use [tavily_tavily_extract] or `webfetch` to call the Sentry API:

```
GET https://sentry.io/api/0/organizations/{org_slug}/issues/?statsPeriod=24h&query=is:unresolved
Authorization: Bearer {token}
```

Paginate if `count > 100` (`?cursor=` param in response headers). Capture: `id`, `title`, `level`, `count`, `userCount`, `firstSeen`, `lastSeen`, `permalink`, `culprit`, `shortId`, `type`.

## Investigate Per Group

For each unique `id`, fetch full details:

```
GET https://sentry.io/api/0/issues/{id}/
```

Examine:
- **Stack trace** — root cause file/function/line
- **Event trend** — spiking or steady?
- **User count** — blast radius
- **First seen vs last seen** — new outbreak or old noise
- **Tags** — browser, environment, release (narrows scope)

## Severity Matrix

| Label        | Criteria |
|--------------|----------|
| **critical** | Data loss, auth/payment broken, 500+ users in 24h |
| **high**     | Core feature broken, 100+ users, uncaught exception in prod |
| **medium**   | Non-critical feature, <100 users, caught/logged error |
| **low**      | Cosmetic, edge case, dev/staging only, 0 users |

## Create Tickets

### ClickUp (default)
1. Ask for ClickUp API token (or check `CLICKUP_API_TOKEN`) and list ID
2. `POST https://api.clickup.com/api/v2/list/{list_id}/task`
   - `name`: error title
   - `description`: investigation summary + Sentry permalink + stack trace
   - `priority`: 1=critical, 2=high, 3=medium, 4=low
   - `tags`: `["sentry", "bug", "{environment}"]`

### GitHub Issues
Use `github_issue_write` with:
- `title`: error message
- `body`: investigation summary + Sentry permalink
- `labels`: `["sentry", "bug", "severity/{level}"]`

## Ticket Body Template

```
**Source:** [Sentry]({permalink})
**Severity:** {level}
**Environment:** {tags.environment}
**Release:** {tags.release}
**Affected Users:** {userCount}
**Events (24h):** {count}

### Investigation
- **Error:** {title}
- **Location:** {culprit}
- **Type:** {type}

### Stack Trace
```
{excerpt}
```

### Suggested Action
{quick root-cause assessment}
```

## Default Behavior

- Group by Sentry `id` (fingerprint is built-in)
- Confirm before creating each ticket (batch review)
- If errors are related (same component/flux), offer to consolidate into one ticket
- Respect rate limits: Sentry 500 req/min, ClickUp 100 req/min

## Usage Tracking

Every skill invocation appends a JSONL line to `~/.claude/skills/_usage.jsonl`:

```json
{"skill":"sentry-cleanup","ts":"2026-07-08T11:00:00Z","project":"skillz","outcome":"3 tickets via ClickUp","duration_min":12}
```

To visualize usage, read `_usage.jsonl` and generate a Mermaid chart. The agent supports three views:

| View | Diagram | Command |
|------|---------|---------|
| **Distribution** | Pie — proportion of total use per skill | `pie title Skill Usage` with summed counts per skill |
| **Timeline** | Gantt — each skill invocation as a task bar | `gantt title Skill Usage Timeline` with dateFormat and one task per entry |
| **Frequency** | XY bar — usage count per skill over last N days | `xychart-beta` with bar data per skill label |

To render, ask the agent: *"Show me skill usage as a {pie|gantt|bar} chart"*. The agent reads `_usage.jsonl`, aggregates, generates Mermaid code, and renders it via `mermaid_validate_and_render_mermaid_diagram`.
