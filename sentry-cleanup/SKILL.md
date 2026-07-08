---
name: sentry-cleanup
description: Check Sentry errors, investigate grouped issues, and create tickets in ClickUp or GitHub Issues with severity labels and tags. Use when reviewing application errors, triaging Sentry backlog, cleaning up before a release, or creating bug tickets from recurring Sentry events.
---

# Sentry Cleanup

## Quick Start

1. Get Sentry auth token (ask user or check `SENTRY_AUTH_TOKEN`) + org slug
2. Fetch unresolved issues from Sentry API
3. Investigate each error group
4. Ask: ClickUp (default) or GitHub Issues?
5. Create tickets with severity labels and tags

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
