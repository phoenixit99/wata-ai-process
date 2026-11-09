# Guide for the PO (Product Owner)

You decide **what to build** and **when it is done**. The AI helps you write clear requirements and
run acceptance; you do not need the command line.

## Your work in the process

| When | You do | Where | Done when |
|---|---|---|---|
| A new need | Create an issue from a template, or write a short description and comment `@claude rewrite this issue using the template` | GitHub Issues | The issue has a description and acceptance criteria |
| **Gate G1** | Re-read the issue (especially `[Assumption]` lines), fix it if needed, apply `status:backlog` | GitHub | The issue has `status:backlog` |
| The issue is `status:fail-to-dev` | Read the `## Triage: FAIL` comment, paste/adapt the "Proposed wording", re-apply `status:backlog` | GitHub | Within SLA (proposed 24 hours) |
| The AI asks a product question in `## Needs human` | Answer in a comment, choosing one option | GitHub | The owner moves the status back |
| **Gate G5 (UAT)** | Run `uat-run` (or follow `## UAT checklist` on staging); post `## UAT: ACCEPTED` and apply `status:done`, or `## UAT: REJECTED` and apply `status:uat-failed` | Staging + GitHub | Within SLA (proposed 48 hours) |
| A large feature | Open an epic issue; read `## Feature analysis`; agree on the direction and child issues | GitHub | Direction agreed |

## Writing good acceptance criteria

Read [Writing acceptance criteria](/en/writing-acceptance-criteria). In short:

- Each criterion: **When** <action> **then** <visible result>.
- Include error cases and **what must not happen**.
- No "fast", "nice", "easy to use", "reasonable": use numbers or concrete behaviour instead.

## Ask the AI on GitHub

Comment on an issue or PR, starting with `@claude`:

- `@claude rewrite this issue using the template and ask me what is missing`
- `@claude explain this PR in business language`
- `@claude does this issue duplicate another one?`

## Notes

- You do **not** apply `status:ready-to-dev`; that belongs to the Tech Lead and QA (gate G2).
- Something found during UAT that the criteria never mentioned is a **new request**: open a new issue instead of rejecting UAT.
- If you are also the PM: never sign two consecutive gates for the same issue.

## In the sprint

Sprint cadence and events: [Scrum process](/en/scrum).

| Event | Your part |
|---|---|
| Refinement | Answer questions, agree AC and size; complete Fail-to-dev stories (`backlog-refinement`) |
| Planning | Bring priorities, agree the Sprint Goal with the team |
| Design approval | Choose the UI option with the Designer and customer in the first 1–2 sprint days |
| Sprint Review | Demo with the customer, turn feedback into stories (`sprint-review`) |
| Retro (as AI Enablement) | Repeated AI errors caused by requirements: fix the DoR, issue templates, AC guidance (`sprint-retro`); see [AI Enablement](/en/roles/ai-enablement) |

<!-- role-skills:start -->
## Your skills

Generated from `skills/catalog.json`. In Claude Code use the command in column 3; on GitHub, comment the sentence in column 4 (works even if skills are not preloaded).

| Skill | Purpose | Claude Code | GitHub |
|---|---|---|---|
| `dev-pipeline` | Routes by status label; per-role work queue | `/dev-pipeline <#>` | `@claude read .claude/skills/dev-pipeline/SKILL.md and follow it for issue #<number>` |
| `github-issue-create` | Drafts a well-formed issue from plain language | `/github-issue-create <#>` | `@claude read .claude/skills/github-issue-create/SKILL.md and follow it for issue #<number>` |
| `backlog-refinement` | Batch refinement: split stories, size S–XL, human-code flag | `/backlog-refinement <#>` | `@claude read .claude/skills/backlog-refinement/SKILL.md and follow it for issue #<number>` |
| `sprint-planning` | Proposes sprint scope from review/QA capacity | `/sprint-planning <#>` | `@claude read .claude/skills/sprint-planning/SKILL.md and follow it for issue #<number>` |
| `uat-run` | PO runs UAT, drafts the verdict | `/uat-run <#>` | `@claude read .claude/skills/uat-run/SKILL.md and follow it for issue #<number>` |
| `sprint-review` | Sprint demo notes, feedback into new stories | `/sprint-review <#>` | `@claude read .claude/skills/sprint-review/SKILL.md and follow it for issue #<number>` |
| `sprint-retro` | Sprint metrics; repeated AI errors into skill fixes | `/sprint-retro <#>` | `@claude read .claude/skills/sprint-retro/SKILL.md and follow it for issue #<number>` |
<!-- role-skills:end -->
