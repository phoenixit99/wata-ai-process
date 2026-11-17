---
name: github-issue-triage
description: "Bước 2 của quy trình WATA. Kiểm tra issue được giao theo 10 điều kiện Definition of Ready (R1–R10), ghi kết quả bằng comment dạng bảng trên issue và chuyển label Backlog sang Ready to dev hoặc Fail to dev (kèm phần còn thiếu và gợi ý cách viết lại). Dùng khi \"triage issue\", \"issue này đủ để code chưa\"."
---

# github-issue-triage — Bước 2: Triage (kiểm tra issue)

> **Vai trò:** AI (tự động) · **Bước:** 2 · **Chế độ:** tự động + tương tác · **Kích hoạt:** label `Backlog` (tự động) hoặc người gọi · **Đọc:** — · **Ghi:** `## Triage: Ready to dev`, `## Triage: Fail to dev`

`$ARGUMENTS`: `<số issue> [--auto]`. Trống: lấy các issue được assign đang ở `Backlog`, hỏi làm issue
nào trước, không thay đổi gì.

**Đọc `docs/agents/contract.md` trước.**

**Bước này là gì.** Yêu cầu không rõ là nguyên nhân phổ biến nhất gây làm lại. AI chỉ code khi issue
đạt đủ Definition of Ready; nếu không, issue chuyển sang `Fail to dev` kèm danh sách phần còn thiếu và
gợi ý cách viết lại. Không viết code, không viết test.

## Bước 1: Ngữ cảnh (chỉ đọc)

1. Đọc issue đủ theo contract mục 4. Kiểm tra issue đang ở `Backlog`.
2. Đọc `.claude/project.yml` để biết danh sách app hợp lệ.
3. Đọc trạng thái hiện tại của mọi issue được nhắc là phụ thuộc.

## Bước 2: Đối chiếu 10 điều kiện

Với **từng** điều kiện, ghi Đạt / Không đạt / Không áp dụng, kèm một dòng bằng chứng.

| # | Điều kiện | Bắt buộc |
|---|---|---|
| R1 | Có người được assign | Có |
| R2 | Tiêu đề cụ thể, nói rõ thay đổi gì | Có |
| R3 | Có mục Description giải thích vấn đề và lý do (khuyến khích dạng user story) | Có |
| R4 | Có mục Acceptance Criteria với ít nhất 1 tiêu chí | Có |
| R5 | Mỗi tiêu chí kiểm thử được: có hành động và kết quả quan sát được (không dùng từ mơ hồ như "nhanh", "đẹp") | Có |
| R6 | Xác định được app bị ảnh hưởng (web / admin / api / mobile) | Có |
| R7 | Không còn TBD, "???" hoặc phần mẫu chưa điền | Có |
| R8 | Không bị chặn bởi issue khác chưa xong | Có |
| R9 | Với bug: có bước tái hiện, kết quả mong đợi và kết quả thực tế | Có (bug) |
| R10 | Thay đổi API mô tả request/response; thay đổi UI có link frame Figma | Khuyến nghị |

Ví dụ: "Người dùng quản lý được đơn hàng" → không đạt (không kiểm thử được). "Khi người dùng bấm Xoá,
đơn hàng biến mất khỏi danh sách và API không còn trả về đơn hàng đó" → đạt.

## Bước 3: Kết luận và soạn comment dạng bảng

- **Ready to dev**: mọi điều kiện bắt buộc đạt (R10 chỉ khuyến nghị, không làm trượt).
- **Fail to dev**: có điều kiện bắt buộc không đạt.

```markdown
@<người viết issue>: <một câu: cần làm gì>

## Triage: <Ready to dev|Fail to dev>

| # | Kết quả | Ghi chú |
|---|---|---|
| R1 | Đạt | ... |
| ... | | |
| R10 | Khuyến nghị | ... |

### Phần còn thiếu và gợi ý cách viết lại     <!-- bắt buộc khi Fail to dev -->
<câu chữ đề xuất, viết sẵn để PO dán vào issue>

---
Đã chạy: ...
Chỉ đọc: ...
Còn là claim: ...
```

## Bước 4: Ghi

- Tương tác: cho xem comment và label sẽ gắn, **chờ đồng ý**. `--auto`: ghi luôn.
- Đọc lại label (vẫn `Backlog`?), đăng comment, rồi đổi label (giữ đúng một label trạng thái):
  ```bash
  gh issue comment <n> --body-file <file>
  gh issue edit <n> --remove-label "Backlog" --add-label "Ready to dev"   # đạt
  gh issue edit <n> --remove-label "Backlog" --add-label "Fail to dev"    # không đạt
  ```
- Issue `Fail to dev` được kiểm tra lại tự động sau khi người viết cập nhật: workflow `wata-intake`
  chuyển lại `Backlog`, skill này chạy lại.

## Luật

- **Không sửa body issue.** Đưa câu chữ đề xuất trong comment; PO quyết định.
- Không viết code, không viết test.
