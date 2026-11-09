---
layout: home

hero:
  name: AI Agent Software Development Process
  text: From issue to UAT, the AI does the repetitive work and people make the decisions
  tagline: WATA Software · For every project · Version 1.3
  actions:
    - theme: brand
      text: Read the process
      link: /en/process
    - theme: alt
      text: I am a... (role guides)
      link: /en/roles/po
    - theme: alt
      text: Skill catalog
      link: /en/skills

features:
  - title: Five human gates
    details: The PO confirms the request (G1), Tech Lead and QA approve the plan (G2), a reviewer tries to refute the work (G3), the Tech Lead merges (G4), the PO accepts in UAT (G5). The AI never passes a gate on its own.
  - title: 20 skills, every role
    details: Every step and every role has its own skill, run in Claude Code or with @claude on GitHub. One catalog keeps everything in sync.
  - title: Labels are the source of truth
    details: Every issue carries exactly one status:* label. The label tells you where the work is, who has it, and which automated step runs next.
  - title: Tests before code
    details: Test cases are designed from the acceptance criteria before any code exists. Review runs in a fresh session so the AI never approves its own work.
  - title: Server-side guardrails
    details: Branch protection, CODEOWNERS, required checks and a guard workflow. Instructions in the prompt are only a backstop.
  - title: Honest reporting
    details: Every AI report separates what was run, what was only read, and what is still a claim. Nothing is reported that was not observed.
---

## Start with your role

| You are | Read first | Main skills |
|---|---|---|
| PO | [PO guide](/en/roles/po), [Writing AC](/en/writing-acceptance-criteria) | `github-issue-create`, `uat-run` |
| BA | [BA guide](/en/roles/ba) | `feature-analysis`, `github-issue-create` |
| PM | [PM guide](/en/roles/pm), [RACI](/en/raci) | `status-report`, `release-plan` |
| Designer | [Designer guide](/en/roles/designer) | `design-review` |
| Developer | [Developer guide](/en/roles/dev) | `github-issue-implement`, `qa-failed-fix` |
| Tech Lead | [Tech Lead guide](/en/roles/tech-lead), [Setup](/en/setup-guide) | `plan-approval`, `merge-readiness`, `hotfix` |
| QA | [QA guide](/en/roles/qa) | `plan-approval`, `qa-manual-session` |

Every role can use `dev-pipeline` to see today's work.
