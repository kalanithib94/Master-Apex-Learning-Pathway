# Lesson 01: Data Types and Variables

**Phase:** 1 — Apex Fundamentals
**Difficulty:** Foundation
**Estimated Time:** 2-3 hours

---

## Concept

Every programming language starts with understanding how to store and manipulate data. In Apex, data types define what kind of values a variable can hold, how much memory it occupies, and what operations you can perform on it. Apex is a strongly-typed language — you must declare a variable's type before using it, and the compiler enforces type safety.

Understanding data types is foundational because every single thing you do in Salesforce development — querying records, processing data, building logic — involves variables. Getting this right from day one sets the stage for everything that follows.

---

## Theory

### Primitive Data Types

Apex provides several primitive data types that map closely to Salesforce field types:

```apex
// Integer — whole numbers, no decimals
Integer recordCount = 150;
Integer negativeValue = -42;

// Long — larger whole numbers (rarely needed, but good to know)
Long bigNumber = 2147483648L;

// Double — decimal numbers (floating point)
Double taxRate = 0.0825;
Double pi = 3.14159;

// Decimal — precise decimal numbers (use for currency/financial calculations)
Decimal totalAmount = 1500.75;
Decimal price = 99.99;

// String — text values
String accountName = 'Acme Corporation';
String emptyString = '';
String nullString = null;

// Boolean — true or false
Boolean isActive = true;
Boolean hasAccess = false;

// Date — calendar date without time
Date today = Date.today();
Date specificDate = Date.newInstance(2026, 4, 25);

// Datetime — date with time
Datetime now = Datetime.now();
Datetime meetingTime = Datetime.newInstance(2026, 4, 25, 14, 30, 0);

// Time — time without date
Time startTime = Time.newInstance(9, 0, 0, 0); // 9:00 AM

// ID — Salesforce record ID (18-character)
Id accountId = '001000000000001AAA';

// Blob — binary data (used for files, encryption)
Blob fileContent = Blob.valueOf('Hello World');
```

### Constants

Use the `final` keyword to create constants — values that never change after initialization:

```apex
public class AppConstants {
    public static final Integer MAX_BATCH_SIZE = 200;
    public static final String DEFAULT_STATUS = 'New';
    public static final Decimal TAX_RATE = 0.0825;
}
```

### Variable Declaration and Initialization

```apex
// Declare and initialize in one line
String firstName = 'John';

// Declare first, initialize later
String lastName;
lastName = 'Doe';

// Multiple declarations of the same type
Integer x = 10, y = 20, z = 30;

// Null values — uninitialized variables default to null
String uninitialized;
System.debug(uninitialized); // Output: null
```

### Type Casting and Conversion

```apex
// String to Integer
Integer count = Integer.valueOf('42');

// String to Decimal
Decimal amount = Decimal.valueOf('199.99');

// Integer to String
String countStr = String.valueOf(42);

// Integer to Decimal (implicit widening — safe)
Decimal d = 42;

// Decimal to Integer (explicit narrowing — may lose data)
Integer i = (Integer)99.7; // Result: 99 (truncated, not rounded)

// Date to String
String dateStr = Date.today().format();

// String to Date
Date parsedDate = Date.valueOf('2026-04-25');
```

### String Methods You Will Use Daily

```apex
String name = '  Acme Corporation  ';

name.trim();                    // 'Acme Corporation'
name.toUpperCase();             // '  ACME CORPORATION  '
name.toLowerCase();             // '  acme corporation  '
name.contains('Acme');          // true
name.startsWith('  Acme');      // true
name.length();                  // 20
name.substring(2, 6);           // 'Acme'
name.replace('Acme', 'Beta');   // '  Beta Corporation  '

// String comparison — use equals(), not ==
String a = 'Hello';
String b = 'Hello';
Boolean same = a.equals(b);             // true
Boolean sameIgnoreCase = a.equalsIgnoreCase('hello'); // true

// Null-safe comparison
String c = null;
Boolean isBlank = String.isBlank(c);    // true
Boolean isEmpty = String.isEmpty(c);    // true (also true for null)
```

### The sObject Type

While not a primitive, `sObject` is Apex's special type for Salesforce records:

```apex
// Specific sObject type
Account acc = new Account();
acc.Name = 'Acme Corp';

// Generic sObject (when the object type is dynamic)
sObject record = new Account(Name = 'Dynamic Account');
String objectType = record.getSObjectType().getDescribe().getName(); // 'Account'
```

---

## Real-World Context

- **Decimal vs Double:** In production, always use `Decimal` for money and financial calculations. `Double` has floating-point precision issues (`0.1 + 0.2 != 0.3`). Every billing feature, invoice calculation, or discount logic you write should use `Decimal`.

- **String methods:** You will use `String.isBlank()`, `.contains()`, `.trim()`, and `.toLowerCase()` constantly when processing user input, validating data, and building search functionality.

- **ID type:** Salesforce IDs are not just strings — the `Id` type gives you compile-time checking and automatic 15-to-18 character conversion. Always use `Id` when storing record identifiers.

- **Constants:** Production orgs use constants classes (`AppConstants`, `SystemConstants`) to avoid magic numbers scattered across the codebase. If you see `200` hardcoded in batch sizes across ten classes, that's a maintenance nightmare.

- **Null handling:** The #1 runtime error in Apex is `NullPointerException`. Developing a habit of checking for null early will save you hours of debugging in production.

---

## Task: Beginner

**Title:** Variable Playground

Write an Anonymous Apex script that declares variables of every primitive type, performs a basic operation with each, and prints the results.

**File:** Save as `scripts/apex/lesson01-beginner.apex`

**Requirements:**
1. Declare one variable of each type: Integer, Long, Double, Decimal, String, Boolean, Date, Datetime, Time, Id
2. Perform one meaningful operation with each variable:
   - Integer: add two integers and store the result
   - Decimal: calculate 15% tax on a price of 1200.50
   - Double: multiply two doubles and observe the result
   - String: create a full name by combining a first name and last name with a space between them
   - Boolean: check if a number is greater than 100 and store the result
   - Date: get today's date and add 30 days to it
   - Datetime: get the current datetime and print it
   - Id: declare a sample Account Id
3. Use `System.debug()` to print each result with a label, like: `System.debug('Tax amount: ' + taxAmount);`
4. Declare one constant using `final` and use it in a calculation

**How to run it:**
```bash
sf apex run --file scripts/apex/lesson01-beginner.apex --target-org learning-org
```

**Hints:**
- To combine strings, use the `+` operator: `'Hello' + ' ' + 'World'`
- To add days to a date: `Date.today().addDays(30)`
- For the constant, use `final Decimal TAX_RATE = 0.15;`

---

## Task: Intermediate

**Title:** String Detective

Write an Anonymous Apex script that explores String methods by solving small text-processing challenges.

**File:** Save as `scripts/apex/lesson01-intermediate.apex`

**Requirements:**
1. Start with this string: `String rawInput = '  John Michael Doe  ';`
   - Trim the whitespace
   - Convert to uppercase
   - Convert to lowercase
   - Find the length of the trimmed string
   - Check if it contains 'Michael'
   - Extract just the first name using `substring()` (hint: first name ends at the first space)
   - Print each result with `System.debug()`

2. Start with this string: `String email = 'John.Doe@Example.COM';`
   - Convert to lowercase
   - Check if it contains '@'
   - Extract the part before '@' (the username)
   - Extract the part after '@' (the domain)
   - Print each result

3. Null safety exercise:
   - Declare `String emptyStr = '';` and `String nullStr = null;`
   - Test both with `String.isBlank()` and `String.isEmpty()` — print the results
   - What happens if you try `nullStr.length()`? Write a comment explaining what would happen (don't actually run it — it would crash)
   - Write a safe version: check if `nullStr != null` before calling `.length()`, print 'null string detected' if it is null

4. String comparison:
   - Declare `String a = 'Salesforce';` and `String b = 'salesforce';`
   - Compare using `==` and `.equals()` — print both results
   - Compare using `.equalsIgnoreCase()` — print the result
   - Write a comment explaining which method you should use and why

**Hints:**
- `indexOf(' ')` gives the position of the first space
- `substring(0, 4)` gives characters from position 0 to 3
- `substringBefore('@')` and `substringAfter('@')` are handy for splitting at a character

---

## Task: Advanced

**Title:** Type Casting Lab

Write an Anonymous Apex script that explores type conversions, precision differences, and null behavior.

**File:** Save as `scripts/apex/lesson01-advanced.apex`

**Requirements:**
1. **Safe conversions (widening):**
   - Assign an Integer `42` to a Decimal variable — does it work? Print the result.
   - Assign an Integer to a Long — does it work? Print the result.
   - Write a comment explaining why these work without any special syntax.

2. **Dangerous conversions (narrowing):**
   - Cast a Decimal `99.7` to an Integer using `(Integer)` — what happens to the `.7`? Print the result.
   - Cast a Decimal `99.3` to an Integer — print and compare with above.
   - Write a comment: does Apex round or truncate?

3. **String-to-number conversions:**
   - Convert the string `'150'` to Integer using `Integer.valueOf()` — print it.
   - Convert the string `'99.99'` to Decimal using `Decimal.valueOf()` — print it.
   - Convert the Integer `42` to a String using `String.valueOf()` — print it.
   - Convert today's date to a String using `String.valueOf()` — print it.

4. **Precision test — Double vs Decimal:**
   - Calculate `0.1 + 0.2` using Double variables — print the result. Is it exactly `0.3`?
   - Calculate `0.1 + 0.2` using Decimal variables — print the result. Is it exactly `0.3`?
   - Write a comment explaining why Decimal gives the correct answer and Double does not.
   - Write a comment on which type you would use for calculating an invoice total.

5. **Null behavior:**
   - Declare an Integer without assigning a value — print it. What shows up?
   - Declare a String without assigning a value — print it. What shows up?
   - Declare a Boolean without assigning a value — print it. What shows up?
   - Write a comment: in Apex, what is the default value of an uninitialized variable?

**Hints:**
- Cast with parentheses: `Integer i = (Integer)someDecimal;`
- Uninitialized variables in Apex default to `null` — not 0, not false, not empty string
- `0.1 + 0.2` as Double will NOT equal `0.3` exactly — this is a famous floating-point issue

---

## Validation Criteria

When you submit your scripts, I will check:

| Criteria | What I Look For |
|----------|----------------|
| Correctness | Does the script run without errors and produce correct debug output? |
| Completeness | Are all requirements covered? |
| Variable naming | Are variables named descriptively using camelCase? |
| Type choices | Are the right data types used for each scenario? |
| Constants | Is `final` used where values should not change? |
| Comments | Do comments explain YOUR understanding, not just narrate the code? |
| Null awareness | Did you handle and understand null behavior? |
| Debug output | Are debug statements labeled clearly so output is readable? |

---

## Interview Angle

Data types and variables come up in interviews in these ways:

1. **"What's the difference between Decimal and Double?"** — Decimal is precise (use for currency), Double has floating-point errors
2. **"What happens if you assign null to a primitive?"** — Primitives can be null in Apex (unlike Java int/boolean)
3. **"How do you avoid NullPointerException?"** — Check with `!= null`, use `String.isBlank()`, use safe navigation operator `?.`
4. **"What is the ID data type?"** — 18-character case-insensitive identifier, auto-converts from 15-char, compile-time type checking
5. **"Explain type casting in Apex"** — Implicit widening (Integer to Decimal), explicit narrowing with cast operator, valueOf() methods for String conversion

---

## External Resources

Learn more from these curated resources:

**Salesforce Official:**
- [Apex Developer Guide — Data Types](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/langCon_apex_primitives.htm) — Official docs on every primitive type
- [Apex Developer Guide — Variables](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/langCon_apex_variables.htm) — Declaration, scope, and constants
- [Apex Developer Guide — String Class](https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_methods_system_string.htm) — Every String method available

**Trailhead:**
- [Apex Basics & Database](https://trailhead.salesforce.com/content/learn/modules/apex_database) — Salesforce's own beginner Apex module

**YouTube:**
- [Apex Hours — Apex Data Types](https://www.youtube.com/results?search_query=apex+hours+data+types+salesforce) — Beginner-friendly walkthrough
- [SalesforceHulk — Apex Variables & Data Types](https://www.youtube.com/results?search_query=salesforcehulk+apex+variables+data+types) — Quick visual explanations

**Articles:**
- [SFDC Stop — Apex Primitive Data Types](https://www.sfdcstop.com/2019/12/primitive-data-types-in-apex.html) — Clean summary with examples

> Tip: Read the official docs first — they are the source of truth. YouTube and articles help when you want a different explanation angle.

---

## Best Practices

**Do:**
- Always initialize variables before using them
- Use `Decimal` for any financial/monetary calculations
- Use `String.isBlank()` instead of `== null` or `== ''` for strings
- Use `final` for values that should never change
- Use the `Id` type for Salesforce record IDs, not String
- Use `equals()` for String comparison, not `==`

**Don't:**
- Don't use `Double` for currency calculations
- Don't ignore null — always handle it explicitly
- Don't use magic numbers — create named constants
- Don't concatenate strings in loops — use `String.join()` with a List
- Don't cast without checking type first — wrap in try-catch or check with `instanceof`

---

## Deep Dives

_This section grows as questions come up during the lesson. Each entry is a doubt that was raised, explained, and preserved for future learners._

### Why use Decimal.valueOf('99.99') instead of just 99.99?

The same number can exist in two forms in Apex — as an actual number or as text:

```apex
Decimal price = 99.99;         // A number — you can do math with it
String priceText = '99.99';    // Text — looks like a number but Apex treats it as letters
```

You cannot do math with a String. Trying `priceText * 0.10` gives a compile error. `Decimal.valueOf()` converts text into a real number:

```apex
String priceText = '99.99';
Decimal price = Decimal.valueOf(priceText);  // Text -> number
Decimal tax = price * 0.10;                  // Now math works — 9.999
```

**When does this matter?** Right now in Lesson 01 it seems pointless — why not just write `99.99` directly? Because in later lessons (DML, integrations, API callouts), you'll see that data coming from outside your code almost always arrives as text. For now, the simple rule:

- `99.99` (no quotes) — already a number, use directly
- `'99.99'` (in quotes) — it's text, use `Decimal.valueOf()` to make it a number

This pattern exists across all Apex types: `Integer.valueOf()`, `Boolean.valueOf()`, `Date.valueOf()`, `Long.valueOf()`. If the String is invalid (e.g., `'hello'`), it throws an error — you'll learn how to handle that in Lesson 09 (Exception Handling).

