---
name: code-review
description: Code review best practices - security, performance, maintainability, and common pitfalls
---

# Code Review Framework

## Security Checks
- Never commit secrets/keys in code
- Validate all inputs (even from internal APIs)
- Use parameterized queries (prevent SQL injection)
- Sanitize before rendering user content (XSS)

## Performance
- Check for N+1 queries
- Lazy load when possible
- Memoize expensive computations
- Avoid nested loops on large data

## Maintainability
- Clear naming (intent is obvious)
- Functions under 30 lines
- No magic numbers — use constants
- Comments explain WHY, not WHAT

## Common Pitfalls
- Unhandled async/await errors
- Memory leaks (listeners not cleaned up)
- Race conditions on shared state
- Hardcoded config values
- Missing null checks

## Review Checklist
- [ ] Security: inputs sanitized?
- [ ] Performance: queries efficient?
- [ ] Error handling: graceful fails?
- [ ] Testing: core paths covered?
- [ ] Docs: public APIs documented?