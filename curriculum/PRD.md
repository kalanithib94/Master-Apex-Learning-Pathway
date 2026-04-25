# Product Requirements Document (PRD)

## Master Apex Learning Pathway

**Version:** 1.0
**Created:** April 2026
**Status:** Active

---

## 1. Purpose

This project is a structured, hands-on Salesforce development learning pathway designed to take a developer from Apex fundamentals through advanced integrations, LWC, and interview readiness. It operates as an interactive tutor system embedded inside a Salesforce DX project, where every concept is taught, practiced at three difficulty levels, and validated.

The secondary purpose is to produce a reusable textbook — a complete curriculum with live code examples that others can follow independently.

---

## 2. Target Audience

**Primary:** A developer with basic Apex awareness who wants to systematically build deep expertise across the Salesforce platform and prepare for technical interviews.

**Secondary:** Any developer who receives this project as a learning resource. The curriculum, code examples, and progress tracker are designed to be self-contained and reproducible.

---

## 3. Goals

- Build production-quality Apex coding skills from the ground up
- Develop fluency in Batch/Async Apex, LWC, and Integration patterns
- Internalize Salesforce best practices and governor limit awareness
- Create a portfolio of working code deployed to a real Salesforce org
- Prepare for Salesforce developer interviews with scenario-based practice
- Produce a documented learning path that others can follow

---

## 4. Success Criteria

| Criteria | Measure |
|----------|---------|
| All 55 lessons completed | PROGRESS.md fully checked off |
| Code deployed to org | Every task class exists in `force-app/main/default/classes/` |
| Test coverage | Every implementation class has a test class with 75%+ coverage |
| Best practices followed | Code passes RULEBOOK.md checklist |
| Interview readiness | Phase 7 completed with mock scenarios |
| Reusability | A new developer can clone this repo and follow the path independently |

---

## 5. Curriculum Phases

### Phase 1: Apex Fundamentals (Lessons 1-10)
Foundation layer — data types, collections, control flow, SOQL, DML, and exception handling. Everything you need before writing real business logic.

### Phase 2: Apex Intermediate (Lessons 11-18)
Real-world Apex — triggers, trigger frameworks, governor limits, bulkification, test classes, and custom metadata. The bridge from "I know Apex" to "I can build features."

### Phase 3: Apex Advanced (Lessons 19-25)
Architecture-level skills — dynamic Apex, design patterns, enterprise layer patterns, security, and custom APIs. What separates a developer from a senior developer.

### Phase 4: Batch and Async Apex (Lessons 26-32)
Asynchronous processing — future methods, queueable, batch, schedulable, and platform events. Handling data at scale.

### Phase 5: Lightning Web Components (Lessons 33-42)
Front-end development — LWC fundamentals, component communication, wire service, LDS, datatables, and performance. Building UIs that talk to your Apex.

### Phase 6: Integrations (Lessons 43-50)
Connecting systems — HTTP callouts, named credentials, REST APIs (inbound and outbound), OAuth, and integration patterns. Making Salesforce talk to the world.

### Phase 7: Interview Preparation (Lessons 51-55)
Bringing it all together — top interview questions, scenario-based challenges, system design, code review exercises, and mock interviews.

---

## 6. How It Works

1. **Lesson delivery** — Each lesson is a markdown file with theory, real-world context, and three tiered tasks
2. **Hands-on coding** — The learner writes Apex/LWC in `force-app/` and deploys to their org
3. **Validation** — The tutor reviews code for correctness, best practices, naming, limits, and coverage
4. **Feedback loop** — Improvements suggested, code refined
5. **Progress tracking** — Lessons marked complete in `PROGRESS.md`
6. **Escalation** — As the learner progresses, the tutor introduces code smells, refactoring, and real-world release considerations

---

## 7. Constraints

- All code must be deployable to a Salesforce org (scratch or developer edition)
- The project follows Salesforce DX source format
- API version: 66.0
- Test classes are mandatory for every implementation class
- The `Assert` class must be used for all assertions
- No GptfyException usage outside of Batch Apex classes
- Meta.xml files are always generated alongside Apex classes

---

## 8. Out of Scope (For Now)

- Salesforce Admin topics (profiles, permission sets, page layouts)
- Flows and Process Builder
- Salesforce CPQ or industry-specific clouds
- Deployment pipelines and CI/CD (may be added later)
- Salesforce certifications curriculum (this is coding-focused)

---

## 9. Timeline

This is a self-paced learning path. Suggested pacing:

| Phase | Estimated Duration |
|-------|-------------------|
| Phase 1: Fundamentals | 2-3 weeks |
| Phase 2: Intermediate | 2-3 weeks |
| Phase 3: Advanced | 2-3 weeks |
| Phase 4: Batch/Async | 1-2 weeks |
| Phase 5: LWC | 3-4 weeks |
| Phase 6: Integrations | 2-3 weeks |
| Phase 7: Interview Prep | 1-2 weeks |
| **Total** | **13-20 weeks** |

Actual pace depends on prior experience and available practice time. There is no deadline — mastery matters more than speed.
