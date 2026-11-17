---
name: github-issue-create
description: "Bước 1 của quy trình WATA. Tạo issue đúng mẫu (Description, Acceptance Criteria, Affected apps, Design, Technical notes) từ yêu cầu bằng ngôn ngữ tự nhiên của PO hoặc thành viên, đánh dấu giả định để PO xác nhận, gắn label Backlog, loại công việc và app liên quan. Cũng dùng để soạn lại issue đang ở Fail to dev. Dùng khi \"tạo issue\", \"viết ticket\", \"soạn issue theo mẫu\"."
---

# github-issue-create — Bước 1: Tạo issue

> **Vai trò:** PO, BA · **Bước:** 1 · **Chế độ:** tương tác · **Kích hoạt:** người gọi · **Đọc:** `## Triage: Fail to dev` · **Ghi:** không ghi lên issue

`$ARGUMENTS`: mô tả yêu cầu bằng ngôn ngữ tự nhiên, hoặc `<số issue>` để soạn lại một issue có sẵn
(thường đang ở `Fail to dev`).

**Đọc `docs/agents/contract.md` và `docs/agents/writing-acceptance-criteria.md` trước.**

Người dùng skill này thường là PO hoặc BA. Dùng ngôn ngữ nghiệp vụ, giải thích ngắn khi phải dùng
thuật ngữ kỹ thuật.

## Bước 1: Hiểu yêu cầu (chỉ đọc)

1. Issue có sẵn: đọc đủ theo contract mục 4, đặc biệt comment `## Triage: Fail to dev` mới nhất,
   vì nó liệt kê phần còn thiếu và gợi ý cách viết lại.
2. Đọc nhanh code liên quan để biết app nào bị ảnh hưởng (web / admin / api / mobile).
3. Tìm issue đang mở có liên quan hoặc chặn việc này:
   ```bash
   gh issue list --state open --search "<từ khoá> in:title,body" --json number,title,labels
   ```

## Bước 2: Hỏi những gì còn thiếu

Hỏi người đang chạy, gộp thành một lượt, ưu tiên điều ảnh hưởng tới Acceptance Criteria: ai dùng,
dữ liệu sai thì sao, có thiết kế Figma chưa. Điều không hỏi được thì ghi `[Giả định] ...` trong issue
để PO xác nhận.

## Bước 3: Soạn issue theo mẫu chuẩn

Theo template trong `.github/ISSUE_TEMPLATE/` đúng loại (feature / bug / chore):

```markdown
## Description
<vấn đề và lý do; khuyến khích dạng user story>

## Acceptance Criteria
- [ ] AC1: Khi <hành động>, thì <kết quả quan sát được>
- [ ] AC2: ...

## Affected apps
web / admin / api / mobile

## Design
<link frame Figma, hoặc "Không đổi UI">

## Technical notes
<request/response nếu đổi API; issue liên quan #...; issue chặn #...>

## Assumptions
- [Giả định] ...
```

Bug thêm: bước tái hiện, kết quả mong đợi, kết quả thực tế.

Tự kiểm bản nháp theo 10 điều kiện Definition of Ready R1–R10 (`docs/agents/process.md` mục 5).
Mỗi tiêu chí phải có hành động và kết quả quan sát được; không dùng từ mơ hồ như "nhanh", "đẹp".

## Bước 4: Xác nhận rồi ghi

- Cho người chạy xem toàn bộ tiêu đề, body và label sẽ gắn. **Chờ đồng ý.**
- Tạo mới, gắn label Backlog, loại công việc và app liên quan:
  ```bash
  gh issue create --title "<tiêu đề>" --body-file <file> \
    --label "Backlog" --label "<feature|bug|chore>" --label "<app>"
  ```
- Soạn lại issue có sẵn: `gh issue edit <n> --body-file <file>` khi PO đồng ý. Issue `Fail to dev`
  được kiểm tra lại tự động sau khi cập nhật (workflow `wata-intake`).

## Luật

- Không tự quyết phạm vi hay hành vi sản phẩm. Hai cách hiểu → hỏi, hoặc ghi `[Giả định]`.
- Chế độ `--auto` không áp dụng: tạo issue luôn cần người xác nhận.
