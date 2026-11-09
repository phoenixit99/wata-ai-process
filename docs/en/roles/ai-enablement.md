# Guide for AI Enablement

You keep the AI working well: skills, coding standards, MCP configuration, and analysis of repeated AI errors. At
project level you are the **process owner**; the Tech Lead may hold this role. At company level, AI Enablement owns
the central `wata-ai-process` repository.

## Your work in the process

| When | You do | Tool |
|---|---|---|
| Sprint 0 | Configure MCP (GitHub, Figma, Playwright); choose the AI Figma tool; check the setup; coach the team on skills | `/sprint0-setup` |
| Daily | Watch `status:needs-human` and agent workflow failures; fix broken configuration | GitHub Actions |
| Retrospective | Compile repeated AI errors; every error seen ≥ 2 times gets an action fixing a skill, coding standard or DoR | `/sprint-retro` |
| A skill needs fixing | Open an issue/PR on the central repo; skills are core, never edited directly in the project's `.claude/skills/` | Central repo |
| Upgrading the process | Read the CHANGELOG, run `install.sh --upgrade`, update `process_version` | `scripts/install.sh` |
| AI cost | Track token cost with the PM, adjust `max_turns_per_run` | `project.yml` |

## Principles

- Fix causes, not symptoms: an error that recurs across projects is fixed in the core.
- Skill changes go through a reviewed PR with a changelog, like code; run `npm run sync` and `npm run check` in the central repo.
- Never loosen guardrails to make the AI "work"; guardrails belong to the Tech Lead and Security.

## In the sprint

Sprint cadence and events: [Scrum process](/en/scrum).

| Event | Your part |
|---|---|
| Sprint 0 | MCP, Figma tool, skills, team coaching (`sprint0-setup`) |
| Retro | Turn repeated AI errors into skill/standard fixes (`sprint-retro`) |

<!-- role-skills:start -->
## Your skills

Generated from `skills/catalog.json`. In Claude Code use the command in column 3; on GitHub, comment the sentence in column 4 (works even if skills are not preloaded).

| Skill | Purpose | Claude Code | GitHub |
|---|---|---|---|
| `dev-pipeline` | Routes by status label; per-role work queue | `/dev-pipeline <#>` | `@claude read .claude/skills/dev-pipeline/SKILL.md and follow it for issue #<number>` |
| `sprint0-setup` | Checks the project's Sprint 0 checklist | `/sprint0-setup <#>` | `@claude read .claude/skills/sprint0-setup/SKILL.md and follow it for issue #<number>` |
| `sprint-retro` | Sprint metrics; repeated AI errors into skill fixes | `/sprint-retro <#>` | `@claude read .claude/skills/sprint-retro/SKILL.md and follow it for issue #<number>` |
<!-- role-skills:end -->
