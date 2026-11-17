---
name: github-issue-implement
description: "Bước 3 của quy trình WATA. Với issue ở Ready to dev: chuyển sang In progress, tạo branch theo quy ước (ví dụ feat/42-due-date), lập bảng đối chiếu Acceptance Criteria → thay đổi code → test trước khi code, code theo coding standard của từng app (lấy thiết kế qua Figma MCP khi có link), viết unit test, qua lint/typecheck/unit test/build rồi mở Pull Request \"Closes #số\" và chuyển issue sang In review. Cũng chạy ở chế độ sửa khi review yêu cầu sửa (In progress sau \"## Code review: FAIL\"). Dùng khi \"code issue này\", \"implement\", \"mở PR\", \"sửa theo review\"."
---

# github-issue-implement — Bước 3: Code và mở Pull Request

> **Vai trò:** Developer · **Bước:** 3 · **Chế độ:** tự động + tương tác · **Kích hoạt:** label `Ready to dev`, `In progress` (tự động) hoặc người gọi · **Đọc:** `## Triage: Ready to dev`, `## Code review: FAIL` · **Ghi:** `## Implementation`

`$ARGUMENTS`: `<số issue> [--auto]`. Trống: liệt kê issue `Ready to dev` được assign, hỏi làm issue nào.

**Đọc `docs/agents/contract.md` trước**, đặc biệt mục 7 (code, branch, PR).

## Chế độ sửa (Request changes)

Issue ở `In progress` mà comment kết quả mới nhất là `## Code review: FAIL`: đây là **chế độ sửa**.
Checkout branch của PR, sửa đúng các phát hiện Blocker/Major trong comment đó (không hơn), chạy lại
Bước 5, push lên PR hiện có, đăng `## Implementation` mới liệt kê từng phát hiện và cách sửa, rồi
chuyển issue về `In review`. Bỏ qua Bước 2, 3 và phần mở PR của Bước 6.

## Bước 1: Ngữ cảnh (chỉ đọc)

1. Issue đủ theo contract mục 4, comment `## Triage: Ready to dev` mới nhất.
2. Code ở mọi app bị ảnh hưởng, trên `origin/main` mới nhất.
3. **Coding standard của từng app bị ảnh hưởng**: `apps/<app>/CODING_STANDARD.md` (đường dẫn ở
   `apps[].standard` trong `.claude/project.yml`). Bắt buộc đọc trước khi code.
4. Issue có link Figma: lấy thiết kế qua Figma MCP (skill `figma-to-code`).

## Bước 2: Nhận việc

- Đọc lại label (vẫn `Ready to dev`?), chuyển issue sang `In progress`:
  ```bash
  gh issue edit <n> --remove-label "Ready to dev" --add-label "In progress"
  ```
- Tạo branch từ `origin/main` theo quy ước: `feat|fix|chore/<số>-<slug>` (ví dụ `feat/42-due-date`).

## Bước 3: Bảng đối chiếu trước khi code

Lập bảng **Acceptance Criteria → thay đổi code → test** trước khi viết code:

| AC | Thay đổi code (app, file) | Test |
|---|---|---|
| AC1 | `apps/api/...` | unit test `...spec.ts` |

Tương tác: cho xem bảng, **chờ đồng ý**. Thiếu spec để code: dừng và hỏi (tương tác) hoặc comment
câu hỏi lên issue và dừng (tự động); không đoán.

## Bước 4: Code và unit test

1. Code theo thứ tự: **contract dùng chung → API → web/admin → mobile**, theo coding standard của
   từng app.
2. Đổi UI: theo frame Figma (skill `figma-to-code`); thêm `data-testid` cho phần tử automation cần.
3. Viết unit test cho logic mới.
4. Commit theo Conventional Commits, có `#<số>`.

## Bước 5: Kiểm tra bắt buộc

Chạy lint, kiểm tra kiểu, unit test và build của **mọi app bị đụng** bằng lệnh trong
`.claude/project.yml`. Tất cả phải qua trước khi mở PR. Không qua được: sửa; vẫn không qua thì dừng
và báo kèm output.

## Bước 6: Mở Pull Request

- Tương tác: cho xem nội dung PR, **chờ đồng ý**. `--auto`: tiếp tục.
- Push và mở PR vào `default_branch`, body theo `.github/pull_request_template.md`, có bảng đối chiếu
  AC → code → test và **`Closes #<số>`** để issue tự đóng khi merge.
  ```bash
  git push -u origin <branch>
  gh pr create --base main --title "<type>(<app>): <mô tả> (#<số>)" --body-file <file>
  ```
- Đăng comment trên issue:
  ```markdown
  ## Implementation

  PR: #<số PR> · Branch: `<branch>`

  | AC | Thay đổi code | Test |
  |---|---|---|

  | Kiểm tra | Kết quả |
  |---|---|
  | lint | pass |
  | typecheck | pass |
  | unit test | pass |
  | build | pass |

  ---
  Đã chạy: ...
  Chỉ đọc: ...
  Còn là claim: ...
  ```
- Đọc lại label, chuyển issue sang `In review`:
  ```bash
  gh issue edit <n> --remove-label "In progress" --add-label "In review"
  ```

## Luật

- Ở trong phạm vi issue. Vấn đề gần đó ghi vào comment, không sửa luôn.
- Không merge, không push vào `main`, không force-push.
- Không báo kết quả không tận mắt thấy.
