# Session: Project Setup and Learning Path Design

**Date:** 2026-04-25
**Phase:** Pre-curriculum
**Topic:** Initial project setup, curriculum design, tooling decisions

---

## Context

The learner has past experience with Apex — understands the basics and what the platform can do — but wants to start from the ground up and build deep, interview-ready expertise systematically.

## Key Decisions Made

### 1. Curriculum Structure
- 55 lessons across 7 phases: Apex Fundamentals -> Intermediate -> Advanced -> Batch/Async -> LWC -> Integrations -> Interview Prep
- Each lesson has 3 tiered tasks: Beginner, Intermediate, Advanced
- Every task gets validated against a living RULEBOOK before moving on

### 2. Documentation-First Approach
- Everything is documented: lessons, progress, coding standards, conversations
- The entire repo should be self-contained — anyone can clone it and follow the same path independently
- PRD.md defines the project goals and success criteria
- RULEBOOK.md is a living coding standards document that evolves per phase
- PROGRESS.md tracks completion and acts as a study journal

### 3. Git Strategy
- Dedicated standalone repo (not inside the parent Project_SFDC repo)
- Repo: `Master-Apex-Learning-Pathway` on GitHub (public, for sharing)
- Every file change auto-commits and pushes — no manual confirmation needed

### 4. Tutor Persona
- Cursor rule (`.cursor/rules/tutor.mdc`) ensures consistent AI tutor behavior across sessions
- Tutor validates code against RULEBOOK, tracks progress, logs conversations
- As the learner progresses, the tutor escalates: introduces code smells, refactoring, real-world release patterns, and timed interview challenges

### 5. Quality Bar
- This is NOT a textbook exercise project — it must prepare for real-world development and interviews
- Tasks must reflect genuine production scenarios, not toy problems
- Best practices and Salesforce release considerations will be woven in progressively
- The learner explicitly asked for intelligent, deeply-crafted content

## Learner Profile

- Has done Apex before — knows what it can do and the basics
- Starting from scratch deliberately to build proper foundations
- Goal: clear future Salesforce developer interviews
- Prefers hands-on learning over theory-heavy explanations
- Wants real-world applicability, not academic exercises

## Files Created This Session

| File | Purpose |
|------|---------|
| `curriculum/PRD.md` | Project charter and success criteria |
| `curriculum/RULEBOOK.md` | Living coding standards document |
| `curriculum/PROGRESS.md` | 55-lesson tracker with study journal |
| `curriculum/phase-1-apex-fundamentals/01-data-types-and-variables.md` | First lesson with 3 tiered tasks |
| `.cursor/rules/tutor.mdc` | Tutor persona rule for AI consistency |
| `README.md` | Project overview and getting-started guide |
| `conversations/` | This folder — session logs |

## Open Items

- GitHub remote not yet connected — learner needs to create the repo and add the remote
- Lesson 01 tasks not yet attempted — next session should begin hands-on coding
- Remaining 54 lesson files to be created as the learner progresses through each phase

## Doubts Raised

_No lesson doubts in this session — project setup only. Doubt tracking begins with Lesson 01._

## Contradictions / Changes

_None yet. This is the first session._
