---
name: refactor-plan
description: Analyse a specific file, module, or flow and produce a refactoring plan with multiple approach options and references for the developer to choose from. Use when user wants to clean up tech debt or improve a known, targeted piece of code — not for broad architectural exploration across the whole codebase.
---

# Refactor Plan

## Process

1. **Determine scope** — single file, module, or multi-file flow
2. **Decide if related code is needed** — if the target is self-contained, proceed with what's visible; if it has non-obvious dependencies, callers, or shared state, explore those files before forming an opinion
3. **Research best practices** — use Context7 or Tavily (no priority preference) to find current patterns for the language/framework involved; gather multiple approaches where available
4. **Analyse the code** — identify:
   - Duplicated logic
   - Large functions doing too much
   - Deep nesting / complex conditionals
   - Tight coupling between components
   - Inconsistent naming
   - Hardcoded values that should be constants
5. **Write the plan** — present multiple options with trade-offs
6. **Ask the user to choose** before any implementation begins

## Output format

- One section per approach, clearly labelled (e.g. "Option A: ...", "Option B: ...")
- Each option includes: what changes, why it helps, trade-offs or risks, and code examples where helpful
- Each option includes at least one reference — an article, book excerpt, or named principle (e.g. "Fowler's *Refactoring*, Extract Function p.106") — so the developer can learn the underlying best practice
- End with a question asking the user which option to proceed with

## Constraints

- Do not implement anything — output is a plan only
- Do not recommend a single solution without alternatives unless only one approach exists
- Flag if no tests exist (behavior preservation is at risk)
