---
name: sprint-review
description: "Sprint Review trong quy trình Scrum WATA, cho PO/PM. Soạn tài liệu demo (story đã nghiệm thu, thay đổi theo sprint, kịch bản demo theo AC, những gì chưa xong và vì sao), sau buổi review chuyển phản hồi của khách hàng thành story mới qua github-issue-create. Dùng khi \"sprint review\", \"chuẩn bị demo\", \"phản hồi khách hàng\"."
---

# sprint-review — demo và phản hồi

> **Vai trò:** PO, PM · **Bước:** review · **Chế độ:** tương tác · **Kích hoạt:** người gọi · **Đọc:** `## UAT: ACCEPTED`, `## Build write-up` · **Ghi:** không ghi lên issue

`$ARGUMENTS`: `[tên milestone sprint]` hoặc `feedback [tên milestone]` (sau buổi review).

**Đọc `docs/agents/contract.md` trước.** Người đọc tài liệu demo là **PO và khách hàng**: ngôn ngữ
nghiệp vụ, không tên file hay thuật ngữ kỹ thuật.

## Phần A: Tài liệu demo (chỉ đọc)

1. Story trong milestone: đã nghiệm thu (`## UAT: ACCEPTED`), đang UAT, chưa xong.
2. Với story đã xong: AC viết lại thành **kịch bản demo** (làm gì → thấy gì), môi trường staging, dữ liệu
   demo cần chuẩn bị.
3. Tóm tắt thay đổi theo sprint từ `## Build write-up` (bỏ chi tiết kỹ thuật).

```markdown
# Sprint Review — <sprint>

Sprint Goal: <...> · Kết quả: <đạt / một phần — vì sao>

## Đã hoàn thành
| Tính năng | Kịch bản demo | Ghi chú |
|---|---|---|
## Chưa hoàn thành và lý do
## Cần khách hàng quyết định
## Dữ liệu/tài khoản demo cần chuẩn bị
```
Đưa cho PO trong chat; lưu `reports/sprint-review-<sprint>.md` khi PO đồng ý.

## Phần B: Phản hồi thành story (sau buổi review)

1. PO dán ghi chú hoặc biên bản buổi review.
2. Tách từng phản hồi: lỗi so với AC (→ bug), yêu cầu mới (→ story), thay đổi ưu tiên (→ việc của PO).
3. Với mỗi lỗi/yêu cầu: đề xuất tiêu đề, mô tả, AC nháp. **Chờ PO đồng ý từng mục**, rồi tạo bằng
   `github-issue-create` (không gắn `status:*`; PO gắn `status:backlog` là cổng G1).

## Luật

- Không trình bày story chưa nghiệm thu như đã xong.
- Không tạo issue khi PO chưa đồng ý. Không tự đổi ưu tiên.
