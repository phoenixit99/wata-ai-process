# Hướng dẫn cài đặt cho một project

Dành cho Tech Lead và PM của project. Cài đặt hiện thực [quy trình](process.md) (phiên bản 1.0): cấu trúc
monorepo, MCP, skill, label trạng thái, coding standard trong thư mục từng app, CI, merge chỉ do con người.

## 1. Cài bộ quy trình vào repo

Vào thư mục repo project và dán **một lệnh**:

```bash
cd <project-repo>
curl -fsSL https://raw.githubusercontent.com/phoenixit99/wata-ai-process/main/scripts/bootstrap.sh | bash
```

Lệnh tải bộ quy trình vào thư mục tạm, copy template, skill, contract vào repo, tự điền `repo:` trong
`.claude/project.yml` từ `git remote origin`, rồi xoá thư mục tạm. Cần `git`, `curl`, `tar`, `python3`.

- Nâng cấp: `... | bash -s -- --upgrade`
- Kiểm tra cấu hình: `... | bash -s -- --check`
- Ghim phiên bản: `... | WATA_REF=v1.0.0 bash`
- Đã clone repo quy trình: `~/wata-ai-process/scripts/install.sh .`

Sau khi cài, **mở Claude Code từ chính thư mục project** (`cd <project-repo> && claude`) để gọi được
`/github-issue-create`, `/dev-pipeline`...

Kết quả trong repo project:

```
<project>/
├── apps/<app>/CODING_STANDARD.md   nextjs- / nestjs- / flutter-coding-standard, theo stack của app
├── .claude/skills/                 8 skill của quy trình
├── .claude/project.yml             cấu hình project
├── .mcp.json                       GitHub, Figma, Playwright
├── .github/                        issue/PR template, labels.yml, CI workflow, wata-agent, wata-intake
├── docs/agents/                    quy trình, contract (bản sao, ghim phiên bản)
└── CLAUDE.md                       hướng dẫn chung cho AI Agent
```

Script **không ghi đè** file cấu hình đã có (in ra danh sách bỏ qua). `--upgrade` chỉ ghi đè lớp lõi (skill,
`docs/agents/*`, workflow `wata-*.yml`, `labels.yml`) và xoá thư mục skill không còn trong quy trình.

## 2. Điền cấu hình

- [ ] `.claude/project.yml`: `repo`, `apps` (đường dẫn, stack, lệnh lint/typecheck/test/build chạy được thật), `e2e`, `people`
- [ ] Coding standard: mỗi app có `apps/<app>/CODING_STANDARD.md` (đã copy bản khởi đầu theo stack); Tech Lead chỉnh
- [ ] `CLAUDE.md`: mô tả project, cách chạy local
- [ ] `.github/CODEOWNERS`: thay `@<org>/...` bằng team thật
- [ ] `.github/ISSUE_TEMPLATE/*.yml`: danh sách app trong mục Affected apps khớp `project.yml`

## 3. GitHub App cho agent

Sự kiện do `GITHUB_TOKEN` tạo ra **không kích hoạt workflow mới**. Nếu agent đổi label bằng `GITHUB_TOKEN`,
bước sau sẽ không chạy. Vì vậy agent dùng token của một GitHub App.

- [ ] Tạo GitHub App (quyền tối thiểu: Contents, Issues, Pull requests: read & write; Metadata, Actions: read).
      Không cho app bypass branch protection.
- [ ] Cài app vào repo của project
- [ ] Repo variable `WATA_APP_ID`; repo secrets `WATA_APP_PRIVATE_KEY`, `ANTHROPIC_API_KEY`
- [ ] Thêm bước cài toolchain (Node/pnpm, Flutter, Playwright) vào `wata-agent.yml` ở chỗ `TODO(project)`

Kiểm tra: tạo issue thử bằng template; issue nhận label `Backlog`, `wata-agent` chạy `github-issue-triage`
và chuyển issue sang `Ready to dev` hoặc `Fail to dev`.

## 4. Label

```bash
~/wata-ai-process/scripts/setup-labels.sh <owner>/<repo> .claude/project.yml
```

- [ ] 8 label trạng thái: `Backlog`, `Fail to dev`, `Ready to dev`, `In progress`, `In review`, `QA`, `QA passed`, `QA failed`
- [ ] Label loại công việc: `feature`, `bug`, `chore`; label app theo `apps[].name`
- [ ] (Tuỳ chọn) board để Quản lý theo dõi tiến độ; label là nguồn sự thật

## 5. Kiểm soát phía GitHub

Theo quy trình mục 9: cấm push vào main, cấm force-push; chỉ con người được merge; CI chặn PR không đạt.

- [ ] Branch protection trên `main`: bắt buộc pull request, approval của CODEOWNERS
- [ ] Required status checks: các job trong `ci.yml` (lint, test, build, automation)
- [ ] Cấm force-push, cấm xoá nhánh; GitHub App của agent không được bypass

## 6. Máy của từng người

- [ ] Cài Claude Code; mở repo; chạy `/dev-pipeline`
- [ ] `GITHUB_MCP_TOKEN`: Personal Access Token fine-grained, giới hạn trong repo của project
- [ ] Figma MCP: đăng nhập OAuth Figma, hoặc Figma Desktop (Dev Mode). Đối chiếu địa chỉ trong `.mcp.json`
- [ ] `gh auth login` (skill dùng `gh` CLI)

Kiểm tra toàn bộ: `curl -fsSL .../bootstrap.sh | bash -s -- --check`.
