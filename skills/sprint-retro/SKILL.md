---
name: sprint-retro
description: Sprint Retrospective trong quy trình Scrum WATA, cho AI Enablement, PM và Tech Lead. Tổng hợp số liệu sprint và các lỗi AI lặp lại từ comment review/QA/UAT/Needs human; lỗi lặp lại từ 2 lần phải có hành động sửa skill, coding standard hoặc DoR, kèm bản nháp thay đổi và issue đề xuất cho repo quy trình trung tâm. Dùng khi "retro", "retrospective", "cải tiến skill".
---

# sprint-retro — cải tiến người và AI

> **Vai trò:** AI Enablement, PM, Tech Lead · **Bước:** retro · **Chế độ:** tương tác · **Kích hoạt:** người gọi · **Đọc:** `## Needs human`, `## Code review: FAIL`, `## QA report: FAIL`, `## UAT: REJECTED` · **Ghi:** không ghi lên issue

`$ARGUMENTS`: `[tên milestone sprint]`.

**Đọc `docs/agents/contract.md` và `docs/agents/process.md` mục 11 (chỉ số) trước.** Cả team chọn hành
động; AI tổng hợp và soạn đề xuất.

## Bước 1: Số liệu sprint (chỉ đọc)

Như `status-report` (`.claude/skills/status-report/SKILL.md`, Bước 1–2), giới hạn trong milestone. So với
mục tiêu tham khảo trong `scrum.md`: lead time, thời gian chờ review, tỉ lệ fail-to-dev, đạt review vòng 1,
độ phủ AC bằng automation, lỗi lọt, chi phí AI mỗi story.

## Bước 2: Lỗi AI lặp lại

Đọc mọi `## Code review: FAIL`, `## QA report: FAIL`, `## UAT: REJECTED`, `## Needs human`, comment
`## Code review: FAIL` của người ở G3 trong sprint. Gom theo **nguyên nhân**, không theo issue:

| Nguyên nhân | Số lần | Issue | Loại |
|---|---|---|---|
| Ví dụ: thiếu trạng thái rỗng trên màn hình danh sách | 3 | #.., #.. | coding standard |

Loại: skill (cách AI làm một bước) · coding standard · DoR/AC (yêu cầu đầu vào) · design system · môi
trường/dữ liệu test · khác.

## Bước 3: Hành động

**Mỗi nguyên nhân lặp lại ≥ 2 lần phải có một hành động.** Với từng cái, soạn sẵn:
- Skill hoặc tài liệu chung (thuộc lõi) → bản nháp đoạn sửa + nội dung **issue cho repo quy trình trung tâm**
  `phoenixit99/wata-ai-process` (tiêu đề, bằng chứng, đề xuất sửa).
- Coding standard, `CLAUDE.md` "Bẫy đã biết", design system (thuộc project) → bản nháp đoạn sửa trong repo
  project.
- DoR/AC → đề xuất cho PO/BA.

```markdown
# Retro — <sprint>

## Số liệu so với mục tiêu
## Lỗi AI lặp lại
## Hành động đề xuất
| Hành động | Loại | Người chịu trách nhiệm | Bản nháp |
|---|---|---|---|
## Điều làm tốt (giữ lại)
```

## Bước 4: Ghi

- Đưa cho team trong chat. Khi team chọn hành động: tạo issue trên repo trung tâm hoặc mở PR sửa
  coding standard/`CLAUDE.md` trong project — **mỗi lần ghi cần đồng ý**.
- Không tự sửa skill đang dùng trong project (`.claude/skills/`): skill thuộc lõi, sửa ở repo trung tâm rồi
  nâng phiên bản.

## Luật

- Gom theo nguyên nhân, nêu bằng chứng (số issue). Không đổ lỗi cho người.
- Không bịa số; chỉ số không tính được thì ghi lý do.
