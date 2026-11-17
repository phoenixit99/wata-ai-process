---
name: qa-test-cases
description: "Bước 5 của quy trình WATA. Với issue ở QA (review đã đạt), sinh test case từ mỗi Acceptance Criteria: luồng chính, dữ liệu sai, giá trị biên, chuyển trạng thái, đồng bộ giữa các app. Mỗi test case có mã TC-<số issue>-<số thứ tự>, độ ưu tiên P1–P3, đánh dấu tự động hoá hay kiểm thử thủ công. Lưu bảng trong repository và tóm tắt trên issue. Dùng khi \"viết test case\", \"sinh test case cho issue này\"."
---

# qa-test-cases — Bước 5: Viết test case

> **Vai trò:** QA · **Bước:** 5 · **Chế độ:** tự động + tương tác · **Kích hoạt:** label `QA` (tự động) hoặc người gọi · **Đọc:** `## Implementation`, `## Code review: PASS` · **Ghi:** `## Test cases`

`$ARGUMENTS`: `<số issue> [--auto]`. Trống: liệt kê issue `QA` chưa có `## Test cases`, hỏi làm issue nào.

**Đọc `docs/agents/contract.md` trước.**

## Bước 1: Ngữ cảnh (chỉ đọc)

1. Issue đủ theo contract mục 4: Acceptance Criteria, `## Implementation`, `## Code review: PASS`.
2. PR và branch của PR; test hiện có trong `e2e/`.

## Bước 2: Sinh test case

Từ **mỗi** Acceptance Criteria, sinh test case cho:

- luồng chính;
- dữ liệu sai;
- giá trị biên;
- chuyển trạng thái;
- đồng bộ giữa các app.

| Cột | Giá trị |
|---|---|
| Mã | `TC-<số issue>-<số thứ tự>` (ví dụ `TC-42-01`) |
| AC | AC1, AC2... |
| Mô tả | Khi ... thì ... |
| Ưu tiên | P1 / P2 / P3 |
| Loại | Tự động hoá / Kiểm thử thủ công |

## Bước 3: Lưu và tóm tắt

- Lưu bảng test case trong repository: `e2e/test-cases/<số issue>.md`, commit vào branch của PR
  (`test: test cases for #<số>`). Nhờ vậy QA của team review được.
- Tóm tắt trên issue:
  ```markdown
  ## Test cases

  File: `e2e/test-cases/<số issue>.md` · <n> test case (<a> tự động hoá, <m> kiểm thử thủ công)

  | Mã | AC | Mô tả | Ưu tiên | Loại |
  |---|---|---|---|---|

  ---
  Đã chạy: ...
  Chỉ đọc: ...
  Còn là claim: ...
  ```
- Tương tác: cho xem, **chờ đồng ý**. `--auto`: ghi luôn.
- Không đổi label. Bước tiếp theo là `e2e-playwright` (Bước 6) trên cùng issue.

## Luật

- Không sửa code sản phẩm.
- Mỗi Acceptance Criteria có ít nhất một test case.
