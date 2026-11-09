# Hướng dẫn cho PM (Project Manager)

Khi AI viết code, việc thường dồn ở **các hàng chờ của con người** (duyệt plan, Needs human, merge,
UAT). Việc của bạn là giữ luồng chảy: ưu tiên, gỡ kẹt, báo cáo, quản lý rủi ro và chi phí.

## Việc của bạn trong quy trình

| Việc | Cách làm |
|---|---|
| **Sắp ưu tiên** | Gắn `priority:p1` / `p2` / `p3` cho issue `status:ready-to-dev`. AI lấy việc theo priority rồi theo tuổi, trong giới hạn WIP |
| **Giới hạn WIP** | Đặt `limits.wip_in_progress` trong `.claude/project.yml` (đề xuất 3). WIP cao hơn tốc độ review của người thì PR chỉ chất đống |
| **SLA hàng chờ** | Chốt `sla_hours` với team. Workflow `wata-sla-reminder` nhắc người phụ trách mỗi sáng và mention bạn |
| **Gỡ kẹt** | Mỗi ngày xem `status:needs-human`, `status:blocked`, issue quá SLA. Escalate hoặc phân công |
| **Thay đổi phạm vi** | AC đổi sau khi đã `ready-to-dev`: yêu cầu cập nhật issue và chuyển về `status:backlog` để triage lại. Đánh giá ảnh hưởng tiến độ |
| **Báo cáo** | Chạy `/status-report 7` (nội bộ) hoặc `/status-report 7 --client` (gửi khách hàng) |
| **Release** | Chạy `/release-plan <milestone>`; chốt phạm vi release, điều phối UAT với PO, lịch deploy với Tech Lead |
| **Chi phí AI** | Theo dõi chi phí token theo project; đặt `limits.max_turns_per_run` và ngân sách tháng (đề xuất, team chốt) |
| **Áp dụng quy trình** | Cùng Tech Lead hoàn thành checklist ở `../setup-guide.md`; ghi số liệu nền trước pilot |

## Chỉ số nên xem hằng tuần

- **Thời gian chờ con người** so với lead time: cao → thiếu người duyệt, không phải AI chậm.
- **Tỉ lệ fail-to-dev** cao → cần hỗ trợ PO/BA viết yêu cầu.
- **Needs human** tăng → skill cần cải tiến; đưa vào retro.
- **UAT rejected** cao → AC chưa phản ánh đúng ý PO.

## Lập kế hoạch khi có AI

- Thời gian code giảm, nhưng **review, QA manual, UAT vẫn tốn thời gian người**. Ước lượng theo
  khâu chậm nhất, không theo tốc độ AI viết code.
- Dành sức chứa cho Tech Lead ký G2/G3/G4 mỗi ngày.

## Kiêm nhiệm

Bạn kiêm PO được, nhưng không tự ký hai cổng liên tiếp cho cùng một issue.

<!-- role-skills:start -->
## Skill của bạn

Sinh tự động từ `skills/catalog.json`. Gọi trong Claude Code bằng lệnh ở cột 3; trên GitHub, comment câu ở cột 4 (dùng được cả khi skill không được nạp sẵn).

| Skill | Dùng khi | Claude Code | GitHub |
|---|---|---|---|
| `dev-pipeline` | Định tuyến theo label; bảng việc theo vai trò | `/dev-pipeline <#>` | `@claude đọc .claude/skills/dev-pipeline/SKILL.md và làm theo cho issue #<số>` |
| `status-report` | Báo cáo tiến độ và chỉ số cho PM | `/status-report <#>` | `@claude đọc .claude/skills/status-report/SKILL.md và làm theo cho issue #<số>` |
| `release-plan` | Kế hoạch release cho PM | `/release-plan <#>` | `@claude đọc .claude/skills/release-plan/SKILL.md và làm theo cho issue #<số>` |
<!-- role-skills:end -->
