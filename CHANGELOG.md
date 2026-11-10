# Changelog

## Chưa phát hành

- **Cài bằng một lệnh:** vào thư mục project, chạy `curl -fsSL https://raw.githubusercontent.com/phoenixit99/wata-ai-process/main/scripts/bootstrap.sh | bash`
  (`-s -- --upgrade`, `-s -- --check`; ghim phiên bản bằng `WATA_REF=<tag>`). Không cần clone repo quy trình.
- `install.sh` tự điền `repo:` trong `.claude/project.yml` từ `git remote origin` khi còn placeholder `<owner>/<repo>`.
- Sửa `install.sh --check`: khi `gh` đã đăng nhập nhưng không đọc được label/secret của repo, script dừng ở S6
  thay vì chạy hết S7–S15.

## 1.5.0 — 2026-11-09

**Gộp 27 skill thành 13.** Mỗi skill ứng với một bước hoặc một cổng; việc phụ của bước là một chế độ. Heading,
label và luồng trạng thái **không đổi**, nên contract, guard và chỉ số giữ nguyên.

- Lệnh cần nhớ: `/dev-pipeline <issue>` (Dev, Tech Lead), `/sprint <sự kiện>` (PM), `@claude` trên GitHub (PO, BA,
  QA, Designer; `wata-mention` giờ có chỉ dẫn chọn skill theo trạng thái issue).
- `--auto` (do `wata-agent` gọi) chỉ chạy chế độ mặc định; chế độ của con người (`--approve`, `--merge`, `--run`,
  `--manual`, `--design`, `--fix`, `--figma`, `--batch`) từ chối khi có `--auto`.
- Kiểm tra Sprint 0 chuyển thành `scripts/install.sh <repo> --check` (S1–S15, chỉ đọc, không in secret).
- `install.sh --upgrade` xoá thư mục skill đã bỏ trong `.claude/skills/` của project.
- `check-consistency.py` báo lỗi nếu tên skill cũ còn xuất hiện; catalog có trường `retired` và `usage`.
- Security có skill riêng là `merge-gate` (được hỏi ở G3 cho `risk:high`).

**Cần làm khi nâng cấp:** tên skill trong `workflow_dispatch` của `wata-agent` đã đổi (ví dụ
`github-issue-implement` → `implement`); script hoặc thói quen gọi tay theo tên cũ phải đổi.

| Tên cũ | Lời gọi mới |
|---|---|
| `github-issue-create` | `issue-create` |
| `github-issue-triage` | `triage` |
| `feature-analysis` | `refine` |
| `backlog-refinement` | `refine --batch` |
| `qa-test-cases` | `test-design` |
| `plan-approval` | `test-design --approve` |
| `github-issue-implement` | `implement` |
| `qa-failed-fix` | `implement --fix` |
| `figma-to-code` | `implement --figma` |
| `github-pr-review` | `pr-review` |
| `design-review` | `pr-review --design` |
| `e2e-playwright` | `qa` |
| `qa-manual-session` | `qa --manual` |
| `refutation-brief` | `merge-gate` |
| `merge-readiness` | `merge-gate --merge` |
| `uat-checklist` | `uat` |
| `uat-run` | `uat --run` |
| `ui-design-brief` | `design-brief` |
| `sprint-planning` | `sprint plan` |
| `daily-scrum` | `sprint daily` |
| `sprint-review` | `sprint review` |
| `sprint-retro` | `sprint retro` |
| `status-report` | `sprint report` |
| `release-plan` | `sprint release` |
| `sprint0-setup` | `install.sh --check` |

## 1.4.2 — 2026-11-09

- **Không còn issue nằm im ở trạng thái của AI.** `wata-agent` thêm bước chạy sau mọi lần chạy skill: nếu skill
  thất bại (lỗi API, hết `--max-turns`, quá thời gian, token App lỗi) hoặc chạy xong mà không đăng kết quả nào
  lên issue, workflow đăng `## Needs human` kèm link log và chuyển issue sang `status:needs-human`. Step skill có
  timeout riêng 80 phút (job 90 phút) để treo cũng được báo.
- **Sửa lỗi:** gắn lại `status:in-progress` sau `## Needs human` không chạy lại được chế độ sửa (router đọc
  `## Needs human` là heading cuối). Router giờ bỏ qua `## Needs human` khi quyết định chế độ sửa.
- **SLA cho review của người.** Thêm `sla_hours.review` (đề xuất 8 giờ); `wata-sla-reminder` nhắc trên PR mở
  chưa có approve quá SLA (người được yêu cầu review, không có thì Tech Lead; báo PM). Đo trên PR vì review
  của người không phải một `status:*`. Project đang chạy: thêm khoá `review` vào `project.yml` để bật (không có
  khoá thì không nhắc).

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
