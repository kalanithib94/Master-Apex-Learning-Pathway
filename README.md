# Master Apex Learning Pathway

A structured, hands-on Salesforce development learning system — from Apex fundamentals through advanced integrations, LWC, and interview preparation.

---

## What Is This?

This is a Salesforce DX project that doubles as an interactive tutoring system. It contains a 55-lesson curriculum organized into 7 phases, where every concept is taught, practiced at three difficulty levels (beginner, intermediate, advanced), and validated against a living rulebook.

All code you write gets deployed to a real Salesforce org. All progress is tracked. The entire repository can be shared with others as a self-contained learning path.

---

## Curriculum Overview

| Phase | Topic | Lessons |
|-------|-------|---------|
| 1 | Apex Fundamentals | 01 - 10 |
| 2 | Apex Intermediate | 11 - 18 |
| 3 | Apex Advanced | 19 - 25 |
| 4 | Batch and Async Apex | 26 - 32 |
| 5 | Lightning Web Components | 33 - 42 |
| 6 | Integrations | 43 - 50 |
| 7 | Interview Preparation | 51 - 55 |

Each lesson includes theory, real-world context, three tiered coding tasks, validation criteria, interview angles, and best practices.

---

## Project Structure

```
Master Apex Learning pathway/
├── force-app/main/default/
│   ├── classes/          # Apex classes and test classes
│   ├── triggers/         # Apex triggers
│   └── lwc/              # Lightning Web Components
├── curriculum/
│   ├── PRD.md            # Project requirements and goals
│   ├── RULEBOOK.md       # Coding standards (living document)
│   ├── PROGRESS.md       # Lesson completion tracker
│   ├── phase-1-apex-fundamentals/
│   ├── phase-2-apex-intermediate/
│   ├── phase-3-apex-advanced/
│   ├── phase-4-batch-and-async/
│   ├── phase-5-lwc/
│   ├── phase-6-integrations/
│   └── phase-7-interview-prep/
├── scripts/
│   ├── apex/             # Anonymous Apex scripts
│   └── soql/             # SOQL query scripts
├── .cursor/rules/        # AI tutor persona rules
├── sfdx-project.json     # SFDX project config (API 66.0)
└── config/
    └── project-scratch-def.json
```

---

## How to Use

### Prerequisites
- Salesforce CLI installed
- A Salesforce Developer Edition org or scratch org
- VS Code with Salesforce Extension Pack (or Cursor IDE)

### Getting Started

1. **Clone this repository**
2. **Authorize your org:**
   ```bash
   sf org login web --set-default --alias learning-org
   ```
3. **Open the first lesson:**
   Open `curriculum/phase-1-apex-fundamentals/01-data-types-and-variables.md`
4. **Read the lesson, then code the tasks** in `force-app/main/default/classes/`
5. **Deploy your code:**
   ```bash
   sf project deploy start --source-dir force-app
   ```
6. **Submit for validation** — the AI tutor will review your code against the RULEBOOK
7. **Track progress** in `curriculum/PROGRESS.md`

### Lesson Flow

1. Read the lesson markdown file
2. Code the **Beginner** task, get it validated
3. Code the **Intermediate** task, get it validated
4. Code the **Advanced** task, get it validated
5. Lesson marked complete, move to the next one

---

## Key Documents

| Document | Purpose |
|----------|---------|
| [PRD](curriculum/PRD.md) | Project goals, phases, and success criteria |
| [RULEBOOK](curriculum/RULEBOOK.md) | Coding standards — all code is validated against this |
| [PROGRESS](curriculum/PROGRESS.md) | Track which lessons are complete |

---

## Tech Stack

- **Language:** Apex (Salesforce)
- **Front-end:** Lightning Web Components (LWC)
- **API Version:** 66.0
- **Project Format:** Salesforce DX Source Format
- **Testing:** Apex Test Framework with Assert class
