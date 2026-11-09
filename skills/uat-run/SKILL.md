---
name: uat-run
description: Skill của PO ở Bước 9 (cổng G5) quy trình WATA. Đi cùng PO qua từng mục của "## UAT checklist" trên staging, ghi đạt/chưa đạt, tách lỗi với yêu cầu mới, rồi soạn sẵn comment "## UAT: ACCEPTED" hoặc "## UAT: REJECTED" để PO đăng. PO tự gắn status:done hoặc status:uat-failed. Dùng khi "nghiệm thu", "làm UAT", "UAT issue này".
---

# uat-run — PO nghiệm thu

> **Vai trò:** PO · **Bước:** 9 · **Chế độ:** tương tác · **Kích hoạt:** người gọi · **Đọc:** `## UAT checklist` · **Ghi:** `## UAT: ACCEPTED`, `## UAT: REJECTED`

`$ARGUMENTS`: `<số issue>`. Trống: liệt kê issue `status:uat` mà người chạy là PO (theo `people.po`),
cũ nhất trước.

**Đọc `docs/agents/contract.md` trước.** Người chạy là **PO**: ngôn ngữ nghiệp vụ, câu ngắn.

**Đây là cổng G5, quyết định là của PO.** Skill hỏi, ghi và soạn; không bao giờ tự gắn `status:done`
hay `status:uat-failed` (contract mục 8). Gọi qua `@claude` thì AI chạy bằng GitHub App, và guard
cũng sẽ gỡ các label đó nếu bot gắn.

## Bước 0: Ngữ cảnh (chỉ đọc)

1. Issue: AC, `## UAT checklist` mới nhất, môi trường và commit ghi trong đó.
2. Checklist ghi "cần xác nhận đã deploy staging": hỏi PO/Tech Lead trước khi bắt đầu.

## Bước 1: Đi qua từng mục

Lần lượt từng mục trong checklist:

1. Đọc lại mục bằng lời đơn giản: làm gì, mong thấy gì.
2. Hỏi PO: **đạt / chưa đạt / không làm được**.
3. Chưa đạt: hỏi "anh/chị thấy gì?" và nhờ ảnh chụp.
4. Hỏi tiếp: **điều này AC có nói tới không?**
   - Có → lỗi UAT (tính vào REJECTED).
   - Không → **yêu cầu mới**, ghi riêng; không làm UAT bị reject.

## Bước 2: Soạn kết luận

- **ACCEPTED**: mọi mục đạt (yêu cầu mới, nếu có, ghi riêng).
- **REJECTED**: có mục chưa đạt.

```markdown
## UAT: <ACCEPTED|REJECTED>

Môi trường: <staging> · Commit: <sha> · Người nghiệm thu: @<po>

| Mục | Kết quả | Ghi chú |
|---|---|---|

### Chưa đạt            <!-- khi REJECTED -->
- Mục <n>: làm <...>, thấy <...>, mong đợi <...> (AC<k>). Ảnh: <...>

### Yêu cầu mới (không tính là lỗi UAT)
- <...> → đề xuất tạo issue mới
```

## Bước 3: PO đăng và gắn label

- Cho PO xem bản soạn. **Chờ đồng ý.** Chạy bằng tài khoản của PO (CLI) thì đăng comment khi PO đồng
  ý; qua `@claude` thì đăng như bot và ghi rõ "PO @<login> đã xác nhận trong phiên".
- Hướng dẫn PO **tự** gắn trên GitHub: ACCEPTED → `status:done` (issue tự đóng); REJECTED →
  `status:uat-failed` (dev sửa bằng `qa-failed-fix`).
- Có yêu cầu mới: hỏi PO có muốn tạo issue không; có thì chuyển sang `github-issue-create` cho từng
  yêu cầu.

## Luật

- Không tự đánh dấu đạt. Không gắn label nghiệm thu.
- Không biến yêu cầu mới thành lỗi UAT.
