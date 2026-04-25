# Rulebook — Coding Standards & Best Practices

**Version:** 1.0
**Last Updated:** April 2026
**Status:** Living document — evolves as you progress through the curriculum

> This rulebook defines the coding standards for all code written in this learning pathway. Every task submission is validated against these rules. New rules are added as new concepts are covered.

---

## 1. Naming Conventions

### Classes
- Use **PascalCase** for class names
- Class name should clearly describe its purpose
- Prefix test classes with `Test` or suffix with `Test` (e.g., `AccountServiceTest` or `TestAccountService`)
- Batch classes should be suffixed with `Batch` (e.g., `AccountCleanupBatch`)
- Schedulable classes should be suffixed with `Scheduler` or `Schedule` (e.g., `AccountCleanupScheduler`)
- Queueable classes should be suffixed with `Queueable` (e.g., `AccountProcessQueueable`)

### Methods
- Use **camelCase** for method names
- Start with a verb: `getAccounts()`, `calculateTotal()`, `validateInput()`
- Boolean methods should read as questions: `isActive()`, `hasPermission()`, `canEdit()`

### Variables
- Use **camelCase** for variable names
- Use descriptive names — `accountList` not `aList`, `totalAmount` not `ta`
- Constants use **UPPER_SNAKE_CASE**: `MAX_RETRY_COUNT`, `DEFAULT_PAGE_SIZE`
- Loop variables can be short: `i`, `j` for index; descriptive for objects: `acc` for Account

### Triggers
- Name format: `<ObjectName>Trigger` (e.g., `AccountTrigger`)
- One trigger per object — always delegate to a handler class

### LWC Components
- Use **camelCase** for component folder names (e.g., `accountList`, `contactForm`)
- JS file names match the folder name
- CSS file names match the folder name

---

## 2. Code Structure

### Classes
- One class per file
- Keep classes focused — single responsibility principle
- Use access modifiers explicitly (`public`, `private`, `global`)
- Default to `with sharing` unless there is a documented reason not to

### Methods
- Keep methods short — ideally under 30 lines
- One method should do one thing
- Extract helper methods for repeated logic
- Always specify return types explicitly

### Comments
- Do NOT add comments that just narrate what the code does
- Comments should explain WHY, not WHAT
- Use Javadoc-style comments for public methods that other classes consume
- Add Jira reference `V2-8418` to new or updated methods for tracking

---

## 3. SOQL Best Practices

- NEVER put SOQL inside a loop
- Always use bind variables instead of string concatenation
- Query only the fields you need
- Use `LIMIT` when you don't need all records
- Use relationship queries to avoid multiple queries
- Use `WITH SECURITY_ENFORCED` or check CRUD/FLS when appropriate
- Aggregate queries count against the SOQL limit — use wisely

---

## 4. DML Best Practices

- NEVER put DML inside a loop
- Collect records into a list, then perform bulk DML
- Use `Database.insert(records, false)` when partial success is acceptable
- Always handle DML exceptions
- Prefer `upsert` with external ID fields when dealing with integration data

---

## 5. Governor Limits Awareness

| Limit | Value | Strategy |
|-------|-------|----------|
| SOQL queries per transaction | 100 | Bulkify queries, use relationship queries |
| DML statements per transaction | 150 | Collect and bulk DML |
| SOQL rows returned | 50,000 | Use selective queries, LIMIT |
| Heap size (sync) | 6 MB | Avoid loading large datasets into memory |
| Heap size (async) | 12 MB | Use Batch Apex for large data |
| CPU time (sync) | 10,000 ms | Optimize loops, avoid nested iterations |
| CPU time (async) | 60,000 ms | Break work into smaller chunks |
| Callouts per transaction | 100 | Batch callouts when possible |
| Future calls per transaction | 50 | Use Queueable for chaining |

---

## 6. Trigger Rules

- **One trigger per object** — no exceptions
- Trigger body should be thin — delegate to a handler class immediately
- Never put business logic in the trigger file
- Handle recursion with a static boolean or a framework
- Always write triggers to be bulk-safe (process `Trigger.new` as a collection)

---

## 7. Test Class Standards

- Every implementation class must have a corresponding test class
- Minimum **75% code coverage** (aim for 90%+)
- Use the `Assert` class for all assertions (not `System.assert`)
- Test positive scenarios, negative scenarios, and bulk scenarios
- Use `@TestSetup` methods for shared test data
- Use `Test.startTest()` and `Test.stopTest()` to reset governor limits
- Test with 200+ records to verify bulk behavior
- Never rely on existing org data — use `SeeAllData=false` (the default)
- Test class naming: `<ClassName>Test` (e.g., `AccountService` -> `AccountServiceTest`)

---

## 8. Exception Handling

- Use `try/catch` blocks for operations that can fail (DML, callouts, parsing)
- Catch specific exceptions before generic `Exception`
- Log meaningful error messages with context (record IDs, method name)
- In Batch Apex classes, use `GptfyException` for logging
- In all other classes, do NOT use `GptfyException`
- Create custom exception classes for domain-specific errors

---

## 9. Security

- Default to `with sharing` for all classes
- Use `without sharing` only when explicitly needed and document why
- Check CRUD/FLS before DML when building features for managed packages or AppExchange
- Use `WITH SECURITY_ENFORCED` in SOQL where applicable
- Never hardcode credentials, IDs, or sensitive data
- Use Custom Metadata, Custom Settings, or Named Credentials for configuration

---

## 10. Meta.xml Rules

- Every Apex class must have a corresponding `-meta.xml` file
- Use the latest API version (currently 66.0)
- Never add `<description>` in apex meta.xml files
- Set `<status>Active</status>` for all classes

---

## 11. Code Review Checklist

Before submitting any task, verify:

- [ ] Class and method names follow naming conventions
- [ ] No SOQL or DML inside loops
- [ ] Test class exists with 75%+ coverage
- [ ] Assert class used for assertions (not System.assert)
- [ ] `with sharing` used unless documented otherwise
- [ ] No hardcoded IDs or credentials
- [ ] Exception handling for DML/callouts
- [ ] Methods are focused and under 30 lines
- [ ] Jira reference V2-8418 added to new/updated methods
- [ ] Meta.xml file generated with correct API version

---

## Rules Added Per Phase

This section will grow as you progress through the curriculum.

### After Phase 1
- _Rules will be added here after completing Phase 1_

### After Phase 2
- _Rules will be added here after completing Phase 2_

### After Phase 3
- _Rules will be added here after completing Phase 3_

### After Phase 4
- _Rules will be added here after completing Phase 4_

### After Phase 5
- _Rules will be added here after completing Phase 5_

### After Phase 6
- _Rules will be added here after completing Phase 6_
