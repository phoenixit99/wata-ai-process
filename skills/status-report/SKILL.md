---
name: status-report
description: Báo cáo tiến độ cho PM theo quy trình WATA. Tổng hợp từ label status:*, timeline và comment heading: issue theo trạng thái, issue kẹt và quá SLA, thời gian chờ con người, lead time, tỉ lệ fail-to-dev, đạt review vòng 1, needs-human, UAT rejected, rủi ro. Xuất bản nội bộ và bản gửi khách hàng. Dùng khi "báo cáo tuần", "status report", "tiến độ dự án".
---

# status-report — báo cáo cho PM

> **Vai trò:** PM · **Bước:** - · **Chế độ:** tương tác · **Kích hoạt:** người gọi · **Đọc:** — · **Ghi:** không ghi lên issue

`$ARGUMENTS`: `[số ngày, mặc định 7] [--client]`. `--client`: bản gửi khách hàng (ít chi tiết nội bộ).

**Đọc `docs/agents/contract.md` (mục 1, 2) và `docs/agents/process.md` mục 11 (chỉ số).** Skill chỉ đọc;
kết quả đưa cho PM, không tự đăng.

## Bước 1: Thu thập (chỉ đọc)

```bash
gh issue list --state all --limit 500 --search "updated:>=<ngày bắt đầu>" \
  --json number,title,labels,state,createdAt,closedAt,assignees
gh api repos/{owner}/{repo}/issues/<n>/timeline --paginate   # thời điểm từng label status:*
gh api repos/{owner}/{repo}/issues/<n>/comments --paginate   # heading kết quả từng bước
```
Đọc `sla_hours` và `limits` trong `.claude/project.yml`.

## Bước 2: Tính

| Chỉ số | Cách tính |
|---|---|
| Đang mở theo trạng thái | Đếm theo label `status:*` |
| Hoàn thành trong kỳ | Issue nhận `status:done` trong kỳ |
| Lead time | `ready-to-dev` → `qa-passed`, trung vị và lớn nhất |
| Thời gian chờ con người | Tổng giờ ở `fail-to-dev`, `test-design` sau `## Test design: PASS`, `needs-human`, `qa-passed`, `uat` |
| Quá SLA | Issue đang ở hàng chờ con người lâu hơn `sla_hours` |
| Tỉ lệ fail-to-dev | `## Triage: FAIL` / tổng triage |
| Đạt review vòng 1 | Issue có `## Code review: PASS` mà không có FAIL trước đó |
| Needs human | Số lần và lý do (tóm tắt từ comment `## Needs human`) |
| UAT rejected | `## UAT: REJECTED` / tổng UAT |

Ghi rõ chỉ số nào không tính được và vì sao (thiếu dữ liệu, quá ít mẫu). **Không ước lượng thay số đo.**

## Bước 3: Soạn

```markdown
# Báo cáo tiến độ <project> — <từ ngày> đến <đến ngày>

## Tóm tắt
<3 dòng: hoàn thành gì, kẹt ở đâu, rủi ro chính>

## Hoàn thành
| # | Tiêu đề | Hoàn thành |
## Đang làm
<bảng theo trạng thái>
## Kẹt và quá SLA
| # | Trạng thái | Bao lâu | Cần ai | Việc cần làm |
## Chỉ số
<bảng chỉ số, so với kỳ trước nếu có>
## Rủi ro và đề xuất
<mỗi rủi ro: ảnh hưởng, đề xuất, người quyết>

---
Nguồn: GitHub issues/timeline đến <thời điểm>. Không tính được: <...>
```

Bản `--client`: bỏ chỉ số nội bộ của AI (vòng sửa, needs-human), giữ hoàn thành, đang làm, rủi ro
ảnh hưởng tiến độ, việc cần khách hàng quyết định.

## Bước 4: Giao

Đưa báo cáo cho PM trong chat hoặc lưu file (`reports/<yyyy-mm-dd>.md` khi PM đồng ý). Không đăng
lên issue, không gửi ra ngoài.

## Luật

- Chỉ đọc. Không đăng lên issue, không đổi label, không gửi báo cáo ra ngoài.
- Không ước lượng thay số đo; chỉ số không tính được thì ghi rõ lý do.
