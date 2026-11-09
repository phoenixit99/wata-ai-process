---
name: uat-checklist
description: Chuẩn bị cổng G5 (Bước 9, UAT) của quy trình WATA. Với issue ở status:uat (đã merge), soạn "## UAT checklist" bằng ngôn ngữ người dùng từ Acceptance Criteria để PO nghiệm thu trên staging, kèm hướng dẫn trả lời ACCEPTED/REJECTED. PO là người ký. Dùng khi "chuẩn bị UAT", "PO nghiệm thu".
---

# uat-checklist — chuẩn bị nghiệm thu (G5)

> **Vai trò:** AI (tự động) · **Bước:** 9 · **Chế độ:** tự động + tương tác · **Kích hoạt:** label `status:uat` (tự động) hoặc người gọi · **Đọc:** `## QA report: PASS` · **Ghi:** `## UAT checklist`

`$ARGUMENTS`: `<số issue> [--auto]`.

**Đọc `docs/agents/contract.md` trước.** Người đọc kết quả là **PO**: viết bằng ngôn ngữ nghiệp
vụ, không dùng tên file, mã test hay thuật ngữ kỹ thuật.

## Bước 0: Ngữ cảnh (chỉ đọc)

1. Issue: AC, QA report (case nào đã test, môi trường), PR đã merge và thời điểm merge.
2. Đã deploy lên staging chưa? Đọc thông tin deploy nếu project có (workflow deploy, release note,
   comment). Không xác định được → ghi "Cần xác nhận đã deploy staging" ở đầu checklist.

## Bước 1: Soạn checklist

- Mỗi AC thành một hoặc vài bước kiểm tra trên staging: **làm gì → thấy gì**. Gồm cả một trường hợp
  sai/biên tiêu biểu.
- Ghi tài khoản/dữ liệu test cần dùng (không ghi mật khẩu; trỏ tới nơi lưu chung của team).
- Ghi rõ điều **ngoài phạm vi** để PO không nhầm là lỗi.

```markdown
@<po>: issue đã merge, mời nghiệm thu trên staging.

## UAT checklist

Môi trường: <staging URL> · Phiên bản/commit: <sha> · <đã deploy lúc ... | cần xác nhận đã deploy>

- [ ] 1. <Đăng nhập bằng tài khoản ...>, vào <màn hình>, bấm <...> → thấy <...>   (AC1)
- [ ] 2. Nhập <dữ liệu sai> → thấy thông báo "<...>", dữ liệu không bị lưu      (AC2)

**Ngoài phạm vi:** <...>

**Cách trả lời:**
- Đạt: comment `## UAT: ACCEPTED`, rồi gắn label `status:done` (issue tự đóng).
- Chưa đạt: comment `## UAT: REJECTED` kèm bước nào, thấy gì, mong đợi gì; gắn `status:uat-failed`.
- Phát hiện điều AC không nói tới: tạo issue mới, không tính là UAT rejected.

---
Đã chạy: ...
Chỉ đọc: ...
Còn là claim: ...
```

## Bước 2: Ghi

- Tương tác: cho xem, **chờ đồng ý**. `--auto`: ghi luôn.
- Đăng comment. Không đổi label; `status:done` và `status:uat-failed` chỉ con người gắn.

## Luật

- Không tự đánh dấu mục nào là đạt. Không gắn label nghiệm thu.
