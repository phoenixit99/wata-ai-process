<p align="center"><img src="docs/public/wata-logo.png" alt="WATA Software" width="320"></p>

# WATA AI Process

Bộ **Quy trình phát triển dự án sử dụng AI Agent** (phiên bản 1.0, 16-10-2026) và **Quy trình Scrum ứng dụng
AI Agent** (phiên bản 1.0) của WATA Software, cùng bộ công cụ để cài quy trình vào một project.

**Nội dung quy trình giữ đúng theo hai tài liệu PDF gốc**: [`docs/process.md`](docs/process.md) và
[`docs/scrum.md`](docs/scrum.md) (bản tiếng Anh ở [`docs/en/`](docs/en/)). Tên skill, tên label trạng thái và
luồng trạng thái không được đổi; `scripts/check-consistency.py` kiểm tra điều này trong CI.

## Quy trình tóm tắt

- **Luồng trạng thái** (mỗi issue đúng một label): Backlog → Fail to dev / Ready to dev → In progress → In review
  → QA → QA passed / QA failed → merge (con người).
- **Definition of Ready**: 10 điều kiện R1–R10.
- **7 bước**: tạo issue → triage → code và mở PR → code review (8 tiêu chí, tối đa 3 vòng) → viết test case →
  automation Playwright (tối đa 3 vòng) → merge (con người).
- **Coding standard** đặt trong thư mục của mỗi app (`apps/<app>/CODING_STANDARD.md`).

## Skill

<!-- skills:start -->
| Bước | Skill | Dùng khi | Vai trò | Kích hoạt |
|---|---|---|---|---|
| 1 | [`github-issue-create`](skills/github-issue-create/SKILL.md) | Tạo issue đúng mẫu (Description, Acceptance Criteria, Design), vào Backlog | PO, BA | người gọi |
| 2 | [`github-issue-triage`](skills/github-issue-triage/SKILL.md) | Kiểm tra issue được giao theo Definition of Ready → Ready to dev hoặc Fail to dev | AI (tự động) | label `Backlog` (tự động) hoặc người gọi |
| 3 | [`github-issue-implement`](skills/github-issue-implement/SKILL.md) | Tạo branch, code theo coding standard, viết unit test, mở Pull Request | Developer | label `Ready to dev`, `In progress` (tự động) hoặc người gọi |
| 4 | [`github-pr-review`](skills/github-pr-review/SKILL.md) | Review PR theo Acceptance Criteria và coding standard, comment trên từng dòng | Developer, Tech Lead | label `In review` (tự động) hoặc người gọi |
| 5 | [`qa-test-cases`](skills/qa-test-cases/SKILL.md) | Sinh test case (positive, negative, biên, trạng thái) từ Acceptance Criteria | QA | label `QA` (tự động) hoặc người gọi |
| 6 | [`e2e-playwright`](skills/e2e-playwright/SKILL.md) | Viết và chạy automation test, phân loại lỗi, báo cáo kết quả lên PR | QA | label `QA` (tự động) hoặc người gọi |
| 3 | [`figma-to-code`](skills/figma-to-code/SKILL.md) | Lấy thiết kế từ Figma, chuyển thành code theo chuẩn từng app, đối chiếu UI | Designer, Developer | người gọi |
| - | [`dev-pipeline`](skills/dev-pipeline/SKILL.md) | Chạy toàn bộ luồng trên cho các issue được giao | Developer, Tech Lead | người gọi |
<!-- skills:end -->

Coding standard theo công nghệ: `nextjs-coding-standard` (web, admin), `nestjs-coding-standard` (api),
`flutter-coding-standard` (mobile); bản khởi đầu ở [`docs/coding-standards/`](docs/coding-standards/).

## Cấu trúc

```
wata-ai-process/
├── docs/                           Tài liệu + nguồn website (VitePress)
│   ├── process.md                  Quy trình phát triển dự án sử dụng AI Agent (theo PDF)
│   ├── scrum.md                    Quy trình Scrum ứng dụng AI Agent (theo PDF)
│   ├── contract.md                 Luật cho AI: tên label, heading comment, cách ghi lên GitHub
│   ├── skills.md                   Danh mục skill (sinh tự động)
│   ├── writing-acceptance-criteria.md, setup-guide.md
│   ├── coding-standards/           nextjs-, nestjs-, flutter-coding-standard
│   └── en/                         Bản tiếng Anh
├── skills/                         8 skill + catalog.json
├── template/                       File cài vào repo project
│   ├── CLAUDE.md, .mcp.json, .claude/project.yml, .claude/settings.json
│   └── .github/                    issue/PR template, labels.yml, CODEOWNERS, workflows (ci, wata-agent, wata-intake)
├── scripts/                        bootstrap.sh, install.sh, setup-labels.sh, sync-skills.py, check-consistency.py, gen-effort-chart.py
├── CHANGELOG.md
└── VERSION                         phiên bản bộ công cụ
```

## Cài vào một project

```bash
curl -fsSL https://raw.githubusercontent.com/phoenixit99/wata-ai-process/main/scripts/bootstrap.sh | bash
```

Nâng cấp: `-s -- --upgrade`; kiểm tra cấu hình: `-s -- --check`; ghim phiên bản: `WATA_REF=v1.0.0 bash`.
Tạo label: `scripts/setup-labels.sh <owner>/<repo> <repo>/.claude/project.yml`. Chi tiết:
[`docs/setup-guide.md`](docs/setup-guide.md).

## Website

```bash
npm install
npm run docs:dev        # http://localhost:5173
npm run docs:build
```

## Sửa skill hoặc tài liệu

1. Nội dung quy trình phải giữ đúng tài liệu PDF gốc. Thay đổi quy trình cần có phiên bản tài liệu mới.
2. Sửa skill trong `skills/<tên>/SKILL.md`; đổi trigger/heading thì sửa `skills/catalog.json` và `docs/contract.md`.
3. Sửa tài liệu ở cả hai ngôn ngữ: `docs/<trang>.md` và `docs/en/<trang>.md`.
4. Chạy `npm run sync` rồi `npm run check`.
