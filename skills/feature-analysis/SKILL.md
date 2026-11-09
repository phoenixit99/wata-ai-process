---
name: feature-analysis
description: Bước 0 của quy trình WATA, cho BA và Tech Lead. Với issue type:epic, đọc code liên quan, phản biện yêu cầu, đề xuất ít nhất hai hướng kiến trúc kèm điểm yếu, nêu app bị đụng, nhu cầu thiết kế, API contract cần chốt, và danh sách issue con đề xuất. Đăng "## Feature analysis". Chỉ tạo issue con khi PO và Tech Lead đồng ý. Dùng khi "phân tích feature", "chia nhỏ epic", "RFC".
---

# feature-analysis — Bước 0: phân tích và chia nhỏ

> **Vai trò:** BA, Tech Lead · **Bước:** 0 · **Chế độ:** tự động + tương tác · **Kích hoạt:** label `type:epic` (tự động) hoặc người gọi · **Đọc:** — · **Ghi:** `## Feature analysis`

`$ARGUMENTS`: `<số issue epic> [--auto]`.

**Đọc `docs/agents/contract.md` trước.** Đây là suy luận kiến trúc; dùng model mạnh nhất có.

**Bước này là gì.** Một feature lớn cần quyết định trước khi cần plan. Kết quả là một bản phân tích
để PO, BA, Tech Lead tranh luận và chốt, **không phải** danh sách việc để code ngay. Ở `--auto`, skill
chỉ đăng phân tích; không bao giờ tự tạo issue con.

## Bước 1: Đọc code trước khi viết

- Model, route, màn hình, job liên quan; tính năng tương tự đã có, có một nửa, hoặc đã bỏ dở.
- `CLAUDE.md` và coding standard của từng app có thể bị đụng.
- **Trích đường dẫn thật.** Đề xuất không dựa trên code là đoán.

## Bước 2: Phản biện yêu cầu

Ghi vào phần **Kiểm chứng giải pháp**:

1. Vấn đề nêu ra có phải vấn đề thật, hay là triệu chứng?
2. Cách đơn giản nhất đạt 80% giá trị với 20% công là gì?
3. Không làm thì sao? Nếu câu trả lời là "không sao nhiều", nói thẳng.
4. Phục vụ trường hợp phổ biến hay hiếm? Đếm được thì đếm (dữ liệu thật, chỉ đọc).
5. Đang giả định điều gì? Bỏ giả định về cách làm, phát biểu lại kết quả mong muốn.

## Bước 3: Ít nhất hai hướng kiến trúc

Hai hướng **thật sự khác nhau**, mỗi hướng: mô tả, app bị đụng, ưu điểm, **điểm yếu**, công sức tương
đối. Phản biện cả hướng mình chọn. Một bảng mà mọi hàng trừ một là bù nhìn còn tệ hơn không có bảng.

## Bước 4: Phạm vi và thứ tự

- **App bị đụng**, mỗi app một dòng thay đổi gì.
- **API contract cần chốt trước** khi chia issue con: endpoint, request/response, kiểu dùng chung.
  Tương thích ngược với app mobile cũ.
- **Thiết kế:** cần Designer không, vì sao (màn hình mới hoặc đổi luồng → mặc định là cần).
- **Rủi ro và câu hỏi mở**, mỗi câu kèm người cần trả lời.
- **Issue con đề xuất:** mỗi issue một dòng tiêu đề, app, loại, phụ thuộc. Thứ tự: contract → API →
  web/admin → mobile. Mỗi issue nên nằm gọn trong một PR review được.

## Bước 5: Soạn và ghi

```markdown
@<po> @<ba> @<tech lead>: <cần quyết định gì>

## Feature analysis

### Tóm tắt (3–5 dòng)
### Kiểm chứng giải pháp
### Các hướng kiến trúc
| Hướng | Mô tả | Ưu điểm | Điểm yếu | Công sức |
|---|---|---|---|---|
**Đề xuất:** <hướng>, vì <...>.
### App bị đụng
### API contract cần chốt
### Thiết kế
### Rủi ro và câu hỏi mở
### Issue con đề xuất
| # | Tiêu đề | App | Loại | Phụ thuộc |
|---|---|---|---|---|

---
Đã chạy: ...
Chỉ đọc: ...
Còn là claim: ...
```

- Tương tác: cho xem, **chờ đồng ý**, rồi đăng. `--auto`: đăng.
- **Tạo issue con chỉ khi PO và Tech Lead đã đồng ý** trong comment, và người chạy xác nhận. Mỗi issue
  con: theo template đúng loại, link về epic ("Part of #<epic>"), **không** gắn `status:*` (PO gắn
  `status:backlog` khi xác nhận, cổng G1).

## Luật

- Không viết code, không tạo branch.
- Không tự chọn hướng thay người quyết; nêu đề xuất và lý do.
