---
name: qa-manual-session
description: Skill của QA ở Bước 6 quy trình WATA. Dẫn QA đi qua từng test case manual/mobile của một issue ở status:qa, ghi kết quả và bằng chứng vào "## QA manual results", rồi gộp với kết quả automation để kết luận "## QA report: PASS/FAIL" và chuyển trạng thái, để issue không bị kẹt chờ. Dùng khi "test manual", "ghi kết quả QA", "test mobile cho issue này".
---

# qa-manual-session — QA test manual/mobile

> **Vai trò:** QA · **Bước:** 6 · **Chế độ:** tương tác · **Kích hoạt:** người gọi · **Đọc:** `## Test design: PASS`, `## QA report: PENDING` · **Ghi:** `## QA manual results`, `## QA report: PASS`, `## QA report: FAIL`

`$ARGUMENTS`: `<số issue>`. Trống: liệt kê issue `status:qa` còn case manual/mobile chưa có kết quả,
hỏi làm issue nào.

**Đọc `docs/agents/contract.md` trước.** Người chạy là **QA**: hỏi từng câu ngắn, không bắt QA viết
định dạng; skill lo phần định dạng.

## Bước 0: Ngữ cảnh (chỉ đọc)

1. Issue đủ theo contract mục 4. Bảng test case (`e2e/test-cases/<số>.md` trên branch PR, hoặc bảng
   trong `## Test design: PASS`). Lấy các case loại `manual` và `mobile`.
2. `## QA report: PENDING` mới nhất (nếu có): kết quả automation, commit nó đã chạy.
3. `## QA manual results` trước đó (nếu có): case nào đã có kết quả, khỏi hỏi lại.
4. PR: commit cuối hiện tại. **So với commit trong QA report: PENDING.** Khác nhau nghĩa là code đã
   đổi sau lần chạy automation.

## Bước 1: Chuẩn bị

Nói với QA trong vài dòng: môi trường cần dùng (staging/preview, phiên bản app mobile, tài khoản test
theo nơi lưu chung của team), số case cần test, case nào P1. Hỏi QA đang test trên môi trường và thiết
bị nào để ghi vào kết quả.

## Bước 2: Đi qua từng case

Lần lượt từng case, P1 trước:

1. Hiển thị: mã, mô tả, các bước, kết quả mong đợi (lấy từ AC).
2. Hỏi: **đạt / không đạt / không test được**, và bằng chứng (link ảnh, video, ghi chú).
3. Không đạt: hỏi thêm "thấy gì" và bước nào; nhắc QA đính kèm ảnh.
4. Không test được: hỏi lý do (môi trường, thiết bị, dữ liệu).

Không tự điền kết quả thay QA. Không suy ra "đạt" từ việc QA không phản đối.

## Bước 3: Ghi kết quả manual

```markdown
## QA manual results

Môi trường: <...> · Thiết bị/phiên bản app: <...> · Commit: <sha> · Người test: @<qa>

| Test case | Ưu tiên | Loại | Kết quả | Bằng chứng / ghi chú |
|---|---|---|---|---|

---
Đã chạy: test tay bởi @<qa> như bảng trên
Chỉ đọc: bảng test case, QA report trước
Còn là claim: —
```
Cho QA xem, **chờ đồng ý**, rồi đăng.

## Bước 4: Kết luận QA (để issue không kẹt)

- **Chưa có kết quả automation**, hoặc **commit đã đổi** sau lần chạy automation: không kết luận. Báo
  QA: gỡ rồi gắn lại label `status:qa` để automation chạy lại trên commit mới (người gắn label thì
  workflow chạy). `e2e-playwright` sẽ đọc `## QA manual results` và kết luận.
- **Có kết quả automation trên đúng commit cuối:** làm theo `e2e-playwright` (`.claude/skills/e2e-playwright/SKILL.md`)
  Bước 5 và 6, gộp cả hai bảng:
  - PASS khi automation đạt và mọi case P1 manual/mobile đạt → `## QA report: PASS`, gắn `status:qa-passed`.
  - FAIL khi có lỗi sản phẩm → `## QA report: FAIL`, xử lý vòng (`round:*`) như `e2e-playwright`.
  - Case P1 "không test được" → chưa PASS; nêu điều cần để test được và ai lo.

Cho QA xem báo cáo và label sẽ gắn, **chờ đồng ý**.

## Luật

- Kết quả là của QA. AI chỉ hỏi, ghi và định dạng.
- Không sửa test case trong bảng; thiếu case thì ghi đề xuất vào ghi chú cho lần test design sau.
- Không gắn label cổng con người.
