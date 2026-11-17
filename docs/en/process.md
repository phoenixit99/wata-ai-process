# AI Agent software development process

From GitHub Issue to Pull Request, Code Review, QA and Automation Test

Version: 1.0 · Created: 16-10-2026 · WATA Software · Internal document

> English translation. The Vietnamese page is the original.

---

## 1. Summary

This document describes the standard software development process for the company's projects: all source code
of a project (web, admin, API, mobile) lives in a single repository, and an AI Agent (Claude) takes on most of the
repetitive work, from checking requirement quality, writing code and reviewing, to writing test cases and running
automation tests.

People keep the decision-making role: writing requirements (issues), confirming scope, and merging code into the
main branch. Every step leaves a trace on GitHub (label, comment, PR), so it is easy to follow and control.

| Item | Content |
|---|---|
| Goal | Shorten the time from requirement to working feature; standardise code and test quality. |
| Scope | Applies to every project; the reference structure has 4 apps: web (Next.js), admin (Next.js), api (NestJS), mobile (Flutter). |
| Main tools | GitHub (Issue, PR, Actions), Claude Code + Skills, MCP: GitHub, Figma, Playwright. |
| Control | Mandatory status labels, Definition of Ready, automated CI, merge by people only. |

## 2. Project monorepo architecture

Each project follows the standard monorepo structure below; folder names and technologies can be adjusted per
project. All apps live in one repository. The AI Agent therefore sees the whole system at once, can change a
feature across several apps in one Pull Request, and the apps share one set of data types (contract).

```
<project>/
├── apps/
│   ├── web/        Next.js – end-user app
│   ├── admin/      Next.js – admin site
│   ├── api/        NestJS  – backend REST API (Prisma)
│   └── mobile/     Flutter – mobile app
├── packages/shared/    Shared data types (@<project>/shared)
├── e2e/                Playwright automation + test cases
├── .claude/skills/     Skills for the AI Agent
├── .mcp.json           MCP connections: GitHub, Figma, Playwright
├── .github/            Issue/PR templates, CI workflow
└── CLAUDE.md           General instructions for the AI Agent
```

| Component | Technology | Role |
|---|---|---|
| apps/web | Next.js 15, React 19, Tailwind | End-user interface |
| apps/admin | Next.js 15, Tailwind | Administration, statistics, operations |
| apps/api | NestJS 10, Prisma | REST API, business logic, data; Swagger docs |
| apps/mobile | Flutter 3, Riverpod | iOS/Android app |
| packages/shared | TypeScript | Contract shared by api, web and admin |
| e2e | Playwright | Automated API, web, admin tests |

::: tip Main benefit
One place for code, coding standards, CI and documentation. The AI Agent has enough context to work accurately
without switching between repositories.
:::

## 3. Tools and integrations

### 3.1 MCP (Model Context Protocol)

MCP is the connection standard that lets the AI Agent work directly with external systems. The project ships 3
connections in `.mcp.json`:

| Connection | What the AI Agent can do | Authentication |
|---|---|---|
| GitHub | Read/create issues, change labels, comment, create branches, open PRs, review with line comments | Personal Access Token (fine-grained, limited to the repo) |
| Figma | Read designs: layout structure, colours, fonts, frame screenshots, to code and compare the UI | Figma OAuth login, or Figma Desktop (Dev Mode) |
| Playwright | Open a browser, explore the UI, take screenshots for writing tests | None |

### 3.2 Skills

Each skill is a standard instruction so the AI Agent does a task the same way every time, following the team's
rules. Skills are managed like code: reviewed, with change history.

| Skill | Function |
|---|---|
| `github-issue-create` | Creates a well-formed issue (Description, Acceptance Criteria, Design), into Backlog |
| `github-issue-triage` | Checks assigned issues against the Definition of Ready → Ready to dev or Fail to dev |
| `github-issue-implement` | Creates a branch, codes to the coding standard, writes unit tests, opens a Pull Request |
| `github-pr-review` | Reviews the PR against the Acceptance Criteria and coding standard, with line comments |
| `qa-test-cases` | Generates test cases (positive, negative, boundary, state) from the Acceptance Criteria |
| `e2e-playwright` | Writes and runs automation tests, classifies failures, reports results on the PR |
| `figma-to-code` | Reads the Figma design, turns it into code per app standard, compares the UI |
| `dev-pipeline` | Runs the whole flow above for the assigned issues |
| `nextjs` / `nestjs` / `flutter-coding-standard` | Per-technology coding standard, placed in each app's folder |

## 4. Work status flow

Every issue always has exactly one status label. The label is the single source of truth: the label tells where
the work is and who (person or AI) is handling it.

| Status | Meaning | Who moves it here |
|---|---|---|
| Backlog | New issue, not yet checked | PO / AI (issue-create skill), GitHub Action |
| Fail to dev | Missing description or acceptance criteria; a comment lists what is missing | AI (triage) |
| Ready to dev | Meets the Definition of Ready, ready to code | AI (triage) |
| In progress | Being coded on its own branch | AI (implement) |
| In review | Pull Request opened, under review | AI (implement) |
| QA | Review passed; test cases being written and automation run | AI (review) |
| QA passed | All automation tests pass, waiting for a person to merge | AI (automation) |
| QA failed | Product bugs remain after 3 self-fix rounds, needs a person | AI (automation) |

```
   ┌─────────────┐   Missing info     ┌───────────┐
   │ Fail to dev │◄───────────────────┤  Backlog  │
   │             ├───────────────────►│           │
   └─────────────┘   PO adds details  └─────┬─────┘
                                            │ Triage passed
                                            ▼
                        ┌──────────────┐◄───┘
                        │ Ready to dev │
                        └──────┬───────┘
                               │ AI codes
                               ▼
                        ┌──────────────┐
                        │ In progress  │◄──┐
                        └──────┬───────┘   │
                               │ Open PR   │ Request changes
                               ▼           │
                        ┌──────────────┐   │
                        │  In review   ├───┘
                        └──────┬───────┘
                               │ Review passed
                               ▼
                        ┌──────────────┐
                        │      QA      │
                        └──┬────────┬──┘
           Automation green│        │ Failing after 3 rounds
                           ▼        ▼
                  ┌───────────┐  ┌───────────┐
                  │ QA passed │  │ QA failed │
                  └─────┬─────┘  └───────────┘
                        ▼
                ┌────────────────┐
                │     Merge      │
                │   (person)     │
                └────────────────┘
```

*Figure 1. Lifecycle of an issue*

## 5. Definition of Ready: conditions to start coding

Unclear requirements are the most common cause of rework. So the AI only codes when an issue meets all the
conditions below; otherwise the issue moves to Fail to dev with a list of what is missing and suggested rewording.

| # | Condition | Required |
|---|---|---|
| R1 | Has an assignee | Yes |
| R2 | Specific title saying what changes | Yes |
| R3 | Has a Description explaining the problem and reason (user story encouraged) | Yes |
| R4 | Has Acceptance Criteria with at least 1 criterion | Yes |
| R5 | Each criterion is testable: an action and an observable result (no vague words like "fast", "nice") | Yes |
| R6 | Affected app identified (web / admin / api / mobile) | Yes |
| R7 | No TBD, "???" or unfilled template parts | Yes |
| R8 | Not blocked by another unfinished issue | Yes |
| R9 | For bugs: reproduction steps, expected result and actual result | Yes (bug) |
| R10 | API change describes request/response; UI change has a Figma frame link | Recommended |

::: tip Example
"Users can manage orders" → fails (not testable). "When the user clicks Delete, the order disappears from the list
and the API no longer returns it" → passes.
:::

## 6. Step by step

### Step 1: Create the issue

- The PO or a team member describes the requirement in natural language; the AI drafts the issue in the standard
  template: Description, Acceptance Criteria, Affected apps, Design (Figma link), Technical notes.
- The issue automatically gets the Backlog label, the work type (feature/bug/chore) and the related apps.
- Anything the AI had to assume is clearly marked for the PO to confirm.

### Step 2: Triage (check the issue)

- The AI takes the assigned issues and checks them against the 10 Definition of Ready conditions.
- The result is written as a table comment on the issue; the label moves to Ready to dev or Fail to dev.
- A Fail to dev issue is re-checked automatically after its author updates it.

### Step 3: Code and open a Pull Request

- The AI moves the issue to In progress and creates a branch by convention (e.g. `feat/42-due-date`).
- Before coding, it builds a mapping table Acceptance Criteria → code change → test.
- It reads the coding standard of each affected app; if there is a Figma link it reads the design via Figma MCP.
- Coding order: shared contract → API → web/admin → mobile; write unit tests.
- Lint, type check, unit tests and build must pass before opening the PR. The PR links the issue
  (`Closes #number`) and the issue moves to In review.

### Step 4: Code review

The AI reviews the PR with an 8-criterion checklist and classifies findings as Blocker / Major / Minor:

| Criterion | What is checked |
|---|---|
| Acceptance Criteria | Every criterion is implemented; nothing out of scope |
| Correctness | Edge cases, error handling, HTTP status codes |
| Coding standard | Structure, naming, types, no leftover code |
| Contract | Shared types in sync across API, web, admin, mobile |
| Security | Input validation, no leaked secrets, no injection |
| Tests | Unit tests for new logic; test ids for automation |
| Performance | No redundant queries, pagination present |
| Design | UI matches the Figma frame |

- Blocker/Major → the AI fixes and re-reviews (at most 3 rounds). Passed → the issue moves to QA.

### Step 5: Write test cases

- From each Acceptance Criterion the AI generates test cases: main flow, invalid data, boundary values, state
  transitions, sync across apps.
- Each test case has an id (TC-issue number-sequence), a priority P1–P3, and is marked automated or manual.
- The test case table is stored in the repository and summarised on the issue, so the team's QA can review it.

### Step 6: Automation tests with Playwright

- The AI writes Playwright tests for the automatable test cases; test names start with the test case id so a
  failure traces back to its Acceptance Criterion.
- When a test fails, the AI classifies it: test bug, product bug, or environment issue; then fixes it in the right
  place (at most 3 rounds).
- Results (pass / fail / manual) are reported as a table on the PR. All passing → QA passed; failures remain →
  QA failed with the cause.

### Step 7: Merge (people)

- The Tech Lead / Reviewer looks at the PR, the AI's review and the automation report, then decides to merge.
- On merge the issue closes automatically through the `Closes #number` link.

## 7. Unified coding standards

Each technology has its own coding standard, placed in the app's folder. The AI Agent must read it before coding
and uses the same standard when reviewing, so code written by AI or by people follows one style.

| Technology | Main content of the coding standard |
|---|---|
| Next.js (web, admin) | Feature-based structure; Server Components first; all API calls through a typed client; full loading/error/empty states; Tailwind; data-testid for automation |
| NestJS (api) | One module per feature; controllers only handle HTTP, logic lives in services; DTOs with validation and Swagger; standardised errors; pagination; unit tests for services |
| Flutter (mobile) | Feature-based structure (data / domain / presentation); Riverpod; models in sync with the shared contract; Theme instead of hard-coded colours; strict lint; unit + widget tests |

There are also shared conventions: branch names, Conventional Commits, a PR template with a checklist, and CI
that runs lint, tests, build and automation for every PR.

## 8. Roles: people and AI

| Role | Responsibility | AI support |
|---|---|---|
| PO / BA | Write requirements and Acceptance Criteria; answer questions when an issue is Fail to dev | Draft well-formed issues, point out gaps |
| Designer | Design in Figma, provide frame links | Read designs, code the UI, compare the UI |
| Developer / Tech Lead | Approve architecture, final review, merge PRs, handle complex cases | Code, unit tests, first-pass review |
| QA | Approve test cases, manual testing of the rest (mobile, UX) | Generate test cases, write and run automation |
| Manager | Track progress through labels and the board | Status reports as tables |

## 9. Risk control

| Risk | Control |
|---|---|
| AI codes the wrong thing | Strict Definition of Ready; AC → code → test mapping; review and automation against the AC |
| Poor, inconsistent code quality | Mandatory coding standard per app; CI blocks PRs failing lint/test/build |
| AI pushes code to production on its own | No push to main, no force-push; only people merge |
| Endless fix loops | 3-round limit for review and automation, then stop and notify a person |
| Leaking sensitive information | GitHub token scoped to the repo; no secrets in comments/logs |
| Lack of transparency | Every step leaves labels and comments on GitHub, fully traceable |

## 10. Suggested metrics

| Metric | How measured | Meaning |
|---|---|---|
| Lead time | Time from Ready to dev to QA passed | Feature delivery speed |
| Fail to dev rate | Fail to dev issues / total triaged issues | Input requirement quality |
| First-time review pass rate | PRs passing review in round 1 | Initial code quality |
| AC coverage by automation | ACs with automated tests / total ACs | Release safety |
| Escaped bugs | Bugs found after merge | Effectiveness of the whole process |
