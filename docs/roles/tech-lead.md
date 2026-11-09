# Hướng dẫn cho Tech Lead

Bạn chịu trách nhiệm kỹ thuật cuối cùng: ký G2 (plan), G3 (refutation), G4 (merge), chốt mức rủi ro,
và giữ guardrail.

## Việc của bạn trong quy trình

| Khi | Bạn làm | Công cụ |
|---|---|---|
| Sau triage | Xem `risk:*` triage đề xuất; đổi nếu không đồng ý | GitHub |
| **G2** | Duyệt plan trong `## Test design: PASS` (QA duyệt test case) bằng `plan-approval`. Gắn `status:ready-to-dev` | Claude Code / GitHub |
| **G3** | Đọc `## Refutation brief`, đọc kỹ các đoạn diff rủi ro, cố tìm điểm sai. Đồng ý: comment `## G3: OK` kèm điều đã kiểm. Có vấn đề: comment `## Code review: FAIL` + gắn `status:in-progress` | GitHub |
| **G4** | Chạy `/merge-readiness <số>`; READY thì merge | Claude Code + GitHub |
| `status:needs-human`, `status:qa-failed` | Phân công hoặc tự xử lý | — |
| Hotfix | Triage trực tiếp, chạy `/hotfix <số>` | Claude Code |
| Release | Cùng PM chuẩn bị bằng `/release-plan` | Claude Code |
| Feature lớn | Cùng BA/PO chốt `## Feature analysis` | GitHub |

## Giữ guardrail (bắt buộc trước khi bật agent)

- Branch protection trên `main`: cấm push trực tiếp, cấm force-push, bắt buộc PR, bắt buộc approval
  CODEOWNERS, required checks từ `ci.yml`.
- GitHub App của agent **không** có quyền bypass branch protection, không có quyền admin.
- `.claude/settings.json` từ template (lớp chặn dự phòng).
- CODEOWNERS bảo vệ `.github/`, `.claude/`, `docs/agents/`, `CLAUDE.md`.

## Giữ chất lượng của AI

- Điền `CLAUDE.md` và coding standard của từng app; thêm vào mục "Bẫy đã biết" mỗi khi AI hoặc người
  mắc lỗi đáng nhớ.
- Đọc lý do `## Needs human` và lỗi G3 bắt được mỗi tháng; đề xuất sửa skill lên repo trung tâm.

## Rủi ro cao

Issue `risk:high`: người làm G3 phải khác người merge; review thêm bảo mật và migration.

<!-- role-skills:start -->
## Skill của bạn

Sinh tự động từ `skills/catalog.json`. Gọi trong Claude Code bằng lệnh ở cột 3; trên GitHub, comment câu ở cột 4 (dùng được cả khi skill không được nạp sẵn).

| Skill | Dùng khi | Claude Code | GitHub |
|---|---|---|---|
| `dev-pipeline` | Định tuyến theo label; bảng việc theo vai trò | `/dev-pipeline <#>` | `@claude đọc .claude/skills/dev-pipeline/SKILL.md và làm theo cho issue #<số>` |
| `feature-analysis` | Phân tích epic, phản biện, hai hướng kiến trúc, đề xuất issue con | `/feature-analysis <#>` | `@claude đọc .claude/skills/feature-analysis/SKILL.md và làm theo cho issue #<số>` |
| `plan-approval` | Hỗ trợ người duyệt ký cổng G2 | `/plan-approval <#>` | `@claude đọc .claude/skills/plan-approval/SKILL.md và làm theo cho issue #<số>` |
| `github-pr-review` | Review PR ở session riêng, hai lượt | `/github-pr-review <#>` | `@claude đọc .claude/skills/github-pr-review/SKILL.md và làm theo cho issue #<số>` |
| `refutation-brief` | Chuẩn bị cho cổng G3 | `/refutation-brief <#>` | `@claude đọc .claude/skills/refutation-brief/SKILL.md và làm theo cho issue #<số>` |
| `merge-readiness` | Kiểm tra trước khi merge (G4) | `/merge-readiness <#>` | `@claude đọc .claude/skills/merge-readiness/SKILL.md và làm theo cho issue #<số>` |
| `hotfix` | Sửa khẩn cấp production | `/hotfix <#>` | `@claude đọc .claude/skills/hotfix/SKILL.md và làm theo cho issue #<số>` |
| `release-plan` | Kế hoạch release cho PM | `/release-plan <#>` | `@claude đọc .claude/skills/release-plan/SKILL.md và làm theo cho issue #<số>` |
<!-- role-skills:end -->
