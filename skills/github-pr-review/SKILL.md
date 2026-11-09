---
name: github-pr-review
description: "Bước 5 của quy trình WATA. Review PR của issue ở status:in-review trong một session MỚI (không phải session đã viết code), hai lượt: đọc diff theo 9 tiêu chí, rồi cố bác bỏ build write-up. Đăng \"## Code review: PASS/FAIL/HOLD\", comment theo dòng trên PR, chuyển sang status:qa hoặc trả về status:in-progress (tối đa 3 vòng, sau đó status:needs-human). Dùng khi \"review PR\", \"code review issue này\"."
---

# github-pr-review — Bước 5: review ở session riêng

> **Vai trò:** Dev, Tech Lead · **Bước:** 5 · **Chế độ:** tự động + tương tác · **Kích hoạt:** label `status:in-review` (tự động) hoặc người gọi · **Đọc:** `## Test design: PASS`, `## Build write-up`, `## Design review: CHANGES` · **Ghi:** `## Code review: PASS`, `## Code review: FAIL`, `## Code review: HOLD`

`$ARGUMENTS`: `<số issue> [số PR] [--auto]`. Trống: liệt kê issue `status:in-review`, cũ nhất trước,
kèm số PR, tác giả, kết quả CI, hỏi review issue nào.

**Đọc `docs/agents/contract.md` trước.**

**Bước này là gì.** Code do agent viết hiếm khi cẩu thả; nó **sai theo cách trông có vẻ đúng**.
Nhiệm vụ là **cố chứng minh thay đổi sai**. Nếu session này chính là session đã viết code: dừng,
yêu cầu chạy lại trong session mới.

## Bước 0: Ngữ cảnh (chỉ đọc)

1. Issue đủ theo contract mục 4: AC, bảng test case trong `## Test design: PASS`, `## Build write-up`
   mới nhất, các `## Code review:` trước đó và label `round:*`.
2. PR: commit cuối, CI chạy trên commit nào, review/thread đang mở.
   ```bash
   gh pr view <pr> --json headRefOid,commits,statusCheckRollup,reviews,files,body
   gh pr diff <pr>
   ```
3. Thử merge local với `origin/main` mới nhất:
   ```bash
   git fetch origin --prune
   git merge-tree --write-tree --name-only origin/main <head-sha>
   ```
   CI đỏ: đọc log trước mọi thứ khác; đỏ thường là lỗi thật, không phải flaky.
4. Checkout commit cuối của PR vào thư mục tạm (worktree tách rời), đọc toàn bộ diff ở đó, cùng
   coding standard của mọi app bị đụng.

## Bước 1: Lượt một — đọc diff theo 9 tiêu chí

| Tiêu chí | Kiểm tra |
|---|---|
| Acceptance Criteria | Mọi AC được hiện thực; không làm ngoài phạm vi |
| Tính đúng | Trường hợp biên, null/rỗng, xử lý lỗi, mã HTTP, race condition |
| Coding standard | Theo chuẩn của app; không còn code thừa, log debug, TODO không có issue |
| Contract | Kiểu dùng chung đồng bộ giữa API, web, admin, mobile; **response cũ vẫn đọc được với bản app mobile cũ** |
| Bảo mật | Validate input, phân quyền, không lộ secret, không injection, không log dữ liệu cá nhân |
| Test | Mỗi test case `unit`/`integration` trong bảng có test trong PR; với bug, test đỏ trên code cũ |
| Hiệu năng | Không truy vấn trong vòng lặp, có phân trang, không tải thừa |
| Thiết kế | UI khớp Figma; đủ trạng thái loading/lỗi/rỗng; có `data-testid`. Có `## Design review: CHANGES` mới nhất thì mỗi mục "phải sửa" là **Major** |
| Kiểm chứng | CI chạy trên commit cuối; claim trong write-up có bằng chứng |

Đổi một giới hạn (timeout, retry, page size, TTL): tìm code khác được tính theo giá trị đó.
Issue `risk:high`: thêm một lượt chỉ cho bảo mật và migration.

## Bước 2: Lượt hai — bác bỏ write-up

Mỗi câu khẳng định trong `## Build write-up` và PR body ("chỉ gọi ở một chỗ", "nhánh kia không đổi",
"test đã chạy", số liệu) được kiểm tại commit cuối. Search lại, có đối chứng dương. Khẳng định về
thư viện kiểm trong package đã cài. Chạy test rẻ, rồi **phá code** mà test nói là bao phủ và xem chúng
có đỏ không.

Lượt bác bỏ không tìm ra gì là **kết quả tốt**; báo cáo đúng như vậy.

## Bước 3: Kết luận và soạn

Phân loại phát hiện: **Blocker** (sai AC, lỗi bảo mật, mất dữ liệu, hỏng app cũ) · **Major** (lỗi
logic, thiếu test bắt buộc, vi phạm chuẩn quan trọng) · **Minor** (đặt tên, gợi ý).

- **PASS**: không Blocker/Major; mọi AC đạt; mọi test bắt buộc có; CI xanh trên commit cuối.
- **FAIL**: có Blocker/Major. Mỗi phát hiện: bằng chứng `file:line` và **cần sửa gì**.
- **HOLD**: bị chặn bởi thứ ngoài diff (PR phụ thuộc chưa merge). Nêu rõ.

Comment trên issue:
```markdown
@<tác giả PR>: <cần làm gì>

## Code review: <PASS|FAIL|HOLD>

- <vì sao> · Vòng <n>/<max_fix_rounds>

---
### Finding N: [Blocker|Major|Minor] <một dòng>
`<file:line>`: <bằng chứng> → <cần sửa gì>

### Độ phủ test
| Test case | Có trong PR | Ghi chú |
|---|---|---|

### Lượt bác bỏ
<claim nào đã kiểm, kết quả>

---
Đã chạy: ...
Chỉ đọc: ...
Còn là claim: ...
```
Và comment theo dòng trên PR cho từng Blocker/Major (`gh pr review <pr> --comment` hoặc GitHub MCP),
cộng một dòng tổng trỏ về comment trên issue.

## Bước 4: Ghi

- Tương tác: cho xem, **chờ đồng ý**. `--auto`: ghi luôn.
- Đọc lại label (vẫn `status:in-review`?), đăng comment issue, rồi comment PR.
- **PASS** → gắn `status:qa`. Không approve thay con người; approval CODEOWNERS là việc của người.
- **FAIL** → tăng vòng: gỡ `round:<n>`, gắn `round:<n+1>`.
  - Vòng ≤ `limits.max_fix_rounds` → gắn `status:in-progress` (implement chạy lại ở chế độ sửa).
  - Vượt → đăng thêm `## Needs human` (tóm tắt vì sao chưa hội tụ), gắn `status:needs-human`.
- **HOLD** → giữ `status:in-review`, chỉ comment.

Nói bước tiếp, chạy trong session mới.

## Luật

- Không merge, không push lên branch PR, không sửa code. Review chỉ viết comment.
- Comment ngắn, cụ thể; phát hiện, không phải bài luận.
