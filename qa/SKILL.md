---
name: qa
description: QA and testing best practices - unit tests, integration tests, test coverage
---

# QA Framework

## Unit Tests
- Test ONE thing per test
- Name describes the scenario + expected result
- AAA pattern: Arrange, Act, Assert
- Mock external dependencies

## Integration Tests
- Test real interactions between components
- Use test database (not production)
- Clean state between tests
- Test happy path AND edge cases

## Test Coverage
- Aim for 80%+ on business logic
- NOT a goal: 100% coverage ≠ good tests
- Cover: happy path, error handling, edge cases
- Priority: critical paths first

## What to Test
- Public API responses
- Error handling paths
- Edge cases (empty, null, negative)
- Security checks
- Performance-sensitive code

## What NOT to Test
- Implementation details
- Third-party libraries
- Simple getters/setters
- Config values

## Test Naming
```
describe('Calculator', () => {
  it('should add two numbers correctly')
  it('should throw on invalid input')
})
```

## Best Practices
- Tests are documentation
- Fail fast, fail clear
- Keep tests fast (< 100ms each)
- One assertion per test when possible