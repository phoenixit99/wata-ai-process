---
name: refutation-brief
description: "Chuẩn bị cho cổng G3 (Bước 7) của quy trình WATA. Với issue ở status:qa-passed, một session mới liệt kê từng claim của write-up/review/QA kèm bằng chứng, các đoạn diff rủi ro cao và những gì chưa được kiểm, đăng \"## Refutation brief\" để reviewer (con người) đọc nhanh và cố tìm điểm sai. AI chỉ chuẩn bị, không ký. Dùng khi \"chuẩn bị refutation\", \"tóm tắt PR cho reviewer\"."
---

# refutation-brief — chuẩn bị cổng G3

> **Vai trò:** Tech Lead · **Bước:** 7 · **Chế độ:** tự động + tương tác · **Kích hoạt:** label `status:qa-passed` (tự động) hoặc người gọi · **Đọc:** `## Build write-up`, `## Code review: PASS`, `## QA report: PASS` · **Ghi:** `## Refutation brief`

`$ARGUMENTS`: `<số issue> [--auto]`.

**Đọc `docs/agents/contract.md` trước.**

**Bước này là gì.** Cổng G3 là con người đọc với mục tiêu **tìm ra điểm sai**, không phải xác nhận
điểm đúng. Skill giúp người đó dùng 10–20 phút đúng chỗ: chỉ ra claim nào dựa trên bằng chứng nào,
chỗ nào rủi ro nhất, và điều gì chưa ai kiểm. **Skill không kết luận PASS/FAIL.**

Issue `risk:low` được bỏ G3 (`docs/agents/risk-tiers.md`): skill đăng một dòng ghi nhận và dừng.

## Bước 0: Ngữ cảnh (chỉ đọc)

1. Issue đủ theo contract mục 4: AC, test design, mọi build write-up, code review, QA report.
2. PR: diff ở commit cuối, `git diff --numstat`, CI trên commit cuối, approval hiện có.

## Bước 1: Soạn brief

1. **Bảng claim.** Mỗi câu khẳng định quan trọng trong write-up, review, QA report:
   claim · ai nói · bằng chứng (test, output, `file:line`) · trạng thái (đã kiểm / chỉ đọc / chưa kiểm).
   Kiểm lại ngẫu nhiên 2–3 claim tại commit cuối; ghi kết quả.
2. **Đoạn diff rủi ro cao** (tối đa 5), mỗi đoạn `file:line` và vì sao rủi ro: auth/phân quyền, tiền,
   migration/xoá dữ liệu, đổi contract, đồng thời, xử lý lỗi bị nuốt, cấu hình/giới hạn bị đổi.
3. **Chưa được kiểm:** test case không chạy được, môi trường không có, bản app cũ chưa thử.
4. **Câu hỏi gợi ý cho reviewer** (3–5 câu), ví dụ: "Nếu request này đến hai lần cùng lúc thì sao?"
5. **Lịch sử vòng:** số vòng review/QA, finding nào lặp lại.

```markdown
@<tech lead / reviewer G3>: brief cho cổng G3, ước tính <n> phút đọc.

## Refutation brief

| Claim | Nguồn | Bằng chứng | Trạng thái |
|---|---|---|---|

### Đọc kỹ những đoạn này
1. `<file:line>`: <vì sao>

### Chưa được kiểm
### Câu hỏi gợi ý
### Lịch sử vòng

---
Đã chạy: ...
Chỉ đọc: ...
Còn là claim: ...

Reviewer: nếu đồng ý, comment `## G3: OK` kèm điều đã kiểm; nếu tìm thấy vấn đề, gắn `status:in-progress`
kèm comment `## Code review: FAIL` ghi finding.
```

## Bước 2: Ghi

- Tương tác: cho xem, **chờ đồng ý**. `--auto`: ghi luôn.
- Đăng comment. **Không đổi label.** Issue ở `status:qa-passed` chờ G3 và G4.
- Issue `risk:high`: nhắc trong comment rằng người làm G3 phải khác người merge (G4).

## Luật

- Không viết "an toàn để merge", "đã đạt". Brief là bản đồ để người tìm lỗi, không phải kết luận.
- Không approve PR.
