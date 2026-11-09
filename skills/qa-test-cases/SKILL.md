---
name: qa-test-cases
description: Bước 3 của quy trình WATA, chạy TRƯỚC khi code. Từ Acceptance Criteria của issue ở status:test-design, kiểm chứng từng AC trên code hiện tại, sinh test case (TC-<số>-<thứ tự>, P1–P3, auto/manual/mobile), lập plan AC → file → test, lưu bảng vào e2e/test-cases/ và đăng "## Test design: PASS/FAIL" để người duyệt ở cổng G2. Dùng khi "thiết kế test", "viết test case", "lập plan cho issue".
---

# qa-test-cases — Bước 3: thiết kế test và plan

> **Vai trò:** AI (tự động) · **Bước:** 3 · **Chế độ:** tự động + tương tác · **Kích hoạt:** label `status:test-design` (tự động) hoặc người gọi · **Đọc:** `## Triage: PASS` · **Ghi:** `## Test design: PASS`, `## Test design: FAIL`

`$ARGUMENTS`: `<số issue> [--auto]`. Trống: liệt kê issue `status:test-design` chưa có
`## Test design:`, hỏi làm issue nào.

**Đọc `docs/agents/contract.md` trước.**

**Bước này là gì.** Mỗi AC được chất vấn và biến thành test sẽ chứng minh nó, **trước khi có code**,
để test bám theo yêu cầu chứ không bám theo code. Bước này **thiết kế** test và plan; không viết code
sản phẩm. Kết quả chờ con người duyệt (G2): Tech Lead/Dev duyệt plan, QA duyệt test case.

## Bước 0: Ngữ cảnh (chỉ đọc)

1. Issue đủ theo contract mục 4. Comment `## Triage: PASS` mới nhất.
2. Code mà AC đụng tới, trên `origin/main` mới nhất (ghi SHA), mọi app liên quan, và coding standard
   của các app đó.
3. **Đã có code chưa?** `git branch -a --list '*<số>*'`, `git log --all --oneline --grep='#<số>'`,
   PR liên kết. Commit nhắc tới issue không chắc là bản sửa của nó; đọc xem nó là gì.
4. Test hiện có ở vùng code đó, và test e2e hiện có trong `e2e.path`.

## Bước 1: Kiểm chứng từng AC

Với **mỗi** AC, trả lời và ghi bằng chứng:

1. **Kiểm thử được không?** Có thứ test quan sát được: status code, field, bản ghi DB, text trên màn
   hình, điều hướng. AC còn chứa lựa chọn chưa quyết thì chưa phải AC.
2. **Hôm nay đúng hay sai?** Tìm code bằng search (không tin số dòng trong issue). Chạy thử khi rẻ:
   một hàm thuần, một request tới API local. Thử cả input AC không nhắc: thiếu, rỗng, null, sai kiểu,
   biên, quyền khác.
3. **Test nào chứng minh nó?** Unit, integration, e2e, hay manual/mobile. Test sẽ **đỏ hôm nay** hay
   chỉ ghim hành vi đã đúng? Test ghim thì phải chứng minh nó đỏ được khi phá code (trên bản sao).

Ghi thêm: **bẫy cho người code** (cách sửa hiển nhiên mà sẽ fail một AC), nơi khác cũng đọc giá trị
bị đổi (enum, key, hằng số), và tương thích ngược với app mobile cũ nếu đổi API.

## Bước 2: Sinh test case

Cho mỗi AC, xét đủ: luồng chính · dữ liệu sai · giá trị biên · chuyển trạng thái · quyền · đồng bộ giữa
app · **điều không được xảy ra** (thường là nơi lỗi nằm).

| Cột | Giá trị |
|---|---|
| ID | `TC-<số issue>-<01..>` |
| AC | AC1, AC2... |
| Mô tả | Khi ... thì ... |
| Ưu tiên | P1 (chặn release) / P2 / P3 |
| Loại | `unit` / `integration` / `auto` (Playwright) / `manual` / `mobile` |
| Đỏ hôm nay? | Có / Không (ghim) / Chưa rõ |
| Nơi đặt | đường dẫn file test dự kiến |

Lưu bảng vào `e2e/test-cases/<số issue>.md` (cùng tiêu đề issue và SHA). File này được commit trong PR
của bước 4; ở bước này chỉ đăng nội dung lên issue.

## Bước 3: Plan

Dưới 30 dòng:

- **Yêu cầu bằng lời của mình**, AC đánh số.
- **Bảng AC → file sẽ sửa → test case.** Thứ tự: contract chung → API → web/admin → mobile.
- **Phạm vi ảnh hưởng:** cái gì đang chạy có thể hỏng. "Không có gì" không phải câu trả lời.
- **Không làm:** những gì cố ý để ngoài phạm vi, và vì sao.
- **Rủi ro:** đề xuất giữ hay đổi `risk:*`.

## Bước 4: Kết luận và soạn comment

- **PASS**: mọi AC kiểm thử được, đúng với code hiện tại (hoặc sai đúng như issue mô tả), mỗi AC có test.
- **FAIL**: nêu lý do theo nhãn: AC sai so với code · không kiểm thử được · chứa quyết định chưa có ·
  sai màn hình/app · issue quá lớn (đề xuất tách). FAIL có thể hẹp: "FAIL, chỉ AC3".

```markdown
@<tech lead> @<qa> @<assignee>: <ai duyệt gì ở G2>

## Test design: <PASS|FAIL>

- <vì sao>

---
### Đã có code chưa?
<trả lời, SHA origin/main>

### Finding N: <một dòng>       <!-- nếu có -->
<bằng chứng `file:line` hoặc output ngắn; các phương án kèm hệ quả>

### Test case
<bảng ở bước 2>

### Plan
<bước 3>

### Duyệt G2
- [ ] Tech Lead/Dev duyệt plan
- [ ] QA duyệt test case
Khi cả hai đồng ý, **một người** gắn `status:ready-to-dev` (có thể kèm comment `## Plan approval`).

---
Đã chạy: ...
Chỉ đọc: ...
Còn là claim: ...
```

## Bước 5: Ghi

- Tương tác: cho xem, **chờ đồng ý**. `--auto`: ghi luôn.
- Đọc lại label (vẫn `status:test-design`?), đăng comment.
- **PASS: không đổi label.** Issue nằm ở `status:test-design` chờ người duyệt; skill không bao giờ
  gắn `status:ready-to-dev`.
- **FAIL:** gắn `status:fail-to-dev`.
- Issue `risk:low`: ghi trong comment rằng chỉ cần Tech Lead duyệt nhanh, không cần QA.

## Luật

- Không viết code sản phẩm, không tạo branch. Thử nghiệm chạy trên bản sao trong thư mục tạm.
- Không sửa body issue. Đề xuất câu chữ trong comment.
- Quyết định sản phẩm/kỹ thuật: đưa phương án kèm hệ quả, tag người được assign.
