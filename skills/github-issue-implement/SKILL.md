---
name: github-issue-implement
description: "Bước 4 của quy trình WATA. Code issue ở status:ready-to-dev theo plan đã duyệt ở G2, viết test trước, chạy lint/typecheck/test/build, mở PR \"Refs #<số>\", đăng \"## Build write-up\" và chuyển sang status:in-review. Cũng chạy ở chế độ sửa khi review hoặc QA trả về (status:in-progress sau \"## Code review: FAIL\" hoặc \"## QA report: FAIL\"). Dùng khi \"code issue này\", \"implement\", \"sửa theo review\"."
---

# github-issue-implement — Bước 4: code và mở PR

> **Vai trò:** Dev · **Bước:** 4 · **Chế độ:** tự động + tương tác · **Kích hoạt:** label `status:ready-to-dev`, `status:in-progress` (tự động) hoặc người gọi · **Đọc:** `## Test design: PASS`, `## Plan approval`, `## Code review: FAIL`, `## QA report: FAIL`, `## Design approval: APPROVED` · **Ghi:** `## Build write-up`, `## Needs human`

`$ARGUMENTS`: `<số issue> [--auto]`. Trống: liệt kê issue `status:ready-to-dev` theo priority và
issue `status:in-progress` của người chạy, hỏi làm issue nào.

**Đọc `docs/agents/contract.md` trước**, đặc biệt mục 7 (code, branch, PR).

## Bước 0: Ngữ cảnh (chỉ đọc)

1. Issue đủ theo contract mục 4.
2. **Xác định chế độ** từ heading mới nhất:
   - `## Test design: PASS` + label `status:ready-to-dev` → **làm mới**.
   - `## Code review: FAIL` hoặc `## QA report: FAIL` mới hơn `## Build write-up` → **chế độ sửa**:
     spec của lần chạy này là các finding trong comment đó, không hơn. Đọc label `round:*`.
3. **Story có label `human-code`:** người code trực tiếp; dừng, không code (tương tác: hỏi người chạy có phải người được giao không và chỉ hỗ trợ khi được yêu cầu).
4. **Cổng G2 phải đã qua.** Làm mới mà không có `## Test design: PASS`, hoặc `status:ready-to-dev`
   không do người gắn (xem timeline): dừng, báo, không code.
5. PR hiện có của issue (cả PR đã đóng) và những gì đã merge vào vùng code này kể từ test design.
   **Tiền đề còn đúng không trên `origin/main` mới nhất?** Có thể đã có người sửa.
6. Code ở mọi app trong plan, coding standard của từng app, `.claude/project.yml` (lệnh build).

## Bước 1: Nhận việc

- Làm mới: đọc lại label, gắn `status:in-progress`. Issue chưa có assignee thì assign người chạy
  (tương tác) hoặc để trống (tự động). Không đổi assignee của người khác.
- Tương tác: nhắc lại plan đã duyệt trong 5–10 dòng, nêu điều gì đã thay đổi kể từ G2. **Chờ đồng ý.**
- Plan không còn đúng (code đã đổi, AC mâu thuẫn): **dừng**. Tương tác: hỏi. Tự động: đăng
  `## Needs human` (vấn đề, các phương án, hệ quả), gắn `status:needs-human`.

## Bước 2: Code

1. Branch từ `origin/main` mới nhất: `feat|fix|chore/<số>-<slug>`. Chế độ sửa: checkout branch của PR.
2. **Test trước.** Mỗi test case loại `unit`/`integration` trong bảng `e2e/test-cases/<số>.md` thành
   test thật, chạy và cho thấy **đỏ** trên code chưa sửa. Bug: tái hiện lỗi trước, lưu output.
3. Code theo thứ tự contract chung → API → web/admin → mobile, theo coding standard. Không thêm
   thư viện hay nâng phiên bản nếu plan không có.
4. Đổi API: response cũ vẫn dùng được cho `mobile.supported_app_versions` bản app gần nhất.
5. Đổi UI: code theo frame trong `## Design approval: APPROVED` (không có thì dừng: story UI chưa qua G2);
   thêm `data-testid` cho phần tử mà test case `auto` cần; lấy thiết kế qua Figma MCP (skill `figma-to-code`).
6. Commit theo Conventional Commits, có `#<số>`.
7. Tương tác: **cho xem diff** (mỗi file, một câu cho mỗi hunk, cái gì plan không nhắc) và chờ đồng ý.

## Bước 3: Chứng minh

1. Chạy lint, typecheck, test, build của **mọi app bị đụng** bằng lệnh trong `project.yml`. Lưu output.
2. Test của bước 2 giờ **xanh**. Lỗi cũng fail trên `main` sạch thì ghi rõ, không giấu.
3. **Phá thử:** đảo một điều kiện chính, cho thấy test đúng chuyển đỏ, rồi hoàn lại.
4. Chạy thử thật khi làm được (API local + request, web trên localhost). Nói rõ điều không chạy được.

Bất kỳ bước nào fail mà không sửa được sau 2 lần thử: dừng, `## Needs human` kèm output.

## Bước 4: Write-up và PR

Soạn `## Build write-up` (kiểm từng câu khẳng định với branch):

```markdown
## Build write-up

### Đã làm
- AC1 → `<file>`: <thay đổi>. Test: TC-<số>-01 (`<file test>`)
### Quyết định thiết kế và lý do
### Không làm (ngoài phạm vi)
### Kiểm chứng
| Lệnh | Kết quả |
|---|---|
| `<lint>` | pass |
### Còn nợ trước release
<env var, migration, index, test manual/mobile cho QA>
### Câu hỏi mở
- @<người>: ...

---
Đã chạy: ...
Chỉ đọc: ...
Còn là claim: ...
```

- Tương tác: cho xem write-up và nội dung PR, **chờ đồng ý**. `--auto`: tiếp tục.
- Push, mở PR (không draft) vào `default_branch`, body theo `.github/pull_request_template.md`, có
  `Refs #<số>` (**không** `Closes`). Chế độ sửa: push lên branch PR hiện có.
  ```bash
  git push -u origin <branch>
  gh pr create --base main --title "<type>(<app>): <mô tả> (#<số>)" --body-file <file>
  ```
- Đợi CI chạy trên **commit cuối** (`gh pr checks <pr> --watch`). Đỏ: sửa hoặc `## Needs human`.
- Đăng write-up lên issue. Chế độ sửa: đăng `## Build write-up` mới, liệt kê từng finding và cách sửa.
- Đọc lại label, gắn `status:in-review`. Nói bước tiếp: `github-pr-review` trong **session mới**.

## Luật

- **Thiếu spec thì dừng code.** Không đoán rồi code theo đoán.
- **Ở trong phạm vi issue.** Vấn đề gần đó ghi vào write-up, không sửa luôn.
- Không merge, không push vào `main`, không tag, không sửa workflow/CODEOWNERS/settings.
- **Không báo kết quả không tận mắt thấy.**
