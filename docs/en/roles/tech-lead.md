# Guide for the Tech Lead

You own the final technical call: you sign G2 (plan), G3 (refutation) and G4 (merge), decide risk
tiers, and keep the guardrails in place.

## Your work in the process

| When | You do | Tool |
|---|---|---|
| After triage | Review the proposed `risk:*`; change it if you disagree | GitHub |
| **G2** | Approve the plan in `## Test design: PASS` (QA approves the test cases) with `plan-approval`. Apply `status:ready-to-dev` | Claude Code / GitHub |
| **G3** | Read `## Refutation brief`, read the risky diff hunks closely, try to find what is wrong. Agree: comment `## G3: OK` with what you checked. Problem: comment `## Code review: FAIL` and apply `status:in-progress` | GitHub |
| **G4** | Run `/merge-readiness <number>`; merge when READY | Claude Code + GitHub |
| `status:needs-human`, `status:qa-failed` | Assign or handle it | — |
| Hotfix | Triage directly, run `/hotfix <number>` | Claude Code |
| Release | Prepare it with the PM using `/release-plan` | Claude Code |
| Large feature | Agree `## Feature analysis` with the BA/PO | GitHub |

## Guardrails (required before enabling the agent)

- Branch protection on `main`: no direct pushes, no force-push, PRs required, CODEOWNERS approval
  required, required checks from `ci.yml`.
- The agent's GitHub App has **no** permission to bypass branch protection and no admin rights.
- `.claude/settings.json` from the template (the backstop).
- CODEOWNERS protects `.github/`, `.claude/`, `docs/agents/`, `CLAUDE.md`.

## Keeping the AI's quality up

- Fill in `CLAUDE.md` and each app's coding standard; add a line to "Known pitfalls" whenever the AI or a
  person makes a memorable mistake.
- Review the reasons behind `## Needs human` and the defects found at G3 every month; propose skill fixes
  to the central repo.

## High risk

`risk:high` issues: the person doing G3 is not the person who merges; add a security and migration review.

## In the sprint

Sprint cadence and events: [Scrum process](/en/scrum).

| Event | Your part |
|---|---|
| Sprint 0 | Architecture, coding standards, branch protection, CODEOWNERS (`sprint0-setup`) |
| Refinement | Assess technical risk, decide size and the `human-code` flag (`backlog-refinement`) |
| Planning | Identify stories a person must code; check review capacity |
| During the sprint | Architecture, G2, G3, G4; keep the fixed review slots |

<!-- role-skills:start -->
## Your skills

Generated from `skills/catalog.json`. In Claude Code use the command in column 3; on GitHub, comment the sentence in column 4 (works even if skills are not preloaded).

| Skill | Purpose | Claude Code | GitHub |
|---|---|---|---|
| `dev-pipeline` | Routes by status label; per-role work queue | `/dev-pipeline <#>` | `@claude read .claude/skills/dev-pipeline/SKILL.md and follow it for issue #<number>` |
| `sprint0-setup` | Checks the project's Sprint 0 checklist | `/sprint0-setup <#>` | `@claude read .claude/skills/sprint0-setup/SKILL.md and follow it for issue #<number>` |
| `feature-analysis` | Analyses an epic: challenge, two architectures, proposed child issues | `/feature-analysis <#>` | `@claude read .claude/skills/feature-analysis/SKILL.md and follow it for issue #<number>` |
| `backlog-refinement` | Batch refinement: split stories, size S–XL, human-code flag | `/backlog-refinement <#>` | `@claude read .claude/skills/backlog-refinement/SKILL.md and follow it for issue #<number>` |
| `sprint-planning` | Proposes sprint scope from review/QA capacity | `/sprint-planning <#>` | `@claude read .claude/skills/sprint-planning/SKILL.md and follow it for issue #<number>` |
| `plan-approval` | Helps reviewers sign gate G2 | `/plan-approval <#>` | `@claude read .claude/skills/plan-approval/SKILL.md and follow it for issue #<number>` |
| `github-pr-review` | Reviews the PR in a fresh session, two passes | `/github-pr-review <#>` | `@claude read .claude/skills/github-pr-review/SKILL.md and follow it for issue #<number>` |
| `refutation-brief` | Prepares gate G3 | `/refutation-brief <#>` | `@claude read .claude/skills/refutation-brief/SKILL.md and follow it for issue #<number>` |
| `merge-readiness` | Pre-merge checks for gate G4 | `/merge-readiness <#>` | `@claude read .claude/skills/merge-readiness/SKILL.md and follow it for issue #<number>` |
| `hotfix` | Emergency production fix | `/hotfix <#>` | `@claude read .claude/skills/hotfix/SKILL.md and follow it for issue #<number>` |
| `release-plan` | Release plan for the PM | `/release-plan <#>` | `@claude read .claude/skills/release-plan/SKILL.md and follow it for issue #<number>` |
| `sprint-retro` | Sprint metrics; repeated AI errors into skill fixes | `/sprint-retro <#>` | `@claude read .claude/skills/sprint-retro/SKILL.md and follow it for issue #<number>` |
<!-- role-skills:end -->
