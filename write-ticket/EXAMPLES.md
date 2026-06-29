# Write Ticket — Examples

Worked examples showing the flow from a rough ask to a filled-in ticket.

---

## Example 1 — Feature

**User's rough ask:** "We need a way to export the reports as CSV."

**Clarifying questions asked:**
- Which report(s) — all of them, or a specific view?
- Should the export respect the current filters/date range?
- Where does the file go — browser download, emailed, saved to storage?

**User answers:** Just the Activity report; respect active filters; browser download.

**Resulting ticket:**

```
Title: Add CSV export to the Activity report

## Context
Users currently copy Activity report data by hand to analyze it in spreadsheets.
Add a CSV export so they can pull the filtered data in one click.

## Requirements
- Add an "Export CSV" button to the Activity report toolbar.
- Export reflects the currently applied filters and date range.
- File downloads in the browser; no server-side storage.

## Acceptance Criteria
- [ ] An "Export CSV" button is visible on the Activity report toolbar.
- [ ] Clicking it downloads a .csv containing the rows currently shown (filters + date range applied).
- [ ] The CSV column headers match the on-screen table columns, in the same order.
- [ ] Exporting an empty result set downloads a CSV with headers and no data rows.
- [ ] The button is disabled while the report is still loading.

## Out of scope
- Other reports, scheduled/emailed exports, XLSX format.
```

Note how each distinct outcome — button presence, download content, headers, empty state, loading state — is its **own** AC rather than bundled into one.

---

## Example 2 — Bug

**User's rough ask:** "Login breaks sometimes after the session expires."

**Clarifying questions asked:**
- What does the user see — error, blank page, redirect loop?
- Reproducible steps?
- Which environments / browsers?

**User answers:** Redirect loop between /login and /dashboard; happens after the token expires mid-session; all browsers.

**Resulting ticket:**

```
Title: Fix redirect loop when session expires mid-use

## Context
When a user's session token expires while they're active, the app bounces
between /login and /dashboard indefinitely instead of prompting re-login.

## Requirements
- Detect an expired/invalid token on protected routes and route to /login once.
- Preserve the intended destination so the user returns after re-authenticating.

## Acceptance Criteria
- [ ] When a token expires mid-session, the user lands on /login (no redirect loop).
- [ ] After logging back in, the user is returned to the page they were on.
- [ ] A clear "Your session expired, please log in again" message is shown on /login.
- [ ] A still-valid session is never redirected to /login.

## Steps to reproduce
1. Log in. 2. Wait for the token to expire (or revoke it). 3. Click any protected nav link.
   Expected: prompted to re-login. Actual: infinite redirect between /login and /dashboard.
```

---

## AC anti-patterns to avoid

| ❌ Bundled / vague | ✅ One outcome, observable |
| --- | --- |
| "Export works correctly" | "Clicking Export downloads a .csv of the filtered rows" |
| "Handle errors" | "A failed export shows a toast: 'Export failed, try again'" |
| "Button looks good and exports data" | Split into two ACs: one for the button, one for the download |
