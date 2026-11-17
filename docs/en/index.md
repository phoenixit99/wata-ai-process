---
layout: home

hero:
  name: AI Agent software development process
  text: From GitHub Issue to Pull Request, Code Review, QA and Automation Test
  tagline: WATA Software · Internal document · Version 1.0
  actions:
    - theme: brand
      text: Read the process
      link: /en/process
    - theme: alt
      text: Scrum process
      link: /en/scrum
    - theme: alt
      text: Skill catalog
      link: /en/skills

  image:
    src: /wata-logo.png
    alt: WATA Software

features:
  - title: Monorepo
    details: All source code of a project (web, admin, API, mobile) lives in one repository; the AI Agent sees the whole system at once.
  - title: Labels are the source of truth
    details: Every issue always has exactly one status label, from Backlog to QA passed. The label tells where the work is and who is handling it.
  - title: Definition of Ready
    details: The AI only codes when an issue meets all 10 conditions; otherwise it moves to Fail to dev with what is missing and suggested rewording.
  - title: 8 skills
    details: github-issue-create, github-issue-triage, github-issue-implement, github-pr-review, qa-test-cases, e2e-playwright, figma-to-code, dev-pipeline; plus per-technology coding standards for Next.js, NestJS, Flutter.
  - title: Only people merge
    details: People write requirements, confirm scope and merge code. Review and automation are limited to 3 rounds, then the AI stops and notifies a person.
---

## Getting started

| You want to | Read |
|---|---|
| Understand the process | [Development process](/en/process), [Scrum process](/en/scrum) |
| Write good issues | [Writing acceptance criteria](/en/writing-acceptance-criteria) |
| Set up a project | [Setup](/en/setup-guide) |
| Write or change a skill | [Agent contract](/en/contract), [Skill catalog](/en/skills) |
