---
name: dev-pipeline
description: "Chạy toàn bộ luồng của quy trình WATA cho các issue được giao: đọc label trạng thái của từng issue và chạy đúng skill của bước đó (github-issue-triage, github-issue-implement, github-pr-review, qa-test-cases, e2e-playwright), nối tiếp cho tới QA passed hoặc tới khi cần con người. Dùng khi \"/dev-pipeline\", \"chạy pipeline cho issue này\", \"làm các issue được giao\"."
---

# dev-pipeline — chạy toàn bộ luồng cho các issue được giao

> **Vai trò:** Developer, Tech Lead · **Bước:** - · **Chế độ:** tương tác · **Kích hoạt:** người gọi · **Đọc:** — · **Ghi:** không ghi lên issue

`$ARGUMENTS`: trống (mọi issue đang mở được assign cho người chạy) hoặc `<số issue> [<số issue>...]`.

**Đọc `docs/agents/contract.md` trước.** Skill này không tự ghi gì; nó chọn bước theo label rồi đọc
`SKILL.md` của skill tương ứng và làm theo đúng skill đó.

## Bước 1: Lấy danh sách issue

```bash
gh api user --jq .login
gh issue list --state open --assignee @me --json number,title,labels
```

Hiển thị danh sách kèm label trạng thái hiện tại; hỏi người chạy xác nhận thứ tự làm.

## Bước 2: Định tuyến theo label trạng thái

| Label | Skill |
|---|---|
| `Backlog` | `github-issue-triage` |
| `Fail to dev` | dừng: chờ PO bổ sung (có thể dùng `github-issue-create` để soạn lại) |
| `Ready to dev` | `github-issue-implement` (gọi `figma-to-code` khi có link Figma) |
| `In progress` | `github-issue-implement` (tiếp tục trên branch đã có, hoặc chế độ sửa sau `## Code review: FAIL`) |
| `In review` | `github-pr-review` |
| `QA` | `qa-test-cases`, rồi `e2e-playwright` |
| `QA passed` | dừng: chờ Tech Lead / Reviewer merge |
| `QA failed` | dừng: cần người xử lý |

Với mỗi issue: nói một dòng (issue ở bước nào, chạy skill nào), đọc `SKILL.md` của skill đó và làm
theo, với cùng số issue. Xong một bước thì đọc lại label và đi tiếp bước kế, cho tới khi gặp trạng thái
dừng.

## Bước 3: Tổng kết

Bảng: issue, trạng thái đầu, trạng thái cuối, PR, việc con người cần làm tiếp.

## Luật

- Dừng (không thay đổi gì) khi issue không có hoặc có nhiều hơn một label trạng thái; báo lỗi.
- Không merge. `QA passed` là điểm dừng: chỉ con người được merge.
- Mỗi lần ghi vẫn theo luật hỏi trước của skill được gọi.
