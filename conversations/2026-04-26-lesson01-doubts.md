# Session: Lesson 01 — Doubts and Follow-ups

**Date:** 2026-04-26
**Phase:** 1 — Apex Fundamentals
**Lesson:** 01 — Data Types and Variables
**Topic:** Clarification questions while reading the lesson theory

---

## Context

Learner is reading through Lesson 01 theory before starting the coding tasks. Questions are about understanding the code examples in the lesson.

## Doubts Raised

### Doubt 1: "What is Decimal.valueOf('99.99')?"
- **Context:** Reading the Primitive Data Types section, line showing `Decimal price = Decimal.valueOf('99.99');`
- **Explanation given:** `Decimal.valueOf()` is a factory method that parses a String into a Decimal. Direct assignment (`Decimal price = 99.99`) works for hardcoded values, but `valueOf()` is essential when values come from external sources — API responses, custom metadata, user input, JSON. The pattern exists on all major Apex types (`Integer.valueOf()`, `Boolean.valueOf()`, etc.). Invalid Strings throw `TypeException`, null throws `NullPointerException`.
- **Resolution:** Explained with real-world examples (API response parsing, custom metadata, user input scenarios)
- **Added to lesson:** Yes, appended to 01-data-types-and-variables.md Deep Dives

## Key Concepts Discussed

- Factory methods (`valueOf()`) vs direct assignment
- When String-to-type conversion matters in real development
- Error scenarios with invalid input (TypeException, NullPointerException)

## Contradictions / Changes

_None._
