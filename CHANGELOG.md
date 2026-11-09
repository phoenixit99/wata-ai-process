# Changelog

## 1.3.0 — 2026-11-09

Đồng bộ skill cho mọi vai trò.

- Thêm 5 skill để vai trò nào cũng có skill tự gọi: `qa-manual-session` (QA), `design-review`
  (Designer), `uat-run` (PO), `release-plan` (PM), `plan-approval` (Tech Lead/Dev/QA ở cổng G2).
- `skills/catalog.json`: nguồn duy nhất cho skill, vai trò, bước, chế độ, label kích hoạt, heading đọc/ghi,
  mô tả song ngữ.
- `scripts/sync-skills.py`: sinh header của từng skill, bảng skill trong README, mục "Skill của bạn" ở
  trang vai trò, trang danh mục skill.
- `scripts/check-consistency.py`: kiểm tra skill/catalog/contract/wata-agent/label/phiên bản đồng bộ.
- `dev-pipeline`: bảng việc và định tuyến theo vai trò.
- Contract: thêm `## QA report: PENDING`, `## QA manual results`, `## Design review: OK/CHANGES`;
  `## Plan approval` và `## UAT: ...` do skill soạn, người đăng.
- `e2e-playwright` đọc kết quả manual; `github-pr-review` tính design review "phải sửa" là Major.
- Đã xác nhận tên input của `anthropics/claude-code-action@v1`.

## 1.2.0 — 2026-11-09

Bản đầu tiên của repo trung tâm.

- Quy trình v1.2 (`docs/process.md`): thêm vai trò PM, Bước 0 phân tích feature, UAT (cổng G5),
  luồng hotfix, phân loại theo rủi ro, RACI và SLA cho hàng chờ của con người, hướng dẫn theo vai trò.
- Contract chung cho agent (`docs/contract.md`): 14 label trạng thái, heading cố định, hai chế độ
  chạy, cách đọc issue, cách ghi lên GitHub, việc cấm, schema `.claude/project.yml`.
- 15 skill: `dev-pipeline`, `feature-analysis`, `github-issue-create`, `github-issue-triage`,
  `qa-test-cases`, `github-issue-implement`, `figma-to-code`, `github-pr-review`, `e2e-playwright`,
  `qa-failed-fix`, `refutation-brief`, `merge-readiness`, `uat-checklist`, `hotfix`, `status-report`.
- Template project: `CLAUDE.md`, `.claude/settings.json` (deny), `.claude/project.yml`, `.mcp.json`,
  issue form (feature, bug, chore, epic, hotfix), PR template, CODEOWNERS, bộ label.
- Workflow: `wata-status-guard`, `wata-agent`, `wata-mention`, `wata-pr-merged`, `wata-sla-reminder`, `ci` mẫu.
- Script: `install.sh`, `setup-labels.sh`.

## 1.1 — 2026-11-09 (tài liệu)

11 cải tiến so với v1.0: review ở session riêng, test design trước code, cổng G2/G3, Needs human và
Blocked, label là nguồn sự thật, chống prompt injection, tương thích ngược API, báo cáo QA trung thực,
R11, guardrail phía server, contract chung, áp dụng toàn công ty.

## 1.0 — 2026-10-16 (tài liệu)

Bản đầu của quy trình (PDF).
