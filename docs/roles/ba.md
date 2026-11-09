# Hướng dẫn cho BA (Business Analyst)

Bạn biến nhu cầu kinh doanh thành yêu cầu làm được: phân tích feature, chia issue, làm rõ nghiệp vụ.

## Việc của bạn trong quy trình

| Khi | Bạn làm | Công cụ | Xong khi |
|---|---|---|---|
| Có feature lớn (epic) | Tạo issue loại epic; chạy (hoặc nhờ dev chạy) `/feature-analysis <số>`, hoặc comment `@claude phân tích epic này theo skill feature-analysis` | GitHub / Claude Code | Có `## Feature analysis` |
| Sau phân tích | Cùng PO và Tech Lead chốt hướng, API contract, danh sách issue con | GitHub comment | PO và Tech Lead đồng ý |
| Tạo issue con | Dùng `/github-issue-create` hoặc template; link về epic ("Part of #<epic>") | GitHub / Claude Code | Issue đủ AC; PO gắn `status:backlog` (G1) |
| Issue `status:fail-to-dev` về nghiệp vụ | Bổ sung theo comment triage | GitHub | Trong SLA |
| `## Needs human` về nghiệp vụ | Trả lời, ghi lý do | GitHub | — |
| Khi PO uỷ quyền | Ký cổng G1 thay PO | GitHub | — |

## Chia issue con tốt

- Mỗi issue **nằm gọn trong một PR review được** (thường dưới vài trăm dòng thay đổi).
- Thứ tự: contract chung → API → web/admin → mobile. Issue sau ghi rõ phụ thuộc issue trước.
- Mỗi issue có AC riêng, kiểm thử độc lập được.
- **Chốt API contract trước** khi các app bắt đầu, để không ai code trên contract đang đổi.

## Dùng Claude Code (khuyến nghị cho BA)

```
/feature-analysis 120        # phân tích epic #120
/github-issue-create <mô tả> # soạn issue con
/dev-pipeline                # xem bảng việc hôm nay
```

<!-- role-skills:start -->
## Skill của bạn

Sinh tự động từ `skills/catalog.json`. Gọi trong Claude Code bằng lệnh ở cột 3; trên GitHub, comment câu ở cột 4 (dùng được cả khi skill không được nạp sẵn).

| Skill | Dùng khi | Claude Code | GitHub |
|---|---|---|---|
| `dev-pipeline` | Định tuyến theo label; bảng việc theo vai trò | `/dev-pipeline <#>` | `@claude đọc .claude/skills/dev-pipeline/SKILL.md và làm theo cho issue #<số>` |
| `feature-analysis` | Phân tích epic, phản biện, hai hướng kiến trúc, đề xuất issue con | `/feature-analysis <#>` | `@claude đọc .claude/skills/feature-analysis/SKILL.md và làm theo cho issue #<số>` |
| `github-issue-create` | Soạn issue đúng mẫu từ ngôn ngữ tự nhiên | `/github-issue-create <#>` | `@claude đọc .claude/skills/github-issue-create/SKILL.md và làm theo cho issue #<số>` |
<!-- role-skills:end -->
