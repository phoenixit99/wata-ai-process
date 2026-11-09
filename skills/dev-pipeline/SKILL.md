---
name: dev-pipeline
description: Điểm vào chung của quy trình WATA cho mọi vai trò (PO, BA, PM, Designer, Dev, Tech Lead, QA). Không tham số: bảng việc hôm nay theo vai trò của người chạy. Có số issue: đọc label status:* và chạy đúng skill của bước đó cho vai trò đó. Dùng khi "/dev-pipeline", "hôm nay tôi làm gì", "issue này đang ở đâu", "walk the board".
---

# dev-pipeline — điểm vào chung, định tuyến theo trạng thái và vai trò

> **Vai trò:** PO, BA, PM, Designer, Dev, Tech Lead, QA, AI Enablement, Security · **Bước:** - · **Chế độ:** tương tác · **Kích hoạt:** người gọi · **Đọc:** — · **Ghi:** không ghi lên issue

`$ARGUMENTS`: trống · `--role <po|ba|pm|designer|dev|tech-lead|qa|ai-enablement|security>` · `<số issue> [--role <vai trò>]`.

**Đọc `docs/agents/contract.md` trước.** Skill này không ghi gì; nó chọn việc và chuyển sang skill
đúng. Danh sách đầy đủ skill theo vai trò ở `docs/agents/skill-catalog.json`.

## Xác định vai trò

1. Người chạy: `gh api user --jq .login`.
2. Vai trò: `--role` nếu có; nếu không, tra login trong `people` của `.claude/project.yml` (một người
   có thể có nhiều vai trò). Không tìm thấy: hỏi người chạy.

## Không có số issue: hôm nay làm gì?

Lấy issue đang mở theo label (`gh issue list --state open --label "<label>" --json number,title,assignees,labels,updatedAt`),
rồi hiển thị **hàng chờ của vai trò**, việc sắp xong trước:

| Vai trò | Hàng chờ (label → điều kiện) | Skill dùng |
|---|---|---|
| PO | `status:uat` → chờ nghiệm thu · `status:fail-to-dev` → cần bổ sung · `## Needs human` về sản phẩm · story chưa có `size:*` | `uat-run`, `github-issue-create`, `backlog-refinement`, `sprint-review` |
| BA | `type:epic` chưa có `## Feature analysis` hoặc chưa chốt · `status:fail-to-dev` về nghiệp vụ | `feature-analysis`, `github-issue-create` |
| PM | `status:needs-human`, `status:blocked`, issue quá `sla_hours` · `status:ready-to-dev` chưa có `priority:*` · `status:qa-passed`/`status:uat` theo milestone | `daily-scrum`, `sprint-planning`, `status-report`, `release-plan`, `sprint-review` |
| Designer | Story UI chưa có `## UI brief` hoặc chưa có `## Design approval: APPROVED` · `status:in-review`/`status:qa` có Figma mà chưa có `## Design review` | `ui-design-brief`, `design-review` |
| Dev | Issue của mình ở `status:qa-failed`, `status:uat-failed`, `status:needs-human` · `status:test-design` có `## Test design: PASS` chờ duyệt plan | `qa-failed-fix`, `github-issue-implement`, `plan-approval`, `github-pr-review` |
| Tech Lead | `status:test-design` có `## Test design: PASS` (G2) · `status:qa-passed` (G3, G4) · `status:needs-human` · `type:hotfix` · story chưa refinement | `plan-approval`, `merge-readiness`, `hotfix`, `refutation-brief`, `backlog-refinement`, `sprint0-setup` |
| QA | `status:test-design` có `## Test design: PASS` (duyệt test case) · `status:qa` có `## QA report: PENDING` hoặc còn case manual | `plan-approval`, `qa-manual-session` |
| AI Enablement | `status:needs-human` lặp lại cùng nguyên nhân · workflow agent lỗi · cuối sprint | `sprint-retro`, `sprint0-setup` |
| Security | Story `risk:high` ở G2/G3 · thay đổi quyền/token · đầu dự án | `sprint0-setup` |

Mỗi issue: số, tiêu đề, assignee, priority, risk, số ngày ở trạng thái. Đánh dấu issue giao cho người
chạy. Tối đa 10 mỗi nhóm. Đề xuất tối đa 3 việc kèm một dòng lý do. **Hỏi người chạy chọn; không thay
đổi gì.**

## Có số issue: chạy bước của nó

1. Đọc `status:*` và `type:*` (`gh issue view <n> --json labels,state`).
2. Chọn skill theo trạng thái **và vai trò**:

   | Label | Vai trò | Skill |
   |---|---|---|
   | `type:epic` | BA, Tech Lead | `feature-analysis` |
   | `type:hotfix` (trước merge) | Tech Lead, Dev | `hotfix` |
   | `status:backlog` | mọi người | `github-issue-triage` |
   | `status:fail-to-dev` | PO, BA | `github-issue-create` (soạn lại issue) |
   | `status:test-design` chưa có `## Test design: PASS` | mọi người | `qa-test-cases` |
   | `status:test-design` đã có `## Test design: PASS` | Tech Lead, Dev, QA | `plan-approval` |
   | `status:ready-to-dev`, `status:in-progress` | Dev | `github-issue-implement` (gọi `figma-to-code` khi có Figma) |
   | `status:in-review` | Dev, Tech Lead | `github-pr-review` (session mới) |
   | `status:in-review`, `status:qa` | Designer | `design-review` |
   | `status:qa` | QA | `qa-manual-session` |
   | `status:qa` | khác | `e2e-playwright` |
   | `status:qa-failed`, `status:uat-failed` | Dev | `qa-failed-fix` |
   | `status:qa-passed` | Tech Lead | `refutation-brief`, rồi `merge-readiness` |
   | `status:uat` chưa có `## UAT checklist` | mọi người | `uat-checklist` |
   | `status:uat` đã có checklist | PO | `uat-run` |
   | `status:backlog` chưa có `size:*` | PO, BA, Tech Lead | `backlog-refinement` |
   | Story UI ở `status:test-design` chưa có `## Design approval: APPROVED` | Designer | `ui-design-brief` |
   | (không theo issue) | PM | `daily-scrum`, `sprint-planning`, `sprint-review`, `status-report`, `release-plan` |
   | (không theo issue) | AI Enablement | `sprint-retro` |
   | (không theo issue) | Tech Lead, PM, AI Enablement, Security | `sprint0-setup` (đầu dự án) |

3. Nói một dòng: issue ở bước nào, vai trò nào, chạy skill nào. Rồi **đọc SKILL.md của skill đó và làm
   theo đúng**, với cùng số issue.
4. Dừng, không thay đổi gì, khi:
   - issue không có hoặc có nhiều hơn một label `status:*`: báo lỗi;
   - `status:blocked`: nêu issue đang chặn và trạng thái của nó;
   - `status:needs-human`: tóm tắt `## Needs human` mới nhất và ai cần xử lý;
   - `status:done` hoặc issue đã đóng;
   - vai trò của người chạy không có skill cho trạng thái này: nói ai là người phụ trách (theo `docs/agents/raci.md`).

## Luật

- **Mỗi bước một session.** Session đã viết code không review chính code đó.
- Không đoán trạng thái, không tự gắn label.
