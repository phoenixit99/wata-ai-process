<!-- Sinh tự động bởi scripts/sync-skills.py. Không sửa tay. -->

# Danh mục skill

Danh sách sinh tự động từ `skills/catalog.json`, nguồn duy nhất cho skill, vai trò và cách kích hoạt. Nội dung từng skill (dành cho AI) nằm trong repo; bấm vào tên để xem.

## Theo vai trò

| Vai trò | Skill |
|---|---|
| PO | `dev-pipeline`, `github-issue-create`, `backlog-refinement`, `sprint-planning`, `uat-run`, `sprint-review`, `sprint-retro` |
| BA | `dev-pipeline`, `feature-analysis`, `github-issue-create`, `backlog-refinement` |
| PM | `dev-pipeline`, `sprint0-setup`, `sprint-planning`, `status-report`, `release-plan`, `daily-scrum`, `sprint-review`, `sprint-retro` |
| Designer | `dev-pipeline`, `ui-design-brief`, `design-review` |
| Dev | `dev-pipeline`, `plan-approval`, `github-issue-implement`, `figma-to-code`, `github-pr-review`, `qa-failed-fix`, `hotfix` |
| Tech Lead | `dev-pipeline`, `sprint0-setup`, `feature-analysis`, `backlog-refinement`, `sprint-planning`, `plan-approval`, `github-pr-review`, `refutation-brief`, `merge-readiness`, `hotfix`, `release-plan`, `sprint-retro` |
| QA | `dev-pipeline`, `plan-approval`, `qa-manual-session` |
| AI Enablement | `dev-pipeline`, `sprint0-setup`, `sprint-retro` |
| Security | `dev-pipeline`, `sprint0-setup` |

## Tất cả skill

| Bước | Skill | Dùng khi | Vai trò | Kích hoạt |
|---|---|---|---|---|
| - | [`dev-pipeline`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/dev-pipeline/SKILL.md) | Định tuyến theo label; bảng việc theo vai trò | PO, BA, PM, Designer, Dev, Tech Lead, QA, AI Enablement, Security | người gọi |
| sprint-0 | [`sprint0-setup`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/sprint0-setup/SKILL.md) | Kiểm tra checklist Sprint 0 của dự án | Tech Lead, PM, AI Enablement, Security | người gọi |
| 0 | [`feature-analysis`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/feature-analysis/SKILL.md) | Phân tích epic, phản biện, hai hướng kiến trúc, đề xuất issue con | BA, Tech Lead | label `type:epic` (tự động) hoặc người gọi |
| 1 | [`github-issue-create`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/github-issue-create/SKILL.md) | Soạn issue đúng mẫu từ ngôn ngữ tự nhiên | PO, BA | người gọi |
| 2 | [`github-issue-triage`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/github-issue-triage/SKILL.md) | Kiểm tra Definition of Ready R1–R11 | AI (tự động) | label `status:backlog` (tự động) hoặc người gọi |
| refinement | [`backlog-refinement`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/backlog-refinement/SKILL.md) | Refinement hàng loạt: tách story, ước lượng S–XL, cờ cần người code | PO, BA, Tech Lead | người gọi |
| design | [`ui-design-brief`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/ui-design-brief/SKILL.md) | Brief UI từ design system, phương án giao diện, duyệt thiết kế trước khi code | Designer | người gọi |
| planning | [`sprint-planning`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/sprint-planning/SKILL.md) | Đề xuất phạm vi sprint theo năng lực review/QA | PM, PO, Tech Lead | người gọi |
| 3 | [`qa-test-cases`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/qa-test-cases/SKILL.md) | Thiết kế test case và plan trước khi code | AI (tự động) | label `status:test-design` (tự động) hoặc người gọi |
| 3 | [`plan-approval`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/plan-approval/SKILL.md) | Hỗ trợ người duyệt ký cổng G2 | Tech Lead, Dev, QA | người gọi |
| 4 | [`github-issue-implement`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/github-issue-implement/SKILL.md) | Code theo plan đã duyệt, mở PR | Dev | label `status:ready-to-dev`, `status:in-progress` (tự động) hoặc người gọi |
| 4 | [`figma-to-code`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/figma-to-code/SKILL.md) | Chuyển frame Figma thành UI, đối chiếu | Dev | người gọi |
| 5 | [`design-review`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/design-review/SKILL.md) | Designer so UI đã code với Figma | Designer | người gọi |
| 5 | [`github-pr-review`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/github-pr-review/SKILL.md) | Review PR ở session riêng, hai lượt | Dev, Tech Lead | label `status:in-review` (tự động) hoặc người gọi |
| 6 | [`e2e-playwright`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/e2e-playwright/SKILL.md) | Viết và chạy automation, kết luận QA | AI (tự động) | label `status:qa` (tự động) hoặc người gọi |
| 6 | [`qa-manual-session`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/qa-manual-session/SKILL.md) | QA test manual/mobile và ghi kết quả | QA | người gọi |
| 6b | [`qa-failed-fix`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/qa-failed-fix/SKILL.md) | Dev sửa lỗi sau QA hoặc UAT | Dev | người gọi |
| 7 | [`refutation-brief`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/refutation-brief/SKILL.md) | Chuẩn bị cho cổng G3 | Tech Lead | label `status:qa-passed` (tự động) hoặc người gọi |
| 8 | [`merge-readiness`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/merge-readiness/SKILL.md) | Kiểm tra trước khi merge (G4) | Tech Lead | người gọi |
| 9 | [`uat-checklist`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/uat-checklist/SKILL.md) | Soạn checklist UAT cho PO | AI (tự động) | label `status:uat` (tự động) hoặc người gọi |
| 9 | [`uat-run`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/uat-run/SKILL.md) | PO nghiệm thu, soạn kết luận UAT | PO | người gọi |
| hotfix | [`hotfix`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/hotfix/SKILL.md) | Sửa khẩn cấp production | Tech Lead, Dev | người gọi |
| - | [`status-report`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/status-report/SKILL.md) | Báo cáo tiến độ và chỉ số cho PM | PM | người gọi |
| - | [`release-plan`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/release-plan/SKILL.md) | Kế hoạch release cho PM | PM, Tech Lead | người gọi |
| daily | [`daily-scrum`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/daily-scrum/SKILL.md) | Bảng việc bị chặn và hàng chờ cho Daily Scrum | PM | người gọi |
| review | [`sprint-review`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/sprint-review/SKILL.md) | Tài liệu demo sprint, phản hồi thành story mới | PO, PM | người gọi |
| retro | [`sprint-retro`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/sprint-retro/SKILL.md) | Số liệu sprint, lỗi AI lặp lại thành đề xuất sửa skill | AI Enablement, PO, PM, Tech Lead | người gọi |
