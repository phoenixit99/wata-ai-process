---
name: e2e-playwright
description: Bước 6 của quy trình WATA. Với issue ở status:qa, viết và chạy test Playwright cho các test case loại auto đã thiết kế ở Bước 3, phân loại lỗi (test / sản phẩm / môi trường), gom kết quả case manual/mobile do QA ghi, đăng "## QA report: PASS/FAIL" lên issue và PR, chuyển sang status:qa-passed, trả về status:in-progress, hoặc status:qa-failed sau 3 vòng. Dùng khi "chạy QA", "viết e2e", "automation test issue này".
---

# e2e-playwright — Bước 6: QA

> **Vai trò:** AI (tự động) · **Bước:** 6 · **Chế độ:** tự động + tương tác · **Kích hoạt:** label `status:qa` (tự động) hoặc người gọi · **Đọc:** `## Test design: PASS`, `## Build write-up`, `## QA manual results` · **Ghi:** `## QA report: PASS`, `## QA report: FAIL`, `## QA report: PENDING`

`$ARGUMENTS`: `<số issue> [--auto]`. Trống: liệt kê issue `status:qa`, hỏi làm issue nào.

**Đọc `docs/agents/contract.md` trước.**

**Bước này là gì.** Chứng minh từng AC trên ứng dụng chạy thật. Lên kế hoạch trước, kết luận sau.
Bước này được ghi **code test** trong `e2e.path`; không sửa code sản phẩm (lỗi sản phẩm trả về
bước 4).

## Bước 0: Ngữ cảnh (chỉ đọc)

1. Issue đủ theo contract mục 4: AC, bảng test case (`e2e/test-cases/<số>.md` trên branch PR),
   `## Build write-up` (mục "Còn nợ"), `## Code review: PASS`, label `round:*`.
2. PR và commit cuối; checkout branch PR.
3. Cấu trúc `e2e.path`: fixture, page object, cách đăng nhập, dữ liệu test, cấu hình môi trường.

## Bước 1: Kế hoạch

- Liệt kê test case theo loại: `auto` (Playwright viết ở đây), `unit`/`integration` (đã có trong PR,
  chỉ xác nhận CI xanh), `manual`/`mobile` (QA làm).
- Với test cần dữ liệu hay tài khoản đặc biệt: cách tạo, cách dọn.
- Tương tác: cho xem kế hoạch, **chờ đồng ý**.

## Bước 2: Viết test Playwright

- Mỗi test case `auto` một test; **tên test bắt đầu bằng mã**: `test('TC-42-03 xoá đơn hàng ...')`.
- Dùng `data-testid` và role/label, không dùng CSS dễ vỡ hay text phụ thuộc ngôn ngữ khi tránh được.
- Không `waitForTimeout` cố định; đợi theo điều kiện (`expect(...).toBeVisible()`, response).
- Đăng nhập qua storage state/API, không qua UI (trừ test của chính màn hình đăng nhập).
- Test độc lập: tự tạo dữ liệu, không phụ thuộc thứ tự chạy.
- Có thể dùng Playwright MCP để khám phá giao diện và lấy selector; test cuối cùng vẫn là code trong repo.
- Commit vào branch PR: `test(e2e): TC-<số>-xx ... (#<số>)`.

## Bước 3: Chạy và phân loại

Chạy bằng `e2e.command` (giới hạn theo file/grep của issue), rồi chạy cả bộ liên quan để bắt hồi quy.

Mỗi test fail, phân loại **có bằng chứng** (trace, screenshot, log):

| Loại | Dấu hiệu | Xử lý |
|---|---|---|
| Lỗi test | Selector sai, đợi sai, dữ liệu test sai | Sửa test, chạy lại |
| Lỗi môi trường | Service không lên, timeout mạng, dữ liệu seed thiếu | Sửa cấu hình test hoặc báo; không tính là lỗi sản phẩm |
| Lỗi sản phẩm | Hành vi khác AC trên ứng dụng chạy đúng | Ghi finding; **không sửa code sản phẩm, không sửa test cho xanh** |

Test flaky (lúc qua lúc fail): chạy lại 3 lần, ghi tỉ lệ; flaky không được tính là đạt.

## Bước 4: Gom kết quả manual/mobile

- Bảng các case `manual`/`mobile` với cột Kết quả, Người test, Bằng chứng.
- Nếu QA đã ghi `## QA manual results` (skill `qa-manual-session`), gom vào; lấy bản mới nhất cho mỗi case. Nếu chưa: mention `people.qa`, liệt kê case
  cần test, **issue chưa được qua QA** cho đến khi mọi case P1 có kết quả đạt.

## Bước 5: Kết luận và soạn

- **PASS**: mọi test `auto` đạt (không flaky), CI xanh trên commit cuối, mọi case P1 manual/mobile đạt.
- **FAIL**: có lỗi sản phẩm, hoặc case P1 manual/mobile fail.
- Chưa đủ kết quả manual → **chưa kết luận**: đăng `## QA report: PENDING` (kết quả automation, commit đã chạy, case manual còn chờ), giữ `status:qa`, mention QA chạy `qa-manual-session`. Skill đó sẽ kết luận khi QA xong.

```markdown
@<tác giả PR> @<qa>: <cần làm gì>

## QA report: <PASS|FAIL>

- <tóm tắt> · Vòng <n>/<max_fix_rounds>

---
| Test case | Loại | Kết quả | Bằng chứng |
|---|---|---|---|
| TC-42-01 | auto | pass | `e2e/...spec.ts` |
| TC-42-04 | mobile | pass | @qa, ảnh chụp |

### Lỗi sản phẩm
#### Finding N: <một dòng>
Bước, mong đợi (AC), thực tế, bằng chứng.

### Chưa test được
<case nào, vì sao>

---
Đã chạy: <lệnh, số test, môi trường, commit>
Chỉ đọc: ...
Còn là claim: ...
```
Đăng thêm một comment ngắn trên PR trỏ về báo cáo.

## Bước 6: Ghi

- Tương tác: cho xem, **chờ đồng ý**. `--auto`: ghi luôn.
- Đọc lại label (vẫn `status:qa`?), push test, đăng comment.
- **PASS** → gắn `status:qa-passed`.
- **FAIL** → tăng `round:*`.
  - Vòng ≤ `max_fix_rounds` → gắn `status:in-progress` (implement sửa theo các finding).
  - Vượt → gắn `status:qa-failed`, mention Tech Lead: developer cần sửa (skill `qa-failed-fix`).

## Luật

- Không sửa code sản phẩm. Không xoá hay nới assertion để test xanh.
- Không gọi là "đạt" khi chưa thấy chạy. Nêu rõ case chưa test được.
