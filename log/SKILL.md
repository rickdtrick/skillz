---
name: log
description: Create timestamped log entries on any Markdown page. Use when the user says "log", "track", "record", "append", or wants to add a dated observation to a page.
---

# Log Skill

## Workflow

1. **Ask what to log** — "What do you want to log?" (e.g., blood sugar reading, expense, workout, note about a person)

2. **Ask where it belongs** — Determine which directory or page it goes in. Check the repo's existing structure for clues:
   - Health metrics → likely a `Health/` or similar directory
   - Financial transactions → likely an `Accounts/` or similar directory
   - Project milestones → likely a `Projects/` or similar directory

   If the user doesn't specify, suggest the best match from the repo structure.

   Ask if there's an existing page to append to, or if a new page should be created.

3. **Ask the format** — When creating a **new** log page, ask:
   - What format? Options: **table** (best for structured data like blood sugar/weight) or **bullets** (best for freeform journal entries)
   - Optionally, ask if they want a chart. If table format, suggest adding a chart code block that renders the table data as a line chart

4. **Collect the entry data**:
   - Date (default: today if not specified)
   - Value / measurement
   - Optional notes

5. **Format the entry** using the chosen format:
   - **Table format** (new pages):
     ```
     # [Log Name]
     
     ```chart
     type: line
     layout: columns
     select: [Value]
     width: 100%
     beginAtZero: false
     ```
     
     | Date | Value | Notes |
     |------|-------|-------|
     | Mar 15 | 110 | after lunch |
     ^[block-id]
     ```
   - **Bullet format**:
     ```
     **MM/DD/YY**
     - [metric]: [value] ([notes])
     ```
   - Use vertical whitespace between date groups
   - For **appending** to an existing page, match the existing format automatically

6. **Create or update the page**:
   - If the page already exists and has entries, **append** the new entry after the last existing entry (add a blank line, then the new date/entry block)
   - If creating a new page, include empty frontmatter `---\n\n---` at the top

7. **Confirm** — tell the user what was logged and where

## Example

```
User: log blood sugar 95 fasting
You: Where should it go?
User: in Health
You: Is there an existing page or create a new one?
User: new page
You: Table or bullet format?
```
