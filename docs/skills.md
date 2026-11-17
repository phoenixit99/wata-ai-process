<!-- Sinh tự động bởi scripts/sync-skills.py. Không sửa tay. -->

# Danh mục skill

Danh sách sinh tự động từ `skills/catalog.json`, nguồn duy nhất cho skill, vai trò và cách kích hoạt. Nội dung từng skill (dành cho AI) nằm trong repo; bấm vào tên để xem.

## Tất cả skill

| Bước | Skill | Dùng khi | Vai trò | Kích hoạt |
|---|---|---|---|---|
| 1 | [`github-issue-create`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/github-issue-create/SKILL.md) | Tạo issue đúng mẫu (Description, Acceptance Criteria, Design), vào Backlog | PO, BA | người gọi |
| 2 | [`github-issue-triage`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/github-issue-triage/SKILL.md) | Kiểm tra issue được giao theo Definition of Ready → Ready to dev hoặc Fail to dev | AI (tự động) | label `Backlog` (tự động) hoặc người gọi |
| 3 | [`github-issue-implement`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/github-issue-implement/SKILL.md) | Tạo branch, code theo coding standard, viết unit test, mở Pull Request | Developer | label `Ready to dev`, `In progress` (tự động) hoặc người gọi |
| 4 | [`github-pr-review`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/github-pr-review/SKILL.md) | Review PR theo Acceptance Criteria và coding standard, comment trên từng dòng | Developer, Tech Lead | label `In review` (tự động) hoặc người gọi |
| 5 | [`qa-test-cases`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/qa-test-cases/SKILL.md) | Sinh test case (positive, negative, biên, trạng thái) từ Acceptance Criteria | QA | label `QA` (tự động) hoặc người gọi |
| 6 | [`e2e-playwright`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/e2e-playwright/SKILL.md) | Viết và chạy automation test, phân loại lỗi, báo cáo kết quả lên PR | QA | label `QA` (tự động) hoặc người gọi |
| 3 | [`figma-to-code`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/figma-to-code/SKILL.md) | Lấy thiết kế từ Figma, chuyển thành code theo chuẩn từng app, đối chiếu UI | Designer, Developer | người gọi |
| - | [`dev-pipeline`](https://github.com/phoenixit99/wata-ai-process/blob/main/skills/dev-pipeline/SKILL.md) | Chạy toàn bộ luồng trên cho các issue được giao | Developer, Tech Lead | người gọi |

## Coding standard

Coding standard riêng cho từng công nghệ, đặt trong thư mục của mỗi app (`apps/<app>/CODING_STANDARD.md`). AI bắt buộc đọc trước khi code và dùng khi review.

| Tên | App | Bản khởi đầu |
|---|---|---|
| `nextjs-coding-standard` | web, admin | [`docs/coding-standards/nextjs-coding-standard.md`](https://github.com/phoenixit99/wata-ai-process/blob/main/docs/coding-standards/nextjs-coding-standard.md) |
| `nestjs-coding-standard` | api | [`docs/coding-standards/nestjs-coding-standard.md`](https://github.com/phoenixit99/wata-ai-process/blob/main/docs/coding-standards/nestjs-coding-standard.md) |
| `flutter-coding-standard` | mobile | [`docs/coding-standards/flutter-coding-standard.md`](https://github.com/phoenixit99/wata-ai-process/blob/main/docs/coding-standards/flutter-coding-standard.md) |

## Theo vai trò

| Vai trò | Skill |
|---|---|
| PO | `github-issue-create` |
| BA | `github-issue-create` |
| Designer | `figma-to-code` |
| Developer | `github-issue-implement`, `github-pr-review`, `figma-to-code`, `dev-pipeline` |
| Tech Lead | `github-pr-review`, `dev-pipeline` |
| QA | `qa-test-cases`, `e2e-playwright` |
