---
name: thermo-nuclear-code-quality-review
description: Run an extremely strict maintainability review for abstraction quality, giant files, spaghetti-condition growth, and test quality. Use for a thermo-nuclear code quality review, thermonuclear review, deep code quality audit, or especially harsh maintainability review.
disable-model-invocation: true
---

# Thermo-Nuclear Code Quality Review

Use this skill for an unusually strict review of implementation quality, maintainability, abstraction quality, codebase health, and test quality. Be **ambitious** about code structure — search for "code judo" moves that preserve behavior while making the implementation dramatically simpler.

The skill operates in two modes:

- **PR mode** (feature branch, not main/master): review the diff for regressions, spaghetti growth, and missed simplification opportunities.
- **Audit mode** (main/master branch, or user says "audit"): survey the entire codebase for the worst structural problems, biggest files, and highest-value refactor targets.

Detect the mode automatically from the current branch name. If `main` or `master` (or the user says "audit"), use audit mode.

## Core Prompt

**PR mode:**
> Perform a deep code quality audit of the current branch's changes. Rethink how to structure the changes to improve quality without impacting behavior. Improve abstractions, modularity, reduce spaghetti, improve succinctness. Be ambitious — if there is a clear path to a simpler implementation involving restructuring, go for it. Be extremely thorough.

**Audit mode:**
> Perform a deep code quality audit of the entire codebase on main/master. Identify the most important structural problems: the most tangled files, the worst abstraction violations, the biggest files past healthy size boundaries, and the highest-value refactor targets. Prioritize findings by impact. Do not rubber-stamp existing code — the bar is the same as for a PR.

## Non-Negotiable Standards

0. **Be ambitious about structural simplification.** Look for reframings that make branches, conditionals, or entire layers disappear. Prefer the solution that feels inevitable.

1. **Do not let files live past 1000 lines.** In PR mode: flag when a diff pushes a file across that threshold. In audit mode: flag every file over 1000 lines and recommend decomposition. Prefer extracting helpers or modules.

2. **Do not allow spaghetti growth.** In PR mode: new ad-hoc conditionals or special-case branches in unrelated flows are a design problem. In audit mode: identify existing spaghetti hotspots and tangled flows. Push logic into a dedicated abstraction.

3. **Bias toward cleaning the design.** Do not rubber-stamp "it works" code that leaves the codebase messier. Prefer simplifications that remove moving pieces.

4. **Prefer direct, boring, maintainable code.** Flag thin wrappers or pass-through helpers that add indirection without clarity.

5. **Push on type and boundary cleanliness.** Question unnecessary `any`, casts, or silent fallbacks. Prefer explicit typed models.

6. **Keep logic in the canonical layer.** Call out feature logic leaking into shared paths. Prefer existing helpers over bespoke one-offs.

7. **Treat unnecessary sequential orchestration as a design smell.** Independent work should not be serialized for no reason. Flag non-atomic updates.

8. **Treat test code with the same scrutiny as production code.** Tests should verify behavior, not implementation. Flag over-mocked or brittle tests, low-signal tests, coverage-gaming, and missing edge-case coverage.

## Review Tone

Be direct, serious, and demanding about quality without being rude. If the code makes the codebase messier, say so clearly. If there is a missed opportunity for dramatic simplification, say that clearly too.

Good phrases:
- `this pushes the file past 1k lines. can we decompose this first?`
- `this adds another special-case branch into an already busy flow.`
- `this works, but it makes the surrounding code more spaghetti.`
- `this feels like feature logic leaking into a shared path.`
- `these tests mirror the implementation — they'll break on refactor. test behavior, not internals.`
- `this test has too much setup for too little assertion. can we simplify?`

Prefer a smaller number of high-conviction comments over a long list of cosmetic notes. For the complete review criteria (questions, flags, remedies, approval bar), read REFERENCE.md in this skill directory.
