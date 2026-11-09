<!-- Sinh tự động bởi scripts/sync-skills.py. Không sửa tay. -->

# Skill catalog

Generated from `skills/catalog.json`, the single source for skills, roles and triggers. Each skill's instructions (written for the AI, in Vietnamese) live in the repo; click a name to read it.

## By role

| Role | Skills |
|---|---|
| PO | `dev-pipeline`, `github-issue-create`, `backlog-refinement`, `sprint-planning`, `uat-run`, `sprint-review`, `sprint-retro` |
| BA | `dev-pipeline`, `feature-analysis`, `github-issue-create`, `backlog-refinement` |
| PM | `dev-pipeline`, `sprint0-setup`, `sprint-planning`, `status-report`, `release-plan`, `daily-scrum`, `sprint-review`, `sprint-retro` |
| Designer | `dev-pipeline`, `ui-design-brief`, `design-review` |
| Developer | `dev-pipeline`, `plan-approval`, `github-issue-implement`, `figma-to-code`, `github-pr-review`, `qa-failed-fix`, `hotfix` |
| Tech Lead | `dev-pipeline`, `sprint0-setup`, `feature-analysis`, `backlog-refinement`, `sprint-planning`, `plan-approval`, `github-pr-review`, `refutation-brief`, `merge-readiness`, `hotfix`, `release-plan`, `sprint-retro` |
| QA | `dev-pipeline`, `plan-approval`, `qa-manual-session` |
| AI Enablement | `dev-pipeline`, `sprint0-setup`, `sprint-retro` |
| Security | `dev-pipeline`, `sprint0-setup` |

## All skills

| Step | Skill | Purpose | Roles | Trigger |
|---|---|---|---|---|
| - | [`dev-pipeline`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/dev-pipeline/SKILL.md) | Routes by status label; per-role work queue | PO, BA, PM, Designer, Developer, Tech Lead, QA, AI Enablement, Security | on demand |
| sprint-0 | [`sprint0-setup`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/sprint0-setup/SKILL.md) | Checks the project's Sprint 0 checklist | Tech Lead, PM, AI Enablement, Security | on demand |
| 0 | [`feature-analysis`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/feature-analysis/SKILL.md) | Analyses an epic: challenge, two architectures, proposed child issues | BA, Tech Lead | label `type:epic` (automatic) or on demand |
| 1 | [`github-issue-create`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/github-issue-create/SKILL.md) | Drafts a well-formed issue from plain language | PO, BA | on demand |
| 2 | [`github-issue-triage`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/github-issue-triage/SKILL.md) | Checks Definition of Ready R1–R11 | AI (automatic) | label `status:backlog` (automatic) or on demand |
| refinement | [`backlog-refinement`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/backlog-refinement/SKILL.md) | Batch refinement: split stories, size S–XL, human-code flag | PO, BA, Tech Lead | on demand |
| design | [`ui-design-brief`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/ui-design-brief/SKILL.md) | UI brief from the design system, options, design approval before coding | Designer | on demand |
| planning | [`sprint-planning`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/sprint-planning/SKILL.md) | Proposes sprint scope from review/QA capacity | PM, PO, Tech Lead | on demand |
| 3 | [`qa-test-cases`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/qa-test-cases/SKILL.md) | Designs test cases and the plan before coding | AI (automatic) | label `status:test-design` (automatic) or on demand |
| 3 | [`plan-approval`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/plan-approval/SKILL.md) | Helps reviewers sign gate G2 | Tech Lead, Developer, QA | on demand |
| 4 | [`github-issue-implement`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/github-issue-implement/SKILL.md) | Implements the approved plan, opens the PR | Developer | label `status:ready-to-dev`, `status:in-progress` (automatic) or on demand |
| 4 | [`figma-to-code`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/figma-to-code/SKILL.md) | Turns a Figma frame into UI and compares | Developer | on demand |
| 5 | [`design-review`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/design-review/SKILL.md) | Designer compares built UI with Figma | Designer | on demand |
| 5 | [`github-pr-review`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/github-pr-review/SKILL.md) | Reviews the PR in a fresh session, two passes | Developer, Tech Lead | label `status:in-review` (automatic) or on demand |
| 6 | [`e2e-playwright`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/e2e-playwright/SKILL.md) | Writes and runs automation, concludes QA | AI (automatic) | label `status:qa` (automatic) or on demand |
| 6 | [`qa-manual-session`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/qa-manual-session/SKILL.md) | QA runs manual/mobile cases and records results | QA | on demand |
| 6b | [`qa-failed-fix`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/qa-failed-fix/SKILL.md) | Developer fixes what QA or UAT found | Developer | on demand |
| 7 | [`refutation-brief`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/refutation-brief/SKILL.md) | Prepares gate G3 | Tech Lead | label `status:qa-passed` (automatic) or on demand |
| 8 | [`merge-readiness`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/merge-readiness/SKILL.md) | Pre-merge checks for gate G4 | Tech Lead | on demand |
| 9 | [`uat-checklist`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/uat-checklist/SKILL.md) | Drafts the UAT checklist for the PO | AI (automatic) | label `status:uat` (automatic) or on demand |
| 9 | [`uat-run`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/uat-run/SKILL.md) | PO runs UAT, drafts the verdict | PO | on demand |
| hotfix | [`hotfix`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/hotfix/SKILL.md) | Emergency production fix | Tech Lead, Developer | on demand |
| - | [`status-report`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/status-report/SKILL.md) | Progress and metrics report for the PM | PM | on demand |
| - | [`release-plan`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/release-plan/SKILL.md) | Release plan for the PM | PM, Tech Lead | on demand |
| daily | [`daily-scrum`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/daily-scrum/SKILL.md) | Blocked work and queues for the Daily Scrum | PM | on demand |
| review | [`sprint-review`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/sprint-review/SKILL.md) | Sprint demo notes, feedback into new stories | PO, PM | on demand |
| retro | [`sprint-retro`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/sprint-retro/SKILL.md) | Sprint metrics; repeated AI errors into skill fixes | AI Enablement, PO, PM, Tech Lead | on demand |
