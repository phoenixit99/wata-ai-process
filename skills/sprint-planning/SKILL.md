---
name: sprint-planning
description: "Sprint Planning trong quy trình Scrum WATA. Tính năng lực sprint theo năng lực review và QA/nghiệm thu của team (không theo năng lực code), đưa số liệu các sprint trước (lead time, số PR mỗi người review được, tỉ lệ fail-to-dev), đề xuất danh sách story vừa sức theo priority và size, gợi ý tách/gom, nhận diện story cần người code. Gắn milestone khi team chốt. Dùng khi \"lập kế hoạch sprint\", \"sprint planning\", \"sprint này nhận bao nhiêu\"."
---

# sprint-planning — lập kế hoạch sprint theo năng lực review/QA

> **Vai trò:** PM, PO, Tech Lead · **Bước:** planning · **Chế độ:** tương tác · **Kích hoạt:** người gọi · **Đọc:** `## Refinement notes` · **Ghi:** không ghi lên issue

`$ARGUMENTS`: `<tên milestone sprint>` (tạo mới nếu chưa có, khi được đồng ý) `[--days 10]`.

**Đọc `docs/agents/contract.md` và `docs/agents/scrum.md` (mục Sprint Planning, Ước lượng) trước.** Cả
team chốt Sprint Goal và phạm vi; AI cung cấp số liệu và đề xuất.

## Bước 1: Số liệu (chỉ đọc)

Từ 2–3 sprint gần nhất (milestone đã đóng) hoặc 30 ngày gần nhất:

| Số liệu | Cách tính |
|---|---|
| PR review được mỗi người/ngày | PR có `## Code review` / approval theo người duyệt cuối, chia số ngày |
| Story nghiệm thu được mỗi sprint | Issue nhận `status:done` |
| Story mỗi size đã hoàn thành | Theo `size:*` |
| Lead time | `ready-to-dev` → `qa-passed` |
| Thời gian chờ review | PR mở → approval cuối |
| Tỉ lệ fail-to-dev | `## Triage: FAIL` / tổng triage |

Không đủ dữ liệu (sprint đầu): ghi rõ và dùng giả định team đưa ra; không bịa số.

## Bước 2: Năng lực sprint

- Năng lực review = số người review × PR/người/ngày × số ngày review thực tế (trừ nghỉ, sự kiện).
- Năng lực QA/nghiệm thu = case manual/mobile QA làm được + story PO nghiệm thu được.
- **Năng lực sprint = giá trị nhỏ nhất** giữa review, QA và nghiệm thu, quy về size theo số liệu Bước 1.
- Giữ dư 10–20% cho việc phát sinh (bug production, hotfix) theo chính sách gián đoạn trong `scrum.md`.

## Bước 3: Đề xuất phạm vi

1. Ứng viên: story `status:ready-to-dev`, hoặc `status:test-design` đã qua refinement và (nếu có UI) có kế
   hoạch duyệt thiết kế trong 1–2 ngày đầu sprint.
2. Sắp theo `priority:*`, rồi phụ thuộc, rồi tuổi. Cộng dồn tới năng lực.
3. Đánh dấu: story `human-code` (cần ai code), story UI cần duyệt thiết kế, story `size:xl` (đề xuất tách),
   story nhỏ cùng vùng code (gợi ý gom).

```markdown
# Đề xuất Sprint <tên> (<ngày bắt đầu> – <ngày kết thúc>)

Sprint Goal (đề xuất): <...>
Năng lực: review <n> PR · QA <n> case · nghiệm thu <n> story → khoảng <n> story cỡ M

| # | Story | Size | Priority | Cờ | Ghi chú |
|---|---|---|---|---|---|

Ngoài sprint (vượt năng lực): ...
Giả định: ...
```

## Bước 4: Chốt

- Team thảo luận, sửa danh sách, chốt Sprint Goal. **Chờ đồng ý.**
- Khi đồng ý: tạo milestone (nếu chưa có) với Sprint Goal trong mô tả và ngày kết thúc; gắn milestone cho
  các story đã chốt.
  ```bash
  gh api repos/{owner}/{repo}/milestones -f title="<tên>" -f due_on="<ISO>" -f description="<Sprint Goal>"
  gh issue edit <n> --milestone "<tên>"
  ```
- Không đổi label `status:*`, không gắn `status:ready-to-dev` (cổng G2 vẫn là của người).

## Luật

- Lập kế hoạch theo năng lực review/QA/nghiệm thu, không theo tốc độ AI viết code.
- Không tự quyết phạm vi; đề xuất kèm lý do.
