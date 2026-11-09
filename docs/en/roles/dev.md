# Guide for Developers

The AI writes most of the code. You approve plans, handle hard cases, unblock the AI, and can always
code by hand.

## Your work in the process

| When | You do | Command |
|---|---|---|
| Start of the day | See what to work on | `/dev-pipeline` |
| **Gate G2** (when assigned) | Read `## Test design: PASS`: the plan, blast radius, what is out of scope. Use `plan-approval` to record your ruling; when QA also agrees, one person applies `status:ready-to-dev` | `/plan-approval <number>` |
| `status:needs-human` | Read `## Needs human`, decide, record the ruling, move the issue to the right status | GitHub / Claude Code |
| `status:qa-failed`, `status:uat-failed` | Fix exactly what was reported | `/qa-failed-fix <number>` |
| A complex case | Run interactively instead of automatically | `/github-issue-implement <number>` |
| Coding by hand | Take the issue and code as usual; it still goes through `in-review` → `qa` → G3/G4 → UAT | — |
| AI review of your own PR | Run it in a **fresh session** | `/github-pr-review <number>` |

## Interactive runs

In interactive mode the AI works **with you**: it reports findings as it goes, asks when something can
be read two ways, and **asks before every write** (comment, label, commit, push, PR). You read, push
back, and decide.

## Things to remember

- One step, one session. Never let the session that wrote the code review it.
- Tests first; a bug needs a test that is red before the fix.
- API changes stay compatible with `mobile.supported_app_versions` older app versions.
- PRs use `Refs #<number>`, not `Closes`: the issue closes only after UAT.
- Do not merge your own PR on a `risk:high` issue without someone else's G3.

<!-- role-skills:start -->
## Your skills

Generated from `skills/catalog.json`. In Claude Code use the command in column 3; on GitHub, comment the sentence in column 4 (works even if skills are not preloaded).

| Skill | Purpose | Claude Code | GitHub |
|---|---|---|---|
| `dev-pipeline` | Routes by status label; per-role work queue | `/dev-pipeline <#>` | `@claude read .claude/skills/dev-pipeline/SKILL.md and follow it for issue #<number>` |
| `plan-approval` | Helps reviewers sign gate G2 | `/plan-approval <#>` | `@claude read .claude/skills/plan-approval/SKILL.md and follow it for issue #<number>` |
| `github-issue-implement` | Implements the approved plan, opens the PR | `/github-issue-implement <#>` | `@claude read .claude/skills/github-issue-implement/SKILL.md and follow it for issue #<number>` |
| `figma-to-code` | Turns a Figma frame into UI and compares | `/figma-to-code <#>` | `@claude read .claude/skills/figma-to-code/SKILL.md and follow it for issue #<number>` |
| `github-pr-review` | Reviews the PR in a fresh session, two passes | `/github-pr-review <#>` | `@claude read .claude/skills/github-pr-review/SKILL.md and follow it for issue #<number>` |
| `qa-failed-fix` | Developer fixes what QA or UAT found | `/qa-failed-fix <#>` | `@claude read .claude/skills/qa-failed-fix/SKILL.md and follow it for issue #<number>` |
| `hotfix` | Emergency production fix | `/hotfix <#>` | `@claude read .claude/skills/hotfix/SKILL.md and follow it for issue #<number>` |
<!-- role-skills:end -->
