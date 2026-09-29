---
name: qa
description: QA and testing best practices - unit tests, integration tests, test coverage
---

# QA Framework

House conventions that override the model's defaults.

## Coverage stance
Coverage is a diagnostic, not a target. Critical paths and error handling are covered
first; a gap in business logic is a finding, a gap in getters or config is not.

## Do not test
Implementation details, third-party libraries, simple accessors, config values.
Tests that mirror the implementation break on refactor and are a finding in review.

## Integration tests
Real component interactions against a test database, with state reset between tests.
Never point an integration test at production.

## Naming
Test name states the scenario and the expected result, so a failure is readable
without opening the file: `should throw on invalid input`.

## Speed
Unit tests stay under ~100ms each. A slow unit test is usually an integration test
in the wrong directory.
