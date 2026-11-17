---
name: e2e-playwright
description: "Bước 6 của quy trình WATA. Viết và chạy automation test Playwright cho các test case tự động hoá được (tên test bắt đầu bằng mã test case), phân loại lỗi (lỗi do test, lỗi sản phẩm, lỗi môi trường) và sửa đúng chỗ (tối đa 3 vòng), báo cáo kết quả bằng bảng trên PR. Toàn bộ đạt → QA passed; còn lỗi → QA failed kèm nguyên nhân. Dùng khi \"chạy automation\", \"viết e2e\", \"chạy Playwright cho issue này\"."
---

# e2e-playwright — Bước 6: Automation test với Playwright

> **Vai trò:** QA · **Bước:** 6 · **Chế độ:** tự động + tương tác · **Kích hoạt:** label `QA` (tự động) hoặc người gọi · **Đọc:** `## Test cases` · **Ghi:** `## Automation report: QA passed`, `## Automation report: QA failed`

`$ARGUMENTS`: `<số issue> [--auto]`. Trống: liệt kê issue `QA` đã có `## Test cases`, hỏi làm issue nào.

**Đọc `docs/agents/contract.md` trước.**

## Bước 1: Ngữ cảnh (chỉ đọc)

1. Issue đủ theo contract mục 4: `## Test cases` mới nhất và file `e2e/test-cases/<số issue>.md` trên
   branch của PR.
2. PR, commit cuối; checkout branch của PR.
3. Cấu trúc `e2e/`: fixture, cách đăng nhập, dữ liệu test. Có thể dùng Playwright MCP để mở trình duyệt,
   khám phá giao diện và chụp màn hình phục vụ viết test.

## Bước 2: Viết test Playwright

- Một test cho mỗi test case **tự động hoá được**. **Tên test bắt đầu bằng mã test case**, để lỗi truy
  ngược được tới Acceptance Criteria: `test('TC-42-03 xoá đơn hàng ...')`.
- Dùng `data-testid` và role/label; đợi theo điều kiện, không đợi cố định.
- Commit vào branch của PR: `test(e2e): TC-<số>-xx ... (#<số>)`.

## Bước 3: Chạy, phân loại lỗi và sửa đúng chỗ

Chạy bằng `e2e.command` trong `.claude/project.yml`. Mỗi test lỗi, phân loại có bằng chứng (trace,
screenshot, log):

| Loại | Sửa ở đâu |
|---|---|
| Lỗi do test | Sửa test |
| Lỗi sản phẩm | Sửa code sản phẩm trên branch của PR, chạy lại lint/typecheck/unit test/build |
| Lỗi môi trường | Sửa cấu hình môi trường test, hoặc báo nếu ngoài tầm |

Rồi chạy lại. **Tối đa 3 vòng.**

## Bước 4: Báo cáo bằng bảng trên PR

```markdown
## Automation report: <QA passed|QA failed>

Vòng <n>/3 · Commit `<sha>`

| Test case | Kết quả | Ghi chú |
|---|---|---|
| TC-42-01 | đạt | `e2e/...spec.ts` |
| TC-42-02 | lỗi | lỗi sản phẩm: ... |
| TC-42-04 | kiểm thử thủ công | QA của team thực hiện |

### Nguyên nhân còn lỗi          <!-- khi QA failed -->
...

---
Đã chạy: <lệnh, số test, môi trường, commit>
Chỉ đọc: ...
Còn là claim: ...
```

- Đăng báo cáo lên **PR**, và một dòng trên issue trỏ về báo cáo.
- Tương tác: cho xem, **chờ đồng ý**. `--auto`: ghi luôn.

## Bước 5: Đổi label

Đọc lại label (vẫn `QA`?):

- **Toàn bộ đạt** → `QA passed` (chờ con người merge):
  ```bash
  gh issue edit <n> --remove-label "QA" --add-label "QA passed"
  ```
- **Còn lỗi sản phẩm sau 3 vòng tự sửa** → `QA failed`, kèm nguyên nhân, mention Tech Lead: cần người
  xử lý.
  ```bash
  gh issue edit <n> --remove-label "QA" --add-label "QA failed"
  ```

## Luật

- Không xoá hay nới assertion để test xanh.
- Không gọi là "đạt" khi chưa thấy test chạy. Case kiểm thử thủ công ghi rõ là kiểm thử thủ công.
- Không merge PR.
