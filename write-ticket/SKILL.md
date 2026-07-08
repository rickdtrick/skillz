---
name: write-ticket
description: Draft a well-formed work ticket — concise requirements with each expected outcome as an acceptance criterion — and create it in the user's ticket tracker (ClickUp, Linear, Jira, Trello, etc.), OR improve an existing ticket in place. Use when the user wants to write, create, or file a ticket/issue/task/user story, or to improve, clean up, rewrite, or sharpen the ACs of an existing ticket (given its ID or URL). Asks clarifying questions, proposes acceptance criteria, and defaults to ClickUp unless another tracker is requested.
---

# Write Ticket

Turn a rough idea into a clear, actionable ticket: a short context/goal, concise requirements, and a checklist of acceptance criteria where **every expected outcome is its own AC**.

## Mode

- **Improve mode** — if the user provides an existing ticket ID or URL (e.g. ClickUp `86exr740d` or `https://app.clickup.com/t/...`), or asks to "improve / clean up / rewrite / fix" a ticket, follow **Improve an existing ticket** below.
- **Create mode** — otherwise, follow the **Create a new ticket** workflow.

## Create a new ticket

### 1. Clarify the goal

Ask the user what the ticket is for. Probe until you can state the goal in one sentence. Cover:

- **Problem / goal** — what are we trying to achieve, and why? Who benefits?
- **Scope** — what's explicitly in vs. out of scope?
- **Type** — feature, bug, chore, spike?
- **Constraints** — deadlines, dependencies, affected systems, designs/specs to link.

Ask only the questions you can't reasonably infer. Don't interrogate — 2–4 sharp questions, then draft.

### 2. Choose the AC format

Before drafting, ask the user how they want the acceptance criteria written, and draft in that format. Offer these options (default to **Checklist** if they have no preference):

- **Checklist** — plain `- [ ] X happens when Y` statements. Best for simple, scannable outcomes.
- **Given/When/Then** — `Given <context>, When <action>, Then <result>`. Best for behavior-driven or scenario-heavy work.
- **Rule-oriented** — short "The system must…" / "Users can…" rules. Best for constraints and policies.
- **Scenario table** — a table of input → expected output rows. Best for many similar cases or data permutations.

Ask once (e.g. *"How do you want the acceptance criteria formatted — a checklist, Given/When/Then, rules, or a scenario table?"*) and reuse that format for the rest of the session unless the user changes it.

### 3. Propose acceptance criteria

From the goal, **suggest** a list of acceptance criteria in the chosen format for the user to confirm or edit. Each AC is one verifiable expected outcome.

- One outcome per AC — don't bundle. Split compound conditions.
- Cover the happy path, key edge cases, and error/empty states.
- Keep them observable (a reviewer can check it), not implementation steps.

Present them and ask: *"Which of these are right? Anything to add or drop?"*

### 4. Resolve the tracker

Determine where the ticket goes:

- **Default to ClickUp.** Unless the user says otherwise, create the ticket via the ClickUp integration. Confirm the target list/space before creating.
- If the user names a different tracker (Linear, Jira, Atlassian, Trello, monday.com, GitHub Issues, Notion), use that instead. If the chosen integration isn't authenticated, prompt the user to connect/authenticate it first.
- If the user just wants the text (no tracker), output the formatted ticket in markdown.

### 5. Assemble and confirm

Build the ticket in this structure, rendering the Acceptance Criteria in the format chosen in step 2, show it to the user, and get a thumbs-up **before** creating it.

```
Title: <imperative, concise — e.g. "Add CSV export to reports">

## Context
<1–3 sentences: the goal and why it matters.>

## Requirements
- <concise requirement>
- <concise requirement>

## Acceptance Criteria
<rendered in the chosen format — e.g. a `- [ ]` checklist, Given/When/Then blocks, rules, or a scenario table, one expected outcome each>

<Optional: Out of scope / Dependencies / Links>
```

### 6. Create the ticket

Create it in the resolved tracker (title, description body, and ACs in the checklist/description). Report back the ticket ID and URL.

## Improve an existing ticket

### 1. Fetch the ticket

Resolve the ID/URL to a tracker and **read the current ticket** — title, description, existing ACs, status, comments. For ClickUp use the ClickUp integration (e.g. `clickup_get_task`); for others use their integration. If you can't access it, ask the user to paste the ticket text.

### 2. Diagnose gaps

Review the ticket against the quality bar and list what's weak:

- Vague or missing goal/context; unclear title.
- Requirements bundled, ambiguous, or actually implementation steps.
- ACs missing, bundled (multiple outcomes in one), unobservable, or with no coverage of edge/error/empty states.
- Missing scope boundaries, dependencies, or repro steps (for bugs).

Ask the user only for genuinely missing information — don't re-ask what the ticket already answers.

### 3. Propose the improved version

Rewrite the ticket into the standard structure (Title / Context / Requirements / Acceptance Criteria). Keep the AC format the ticket already uses unless it's unclear or the user asks to change it — if so, offer the formats from step 2 of Create mode. Show it as a **before → after** so the user sees what changed, and briefly note the key fixes. Preserve anything already good; don't invent scope.

### 4. Update in place

After the user approves, **update the existing ticket** (don't create a duplicate): patch title, description, and ACs. Keep the ticket's status, assignees, and links intact unless asked. Report back the ticket URL.

## Principles

- **Concise requirements, exhaustive criteria.** Requirements say what to build; ACs define done.
- **One outcome = one AC.** This is the core rule — never merge two outcomes into one checkbox.
- **Observable, not prescriptive.** ACs describe results, not how to implement them.
- **Confirm before creating.** Always preview the ticket; never silently file it.

## Examples

See `EXAMPLES.md` for worked feature and bug tickets, plus AC anti-patterns to avoid.
