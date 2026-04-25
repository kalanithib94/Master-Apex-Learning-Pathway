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

**Title:** Data Type Explorer

Create an Apex class called `DataTypeExplorer` that demonstrates your understanding of each primitive data type.

**Requirements:**
1. Create a method `demonstratePrimitives()` that returns a `Map<String, String>` where each key is the data type name and each value is a string representation of a sample value of that type
2. Include at least these types: Integer, Decimal, Double, String, Boolean, Date, Datetime, Id
3. Create a method `convertStringToTypes(String input)` that takes a numeric string (like `'42'`) and returns a `Map<String, Object>` containing the string converted to Integer, Decimal, Double, and Long
4. Create a corresponding test class `DataTypeExplorerTest` with assertions for both methods

**Hints:**
- Use `String.valueOf()` to convert any type to String
- Use `Integer.valueOf()`, `Decimal.valueOf()` for the reverse
- Test with both valid input and think about what happens with null

---

## Task: Intermediate

**Title:** String Utility Toolkit

Create an Apex class called `StringUtils` that provides reusable string manipulation methods that you would actually use in a real project.

**Requirements:**
1. `sanitizeInput(String input)` — trims whitespace, returns null if blank
2. `formatPhoneNumber(String phone)` — takes a 10-digit string and returns it formatted as `(XXX) XXX-XXXX`. Returns null if input is not exactly 10 digits
3. `maskEmail(String email)` — takes an email like `john.doe@example.com` and returns `j*****e@example.com` (first char, asterisks, last char before @, then the domain unchanged). Returns null if input is not a valid email format (must contain @)
4. `generateInitials(String fullName)` — takes a full name like `'John Michael Doe'` and returns `'JMD'`. Handle single names, extra spaces, and null
5. Create `StringUtilsTest` with tests covering valid inputs, null inputs, empty strings, and edge cases for each method

**Hints:**
- Use `String.isBlank()` for null/empty checks
- Use `.split()` to break strings apart
- Use `.substring()` and `.charAt()` for character-level operations
- Think about what `isNumeric()` or `isAlpha()` could help with for phone validation

---

## Task: Advanced

**Title:** Type-Safe Configuration Parser

Create an Apex class called `ConfigParser` that simulates parsing a configuration string (like you would receive from an API or custom setting) into strongly-typed values.

**Requirements:**
1. The class accepts a configuration string in the format: `key1=value1;key2=value2;key3=value3`
2. `ConfigParser(String configString)` — constructor that parses and stores the config internally
3. `getString(String key)` — returns the string value for a key, null if not found
4. `getInteger(String key)` — returns the value parsed as Integer, null if not found or not a valid integer
5. `getDecimal(String key)` — returns the value parsed as Decimal, null if not found or not a valid decimal
6. `getBoolean(String key)` — returns the value parsed as Boolean (accepts `'true'`, `'false'`, `'yes'`, `'no'`, `'1'`, `'0'`), null if not found or not a valid boolean
7. `getDate(String key)` — returns the value parsed as Date (format: `YYYY-MM-DD`), null if not found or not a valid date
8. `getKeys()` — returns a `Set<String>` of all keys
9. `hasKey(String key)` — returns Boolean
10. Handle edge cases: null config string, empty config string, keys with no values, duplicate keys (last wins), extra whitespace around keys and values
11. Create `ConfigParserTest` with thorough tests covering happy path, edge cases, null/empty inputs, invalid type conversions, and duplicate keys

**Hints:**
- Use `.split(';')` to break into pairs, then `.split('=')` for key-value
- Wrap type conversions in try-catch to handle invalid values gracefully
- Think about what happens with `key=` (empty value) vs `key` (no equals sign)
- Store parsed data in a `Map<String, String>` internally

---

## Validation Criteria

When you submit your code, I will check:

| Criteria | What I Look For |
|----------|----------------|
| Correctness | Does the code compile and produce correct results? |
| Naming | PascalCase class names, camelCase methods and variables |
| Null safety | Are null inputs handled without NullPointerException? |
| Type usage | Are the right data types used (Decimal for money, Id for IDs)? |
| Constants | Are magic values avoided and constants used where appropriate? |
| Test coverage | Does the test class cover positive, negative, and edge cases? |
| Assertions | Is the `Assert` class used (not `System.assert`)? |
| Meta.xml | Does the meta.xml exist with API 66.0 and no description? |
| Code structure | Are methods focused and under 30 lines? |

---

## Interview Angle

Data types and variables come up in interviews in these ways:

1. **"What's the difference between Decimal and Double?"** — Decimal is precise (use for currency), Double has floating-point errors
2. **"What happens if you assign null to a primitive?"** — Primitives can be null in Apex (unlike Java int/boolean)
3. **"How do you avoid NullPointerException?"** — Check with `!= null`, use `String.isBlank()`, use safe navigation operator `?.`
4. **"What is the ID data type?"** — 18-character case-insensitive identifier, auto-converts from 15-char, compile-time type checking
5. **"Explain type casting in Apex"** — Implicit widening (Integer to Decimal), explicit narrowing with cast operator, valueOf() methods for String conversion

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

### What is a Map? (Quick intro for Lesson 01 tasks)

A Map is a container that stores pairs — a label (called **key**) and a value. Think of it like a dictionary: you look up a word (key), you get its definition (value).

```apex
// Create an empty Map — types in <> define what the key and value types are
Map<String, String> myMap = new Map<String, String>();

// Put pairs in
myMap.put('Integer', '150');
myMap.put('Boolean', 'true');

// Get a value by its key
String result = myMap.get('Integer');  // Returns '150'

// Check how many pairs exist
Integer size = myMap.size();  // Returns 2
```

`Map<String, String>` means both the key and value are Strings. `Map<String, Object>` means the key is a String but the value can be any type. Maps are covered in full depth in Lesson 02 — this is just enough to complete the Beginner task.
