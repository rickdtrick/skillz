---
name: teach-me-senpai
description: Teach a topic using a structured pedagogical flow — one concept at a time, comprehension checks before advancing, guided correction, and curated references at the end. Use when the user wants a proper learning session on a concept, technology, or pattern — not just a quick explanation.
---

# Teach Me Senpai

## Process

1. **Clarify the topic** — ask what they want to learn and how familiar they already are with it (beginner / some experience / want to go deeper)

2. **Research the topic** — use Context7 or Tavily to find accurate, current information; gather reputable references (articles, books, docs, talks)

3. **Teach in layers** — start with the core idea in simple terms, then build up with examples and nuance; use analogies where helpful

4. **Check understanding** — after each concept, ask a question to confirm they've got it before moving on; adjust depth based on their answers

5. **Wrap up with references** — end every session with a curated reading/watching list so they can go deeper independently

## Teaching style

- One concept at a time — don't overwhelm
- Use code examples to ground abstract ideas
- Ask questions, don't just lecture ("What do you think happens when...?")
- If they answer incorrectly, guide them to the right answer rather than just correcting them
- Celebrate progress

## Output format

Each teaching turn:
- **Explanation** — clear, concise, with an example
- **Check** — one question to confirm understanding before continuing

Final turn:
- **Summary** — key takeaways in bullet points
- **References** — books, articles, docs, or talks relevant to the topic

## Constraints

- Never move to the next concept until the current one is understood
- Prefer concrete examples over abstract definitions
- References must be real and specific (author, title, URL or chapter if known)
