---
name: release-plan
description: "Skill của PM (cùng Tech Lead) trong quy trình WATA. Gom các issue của một milestone hoặc đang ở qa-passed/uat, cho biết cái nào sẵn sàng, cái nào chặn release, việc phải làm trước release (migration, env var, cấu hình) lấy từ build write-up, thứ tự merge/deploy, lịch UAT, kế hoạch rollback và ai chịu trách nhiệm. Chỉ đọc; kết quả đưa PM. Dùng khi \"lên kế hoạch release\", \"release này gồm gì\", \"sẵn sàng release chưa\"."
---

# release-plan — kế hoạch release

> **Vai trò:** PM, Tech Lead · **Bước:** - · **Chế độ:** tương tác · **Kích hoạt:** người gọi · **Đọc:** `## Merge readiness: READY`, `## UAT checklist` · **Ghi:** không ghi lên issue

`$ARGUMENTS`: `<tên milestone>` hoặc trống (lấy mọi issue `status:qa-passed` và `status:uat`).

**Đọc `docs/agents/contract.md` trước.** Skill chỉ đọc.

## Bước 1: Thu thập (chỉ đọc)

```bash
gh issue list --state all --milestone "<milestone>" --json number,title,labels,state,assignees
gh issue list --state open --label status:qa-passed --json number,title,labels
gh issue list --state open --label status:uat --json number,title,labels
```
Với mỗi issue: trạng thái, `risk:*`, PR (đã merge chưa), `## Merge readiness` mới nhất, mục "Còn nợ
trước release" trong `## Build write-up`, `## UAT:` nếu có.

## Bước 2: Phân loại

| Nhóm | Điều kiện |
|---|---|
| Sẵn sàng | Đã merge và `## UAT: ACCEPTED`, hoặc `## Merge readiness: READY` |
| Gần xong | `status:qa-passed` chưa có G3/G4; `status:uat` chưa nghiệm thu |
| Chặn | `needs-human`, `qa-failed`, `uat-failed`, `blocked`, hoặc phụ thuộc issue chưa xong |
| Ngoài release | Chưa tới QA |

## Bước 3: Việc trước release

Gom từ write-up: migration (thứ tự, có chạy lại an toàn không), biến môi trường, cấu hình, feature
flag, index, dữ liệu cần chuẩn bị, thay đổi contract ảnh hưởng app mobile (bản app tối thiểu). Mỗi việc
một người chịu trách nhiệm (hỏi PM nếu chưa rõ).

## Bước 4: Soạn kế hoạch

```markdown
# Kế hoạch release <milestone> — <ngày dự kiến>

## Tóm tắt
<gồm gì, rủi ro chính, quyết định cần PM/PO>

## Phạm vi
| # | Tiêu đề | Nhóm | Risk | Còn thiếu gì | Ai |
## Việc trước release
| Việc | Issue | Ai | Khi nào |
## Thứ tự merge / deploy
## Lịch UAT
## Rollback
<với mỗi issue risk:high: cách hoàn tác (revert, tắt flag, migration ngược)>
## Rủi ro và quyết định cần có

---
Nguồn: GitHub đến <thời điểm>. Chưa xác minh: <...>
```

## Bước 5: Giao

Đưa PM trong chat; lưu `reports/release-<milestone>.md` khi PM đồng ý. Không đăng lên issue, không
đổi label, không gửi ra ngoài.

## Luật

- Không quyết phạm vi release thay PM/PO; nêu đề xuất và lý do.
- Không merge, không deploy.
