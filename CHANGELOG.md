# Changelog

## 1.4.1 — 2026-11-09

- Vai trò AI Enablement ở mỗi project do **Tech Lead và PO cùng kiêm nhiệm**: Tech Lead phía kỹ thuật (skill,
  coding standard, MCP, workflow, chi phí AI; chịu trách nhiệm chính), PO phía yêu cầu (DoR, mẫu issue/AC,
  design system cùng Designer). Thêm bảng phân công và chỉ số đánh giá vào trang AI Enablement.
- `sprint-retro` thêm vai trò PO.
- **Sửa lỗi:** `description` trong frontmatter của 16/27 skill không đặt trong ngoặc kép và chứa ": ", làm YAML
  không hợp lệ (GitHub báo lỗi, Claude Code có thể không nạp skill). Mọi description giờ trong ngoặc kép;
  `check-consistency.py` bắt buộc định dạng này và CI đọc thử toàn bộ YAML bằng trình đọc thật.

## 1.4.0 — 2026-11-09

Gộp Quy trình Scrum ứng dụng AI Agent vào cùng repo và website.

- Trang mới (song ngữ): Quy trình Scrum v1.1 (từ PDF v1.0, đã thống nhất với quy trình dev), Definition of
  Done, Sprint 0, hướng dẫn vai trò AI Enablement và Security. Biểu đồ effort sinh bằng
  `scripts/gen-effort-chart.py`.
- Thống nhất 6 điểm: test case thiết kế trước khi code; AI review ở session riêng; DoR 11 tiêu chí; duyệt
  thiết kế UI là điều kiện của G2; giới hạn WIP cho review và QA; thêm DoD.
- 7 skill mới: `sprint0-setup`, `backlog-refinement`, `ui-design-brief`, `sprint-planning`, `daily-scrum`,
  `sprint-review`, `sprint-retro` (tổng 27). Vai trò mới trong catalog: `ai-enablement`, `security`.
- Label `size:s/m/l/xl`, `human-code`; heading `## Refinement notes`, `## UI brief`,
  `## Design approval: APPROVED/CHANGES`.
- `wata-agent` và `wata-sla-reminder`: không lấy việc mới khi hàng chờ review/QA đầy; bỏ qua story `human-code`.
- `project.yml`: `wip_in_review`, `wip_qa`, `people.ai_enablement`, `people.security`, `design_system`, `sprint`.
  Template thêm `docs/design-system.md`.
- Website: logo WATA chính thức ở header, trang chủ và favicon; mục Scrum trong menu.

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
