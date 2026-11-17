---
name: github-pr-review
description: "Bước 4 của quy trình WATA. Review PR của issue ở In review theo checklist 8 tiêu chí (Acceptance Criteria, tính đúng, coding standard, contract, bảo mật, test, hiệu năng, thiết kế) và coding standard, comment trên từng dòng, phân loại Blocker / Major / Minor. Có Blocker/Major thì AI tự sửa và review lại (tối đa 3 vòng); đạt thì chuyển issue sang QA. Dùng khi \"review PR\", \"code review issue này\"."
---

# github-pr-review — Bước 4: Code review

> **Vai trò:** Developer, Tech Lead · **Bước:** 4 · **Chế độ:** tự động + tương tác · **Kích hoạt:** label `In review` (tự động) hoặc người gọi · **Đọc:** `## Implementation` · **Ghi:** `## Code review: PASS`, `## Code review: FAIL`

`$ARGUMENTS`: `<số issue> [số PR] [--auto]`. Trống: liệt kê issue `In review` kèm số PR, hỏi review
issue nào.

**Đọc `docs/agents/contract.md` trước.**

## Bước 1: Ngữ cảnh (chỉ đọc)

1. Issue đủ theo contract mục 4: Acceptance Criteria, `## Implementation` mới nhất, các
   `## Code review:` trước đó (đếm số vòng đã review).
2. PR: diff, commit cuối, kết quả CI.
   ```bash
   gh pr view <pr> --json headRefOid,statusCheckRollup,files,body
   gh pr diff <pr>
   ```
3. Coding standard của mọi app bị đụng (`apps/<app>/CODING_STANDARD.md`). Có link Figma: frame thiết kế
   qua Figma MCP.

## Bước 2: Review theo checklist 8 tiêu chí

| Tiêu chí | Nội dung kiểm tra |
|---|---|
| Acceptance Criteria | Mọi tiêu chí được hiện thực; không làm ngoài phạm vi |
| Tính đúng | Trường hợp biên, xử lý lỗi, mã trạng thái HTTP |
| Coding standard | Cấu trúc, đặt tên, kiểu dữ liệu, không còn code thừa |
| Contract | Kiểu dữ liệu dùng chung đồng bộ giữa API, web, admin, mobile |
| Bảo mật | Validate input, không lộ secret, không có lỗ hổng injection |
| Test | Có unit test cho logic mới; có test id cho automation |
| Hiệu năng | Không truy vấn thừa, có phân trang |
| Thiết kế | Giao diện khớp với frame Figma |

Phân loại mỗi phát hiện: **Blocker** · **Major** · **Minor**. Mỗi phát hiện có `file:line`, bằng chứng
và cần sửa gì.

## Bước 3: Comment

- Comment trên **từng dòng** của PR cho mỗi phát hiện (GitHub MCP hoặc `gh api`).
- Comment tổng trên issue:
  ```markdown
  @<tác giả PR>: <cần làm gì>

  ## Code review: <PASS|FAIL>

  Vòng <n>/3

  | Tiêu chí | Kết quả |
  |---|---|
  | Acceptance Criteria | Đạt |
  | ... | |

  ### Phát hiện
  - [Blocker|Major|Minor] `<file:line>`: <vấn đề> → <cần sửa gì>

  ---
  Đã chạy: ...
  Chỉ đọc: ...
  Còn là claim: ...
  ```
- Tương tác: cho xem trước khi đăng, **chờ đồng ý**. `--auto`: đăng luôn.

## Bước 4: Tự sửa và review lại, hoặc chuyển QA

- **Có Blocker/Major** (`## Code review: FAIL`, request changes): chuyển issue về `In progress` để AI
  tự sửa (`github-issue-implement` chạy ở chế độ sửa theo các phát hiện), sau đó issue quay lại
  `In review` và được review lại từ Bước 2. **Tối đa 3 vòng.**
  ```bash
  gh issue edit <n> --remove-label "In review" --add-label "In progress"
  ```
- **Vòng 3 vẫn còn Blocker/Major:** dừng, giữ `In review`, mention Tech Lead (`people.tech_lead`)
  trong comment `## Code review: FAIL` cuối: cần người xử lý.
- **Đạt** (`## Code review: PASS`, không còn Blocker/Major): đọc lại label, chuyển issue sang `QA`:
  ```bash
  gh issue edit <n> --remove-label "In review" --add-label "QA"
  ```
- Minor không chặn; ghi trong comment để tác giả cân nhắc.

## Luật

- Không merge PR, không approve thay con người; merge là việc của Tech Lead / Reviewer.
- Review chỉ viết comment; việc sửa code thuộc `github-issue-implement` (chế độ sửa).
