# Hướng dẫn cho Designer

## Việc của bạn trong quy trình

| Khi | Bạn làm | Xong khi |
|---|---|---|
| Issue đổi UI | Cung cấp **link frame Figma cụ thể** (không phải link cả file) trong mục Design | Link mở được đúng frame |
| Thiết kế | Vẽ đủ trạng thái: mặc định, loading, lỗi, rỗng, text dài, các quyền khác nhau | AI không phải đoán |
| AI hỏi về thiết kế | Trả lời trong comment issue hoặc PR | — |
| **Review UI** | Chạy `/design-review <số>` (hoặc comment `@claude`): so staging hoặc ảnh trong write-up với Figma, liệt kê chỗ lệch; bạn quyết mục nào phải sửa | `## Design review: OK` hoặc `## Design review: CHANGES` |
| Feature lớn | Tham gia Bước 0 khi `## Feature analysis` nói cần thiết kế | Có frame trước khi chia issue con |

## Giúp AI code đúng thiết kế

- Dùng component và token (màu, spacing, typography) của design system; AI map theo token có sẵn
  trong code. Giá trị lệch token sẽ bị làm tròn về token gần nhất và được ghi chú để bạn xác nhận.
- Đặt tên layer có nghĩa; dùng auto-layout.
- Cấp quyền xem file Figma cho tài khoản dùng Figma MCP của team.

<!-- role-skills:start -->
## Skill của bạn

Sinh tự động từ `skills/catalog.json`. Gọi trong Claude Code bằng lệnh ở cột 3; trên GitHub, comment câu ở cột 4 (dùng được cả khi skill không được nạp sẵn).

| Skill | Dùng khi | Claude Code | GitHub |
|---|---|---|---|
| `dev-pipeline` | Định tuyến theo label; bảng việc theo vai trò | `/dev-pipeline <#>` | `@claude đọc .claude/skills/dev-pipeline/SKILL.md và làm theo cho issue #<số>` |
| `design-review` | Designer so UI đã code với Figma | `/design-review <#>` | `@claude đọc .claude/skills/design-review/SKILL.md và làm theo cho issue #<số>` |
<!-- role-skills:end -->
