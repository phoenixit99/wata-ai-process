# Guide for QA

The AI designs test cases and runs automation. You make sure the test cases are right and complete,
test what the AI cannot (manual, mobile, UX), and have a say at gate G2.

## Your work in the process

| When | You do | Where |
|---|---|---|
| **G2** | Review the test-case table in `## Test design: PASS`: missing flows, correct P1–P3, which cases must be manual/mobile. Record your ruling with `plan-approval` | Claude Code / GitHub |
| Issue in `status:qa` | Run `/qa-manual-session <number>`: it walks you through each `manual` and `mobile` case and records the results | Staging / device + GitHub |
| `## QA report` | Check the AI's conclusion; comment with evidence on anything it missed | GitHub |
| `status:qa-failed` | Help the developer reproduce | — |
| Regularly | Propose additions to the e2e regression suite | Repo `e2e/` |

## Recording manual/mobile results

`qa-manual-session` writes this for you, but the format is:

```markdown
## QA manual results

Environment: <...> · Device/app version: <...> · Commit: <sha> · Tester: @<qa>

| Test case | Priority | Type | Result | Evidence / notes |
|---|---|---|---|---|
| TC-42-04 | P1 | mobile | pass | screenshot |
| TC-42-05 | P2 | manual | fail | Step 3 shows "..." instead of "..." |
```
The AI merges these into `## QA report`. An issue passes QA only when **every P1 case** has passed.

## Good test cases (when reviewing at G2)

- Every criterion at least: main flow, invalid data, boundary values, and **what must not happen**.
- Cases spanning several apps (created on web, shown on mobile) are the easiest to miss.
- P1 = a failure blocks the release.

<!-- role-skills:start -->
## Your skills

Generated from `skills/catalog.json`. In Claude Code use the command in column 3; on GitHub, comment the sentence in column 4 (works even if skills are not preloaded).

| Skill | Purpose | Claude Code | GitHub |
|---|---|---|---|
| `dev-pipeline` | Routes by status label; per-role work queue | `/dev-pipeline <#>` | `@claude read .claude/skills/dev-pipeline/SKILL.md and follow it for issue #<number>` |
| `plan-approval` | Helps reviewers sign gate G2 | `/plan-approval <#>` | `@claude read .claude/skills/plan-approval/SKILL.md and follow it for issue #<number>` |
| `qa-manual-session` | QA runs manual/mobile cases and records results | `/qa-manual-session <#>` | `@claude read .claude/skills/qa-manual-session/SKILL.md and follow it for issue #<number>` |
<!-- role-skills:end -->
