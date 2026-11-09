---
name: qa-failed-fix
description: "Bước 6b của quy trình WATA, dev chạy tương tác. Sửa đúng phần lỗi mà QA (status:qa-failed) hoặc PO khi UAT (status:uat-failed) đã nêu: tái hiện trước, test đỏ trước khi sửa, đăng \"## QA fix\" và chuyển về status:in-review để review lại ở session mới. Dùng khi \"sửa lỗi QA\", \"QA failed\", \"UAT rejected\"."
---

# qa-failed-fix — Bước 6b: sửa sau QA hoặc UAT

> **Vai trò:** Dev · **Bước:** 6b · **Chế độ:** tương tác · **Kích hoạt:** người gọi · **Đọc:** `## QA report: FAIL`, `## UAT: REJECTED` · **Ghi:** `## QA fix`

`$ARGUMENTS`: `<số issue>`. Trống: liệt kê issue `status:qa-failed` và `status:uat-failed`, của người
chạy trước, cũ nhất trước, kèm một dòng lỗi; hỏi làm issue nào.

**Đọc `docs/agents/contract.md` trước.** Skill này **chỉ chạy tương tác**: issue tới đây vì AI đã
thử đủ vòng không được, hoặc vì PO không chấp nhận. Developer dẫn dắt.

**Spec của bước này là báo cáo lỗi mới nhất**: `## QA report: FAIL` hoặc `## UAT: REJECTED`. Sửa
đúng phần đó, không hơn.

## Bước 0: Ngữ cảnh (chỉ đọc)

1. Issue đủ theo contract mục 4. Đọc **mọi** QA report và UAT trước đó, các `## Build write-up` và
   `## Code review:`: vì sao 3 vòng trước chưa hội tụ?
2. Liệt kê từng lỗi: bước, mong đợi, thực tế, môi trường/commit nơi phát hiện.
3. PR: còn mở hay đã merge (UAT failed thì đã merge), commit cuối, lệch `main` bao nhiêu.
4. Người chạy có phải assignee không. Không phải: phối hợp với assignee trước khi sửa.

## Bước 1: Tái hiện và lên kế hoạch, rồi DỪNG

1. **Tái hiện từng lỗi** đúng cách QA/PO làm, trên cùng loại môi trường, trước khi đổi gì. Lưu bằng chứng.
2. **QA/PO có đúng không?** Lỗi không tái hiện được, hoặc hành vi mong đợi khác với AC đã duyệt:
   **đó là phát hiện**. Soạn trả lời kèm bằng chứng, dừng, không code. AC chưa nói tới hành vi đó →
   đó là yêu cầu mới (issue mới), không phải lỗi.
3. Kế hoạch: cách sửa từng lỗi, file, test sẽ đỏ khi chưa sửa. Không gì ngoài lỗi đã nêu.
4. Với `status:qa-failed`: nêu vì sao các vòng trước sai (thiếu ngữ cảnh, AC mơ hồ, môi trường) để
   ghi vào bài học.

**Chờ đồng ý.**

## Bước 2: Sửa

1. PR còn mở: checkout branch PR. PR đã merge (UAT): branch mới từ `origin/main` mới nhất,
   `fix/<số>-uat-<slug>`.
2. Test trước, **đỏ** trên code chưa sửa; rồi sửa; commit có `#<số>`.
3. Cho xem diff và kết quả test (đỏ rồi xanh). **Chờ đồng ý** trước khi push.
4. Chạy lại đúng cách QA/PO đã làm; lưu bằng chứng.

## Bước 3: Trả lại

1. Push. PR đã merge thì mở PR mới với `Refs #<số>`. CI xanh trên commit cuối.
2. Comment trên issue:

```markdown
@<qa hoặc po>: <cần kiểm tra lại gì>

## QA fix

| Lỗi | Nguyên nhân | Sửa | Test ghim |
|---|---|---|---|

### Vì sao các vòng trước chưa hội tụ
<một đến ba dòng; đưa vào retro>

---
Đã chạy: ...
Chỉ đọc: ...
Còn là claim: ...
```

3. Gỡ `round:*`, đọc lại label, gắn `status:in-review`. Bước tiếp: `github-pr-review` trong session mới,
   sau đó QA chạy lại.

## Luật

- Chỉ sửa phần đã nêu. Vấn đề mới gặp → ghi chú, hoặc issue mới khi được đồng ý.
- Không cãi QA/PO khi không có bằng chứng. Đưa bản tái hiện hoặc AC, và tag họ.
- Không merge, không push vào `main`.
