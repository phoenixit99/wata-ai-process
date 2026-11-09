---
name: backlog-refinement
description: "Buổi Backlog Refinement trong quy trình Scrum WATA. Đi qua nhiều story ở status:backlog/fail-to-dev cùng PO và Tech Lead: chạy kiểm tra DoR, đề xuất tách story lớn, ước lượng S/M/L/XL theo độ phức tạp nghiệp vụ và công review/nghiệm thu (không theo công code), gắn cờ human-code cho story rủi ro cao, đăng \"## Refinement notes\". Dùng khi \"refinement\", \"groom backlog\", \"ước lượng story\"."
---

# backlog-refinement — refinement và ước lượng

> **Vai trò:** PO, BA, Tech Lead · **Bước:** refinement · **Chế độ:** tương tác · **Kích hoạt:** người gọi · **Đọc:** `## Triage: FAIL` · **Ghi:** `## Refinement notes`

`$ARGUMENTS`: trống (mọi issue `status:backlog` và `status:fail-to-dev` chưa có `size:*`), `--milestone <tên>`,
hoặc danh sách số issue.

**Đọc `docs/agents/contract.md` và `docs/agents/scrum.md` (mục Ước lượng) trước.** Đây là phiên làm
việc với **PO và Tech Lead**: AI chuẩn bị và đề xuất, người quyết.

## Bước 0: Chuẩn bị (chỉ đọc)

1. Lấy danh sách story; với mỗi story đọc đủ theo contract mục 4.
2. Nhóm story cùng epic hoặc cùng vùng code để bàn liền nhau.

## Bước 1: Từng story

1. **DoR:** áp R1–R11 như `github-issue-triage` (`.claude/skills/github-issue-triage/SKILL.md`, Bước 1).
   Thiếu gì thì viết sẵn câu chữ đề xuất; hỏi PO ngay trong phiên thay vì chờ.
2. **Có UI?** Story đổi giao diện cần brief UI (mục Design hoặc `## UI brief`). Chưa có: ghi việc cho
   Designer (`ui-design-brief`) và nhắc rằng story chưa thể vào sprint cho tới khi thiết kế được duyệt.
3. **Ước lượng** theo bảng (đề xuất, team chốt):

   | Size | Độ phức tạp nghiệp vụ | Độ mơ hồ | Công review/nghiệm thu |
   |---|---|---|---|
   | `size:s` | Một luồng, một app | Không | Đọc trong vài phút |
   | `size:m` | Vài luồng hoặc hai app | Thấp | Dưới một giờ |
   | `size:l` | Nhiều luồng, đổi contract | Có điểm cần hỏi | Vài giờ, có test manual/mobile |
   | `size:xl` | Nhiều app, nhiều quyết định | Cao | Nên **tách** trước khi vào sprint |

   Story point không còn phản ánh công code; đừng ước lượng theo số dòng code AI sẽ viết.
4. **Tách story:** `size:xl` hoặc AC trải nhiều app → đề xuất story con độc lập (mỗi story một PR review
   được, thứ tự contract → API → web/admin → mobile).
5. **Cờ `human-code`:** đề xuất cho story bảo mật, thanh toán, thuật toán phức tạp, hoặc dữ liệu nhạy
   cảm. Tech Lead quyết.
6. Hỏi PO/Tech Lead xác nhận size, cờ, và việc tách. Ghi đúng phán quyết.

## Bước 2: Ghi (sau khi đồng ý từng story)

```markdown
## Refinement notes

- Size: size:<x> — <lý do một dòng>
- human-code: <có/không — lý do>
- DoR: <đạt / thiếu R..., câu chữ đề xuất bên dưới>
- UI: <không đổi UI | cần brief UI (Designer) | đã có brief>
- Tách: <không | đề xuất #.., hoặc danh sách story con>
- Phán quyết: <PO/Tech Lead đã quyết gì>

---
Đã chạy: ...
Chỉ đọc: ...
Còn là claim: ...
```

- Đăng comment, gắn `size:*` và `human-code` (nếu có). Không đổi label `status:*`: triage tự động vẫn
  là bước chuyển trạng thái; nếu story đã sửa xong trong phiên, PO gắn lại `status:backlog` để triage chạy.
- Tạo story con chỉ khi PO đồng ý, qua `github-issue-create`.

## Bước 3: Tổng kết phiên

Bảng: story, size, cờ, sẵn sàng cho sprint (có/chưa và vì sao). Tổng size theo nhóm để `sprint-planning` dùng.

## Luật

- Không tự quyết size, cờ hay việc tách; người quyết.
- Không sửa body issue; đề xuất câu chữ trong comment.
