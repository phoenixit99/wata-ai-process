# Scrum with an AI Agent

Roles, stages, quality gates and the effort shift compared with traditional Scrum

Version: 1.0 · Created: 16-10-2026 · WATA Software · Internal document

> English translation. The Vietnamese page is the original.

---

## 1. Purpose and scope

This document defines the team's Scrum process after bringing an AI Agent into software development. The Scrum
framework stays the same (roles, events, artifacts), but the **split of work between people and AI** and the
**effort focus** of each stage change.

It applies to the company's software development **projects**, especially those organised as a monorepo (web,
admin, API, mobile in one repository).

::: tip Core principle
The AI takes the repetitive execution (writing code, tests, first-round review). People are responsible for
**value** (what and why), **decisions** (architecture, merge, release) and **acceptance**.
:::

## 2. Overview of Scrum with AI

A sprint has 10 consecutive steps. The colour of each step shows the direction of the effort shift compared with
traditional Scrum:

- **Light red:** human effort increases. These are the new bottlenecks.
- **Light green:** the AI does most of the work; human effort drops sharply.
- **Grey:** effort stays about the same.

| # | Step | People – AI split | Effort |
|---|---|---|---|
| 1 | Discovery & requirements | People: PO/BA · AI: drafts stories, suggests AC | Light red (up) |
| 2 | Refinement & DoR check | People: PO + Team · AI: automatic triage | Light red (up) |
| 3 | Sprint planning | People: whole team · AI: review/QA capacity data | Grey (same) |
| 4 | UI design & architecture | AI: creates Figma, proposes architecture · People: Designer approves UI · Tech Lead decides architecture | Light green (down) |
| 5 | Coding + unit tests | AI: code, tests · People: assign, supervise | Light green (down) |
| 6 | Code review | AI: first-round review · People: final approval | Light red (up) |
| 7 | QA: test cases + automation | AI: generates & runs · People: approve, exploratory testing | Light green (down) |
| 8 | CI/CD & deployment | Automated · People: approve release | Light green (down) |
| 9 | Sprint review & UAT | People: PO, customer | Light red (up) |
| 10 | Retrospective | People: whole team · Improve both the process and the AI skills | Grey (same) |

Step 6 → 5: fixes (review asks for changes, back to coding). Step 10 → 1: next sprint.

*Figure 1. Sprint loop and people – AI split*

## 3. Roles and responsibilities

| Role | Traditional Scrum | Scrum with AI | Effort |
|---|---|---|---|
| Product Owner / BA | Write stories, prioritise backlog, accept | Same, but write stricter AC, answer Fail to dev stories quickly, accept more | ▲ Up |
| Scrum Master / PM | Facilitate events, remove blockers | Also: watch review/QA bottlenecks, WIP limits, AI cost | ● Same |
| Tech Lead | Architecture, review, support devs | Architecture, final PR approval, owns the coding standards | ▲ Up |
| Developer | Write code, unit tests, fix bugs | Design solutions, assign work to the AI, check and own the code | ▼ Down |
| QA | Write test cases, manual testing, write automation | Approve AI-generated test cases, exploratory/UX testing, real-device testing | ▼ Down |
| Designer | Design each screen, hand over to devs | Build and describe the design system, write UI briefs, review and refine AI-made Figma, own UX | ▼ Down (up in Sprint 0) |
| AI Enablement (new) | — | Maintain skills, coding standards, MCP configuration; analyse recurring AI mistakes. Can be held by the Tech Lead | New |

### 3.1 RACI matrix by stage

R = responsible, A = accountable, C = consulted, I = informed.

| Stage | PO | Designer | Tech Lead | Dev | QA | AI |
|---|---|---|---|---|---|---|
| Writing requirements | A/R | C | C | I | C | R (draft) |
| Refinement / DoR | A | C | R | C | C | R (triage) |
| UI design (Figma) | C | A | I | I | I | R |
| Technical design | C | I | A/R | C | I | C (proposal) |
| Coding | I | I | C | A | I | R |
| Code review | I | I | A | R | I | R (round 1) |
| Test cases & automation | C | I | I | C | A | R |
| Merge & release | I | I | A/R | C | C | — |
| Acceptance | A/R | C | C | I | C | — |

::: tip
The AI is never A (accountable). Every AI output has a specific person accountable for it.
:::

## 4. Artifacts and standards

| Artifact | Change compared with traditional |
|---|---|
| Product Backlog | Stories must follow the template: Description, Acceptance Criteria, UI brief, affected apps; the Figma link is attached after the design is approved. Each story has exactly one status label. |
| Sprint Backlog | Adds WIP limits for the In review and QA columns to avoid pile-ups. |
| Increment | Comes with test cases and automation covering all AC. |
| Definition of Ready | Stricter: 10 criteria, checked automatically by the AI. Stories with UI need a screen description/UI brief. Stories that fail do not enter the sprint. |
| Definition of Done | Adds: automation covers every AC, CI green, final reviewer approved, no Blocker/Major left, UI matches the approved Figma. |
| Design System (new) | Colours, fonts, spacing, components, layout rules and UX principles described by the Designer in an AI-readable form; required input for the AI to create Figma. Versioned. |
| AI assets (new) | Skills, machine-readable coding standards, CLAUDE.md, MCP configuration. Versioned and reviewed like code. |

## 5. Scrum events and timeboxes

Reference: 2-week sprint. The team can shorten the sprint to 1 week once the review and acceptance flow is stable.

| Event | Traditional | With AI | Notes |
|---|---|---|---|
| Sprint Planning | 4 hours | 3–4 hours | Plan by review/QA capacity |
| Daily Scrum | 15 min | 15 min | Label dashboard replaces status reports; focus on blocked work |
| Backlog Refinement | ≤ 10% of sprint | 20–25% of sprint | Largest increase |
| Sprint Review | 2 hours | 2–3 hours | More features to demo |
| Retrospective | 1.5 hours | 1.5 hours | Adds skill/standard improvements |
| Review queue (new) | — | 2 slots/day | Fixed time slots to review PRs, avoiding backlog |
| Design review (new) | — | 30–60 min/story group | PO + Designer + customer, in the first 1–2 days of the sprint |

## 6. Detailed process by stage

Each stage describes: goal, people/AI split, output, quality gate, and the effort shift compared with traditional
Scrum.

### 6.1 Sprint 0: Foundation setup (once per project)

**Goal:** Prepare the environment so the AI works to standard from the first sprint.

| Item | Content |
|---|---|
| Input | Contract, overall scope, technology stack. |
| People do | Tech Lead: choose the architecture, write the coding standard for each technology · PM: set up status labels, board, CI, access rights · Security: approve the data policy, tokens, AI permission scope · Designer: build and describe the design system (colours, fonts, spacing, components, layout rules), prepare sample briefs for the AI to create Figma |
| AI does | Scaffold the monorepo, CI, issue/PR templates · Draft coding standards, workflow skills · Set up an AI tool able to create/write designs in Figma (the specific tool is trialled and chosen by the team) |
| Output | Repository, skills, coding standards, design system, Definition of Ready/Done, MCP connections (GitHub, Figma, Playwright). |
| Quality gate | Tech Lead and Security sign off the standards and access rights; Designer approves the design system. |

**Effort shift: ▲ Up.** A new stage compared with traditional (about 1–2 weeks). An upfront investment reused in
later sprints.

### 6.2 Discovery and requirements (Product Backlog)

**Goal:** Turn customer needs into clear, testable user stories.

| Item | Content |
|---|---|
| Input | Customer needs, meeting notes. |
| People do | PO/BA: work with the customer, decide value and priority · PO/BA: finalise the Acceptance Criteria (AC) · Designer: describe the UI requirements (UI brief) in the story |
| AI does | Draft user stories from meeting notes using the template · Suggest AC in Given/When/Then form, point out missing edge cases · Split large stories into small independent ones |
| Output | Stories in Backlog with Description, AC, Design, affected apps. |
| Quality gate | The story has all required template sections. |

**Effort shift: ▲ Up about +20%.** The AI drafts quickly, but the PO/BA must write in more detail and more
precisely than before because the AI executes literally and does not fill gaps like an experienced developer.

### 6.3 Backlog Refinement and Definition of Ready check

**Goal:** Make sure every story entering the sprint is ready for the AI.

| Item | Content |
|---|---|
| Input | Stories in Backlog. |
| People do | PO + Tech Lead: answer questions, settle scope, assess technical risk · PO: complete Fail to dev stories |
| AI does | Automatic triage against the 10 DoR criteria · Move to Ready to dev or Fail to dev, commenting clearly on what is missing and how to rewrite it |
| Output | List of Ready to dev stories. |
| Quality gate | All required DoR criteria met. |

**Effort shift: ▲ Up about +60%**, from ~10% to ~20–25% of the PO's and Tech Lead's sprint time. This stage
decides output quality when working with AI.

### 6.4 Sprint Planning

**Goal:** Choose an amount of work that fits the team's real capacity in the sprint.

| Item | Content |
|---|---|
| Input | Ready to dev stories, data from previous sprints. |
| People do | Whole team: choose stories, commit to the Sprint Goal · Tech Lead: identify stories that need a person to code directly (complex, sensitive) |
| AI does | Provide data: lead time, PRs each person can review, Fail to dev rate · Suggest splitting or grouping stories |
| Output | Sprint Backlog, Sprint Goal. |
| Quality gate | Total work does not exceed the team's review and QA capacity. |

**Effort shift: ● Same.** Effort is unchanged, but the criterion changes: plan by review/acceptance capacity
instead of coding capacity.

### 6.5 UI design (AI creates Figma) and architecture

**Goal:** Settle the UI and technical solution before coding.

| Item | Content |
|---|---|
| Input | Stories in the sprint, UI brief, design system. |
| People do | Designer: write the brief, review and refine the AI-made Figma, check UX and accessibility · PO + customer: choose and confirm the UI option · Tech Lead: decide architecture, API contract, data model |
| AI does | Create Figma from the design system, with normal, error, empty and loading states · Offer 2–3 UI options, update from feedback · Propose technical options, compare pros and cons |
| Output | Approved Figma frames attached to the story; a short technical design. |
| Quality gate | Designer approves and the customer confirms the UI before coding starts; Tech Lead approves the architecture for complex stories. |

**Effort shift: ▼ Down about −25%.** The AI creates the design and options; the Designer moves from drawing each
screen to describing, reviewing and refining. Architecture decisions stay with people.

### 6.6 Coding and unit tests

**Goal:** Implement the story to the AC and the coding standard.

| Item | Content |
|---|---|
| Input | Ready to dev story, coding standard, approved Figma, technical design. |
| People do | Developer: assign work to the AI, monitor, handle what the AI gets wrong or complex parts · Developer: final responsibility for the code |
| AI does | Create the branch, build the AC → change → test table · Write code and unit tests, run lint/typecheck/build · Open a Pull Request linked to the story |
| Output | Pull Request with the AC mapping table. |
| Quality gate | CI green: lint, typecheck, unit tests, build. |

**Effort shift: ▼ Down about −70%.** The biggest drop. Developers move from writing code to designing, assigning
and checking.

### 6.7 Code review

**Goal:** Make sure the code is correct, safe and maintainable before QA.

| Item | Content |
|---|---|
| Input | Pull Request. |
| People do | Reviewer/Tech Lead: final approval, focusing on business logic, architecture, security · Decide to accept or request changes |
| AI does | First-round review with the 8-criterion checklist, line comments · Self-fix Blocker/Major issues (at most 3 rounds) |
| Output | Approved PR, story moves to QA. |
| Quality gate | No Blocker/Major left; final reviewer approved. |

**Effort shift: ▲ Up about +40%.** Much more code means more total review effort, even though the AI filters each
PR first. This is the new bottleneck; limit the number of PRs waiting for review.

### 6.8 QA: test cases and automation

**Goal:** Prove every AC works without regressions.

| Item | Content |
|---|---|
| Input | Reviewed PR, the story's AC. |
| People do | QA: approve the test cases, add business scenarios · QA: exploratory testing, UX testing, real-device testing (mobile) |
| AI does | Generate test cases: main flow, invalid data, boundary values, state transitions · Write and run Playwright automation, classify failures, self-fix (at most 3 rounds) · Report results on the PR |
| Output | Test cases, automation tests, QA passed/failed report. |
| Quality gate | Every AC has at least 1 test; automation green. |

**Effort shift: ▼ Down.** Test cases and manual QA about −50%, automation about −60%. QA moves from writing and
running tests to reviewing and exploring. Automation coverage rises.

### 6.9 Integration and deployment (CI/CD)

**Goal:** Ship code to staging/production safely.

| Item | Content |
|---|---|
| Input | QA passed PR. |
| People do | Tech Lead: merge the PR · PM/Tech Lead: approve the production release |
| AI does | CI runs all checks automatically; the AI drafts release notes |
| Output | Build on staging/production, release notes. |
| Quality gate | Only people merge and approve releases. |

**Effort shift: ▼ Down about −33%**, thanks to automated checks and release notes.

### 6.10 Sprint Review and UAT

**Goal:** The customer and PO accept the features.

| Item | Content |
|---|---|
| Input | Increment on staging. |
| People do | PO + customer: demo, acceptance, feedback · PO: update the backlog from feedback |
| AI does | Draft demo material, summarise sprint changes · Turn feedback into new stories |
| Output | Accepted features, updated backlog. |
| Quality gate | Customer/PO accept against the AC. |

**Effort shift: ▲ Up about +25%.** Each sprint delivers more features, so acceptance work grows. Agree response
times with the customer in advance.

### 6.11 Sprint Retrospective

**Goal:** Improve how both people and AI work.

| Item | Content |
|---|---|
| Input | Sprint data, recurring AI mistakes. |
| People do | Whole team: evaluate, choose improvement actions · AI platform owner: update skills, coding standards, DoR |
| AI does | Summarise data and recurring mistakes from review/QA comments |
| Output | Improvement actions; new versions of skills/standards. |
| Quality gate | Every AI mistake repeated ≥ 2 times must have an action to fix a skill or standard. |

**Effort shift: ● Same.** Meeting effort is unchanged; skill maintenance is added (about 4% of total effort,
counted under AI platform operations).

## 7. Summary of the effort shift

The table and chart below convert the total effort of a traditional sprint into **100 units** for comparison. These
are initial reference figures based on a typical web/mobile project; the team should replace them with real
measurements after 2–3 pilot sprints.

![Effort by stage: traditional vs with AI](/effort-en.svg)

*Figure 2. Effort by stage: traditional vs with AI*

| Stage | Traditional | With AI | Change | Who carries the change |
|---|---|---|---|---|
| Discovery & requirements | 10 | 12 | ▲ +20% | PO/BA |
| Refinement & DoR | 5 | 8 | ▲ +60% | PO, Tech Lead |
| Sprint planning | 3 | 3 | ● 0% | Whole team |
| UI design & architecture | 8 | 6 | ▼ −25% | Designer, Tech Lead |
| Coding | 40 | 12 | ▼ −70% | Developer |
| Unit tests | 7 | 2 | ▼ −71% | Developer |
| Code review | 5 | 7 | ▲ +40% | Tech Lead, Reviewer |
| Test cases & manual QA | 10 | 5 | ▼ −50% | QA |
| Test automation | 5 | 2 | ▼ −60% | QA |
| CI/CD & deployment | 3 | 2 | ▼ −33% | Tech Lead |
| Sprint review & UAT | 4 | 5 | ▲ +25% | PO, customer |
| AI platform operations | 0 | 4 | New | AI Enablement |
| **Total** | **100** | **68** | **▼ −32%** | |

### 7.1 How the effort mix changes

| Work group | Traditional share | Share with AI |
|---|---|---|
| Requirements, refinement, acceptance (PO/BA, customer) | 19% | 37% |
| Design, architecture, review, release (Designer, Tech Lead) | 16% | 22% |
| Execution: code, unit tests, QA, automation | 62% | 31% |
| Planning & AI platform operations | 3% | 10% |

::: tip Conclusion
Total effort drops by about 32%, but more important is the shift in focus. Execution falls from about 62% to 31%
of total effort. Requirements, decisions and acceptance rise from about 35% to nearly 60%. The team needs more BA,
review and architecture capability, and less pure coding capability.
:::

## 8. Estimation and measurement

### 8.1 How estimation changes

- Story points no longer reflect coding effort. Estimate by business complexity, ambiguity and review/acceptance
  effort.
- Use an S / M / L / XL scale for stories. Flag "needs a person to code" for high-risk stories (security,
  payments, algorithms).
- Sprint capacity is measured by how many PRs the team can review and how many stories the PO can accept, not by
  coding velocity.

### 8.2 Metrics

| Metric | How measured | Reference target |
|---|---|---|
| Lead time | Ready to dev → QA passed | Down ≥ 40% after 3 sprints |
| Review wait time | PR opened → final reviewer approves | < 1 working day |
| Fail to dev rate | Fail to dev stories / triaged stories | < 20% and falling |
| Round-1 review pass rate | PRs needing no Blocker/Major fixes | ≥ 60% |
| AC coverage by automation | ACs with automated tests / total ACs | ≥ 80% (web/admin/api) |
| Escaped bugs | Bugs found after merge | No increase vs traditional |
| AI cost per story | Tokens/licences divided per story | Track the trend |

## 9. Risks and controls

| Risk | Control |
|---|---|
| PRs piling up for review (new bottleneck) | WIP limit on the In review column; fixed daily review slots; AI first-round review |
| Ambiguous requirements → AI is fast but wrong | 10-criterion DoR checked automatically; more refinement time |
| Reviewers over-trusting the AI | Final reviewer must check business logic and security; random checks of approved PRs |
| Customer cannot accept in time | Agree a response SLA in the contract; weekly batch acceptance |
| Juniors lose learning opportunities | Rotate "needs a person to code" stories; juniors review with the Tech Lead |
| Data security, code licensing | Repo-scoped tokens; AI clauses in the contract; no real customer data in prompts |
| AI designs are generic, off-brand, poorly accessible | Design system is mandatory input; Designer approves every screen before coding |
| Licensing of design assets (images, icons, fonts made by AI) | Only use assets from licensed libraries; record sources in the design system |
| Slow customer design approval delays the sprint | Limit approval to the first 1–2 days of the sprint; for large UI stories, do the design a sprint ahead |
| AI vendor dependency | Skills and standards written as neutral Markdown, usable with many tools |
