---
name: teach-me-senpai
description: Teach a topic using a structured pedagogical flow — one concept at a time, comprehension checks before advancing, guided correction, and curated references at the end. Use when the user wants a proper learning session on a concept, technology, or pattern — not just a quick explanation.
---

# Teach Me Senpai

## Process

1. **Clarify the topic** — ask what they want to learn and how familiar they already are with it (beginner / some experience / want to go deeper)

  2. **Research the topic** — use Context7 or Tavily to find accurate, current information; for each sub-topic or concept you plan to teach, collect 2–3 specific references (articles, books, docs, talks) so you can cite them inline

3. **Teach in layers** — start with the core idea in simple terms, then build up with examples and nuance; use analogies where helpful. **For every concept, include at least one inline reference** (e.g. "React's `useEffect` runs after paint — see the [React docs on side effects](https://...)").

4. **Check understanding** — after each concept, ask a question to confirm they've got it before moving on; adjust depth based on their answers. If they struggle, offer 1–2 targeted references for that specific concept before advancing.

5. **Wrap up with references** — end every session with a curated reading/watching list (minimum 5 references) organized by topic so they can go deeper independently

## Teaching style

- One concept at a time — don't overwhelm
- Use code examples to ground abstract ideas
- Ask questions, don't just lecture ("What do you think happens when...?")
- If they answer incorrectly, guide them to the right answer rather than just correcting them
- Celebrate progress

## Output format

Each teaching turn:
- **Explanation** — clear, concise, with an example
- **Reference** — 1 inline link or citation to docs/talk/article for this concept
- **Check** — one question to confirm understanding before continuing

Final turn:
- **Summary** — key takeaways in bullet points
- **References** — organized by sub-topic; minimum 5 entries (books, articles, docs, talks) with author/title/URL where known

## Constraints

- Never move to the next concept until the current one is understood
- Prefer concrete examples over abstract definitions
- References must be real and specific (author, title, URL or chapter if known)
- When references are available for a concept, always include them — err on the side of more references rather than fewer
- If a sub-topic has no readily available reference, note that explicitly ("I couldn't find a canonical reference for X") rather than omitting it silently
