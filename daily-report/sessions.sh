#!/usr/bin/env bash
# Summarize Claude Code sessions for one repo (and its worktrees) inside a time window.
# Usage: sessions.sh <repo_path> <since_epoch> <until_epoch>
# Prints one JSON object per session that had a human prompt inside the window.
set -euo pipefail

repo="${1%/}"
since="$2"
until="$3"
projects="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/projects"
encoded=$(printf '%s' "$repo" | sed 's#[/.]#-#g')
days=$(( ($(date +%s) - since) / 86400 + 1 ))

shopt -s nullglob
for dir in "$projects/$encoded" "$projects/$encoded"-*; do
  [[ -d "$dir" ]] || continue
  command find "$dir" -maxdepth 1 -name '*.jsonl' -mtime "-$days" | while read -r file; do
    # Pass 1: stream each line down to a small event (transcripts can be tens of MB).
    jq -c --arg repo "$repo" '
      def ts: .timestamp | sub("\\.[0-9]+Z$"; "Z") | fromdateiso8601;
      def human_text:
        .message.content
        | if type == "string" then .
          elif type == "array" and (map(.type) | index("tool_result") | not)
            then map(select(.type == "text") | .text | select(startswith("[Image") | not)) | join(" ")
          else empty end;
      if .type == "ai-title" or .type == "custom-title" then {k: "title", v: (.customTitle // .aiTitle)}
      elif (.cwd // "") as $cwd | ($cwd != $repo and ($cwd | startswith($repo + "/") | not)) then empty
      elif .isSidechain == true or (.timestamp | not) then empty
      elif .type == "user" then
        (human_text | select(test("^\\s*(Base directory for this skill|<system-reminder>|<local-command|<task-notification|Caveat:|\\[Request interrupted|\\[Image|Another Claude session sent)") | not)
                    | select(test("\\S"))
                    # Slash commands: keep "/name args", drop settings-only built-ins.
                    | if test("<command-name>") then
                        (capture("<command-name>(?<n>[^<]*)</command-name>").n) as $n
                        | select($n | test("^/(clear|compact|effort|model|fast|config|resume|login|logout|status|cost|context|help|memory|permissions|rename|exit|ide|mcp|hooks|plugin|agents|doctor)$") | not)
                        | "\($n) \(capture("<command-args>(?<a>[\\s\\S]*?)</command-args>").a? // "")"
                      else . end) as $t
        | {k: "prompt", t: ts, branch: .gitBranch, v: ($t | gsub("</?pasted_content[^>]*>"; "") | gsub("\\s+"; " ") | .[0:240])}
      elif .type == "assistant" then
        ts as $t
        | .message.content[]?
        | if .type == "text" then {k: "reply", t: $t, v: (.text | .[0:600])}
          elif .type == "tool_use" then {k: "tool", t: $t, name: .name,
                 cmd: (if .name == "Bash" then (.input.command // "" | .[0:200]) else null end),
                 ids: [.input | .. | objects | to_entries[] | select(.key | test("^(task_?id|issue_?id|id)$"; "i")) | .value | tostring]}
          else empty end
      else empty end
    ' "$file" 2>/dev/null \
    | jq -s -c --argjson since "$since" --argjson until "$until" --arg file "$file" '
      # Pass 2: keep sessions with a human prompt inside the window, then aggregate.
      (map(select(.k == "title").v) | last) as $title
      | map(select(.t != null and .t >= $since and .t < $until))
      | (map(select(.k == "prompt")) | unique_by(.v) | sort_by(.t)) as $prompts
      | select($prompts | length > 0)
      | {
          session: ($file | split("/") | last | rtrimstr(".jsonl")),
          title: $title,
          first_ts: ($prompts | first.t | todate),
          last_ts: ($prompts | last.t | todate),
          branches: ($prompts | map(.branch) | unique),
          prompts: (if ($prompts | length) > 4 then $prompts[0:3] + [$prompts[-1]] else $prompts end | map(.v)),
          prompt_count: ($prompts | length),
          tools: (map(select(.k == "tool").name) | group_by(.) | map({(.[0]): length}) | add // {}),
          mcp_ids: (map(select(.k == "tool" and (.name | startswith("mcp__"))).ids[]) | unique),
          urls: ([$prompts[].v | scan("https?://[^\\s)>\\]]+")] | unique),
          committed: any(.[]; .k == "tool" and (.cmd // "" | test("git commit"))),
          opened_pr: any(.[]; .k == "tool" and (.cmd // "" | test("gh pr create"))),
          last_reply: (map(select(.k == "reply").v) | last)
        }
    '
  done
done
