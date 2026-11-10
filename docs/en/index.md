---
layout: home

hero:
  name: AI Agent Software Development Process
  text: From issue to UAT, the AI does the repetitive work and people make the decisions
  tagline: WATA Software · For every project · Version 1.5
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
    - theme: alt
      text: Scrum process
      link: /en/scrum

  image:
    src: /wata-logo.png
    alt: WATA Software

features:
  - title: Scrum with AI
    details: A 10-step sprint, new events and timeboxes, planning by review/QA capacity, effort shifting from execution to requirements, decisions and acceptance.
  - title: Five human gates
    details: The PO confirms the request (G1), Tech Lead and QA approve the plan (G2), a reviewer tries to refute the work (G3), the Tech Lead merges (G4), the PO accepts in UAT (G5). The AI never passes a gate on its own.
  - title: 13 skills, three commands to remember
    details: Developers use /dev-pipeline, the PM uses /sprint, other roles comment @claude on GitHub; the AI picks the right skill from the issue status. A single catalog keeps everything in sync.
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
| PO | [PO guide](/en/roles/po), [Writing AC](/en/writing-acceptance-criteria) | `issue-create`, `uat --run` |
| BA | [BA guide](/en/roles/ba) | `refine`, `issue-create` |
| PM | [PM guide](/en/roles/pm), [RACI](/en/raci) | `sprint report`, `sprint release` |
| Designer | [Designer guide](/en/roles/designer) | `design-brief`, `pr-review --design` |
| Developer | [Developer guide](/en/roles/dev) | `implement`, `implement --fix` |
| Tech Lead | [Tech Lead guide](/en/roles/tech-lead), [Setup](/en/setup-guide) | `test-design --approve`, `merge-gate --merge`, `hotfix` |
| QA | [QA guide](/en/roles/qa) | `test-design --approve`, `qa --manual` |
| AI Enablement | [AI Enablement guide](/en/roles/ai-enablement) | `sprint retro`, [`--check`](/en/setup-guide) |
| Security | [Security guide](/en/roles/security) | `merge-gate`, [`--check`](/en/setup-guide) |

Every role can use `dev-pipeline` to see today's work.
