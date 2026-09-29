# Deep Dive Examples

## Example: Kickoff — "I want to really understand Rust's ownership model"

> User: "I've used Rust for a few weeks but ownership still feels like magic. I want to actually *get* it, not just fight the borrow checker."

**Agent asks, in one message, before touching the filesystem:**

> Two quick things before I start:
>
> **1. Format** — Markdown (fast to write, diff-able, renders anywhere) or HTML (self-contained, printable, auto-graded quizzes)? I'd default to Markdown.
>
> **2. Location** — where should the course live? Default is `./rust-ownership-deep-dive` in your current directory.

User: "markdown, and put it in ~/deep-dives/rust-ownership"

**Agent then asks about the mission**, writes `MISSION.md` with `format: markdown` and `location: /Users/…/deep-dives/rust-ownership` in the frontmatter so neither question is ever asked again.

## Example: Build phase — the whole course in one go

1. **Research** — Rust Book ch. 4/15/19, Niko Matsakis on the borrow checker, `std::mem::replace` docs, Crust of Rust videos. 4 sources minimum per lesson, all added to `REFERENCES.md` with `Use for:` annotations as they're found.
2. **Map** — `CONCEPT-MAP.md` with ownership → borrowing → lifetimes → smart pointers as the spine, a Mermaid graph for the dependency edges, everything marked `planned`.
3. **Plan** — `CURRICULUM.md` with 11 lessons across 3 tracks, each line naming the lesson's concepts and prerequisite, plus 3 projects and where each unlocks.
4. **Write** — all 11 `lessons/000N-*.md` files generated in one pass, reporting progress as it goes ("lesson 4/11 — borrowing rules…"). Each one has inline citations, a predict-the-output exercise with a hidden answer key, a comprehension check, and an "ask your agent" prompt.
5. **Scaffold** — 3 `projects/` specs written up front, not gated on the learner finishing the lessons.
6. **Seed** — `PROGRESS.md` empty of completions, `GLOSSARY.md` header only, `learning-records/` empty.

Then: "11 lessons, 3 projects, markdown, at `~/deep-dives/rust-ownership`. Want to start session 1?"

## Example: Teach phase — session 5

> Session 5 starts. `PROGRESS.md` says L0004 was learned, L0005 (`Arc<Mutex>`) is next.

1. **Retrieval warm-up** — "Last time we covered shared references. What's the rule that prevents two threads mutating the same data without synchronization?" User answers correctly.
2. **Update** `PROGRESS.md` — current focus is L0005.
3. **Map** — shows where `Arc<Mutex>` sits: it composes lesson 0003 (shared ownership) with lesson 0004 (interior mutability).
4. **Teach** — works through `lessons/0005-arc-mutex.html`'s sibling, `0005-interior-mutability.md`.
5. **Check** — comprehension questions from the lesson file. User mis-answers one about lock poisoning.
6. **Record** — `learning-records/0005-lock-poisoning.md` notes the misconception and how it was corrected.
7. **Glossary** — adds `Poisoning` and `Guard`, neither of which was pre-populated during the Build phase.
8. **Set next** — L0006.

The lesson file is read from disk, never regenerated.

## Example: Batch-mode escalation

> User answers a comprehension question wrong on the third attempt.

Agent reverts to the original rule: don't advance past a concept the learner can't explain back. It walks the concept again with a different example, updates the lesson file in place with the extra example, then returns to the comprehension check. Only after a correct unprompted answer does it mark the concept `learned` and move on.
