# Reference: Thermo-Nuclear Code Quality Review

## Primary Review Questions

**PR mode:**
- Is there a "code judo" move that would make this dramatically simpler?
- Can this change be reframed so fewer concepts, branches, or helper layers are needed?
- Does this improve or worsen the local architecture?
- Did the diff add branching complexity where a better abstraction should exist?
- Did a previously cohesive module become more coupled or harder to scan?
- Is this logic living in the right file and layer?
- Did this change enlarge a file or component past a healthy size boundary?

**Audit mode:**
- What are the 3-5 most tangled files or modules in the codebase?
- Where is the most duplicated or copy-pasted logic?
- Which files are past healthy size boundaries that should be decomposed?
- Where do abstraction boundaries not exist but should?
- Which modules are coupled in ways that make changes hard?
- Where is the test suite weakest relative to production risk?

**Both modes:**
- Are there repeated conditionals that signal a missing model or helper?
- Is the implementation direct and legible, or does it rely on special cases?
- Is this abstraction earning its keep, or is it just a wrapper?
- Did the diff (or existing code) introduce casts or optionality that obscure invariants?
- Is this orchestration more sequential or less atomic than it needs to be?
- **Are the tests readable and maintainable, or do they duplicate production logic?**
- **Would a test failure clearly indicate what broke and why?**
- **Is coverage meaningful, or is it coverage-gaming or smoke tests?**
- **Are tests coupled to implementation details that will change on refactor?**

## What to Flag Aggressively

**PR mode:**
- A complicated implementation where a cleaner reframing could delete whole categories of complexity.
- Refactors that move code around but fail to reduce concepts.
- A file crossing 1000 lines, especially if new code could be split out.
- New conditionals bolted onto unrelated code paths.
- One-off booleans, nullable modes, or flags that complicate control flow.

**Audit mode:**
- Any file over 1000 lines that should be decomposed (list the worst 5-10).
- The most complex functions/modules by nesting depth or cyclomatic complexity.
- Modules with clear duplication or copy-paste patterns.
- Missing abstractions where repeated conditionals signal a missing model.
- Architecture boundaries that don't exist but should (cross-cutting concerns leaking everywhere).
- Areas with no tests or tests that clearly provide no value.

**Both modes:**
- Feature logic leaking into general-purpose modules.
- Generic "magic" handling that hides simple structure.
- Thin wrappers or identity abstractions that add indirection without simplifying.
- Unnecessary casts, `any`, `unknown`, or optional params.
- Copy-pasted logic instead of extracted helpers.
- Narrow edge-case handling in an already busy function.
- "Temporary" branching likely to become permanent debt.
- Bespoke helpers when the codebase already has a canonical utility.
- Logic in the wrong layer when there is a clear central home.
- Sequential async flow where independent work could run in parallel.
- Partial-update logic that leaves state less atomic than necessary.
- **Tests that mirror the implementation (same logic and branches) — they break on every refactor.**
- **Over-mocked or brittle tests coupled to internal structure instead of behavior.**
- **Tests with low signal: too much setup for too few assertions.**
- **Missing tests for edge cases or error paths handled in production code.**
- **Coverage-gaming: tests that assert trivial behavior to pad numbers.**
- **Assertions on implementation details (internal calls, state) over observable outcomes.**

## Preferred Remedies

- Delete a whole layer of indirection rather than polishing it.
- Reframe the state model so conditionals disappear instead of getting centralized.
- Change the ownership boundary so the feature extends an existing abstraction naturally.
- Turn special-case logic into a simpler default flow.
- Extract a helper or pure function.
- Split a large file into smaller focused modules.
- Move feature logic behind a dedicated abstraction.
- Replace condition chains with a typed model or dispatcher.
- Separate orchestration from business logic.
- Collapse duplicate branches into a single clear flow.
- Delete wrappers that do not meaningfully clarify the API.
- Reuse the existing canonical helper instead of a near-duplicate.
- Make type boundaries more explicit so control flow gets simpler.
- Move logic to the package/module that already owns the concept.
- Parallelize independent work when that simplifies orchestration.
- Restructure related updates into a more atomic flow.
- **Extract shared test fixtures or factories to reduce setup noise.**
- **Replace implementation-coupled tests with behavior-focused ones (test what, not how).**
- **Use table-driven tests for repetitive cases.**
- **Add edge-case coverage for error paths and boundary conditions.**

## Output Expectations

**PR mode** — prioritize findings in this order:

1. Structural code-quality regressions
2. Missed opportunities for dramatic simplification / code-judo moves
3. Spaghetti / branching complexity increases
4. Boundary / abstraction / type-contract problems
5. File-size and decomposition concerns
6. Test quality and coverage issues
7. Modularity and abstraction concerns
8. Legibility and maintainability concerns

**Audit mode** — prioritize findings in this order:

1. Hotspots: files over 1000 lines, highest cyclomatic complexity, most churn
2. Missing or broken abstractions / repeated conditionals that signal missing models
3. Architecture boundary leaks and cross-cutting concerns
4. Duplication and copy-paste clusters
5. Weak or missing test coverage for the riskiest areas
6. File-size and decomposition opportunities
7. Modularity and coupling concerns
8. Legibility and naming

Both modes: do not flood the review with low-value nits if there are larger structural issues.

## Approval Bar

**PR mode** — presumptive blockers (do not approve unless justified):

- The PR preserves incidental complexity when a code-judo move would delete it.
- The PR pushes a file from below 1000 lines to above 1000 lines.
- The PR adds ad-hoc branching that tangles an existing flow.
- The PR solves a local problem by scattering feature checks across shared code.
- The PR adds an unnecessary abstraction, wrapper, or cast-heavy contract.
- The PR duplicates an existing helper or puts logic in the wrong layer.
- **Tests are brittle, over-mocked, or coupled to implementation details.**
- **Tests have low signal-to-noise ratio or miss meaningful edge-case coverage.**

**Audit mode** — there is no "approval" in audit mode. Deliver a prioritized action list instead: the 5-10 highest-impact changes the team should make, ordered by payoff.
