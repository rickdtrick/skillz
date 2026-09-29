# Deep Dive Reference

## Workspace File Formats

### MISSION.md

Frontmatter carries the kickoff answers so they are never asked twice.

```
---
topic: {Topic}
format: markdown          # markdown | html
location: /abs/path/to/workspace
created: 2026-01-15
lesson_count: 12
---

# Mission: {Topic}

## Why
{1–3 sentences. Concrete real-world goal.}

## Success looks like
- {Observable outcome}
- {Another outcome}

## Constraints
- {Time, budget, prior commitments}

## Out of scope
- {Adjacent topics not chasing right now}
```

### CURRICULUM.md

The plan the Build phase generates against. Written before any lesson file.

```
# Curriculum: {Topic}

## Track 1 — {Sub-topic}
- **L0001 — {Lesson title}** — {what the learner can do after}. Concepts: A, B. Prereq: —
- **L0002 — {Lesson title}** — {what the learner can do after}. Concepts: B, C. Prereq: L0001

## Track 2 — {Sub-topic}
- **L0007 — {Lesson title}** — ... Prereq: L0004

## Projects
- **P1 — {Title}** — unlocks after L0004
- **P2 — {Title}** — unlocks after L0009
```

### PROGRESS.md

```
# Progress: {Topic}

## Completed
- L0001: {title} (2026-01-15)
- L0002: {title} (2026-01-16)
- LR-0001: {concept} (2026-01-16)

## Current focus
{What we're working on this session}

## Up next
{What the next session will cover}
```

### CONCEPT-MAP.md

```
## {Sub-topic}
- **Concept** — {one-line definition}. Depends on: {prereq}. Opens up: {next}. Status: learned | in-progress | planned | uncertain
```

Use a Mermaid graph when the dependency structure is non-trivial.

### GLOSSARY.md

Terms are added during the Teach phase, only after the learner demonstrates understanding. Never pre-populate this file during the Build phase.

```
## {Term}
{1–2 sentence definition. What it IS, not what it does.}

_Avoid_: {synonyms to discourage}
```

### REFERENCES.md

Source keys used by lesson frontmatter and inline citations.

```
## Knowledge
- `rust-ref-ch4` — [The Rust Programming Language, ch. 4 — Steve Klabnik & Carol Nichols](https://doc.rust-lang.org/book/ch04-00-understanding-ownership.html)
  Use for: ownership rules, move vs. copy

## Wisdom (Communities)
- [Crust of Rust](https://www.youtube.com/@crustofrust) — {what it's good for}

## Gaps
- {Missing resources needed for mission}
```

### Learning Record (`learning-records/0001-slug.md`)

```
# {Title}
{1–3 sentences: what was learned, why it matters for future sessions.}
```

Optional line: `Status: superseded by LR-NNNN`

### Project (`projects/0001-slug.md`)

```
# {Title}

## Goal
{Link to mission}

## Requirements
- {list}

## Success criteria
- {how to verify}

## Hints
<details><summary>Hint 1</summary>{hint}</details>

## Timebox
{recommended duration}
```

## Lesson Specs

Pick exactly one, based on the `format` in `MISSION.md` frontmatter. Never mix formats in one workspace.

### Markdown (`lessons/0001-slug.md`)

```md
---
lesson: 0001
title: Ownership Rules
concepts: [Ownership, Move semantics]
prereq: none
sources: [rust-ref-ch4, matsakis-borrowck]
status: planned            # planned | in-progress | learned
updated: 2026-01-15
---

# 0001 — Ownership Rules

> **After this lesson you can** predict which values move versus copy, and explain why the compiler rejects each aliasing pattern.

## Where this sits
See [CONCEPT-MAP.md](../CONCEPT-MAP.md). Ownership is the root of the Rust memory model; borrowing (lesson 0002) only makes sense once these three rules are automatic.

## The idea

{Rich explanation, broken into sections. Cite inline after every claim.}

The first rule: every value has a single owner. [rust-ref-ch4]
...

## Try it

**Predict:** mark each line `M` (moves) or `C` (copies), then expand to check.

```rust
let s = String::from("hi");
let t = s;              // ___
println!("{s}");        // ___
```

<details><summary>Answers</summary>

- line 2: **M** — `String` is heap-allocated, so `s` is moved into `t`
- line 3: **error** — `s` was moved; the compiler rejects the use

</details>

## Check your understanding

1. {question}
2. {question}
3. {question}

## Glossary

- **Ownership** — see [GLOSSARY.md](../GLOSSARY.md#ownership)
- **Move** — see [GLOSSARY.md](../GLOSSARY.md#move)

## Ask your agent

> "I still don't see why `s` is unusable after the move on line 2. Show me the borrow checker's exact reasoning for that error."

## Sources

- [The Rust Programming Language, ch. 4 — Steve Klabnik & Carol Nichols](https://doc.rust-lang.org/book/ch04-00-understanding-ownership.html)
- [Understanding ownership — Niko Matsakis](https://smallcultfollowing.com/babysteps/blog/2019/01/16/understanding-ownership-what-is-it-and-how-does-it-affect-rust.html)
```

Rules: every claim carries an inline source link; the answer key stays hidden behind `<details>`; the comprehension check has 1–3 questions; the "ask your agent" prompt is always last.

### HTML (`lessons/0001-slug.html`)

One self-contained file. No external stylesheets, fonts, scripts, or images — it must work offline and print to PDF.

```html
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>0001 — Ownership Rules</title>
<style>
  :root { --fg: #1a1a1a; --muted: #666; --accent: #b45309; --bg: #fdfdfc; --line: #e5e5e0; }
  * { box-sizing: border-box; }
  body { margin: 0 auto; max-width: 42rem; padding: 3rem 1.5rem 6rem;
         font: 17px/1.65 ui-serif, Georgia, serif; color: var(--fg); background: var(--bg); }
  h1, h2, h3 { line-height: 1.25; letter-spacing: -0.01em; }
  h1 { font-size: 2rem; }
  a { color: var(--accent); }
  .goal { border-left: 3px solid var(--accent); padding: 0.25rem 0 0.25rem 1rem;
          color: var(--muted); font-style: italic; }
  pre { background: #f5f5f2; border: 1px solid var(--line); border-radius: 6px;
        padding: 0.9rem 1rem; overflow-x: auto; font: 14px/1.5 ui-monospace, SFMono-Regular, Menlo, monospace; }
  code { font: 0.9em ui-monospace, SFMono-Regular, Menlo, monospace; }
  .quiz { border: 1px solid var(--line); border-radius: 6px; padding: 1rem 1.1rem; margin: 1.5rem 0; }
  .quiz button { font: inherit; padding: 0.3rem 0.8rem; margin: 0.2rem 0.2rem 0.2rem 0;
                 border: 1px solid var(--line); border-radius: 4px; background: #fff; cursor: pointer; }
  .quiz .verdict { margin-top: 0.6rem; font-weight: 600; }
  .right  { color: #15803d; }
  .wrong  { color: #b91c1c; }
  .ask { background: #faf7f0; border: 1px solid var(--line); border-radius: 6px; padding: 1rem 1.1rem; }
  footer { margin-top: 3rem; padding-top: 1rem; border-top: 1px solid var(--line);
           color: var(--muted); font-size: 0.85rem; }
  @media print { body { max-width: none; } .quiz button { display: none; } a { color: inherit; } }
</style>
</head>
<body>

<p class="goal"><strong>After this lesson you can</strong> predict which values move versus copy, and explain why the compiler rejects each aliasing pattern.</p>

<h1>0001 — Ownership Rules</h1>

<h2>Where this sits</h2>
<p>See <code>CONCEPT-MAP.md</code>. Ownership is the root of the Rust memory model; borrowing (lesson 0002) only makes sense once these three rules are automatic.</p>

<h2>The idea</h2>
<p>Every value has a single owner. <a href="https://doc.rust-lang.org/book/ch04-00-understanding-ownership.html">The Rust Book, ch. 4</a></p>

<pre><code>let s = String::from("hi");
let t = s;
println!("{s}");</code></pre>

<div class="quiz" data-answer="b">
  <p><strong>Predict:</strong> what happens on line 3?</p>
  <button onclick="mark(this, false)">It prints <code>hi</code></button>
  <button onclick="mark(this, true)">Compile error — <code>s</code> was moved</button>
  <button onclick="mark(this, false)">It prints <code>hi</code> twice</button>
  <div class="verdict" hidden></div>
  <p hidden><em>Line 2 moves the heap-allocated <code>String</code> into <code>t</code>, leaving <code>s</code> uninitialized. The borrow checker rejects the use on line 3. <a href="https://smallcultfollowing.com/babysteps/blog/2019/01/16/understanding-ownership-what-is-it-and-how-does-it-affect-rust.html">Matsakis</a></em></p>
</div>

<h2>Check your understanding</h2>
<ol>
  <li>Why does <code>String</code> move but <code>i32</code> copy?</li>
  <li>What is the compiler actually protecting you from here?</li>
</ol>

<h2>Ask your agent</h2>
<div class="ask">
  <p>"I still don't see why <code>s</code> is unusable after the move on line 2. Show me the borrow checker's exact reasoning for that error."</p>
</div>

<footer>
  Sources: <a href="https://doc.rust-lang.org/book/ch04-00-understanding-ownership.html">The Rust Programming Language, ch. 4</a> ·
  <a href="https://smallcultfollowing.com/babysteps/blog/2019/01/16/understanding-ownership-what-is-it-and-how-does-it-affect-rust.html">Niko Matsakis</a>
</footer>

<script>
function mark(btn, correct) {
  const quiz = btn.closest('.quiz');
  const verdict = quiz.querySelector('.verdict');
  verdict.hidden = false;
  verdict.textContent = correct ? 'Correct.' : 'Not quite — expand the explanation below.';
  verdict.className = 'verdict ' + (correct ? 'right' : 'wrong');
  quiz.querySelectorAll('button').forEach(b => b.disabled = true);
}
</script>
</body>
</html>
```

Rules: every claim links to a source; each interactive element scores the learner in place; the explanation is always present in the DOM (hidden or revealed) so printing keeps it; include a `@media print` block; finish with the "ask your agent" block and a source footer.
