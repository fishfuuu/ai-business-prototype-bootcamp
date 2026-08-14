# Enterprise AI Business Prototype Bootcamp

> For business managers who know their business best: build business prototypes with AI agents, decide where AI fits, and hand a verified prototype package to IT for engineering delivery.
>
> [中文版](README.md)

Enterprises struggle with AI transformation not because of technology, but because nobody translates deep business knowledge into a plan that engineering can verify and build on. This bootcamp trains business managers to use Coding Agents (e.g., Claude) to turn real business pain points into runnable system prototypes, decide where and how AI should be integrated, and finally hand a complete "prototype + evidence + decision" package to IT.

> Note: This is a **public course-material repository**. We do not accept internal prototypes or student work here; keep training outputs in your own private repositories.

---

## Table of Contents

- [Why This Course](#why-this-course)
- [Who It Is For](#who-it-is-for)
- [What You Will Gain](#what-you-will-gain)
- [Ten-Lesson Overview](#ten-lesson-overview)
- [Resources & Key Documents](#resources--key-documents)
- [Repository Structure](#repository-structure)
- [Tech Stack](#tech-stack)
- [Requirements](#requirements)
- [Quick Start](#quick-start)
- [Safety & Compliance](#safety--compliance)
- [Contributing](#contributing)
- [License](#license)

---

## Why This Course

Many companies get stuck at the same point when adopting AI:

- Engineering doesn't understand the business; business can't articulate requirements;
- Teams chase "full automation / LLM agents" even where simple rules would do;
- Deliverables can't be verified or handed off, so AI stays on slides.

This course centers on one idea: **the business manager knows the business best**. The manager drives AI agents to build **low-risk, verifiable, human-overridable prototypes**, validates what AI can actually deliver, then hands evidence and decisions to IT.

Core principles:

1. **Define first, then build**: turn vague business into an executable contract instead of letting AI guess.
2. **Simplest sufficient**: use rules before AI, use Workflow before Agent.
3. **Human in the loop**: the manager approves, corrects, takes over, or stops at key nodes; AI does not make business decisions.
4. **Prototype ≠ production**: mock data and simulated behavior deliver "decision evidence", not a deployable system.

## Who It Is For

- Business managers / department heads / domain experts who know their business best (no coding required);
- Functional leaders who want to reshape workflows with AI and drive enterprise AI transformation;
- Executives and technical decision-makers who care about making AI actually work for the business;
- Trainers / course developers may use this material to run internal bootcamps.

## What You Will Gain

After ten lessons and assignments, you will be able to:

1. **Build system prototypes tied to real business pain points** with Coding Agents such as Claude (dashboards, workflow tools, system sketches);
2. **Decide where and at what level to integrate AI** (no AI / assisted / fixed Workflow / controlled Agent), with reasons;
3. **Build a verifiable evidence chain for your prototype** (UI behavior, logs, engineering checks) instead of "I think it works";
4. **Produce a hand-off "development starter package"**: confirmed facts, evidence, gaps, product decision, and next steps for IT to judge and engineer;
5. **Master engineering guardrails for working with AI**: contract freeze, incremental slicing, bounded debugging, independent review, and mock-data rules.

## Ten-Lesson Overview

| # | Topic | Outcome |
| --- | --- | --- |
| L1 | From business problem to first system page | Understand LLM / Tools / Agent; build the first controlled prototype page |
| L2 | Make the prototype clear, credible, usable | Use reference images & design rules to craft a professional page |
| L3 | Turn vague business into an executable contract | Freeze a business & data contract through structured questioning |
| L4 | Slice the contract into implementable increments | Controlled agent loop + physical state machine, delivered incrementally |
| L5 | First AI/Agent integration into business | Judge AI involvement level per step; pick an opportunity candidate |
| L6 | Find bugs with facts, fix within bounds | Five-layer diagnosis + bounded debugging |
| L7 | Agent drives the page and leaves evidence | Browser-automated acceptance + a four-category evidence chain |
| L8 | Claude builds, Codex reviews, manager decides | Context-isolated independent review + accept/fix/stop/defer |
| L9 | Department AI opportunity map & pattern selection | Scale one candidate into a department-level AI opportunity map |
| L10 | Freeze the prototype, decide, and hand off | Inventory assets, make the product decision, deliver the starter package to IT |

Each lesson ships with: a **learner guide** (concepts + hands-on labs), an **interactive HTML page** (demos / quizzes / exit checks), and a **teacher plan**.

## Resources & Key Documents

| Document | Description |
| --- | --- |
| [Course Roadmap](lessons/COURSE_ROADMAP.md) | Course positioning, capability matrix, per-lesson tasks & deliverables |
| [Frozen Baseline](lessons/TEN_LESSON_FROZEN_BASELINE.md) | Frozen standard for concepts, tasks, evidence, and non-goals |
| [Learner Guides](lessons/) | `LESSON_01_GUIDE.md` ~ `LESSON_10_GUIDE.md` (concepts + labs) |
| [Interactive Pages](lessons/html/) | Ten lesson HTML pages (with quizzes & exit checks) + roadmap/glossary HTML |
| [Glossary](GLOSSARY.md) | Unified terminology |
| [Design Spec](DESIGN.md) | Design system & component rules for prototypes |
| [AI Engineering Guardrails](CLAUDE.md) | Collaboration guardrails, verification & commit rules |

## Repository Structure

```text
ai-business-prototype-bootcamp/
├── lessons/                  # Course core
│   ├── COURSE_ROADMAP.md
│   ├── TEN_LESSON_FROZEN_BASELINE.md
│   ├── LESSON_XX_GUIDE.md        # learner guides
│   ├── LESSON_XX_TEACHER_PLAN.md # teacher plans
│   └── html/                 # interactive pages (10 lessons + roadmap + glossary)
├── src/                      # "Fitting Mirror" prototype base (Vue 3 app)
│   ├── pages/ components/ layouts/
│   ├── mocks/                # all mock data
│   └── router/ main.ts ...
├── references/               # read-only reference assets (components/config/styles)
├── course-fixtures/          # lesson demo fixtures (failure/fallback samples)
├── scripts/                  # course tooling (e.g., student package export)
├── student-package/templates/# student starter templates
├── .agents/  .claude/        # AI collaboration skills (grill-me, diagnose, incremental implementation, etc.)
├── index.html  package.json  vite.config.ts  tsconfig.json
├── DESIGN.md  GLOSSARY.md  CLAUDE.md  README.md  LICENSE
└── start-project.bat
```

## Tech Stack

The "Fitting Mirror" is a ready-to-use enterprise admin prototype base that all course prototypes build on:

- **Vue 3 + TypeScript**: Composition API + type safety
- **Element Plus**: enterprise UI library
- **Vite**: dev server & build (default `127.0.0.1:8888`)
- **Pinia + Vue Router**: state & routing
- **ECharts**: data visualization (dashboards, charts)
- **Tailwind CSS**: utility-first CSS
- Built-in business components: `KpiCard`, `FilterPanel`, `DataTable`, `StatusTag`, etc.

## Requirements

| Dependency | Requirement | Notes |
| --- | --- | --- |
| Node.js | >= 20.19.0 | Run the prototype base |
| npm | Bundled with Node.js | Install dependencies |
| Modern browser | Chrome / Edge | Open the Fitting Mirror |
| Claude Code (recommended) | Latest | The coding agent used in labs (other compatible agents work too) |
| MCP / Playwright (optional) | Lesson 7 browser acceptance | e.g., `@playwright/mcp` for browser-automated evidence |

> All exercises use **mock/fictional data**; no real API keys, model keys, or database configuration needed.

## Quick Start

```powershell
# 1) Install dependencies
npm install

# 2) Start the dev server (opens http://127.0.0.1:8888)
npm run dev

# or double-click start-project.bat
```

Other commands:

```powershell
npm run typecheck   # TypeScript type check
npm run build       # type check + production build
npm run preview     # preview the production build
```

## Scripts (Teachers / Maintainers)

The repository ships 3 PowerShell scripts for building and verifying student distribution packages:

| Script | Purpose | Key parameters |
| --- | --- | --- |
| `scripts/export-student-package.ps1` | **Build a full student package**: exports a whitelisted set of runtime files + learner templates + all 10 lesson guides + interactive courseware (12 HTML pages) + teaching skills + student roadmap from a Git commit (default `HEAD`), generates `VERSION.txt` / `PACKAGE_MANIFEST.txt` / `SHA256SUMS.txt`, runs safety checks, and compresses everything into a ZIP plus SHA256. **Uncommitted working-tree changes never enter the package.** | `-CourseState` (e.g. `lesson-01-start`), `-Version` (e.g. `v0.1.0`), `-SourceRef`, `-OutputDirectory`, `-PackageProfile` |
| `scripts/export-teacher-package.ps1` | **Build a teacher classroom-delivery bundle**: packages the 10 teacher plans + 10 learner guides + interactive courseware + course roadmap + course fixtures + teaching skills + prototype base from a Git commit (default `HEAD`), generates `VERSION.txt` / `PACKAGE_MANIFEST.txt` / `SHA256SUMS.txt`, and compresses into a ZIP plus SHA256. **Uncommitted working-tree changes never enter the package.** | `-Version` (e.g. `v0.1.0`), `-SourceRef`, `-OutputDirectory` |
| `student-package/templates/scripts/verify-student-project.ps1` | **Verify a student package**: inside the student project, checks required files, forbidden teacher-only paths, `npm run typecheck`, `npm run build`, and scans for environment/credential files. | none (run from the project root) |

> Teacher/maintainer only: the student package is exported from a Git commit snapshot, so **uncommitted changes never enter a distribution package**; commit the relevant content before distributing.

## Safety & Compliance

- **Mock only**: all sample and exercise data is fictional; no real customer, employee, or business data;
- **Never commit**: `.env`, tokens, passwords, secrets, database connections, production endpoints, or internal accounts;
- **`references/` is read-only**: do not modify or delete reference materials;
- **Prototype ≠ production**: prototypes validate paths and support decisions; production still needs security, data, testing, and operations gates.

## Contributing

This is a public course repository; contributions via issues/PRs are welcome.

1. Read the [AI Engineering Guardrails](CLAUDE.md) and the [Design Spec](DESIGN.md) first;
2. Run `npm run typecheck` and `npm run build` before submitting;
3. Clearly explain the goal, teaching impact, and verification results in your PR;
4. **Never submit real business data, internal prototypes, or any sensitive information**.

## Credits

Some teaching and course-production skills in this repository are sourced from or adapted from the following open-source projects:

| Skill | Source | License |
| --- | --- | --- |
| `grill-me`, `diagnose` ($diagnose), `incremental-implementation` (teaching) | [mattpocock/skills](https://github.com/mattpocock/skills) | MIT |
| `teach` (course production) | [mattpocock/skills](https://github.com/mattpocock/skills) | MIT |
| `alterlab-teaching-design` (course production, verbatim) | [AlterLab-IEU/AlterLab-Academic-Skills](https://github.com/AlterLab-IEU/AlterLab-Academic-Skills) | MIT |
| `curriculum-knowledge-architecture-designer` (course production, verbatim) | [GarethManning/education-agent-skills](https://github.com/GarethManning/education-agent-skills) | CC BY-SA 4.0 |
| `find-skills` (course production) | [vercel-labs/skills](https://github.com/vercel-labs/skills) | MIT |
| `teaching-lesson-plan` (course production, adapted) | [mohitagw15856/pm-claude-skills](https://github.com/mohitagw15856/pm-claude-skills) | MIT |

Each skill file also retains its source and copyright notice. `teacher-plan-architect` and `qa-tester` are original to this repository.

> Note: `curriculum-knowledge-architecture-designer`'s upstream is **CC BY-SA 4.0** (different from this repo's MIT). It is included verbatim and redistributed under its upstream license; if you adapt and publicly redistribute it, you must license the adaptation under CC BY-SA 4.0 as well.

## License

Licensed under the [MIT License](LICENSE). Course materials and sample prototypes may be used and redistributed under it. When applying to real business scenarios, ensure compliance with your organization's data policies.
