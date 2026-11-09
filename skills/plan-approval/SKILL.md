---
name: plan-approval
description: Skill cho người ký cổng G2 (Tech Lead/Dev duyệt plan, QA duyệt test case) trong quy trình WATA. Tóm tắt "## Test design: PASS" thành 5–10 điểm cần quyết định, ghi phán quyết của người duyệt, soạn "## Plan approval". Khi đủ người duyệt, nhắc người đó tự gắn status:ready-to-dev. Không bao giờ tự gắn. Dùng khi "duyệt plan", "review test case", "G2".
---

# plan-approval — hỗ trợ cổng G2

> **Vai trò:** Tech Lead, Dev, QA · **Bước:** 3 · **Chế độ:** tương tác · **Kích hoạt:** người gọi · **Đọc:** `## Test design: PASS`, `## Design approval: APPROVED` · **Ghi:** `## Plan approval`

`$ARGUMENTS`: `<số issue>`. Trống: liệt kê issue `status:test-design` đã có `## Test design: PASS`,
đánh dấu issue đang chờ người chạy duyệt (theo `people.tech_lead`, `people.qa`).

**Đọc `docs/agents/contract.md` trước.** Cổng G2 là của con người; skill giúp đọc nhanh và ghi lại
phán quyết, **không bao giờ gắn `status:ready-to-dev`**.

## Bước 0: Ngữ cảnh (chỉ đọc)

1. Issue: AC, `## Test design: PASS` mới nhất (plan, bảng test case, finding), `risk:*`.
2. Các `## Plan approval` đã có: ai đã duyệt phần nào.
3. Người chạy là ai, giữ vai trò gì (`people` trong `.claude/project.yml`). Người viết issue không
   tự duyệt plan của nó (không ký hai cổng liên tiếp).

## Bước 1: Tóm tắt điểm cần quyết định

5–10 điểm, ưu tiên điều dễ sai nhất:
- Phạm vi: file/app sẽ đụng, điều cố ý không làm.
- Phạm vi ảnh hưởng: cái gì đang chạy có thể hỏng.
- Finding còn mở và các phương án.
- Test: AC nào chỉ có test ghim (không đỏ hôm nay), case P1 nào là manual/mobile, case còn thiếu.
- Rủi ro: có nên đổi `risk:*`.
- **Story có UI:** đã có `## Design approval: APPROVED` mới nhất chưa (skill `ui-design-brief`). Chưa có → chưa đủ điều kiện G2, dù plan và test case đều ổn.
- Story có `human-code`: ghi rõ ai sẽ code (agent sẽ không implement).

Tech Lead/Dev xem phần plan; QA xem phần test case. `risk:low`: chỉ cần Tech Lead.

## Bước 2: Hỏi và ghi phán quyết

Từng điểm: đồng ý / yêu cầu đổi (đổi gì) / hỏi thêm. Ghi đúng lời người duyệt.

## Bước 3: Soạn

```markdown
## Plan approval

Người duyệt: @<login> · Phần: <plan | test case | cả hai> · Kết luận: <ĐỒNG Ý | CẦN ĐỔI>

| Điểm | Phán quyết |
|---|---|

### Yêu cầu đổi           <!-- nếu có -->
- ...
```
Cho người duyệt xem, **chờ đồng ý**, rồi đăng.

## Bước 4: Bước tiếp

- **Đủ người duyệt** (plan + test case, hoặc chỉ Tech Lead nếu `risk:low`), đều ĐỒNG Ý, và story UI đã có `## Design approval: APPROVED`: nhắc người
  duyệt **tự gắn** `status:ready-to-dev` trên GitHub. Implement sẽ chạy.
- **CẦN ĐỔI ở plan/test case:** người duyệt gỡ rồi gắn lại `status:test-design` để `qa-test-cases` chạy
  lại và đọc `## Plan approval` này.
- **AC sai hoặc thiếu:** người duyệt gắn `status:fail-to-dev`, mention PO.

## Luật

- Không gắn `status:ready-to-dev`. Không duyệt thay người.
