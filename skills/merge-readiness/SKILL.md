---
name: merge-readiness
description: Kiểm tra trước cổng G4 (Bước 8) của quy trình WATA, do Tech Lead gọi. Xác nhận CI xanh trên commit cuối, đủ approval CODEOWNERS, PR không conflict, đủ chuỗi heading PASS, G3 đã có (trừ risk:low), PR dùng "Refs #". Đăng "## Merge readiness: READY/NOT READY". AI không bao giờ merge. Dùng khi "merge được chưa", "kiểm tra trước khi merge".
---

# merge-readiness — kiểm tra trước cổng G4

> **Vai trò:** Tech Lead · **Bước:** 8 · **Chế độ:** tương tác · **Kích hoạt:** người gọi · **Đọc:** `## Refutation brief`, `## G3: OK` · **Ghi:** `## Merge readiness: READY`, `## Merge readiness: NOT READY`

`$ARGUMENTS`: `<số issue>` (Tech Lead chạy tương tác).

**Đọc `docs/agents/contract.md` trước.** Skill chỉ đọc và đăng một comment. **Merge là việc của
con người** (`gh pr merge` bị chặn trong `.claude/settings.json`).

## Kiểm tra

| # | Điều kiện | Cách kiểm |
|---|---|---|
| M1 | Issue ở `status:qa-passed` | `gh issue view <n> --json labels` |
| M2 | Có đủ chuỗi: `## Triage: PASS`, `## Test design: PASS`, `## Build write-up`, `## Code review: PASS`, `## QA report: PASS` — và mỗi cái mới hơn lần sửa cuối | comment theo thời gian |
| M3 | G2 do người ký: label `status:ready-to-dev` do người (không phải bot) gắn | timeline |
| M4 | G3 đã có: comment `## G3: OK` của người (không phải bot), sau `## Refutation brief` (bỏ qua nếu `risk:low`) | comment |
| M5 | `risk:high`: người làm G3 khác người sắp merge | so login |
| M6 | CI xanh **trên commit cuối** của PR | `gh pr view <pr> --json headRefOid,statusCheckRollup` |
| M7 | Đủ approval CODEOWNERS, không còn "changes requested" | `gh pr view <pr> --json reviewDecision,reviews` |
| M8 | Không conflict với `main` mới nhất | `git merge-tree --write-tree origin/main <head>` |
| M9 | PR body có `Refs #<số>`, không có `Closes/Fixes #<số>` | PR body |
| M10 | "Còn nợ trước release" trong write-up đã có người nhận (env var, migration...) | write-up + comment |
| M11 | Không có commit mới sau lần QA cuối (nếu có: QA/review phải chạy lại) | so thời gian commit với QA report |

## Kết luận

```markdown
@<tech lead>: <READY: có thể merge | NOT READY: cần xử lý mục ...>

## Merge readiness: <READY|NOT READY>

| # | Điều kiện | Kết quả | Ghi chú |
|---|---|---|---|

---
Đã chạy: ...
Chỉ đọc: ...
Còn là claim: ...
```

- Cho người chạy xem, **chờ đồng ý** rồi đăng. Không đổi label.
- READY: nhắc rằng merge xong, workflow `wata-pr-merged` tự chuyển issue sang `status:uat`.
- NOT READY: nêu ai cần làm gì cho từng mục fail.

## Luật

- Không merge, không approve, không bấm "Update branch".
