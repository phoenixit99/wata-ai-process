---
name: daily-scrum
description: Daily Scrum trong quy trình Scrum WATA, cho PM/Scrum Master. Thay báo cáo miệng bằng bảng từ label: việc bị chặn (needs-human, blocked, qa-failed, uat-failed), hàng chờ review/QA so với giới hạn WIP, issue quá SLA, tiến độ so với Sprint Goal. Chỉ đọc. Dùng khi "daily", "stand-up", "hôm nay kẹt gì".
---

# daily-scrum — bảng cho buổi daily 15 phút

> **Vai trò:** PM · **Bước:** daily · **Chế độ:** tương tác · **Kích hoạt:** người gọi · **Đọc:** `## Needs human` · **Ghi:** không ghi lên issue

`$ARGUMENTS`: `[tên milestone sprint]` (mặc định milestone đang mở có hạn gần nhất).

**Đọc `docs/agents/contract.md` trước.** Skill chỉ đọc. Buổi họp tập trung vào **việc bị chặn**; tiến độ
bình thường đã có trên label.

## Thu thập (chỉ đọc)

```bash
gh issue list --state all --milestone "<sprint>" --json number,title,labels,assignees,state,updatedAt
```
Đọc `limits`, `sla_hours`, `sprint.review_slots` trong `.claude/project.yml`; comment `## Needs human` mới
nhất của các issue bị chặn.

## Bảng

```markdown
# Daily — <sprint> — <ngày> (ngày <n>/<tổng>)

## Bị chặn (bàn trong buổi họp)
| # | Trạng thái | Từ bao giờ | Cần ai | Việc cần làm |
|---|---|---|---|---|

## Hàng chờ con người
| Hàng chờ | Số issue | Giới hạn | Ghi chú |
|---|---|---|---|
| Chờ review (in-review) | n | wip_in_review | khung giờ review hôm nay: 10:00, 15:00 |
| Chờ QA (qa) | n | wip_qa | case manual còn chờ |
| Chờ duyệt plan (G2) | n | — | |
| Chờ G3/G4 (qa-passed) | n | — | |
| Chờ UAT | n | — | |

## Quá SLA
## Tiến độ Sprint Goal
<done / tổng; story có nguy cơ trễ và vì sao>

---
Nguồn: GitHub đến <thời điểm>.
```

Đưa cho PM trong chat. Không đăng lên issue, không nhắc ai (việc nhắc do `wata-sla-reminder` và PM).

## Luật

- Chỉ đọc. Không đổi label, không phân công thay PM.
- Ghi rõ dữ liệu không lấy được (API lỗi, milestone thiếu); không đoán.
