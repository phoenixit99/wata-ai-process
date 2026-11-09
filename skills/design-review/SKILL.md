---
name: design-review
description: Skill của Designer trong quy trình WATA. So giao diện đã code (staging/preview, localhost, hoặc ảnh trong build write-up) với frame Figma của issue, liệt kê chỗ lệch theo mức (phải sửa / nên sửa / chấp nhận), Designer xác nhận từng mục, rồi đăng "## Design review: OK" hoặc "## Design review: CHANGES" để bước review/QA dùng. Dùng khi "review UI", "so với Figma", "design QA".
---

# design-review — Designer duyệt giao diện

> **Vai trò:** Designer · **Bước:** 5 · **Chế độ:** tương tác · **Kích hoạt:** người gọi · **Đọc:** `## Build write-up` · **Ghi:** `## Design review: OK`, `## Design review: CHANGES`

`$ARGUMENTS`: `<số issue> [URL môi trường]`. Trống: liệt kê issue đổi UI (có link Figma) đang ở
`status:in-review` hoặc `status:qa`, hỏi làm issue nào.

**Đọc `docs/agents/contract.md` trước.** Người chạy là **Designer**: dùng ngôn ngữ thiết kế, không
dùng tên file code trừ khi được hỏi.

## Bước 0: Ngữ cảnh (chỉ đọc)

1. Issue: link frame Figma, AC liên quan đến UI. `## Build write-up` mới nhất (ảnh chụp, phần lệch
   `figma-to-code` đã ghi, câu hỏi cho Designer).
2. Thiết kế qua Figma MCP: các frame, trạng thái (mặc định, loading, lỗi, rỗng), token.
3. Nơi xem bản đã code: URL staging/preview Designer đưa, hoặc localhost nếu chạy được; không có thì
   dùng ảnh trong write-up và nói rõ hạn chế đó.

## Bước 1: Chụp và so

- Chụp từng màn hình/trạng thái tương ứng với frame (Playwright MCP), cùng kích thước khung hình.
  Mobile: dùng ảnh trong write-up hoặc ảnh Designer cung cấp.
- So: bố cục, khoảng cách, màu, chữ (cỡ, đậm, dòng), icon, trạng thái, responsive, text dài.

## Bước 2: Danh sách lệch

| # | Màn hình / trạng thái | Lệch | Mức đề xuất |
|---|---|---|---|

Mức: **phải sửa** (sai thiết kế, sai trạng thái, ảnh hưởng hiểu nội dung) · **nên sửa** · **chấp nhận**
(lệch do dùng token có sẵn). Đưa danh sách cho Designer; **Designer quyết mức cuối cùng** từng mục,
có thể thêm mục.

## Bước 3: Soạn và đăng

```markdown
@<tác giả PR> @<tech lead>: <cần làm gì>

## Design review: <OK|CHANGES>

Xem trên: <URL/ảnh> · Frame: <link>

| # | Màn hình / trạng thái | Lệch | Mức |
|---|---|---|---|

---
Đã chạy: chụp và so <các màn hình>
Chỉ đọc: Figma <frame>, build write-up
Còn là claim: <phần không xem được, ví dụ mobile thật>
```
- **OK**: không còn mục "phải sửa".
- **CHANGES**: còn mục "phải sửa".

Cho Designer xem, **chờ đồng ý**, rồi đăng. **Không đổi label.**

## Bước 4: Đưa vào luồng

- Issue đang `status:in-review`: `github-pr-review` đọc `## Design review: CHANGES` và tính các mục
  "phải sửa" là Major.
- Issue đã qua review (`status:qa` trở đi): nhắc Tech Lead quyết định. Nếu cần sửa, Tech Lead đăng
  `## Code review: FAIL` trỏ tới design review và gắn `status:in-progress`.

## Luật

- Không sửa code. Không tự quyết mức thay Designer.
- Không đoán thiết kế khi không mở được Figma; báo và dừng.
