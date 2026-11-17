<!-- Sinh tự động bởi scripts/sync-skills.py. Không sửa tay. -->

# Skill catalog

Generated from `skills/catalog.json`, the single source for skills, roles and triggers. Each skill's instructions (written for the AI, in Vietnamese) live in the repo; click a name to read it.

## All skills

| Step | Skill | Purpose | Roles | Trigger |
|---|---|---|---|---|
| 1 | [`github-issue-create`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/github-issue-create/SKILL.md) | Creates a well-formed issue (Description, Acceptance Criteria, Design) in Backlog | PO, BA | on demand |
| 2 | [`github-issue-triage`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/github-issue-triage/SKILL.md) | Checks assigned issues against the Definition of Ready → Ready to dev or Fail to dev | AI (automatic) | label `Backlog` (automatic) or on demand |
| 3 | [`github-issue-implement`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/github-issue-implement/SKILL.md) | Creates a branch, codes to the coding standard, writes unit tests, opens a Pull Request | Developer | label `Ready to dev`, `In progress` (automatic) or on demand |
| 4 | [`github-pr-review`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/github-pr-review/SKILL.md) | Reviews the PR against the Acceptance Criteria and coding standard, with line comments | Developer, Tech Lead | label `In review` (automatic) or on demand |
| 5 | [`qa-test-cases`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/qa-test-cases/SKILL.md) | Generates test cases (positive, negative, boundary, state) from the Acceptance Criteria | QA | label `QA` (automatic) or on demand |
| 6 | [`e2e-playwright`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/e2e-playwright/SKILL.md) | Writes and runs automation tests, classifies failures, reports results on the PR | QA | label `QA` (automatic) or on demand |
| 3 | [`figma-to-code`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/figma-to-code/SKILL.md) | Reads the Figma design, turns it into code per app standard, compares the UI | Designer, Developer | on demand |
| - | [`dev-pipeline`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/dev-pipeline/SKILL.md) | Runs the whole flow above for the assigned issues | Developer, Tech Lead | on demand |

## Coding standards

One coding standard per technology, placed in each app's folder (`apps/<app>/CODING_STANDARD.md`). The AI must read it before coding and uses it when reviewing.

| Name | Apps | Starter |
|---|---|---|
| `nextjs-coding-standard` | web, admin | [`docs/coding-standards/nextjs-coding-standard.md`](https://github.com/phoenixit99/wata-ai-process/blob/main/docs/coding-standards/nextjs-coding-standard.md) |
| `nestjs-coding-standard` | api | [`docs/coding-standards/nestjs-coding-standard.md`](https://github.com/phoenixit99/wata-ai-process/blob/main/docs/coding-standards/nestjs-coding-standard.md) |
| `flutter-coding-standard` | mobile | [`docs/coding-standards/flutter-coding-standard.md`](https://github.com/phoenixit99/wata-ai-process/blob/main/docs/coding-standards/flutter-coding-standard.md) |

## By role

| Role | Skills |
|---|---|
| PO | `github-issue-create` |
| BA | `github-issue-create` |
| Designer | `figma-to-code` |
| Developer | `github-issue-implement`, `github-pr-review`, `figma-to-code`, `dev-pipeline` |
| Tech Lead | `github-pr-review`, `dev-pipeline` |
| QA | `qa-test-cases`, `e2e-playwright` |
