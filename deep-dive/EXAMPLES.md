# Deep Dive Examples

## Example: Session 1 of "I want to really understand Rust's ownership model"

> User: "I've used Rust for a few weeks but ownership still feels like magic. I want to actually *get* it, not just fight the borrow checker."

**Agent creates the workspace:**

1. Asks about mission → writes `MISSION.md` with goal "ship a small CLI tool without fighting the compiler"
2. Researches ownership: finds Rust Book chapters 4, 15, and 19; Niko Matsakis' blog on borrow checker; std::mem::replace docs; Crust of Rust videos
3. Creates `CONCEPT-MAP.md` with ownership → borrowing → lifetimes as the spine, marks ownership as `in-progress`
4. Creates `lessons/0001-ownership-rules.html` — one concept: the three ownership rules, with inline citations, a quiz ("which of these moves?"), and an exercise to predict compiler errors
5. Works through the lesson with the user. User gets a question wrong about moved values in loops. Agent corrects, writes `learning-records/0001-heap-aliasing-bug.txt`
6. Comprehension check: user explains ownership rules correctly → concept marked `learned` in CONCEPT-MAP
7. Sets next session to `borrowing`

## Example: Mid-series project

> After 4 sessions on ownership, borrowing, lifetimes, and shared vs. exclusive references:

Agent creates `projects/0001-json-parser.md` — build a minimal JSON parser from scratch using only `&str` slices and no cloning. Success criteria: passes 5 test cases. Timebox: one session.

User works on it, gets stuck on nested arrays, agent guides with hints from lessons they've already completed (spaced retrieval).

## Example: Retrieval warm-up

> Session 5 starts. Before teaching `Arc<Mutex>`:

Agent asks: "Last time we covered shared references. What's the rule that prevents two threads from mutating the same data without synchronization?" (checks retention of lesson 0004). User answers correctly → learning record notes demonstrated recall. Proceeds to new material.
