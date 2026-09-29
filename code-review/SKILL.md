---
name: code-review
description: Code review best practices - security, performance, maintainability, and common pitfalls
---

# Code Review Framework

House conventions that override the model's defaults. Everything not listed here
follows normal review judgment.

## Thresholds this project holds to
- Functions over 30 lines get a decomposition note, not a pass.
- Comments explain WHY. A comment restating WHAT the code does is a finding.
- Config values and magic numbers belong in named constants, even single-use ones.

## Always raised, even when minor
- Unhandled async/await rejections.
- Listeners, subscriptions, or timers with no cleanup path.
- Shared mutable state touched from more than one flow.

## Review output
Rank findings by impact. Prefer a few high-conviction comments over a long list of
cosmetic notes. State the fix, not just the problem.
