# Project setup guide

For the project's Tech Lead and PM. The setup implements the [process](process.md) (version 1.0): monorepo
structure, MCP, skills, status labels, coding standards in each app's folder, CI, merge by people only.

## 1. Install the process into the repo

Go to the project repo folder and paste **one command**:

```bash
cd <project-repo>
curl -fsSL https://raw.githubusercontent.com/phoenixit99/wata-ai-process/main/scripts/bootstrap.sh | bash
```

It downloads the process into a temp folder, copies the templates, skills and contract into the repo, fills
`repo:` in `.claude/project.yml` from `git remote origin`, then removes the temp folder. Needs `git`, `curl`,
`tar`, `python3`.

- Upgrade: `... | bash -s -- --upgrade`
- Check the configuration: `... | bash -s -- --check`
- Pin a version: `... | WATA_REF=v1.0.0 bash`
- Already cloned the process repo: `~/wata-ai-process/scripts/install.sh .`

After installing, **open Claude Code from the project folder** (`cd <project-repo> && claude`) so that
`/github-issue-create`, `/dev-pipeline`... are available.

Result in the project repo:

```
<project>/
├── apps/<app>/CODING_STANDARD.md   nextjs- / nestjs- / flutter-coding-standard, by the app's stack
├── .claude/skills/                 the 8 process skills
├── .claude/project.yml             project configuration
├── .mcp.json                       GitHub, Figma, Playwright
├── .github/                        issue/PR templates, labels.yml, CI workflow, wata-agent, wata-intake
├── docs/agents/                    process, contract (pinned copies)
└── CLAUDE.md                       general instructions for the AI Agent
```

The script **never overwrites** existing configuration files (it lists what it skipped). `--upgrade` only
overwrites the core layer (skills, `docs/agents/*`, `wata-*.yml` workflows, `labels.yml`) and removes skill folders
that are no longer part of the process.

## 2. Fill in the configuration

- [ ] `.claude/project.yml`: `repo`, `apps` (paths, stack, lint/typecheck/test/build commands that really run), `e2e`, `people`
- [ ] Coding standards: each app has `apps/<app>/CODING_STANDARD.md` (starter copied by stack); the Tech Lead adapts it
- [ ] `CLAUDE.md`: project description, how to run locally
- [ ] `.github/CODEOWNERS`: replace `@<org>/...` with real teams
- [ ] `.github/ISSUE_TEMPLATE/*.yml`: the app list under Affected apps matches `project.yml`

## 3. GitHub App for the agent

Events created with `GITHUB_TOKEN` **do not trigger new workflows**. If the agent changed labels with
`GITHUB_TOKEN`, the next step would never run. So the agent uses a GitHub App token.

- [ ] Create a GitHub App (minimum permissions: Contents, Issues, Pull requests: read & write; Metadata, Actions:
      read). Do not let the app bypass branch protection.
- [ ] Install the app on the project repo
- [ ] Repo variable `WATA_APP_ID`; repo secrets `WATA_APP_PRIVATE_KEY`, `ANTHROPIC_API_KEY`
- [ ] Add toolchain setup (Node/pnpm, Flutter, Playwright) to `wata-agent.yml` at `TODO(project)`

Check: create a test issue from a template; it gets the `Backlog` label, `wata-agent` runs `github-issue-triage`
and moves the issue to `Ready to dev` or `Fail to dev`.

## 4. Labels

```bash
~/wata-ai-process/scripts/setup-labels.sh <owner>/<repo> .claude/project.yml
```

- [ ] 8 status labels: `Backlog`, `Fail to dev`, `Ready to dev`, `In progress`, `In review`, `QA`, `QA passed`, `QA failed`
- [ ] Work type labels: `feature`, `bug`, `chore`; app labels from `apps[].name`
- [ ] (Optional) a board for the Manager to track progress; labels are the source of truth

## 5. GitHub-side controls

Per process section 9: no push to main, no force-push; only people merge; CI blocks failing PRs.

- [ ] Branch protection on `main`: pull request required, CODEOWNERS approval
- [ ] Required status checks: the jobs in `ci.yml` (lint, test, build, automation)
- [ ] No force-push, no branch deletion; the agent's GitHub App cannot bypass

## 6. Each person's machine

- [ ] Install Claude Code; open the repo; run `/dev-pipeline`
- [ ] `GITHUB_MCP_TOKEN`: fine-grained Personal Access Token limited to the project repo
- [ ] Figma MCP: Figma OAuth login, or Figma Desktop (Dev Mode). Check the address in `.mcp.json`
- [ ] `gh auth login` (skills use the `gh` CLI)

Full check: `curl -fsSL .../bootstrap.sh | bash -s -- --check`.
