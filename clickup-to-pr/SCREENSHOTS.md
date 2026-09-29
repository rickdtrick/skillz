# PR screenshots for frontend changes

Any diff that changes user-visible output needs before/after screenshots in the PR body. Screenshots are captured with a browser-automation MCP (Browser MCP), never fabricated.

## 1. Detect Browser MCP
Check the available tools for `mcp__browsermcp__*` (or an equivalent browser-automation MCP such as Playwright MCP). If present, go straight to capture.

## 2. If it isn't available, ask first
> This change is user-facing. Do you want screenshots in the PR? I'd need Browser MCP enabled to capture them.

If the user says no, continue without screenshots and write `_No screenshots (Browser MCP not enabled)_` in the Screenshots section. Do not ask again for the remaining tickets in the same run.

## 3. Setup instructions (give these when the user says yes)

**Browser MCP** (browsermcp.io) — Chrome extension plus a local MCP server:

1. Install the Browser MCP extension from the Chrome Web Store.
2. Register the server with Claude Code:
   ```bash
   claude mcp add browsermcp -- npx @browsermcp/mcp@latest
   ```
3. Restart the Claude Code session so the tools load.
4. Open the app tab in Chrome, click the Browser MCP extension icon, and hit **Connect** — the extension only exposes the tab you explicitly connect.
5. Confirm back here once it's connected.

**Already installed but tools missing** → the MCP server is likely disconnected: run `claude mcp list` to check status, re-run `/mcp` to reconnect, or restart the session. If the tools are there but calls fail, the extension is not connected to a tab (step 4).

**Alternative** — if the user already has Playwright MCP or Chrome DevTools MCP configured, use that instead; the capture steps are the same.

## 4. Ask where to save the files
GitHub has no API for uploading images to a PR, so the user has to attach them by hand. Ask where the files should land before capturing:

> Where should I save the screenshots? (e.g. `~/Desktop/pr-screenshots/`, or I can use the session scratchpad.)

- Default to a dedicated folder on the Desktop if the user has no preference, since they need to find the files in Finder to drag them.
- Never save screenshots inside the repo — they'd end up in the diff.
- Name files so the drop order is obvious: `01-before-desktop.png`, `02-after-desktop.png`, `03-after-mobile.png`.

## 5. Capture
1. Start the dev server for the touched project using the repo's own script (check `package.json`, the Makefile, or the monorepo tool's config) and note the local URL.
2. Navigate to the changed view. Log in first if the view is behind auth — ask the user for credentials or a seeded account rather than guessing.
3. Capture **after** state for every affected view.
4. Capture **before** state when the change modifies existing UI: stash or check out the base branch, reload, capture, then return to the working branch. Skip this for brand-new views.
5. Capture each breakpoint the ticket or Figma design specifies (default: desktop ~1440px; add mobile ~390px if the design includes it).

## 6. Hand off for upload
Write the Screenshots section with a labelled placeholder per image, then tell the user exactly what to do:

```
## Screenshots

**Before** (desktop)
<!-- drop 01-before-desktop.png here -->

**After** (desktop)
<!-- drop 02-after-desktop.png here -->
```

Then print, with the real path and file list:

> Screenshots saved to `<path>`:
> - `01-before-desktop.png`
> - `02-after-desktop.png`
>
> GitHub has no API for image uploads, so please attach them yourself:
> 1. Open the PR → **Edit** on the description.
> 2. Drag each file from `<path>` onto the matching `<!-- drop ... -->` line (or click the attach-files control at the bottom of the editor).
> 3. Delete the placeholder comment lines and **Update comment**.
>
> Order matters: `01` first, then `02`, so the Before/After labels stay correct.

- Label everything `**Before**` / `**After**`, and by breakpoint when more than one.
- Note any deliberate deviation from the Figma design and why.
- Leave the placeholders in the pushed PR body — they mark the drop points and are invisible in rendered markdown.

## Rules
- Never invent a screenshot, a URL, or a visual description you didn't observe.
- If the dev server won't start or the view can't be reached, say so in the PR body instead of guessing.
- Re-capture after any post-review fix that changes rendered output.
