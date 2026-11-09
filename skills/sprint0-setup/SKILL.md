---
name: sprint0-setup
description: "Sprint 0 của quy trình Scrum WATA (một lần mỗi dự án). Kiểm tra repo đã sẵn sàng để AI làm việc đúng chuẩn chưa: bộ quy trình đã cài, project.yml, coding standard, design system, label, branch protection, CODEOWNERS, GitHub App và secret, MCP, quyền truy cập, chính sách dữ liệu. Báo cáo theo checklist kèm người phụ trách từng mục. Chỉ đọc. Dùng khi \"Sprint 0\", \"dự án đã sẵn sàng chưa\", \"kiểm tra setup\"."
---

# sprint0-setup — kiểm tra Sprint 0

> **Vai trò:** Tech Lead, PM, AI Enablement, Security · **Bước:** sprint-0 · **Chế độ:** tương tác · **Kích hoạt:** người gọi · **Đọc:** — · **Ghi:** không ghi lên issue

`$ARGUMENTS`: trống (repo hiện tại) hoặc `<owner>/<repo>`.

**Đọc `docs/agents/contract.md`, `docs/agents/sprint-0.md` và `docs/agents/setup-guide.md` trước.**
Skill chỉ đọc; nó cho biết mục nào còn thiếu và ai lo, không tự sửa cấu hình (contract mục 8).

## Bước 1: Kiểm tra (chỉ đọc)

| # | Mục | Cách kiểm | Người ký |
|---|---|---|---|
| S1 | Bộ quy trình đã cài, đúng phiên bản | `docs/agents/VERSION` khớp `process_version` trong `.claude/project.yml` | Tech Lead |
| S2 | `project.yml` đã điền | Không còn `<owner>`, `<repo>`; `people` có người cho mọi vai trò; lệnh build có thật | Tech Lead, PM |
| S3 | Lệnh lint/typecheck/test/build chạy được | Chạy thử từng lệnh trong `apps[].commands` (chỉ khi người chạy đồng ý; có thể lâu) | Tech Lead |
| S4 | Coding standard cho từng app | File ở `apps[].standard` tồn tại và đã được chỉnh (không còn dòng "Bản khởi đầu" nguyên văn) | Tech Lead |
| S5 | Design system AI đọc được | File `design_system` tồn tại, có màu, font, khoảng cách, component, quy tắc layout, nguyên tắc UX; không còn phần mẫu | Designer |
| S6 | `CLAUDE.md` đã điền | Không còn placeholder `<TÊN PROJECT>`, bảng app có lệnh chạy local | Tech Lead |
| S7 | Label | `gh label list` có đủ label trong `.github/labels.yml` và `app:*` | PM |
| S8 | Branch protection trên `main` | `gh api repos/{owner}/{repo}/branches/main/protection`: bắt buộc PR, CODEOWNERS, required checks, cấm force-push | Tech Lead, Security |
| S9 | CODEOWNERS | Không còn `@<org>/...` | Tech Lead |
| S10 | GitHub App và secret | Biến `WATA_APP_ID`, secret `WATA_APP_PRIVATE_KEY`, `ANTHROPIC_API_KEY` tồn tại (chỉ kiểm tên, `gh secret list`, `gh variable list`); app không nằm trong danh sách bypass | Security |
| S11 | Workflow | `.github/workflows/wata-*.yml` có mặt; bước toolchain `TODO(project)` đã được thay | Tech Lead |
| S12 | MCP | `.mcp.json` có GitHub, Figma, Playwright; người chạy có `GITHUB_MCP_TOKEN` | AI Enablement |
| S13 | Chính sách dữ liệu | Hợp đồng cho phép dùng AI; không đưa dữ liệu thật của khách vào prompt (hỏi PM/Security, ghi câu trả lời) | Security, PM |
| S14 | Definition of Ready/Done | Team đã đọc và đồng ý `docs/agents/definition-of-done.md` và DoR R1–R11 | PM |
| S15 | Số liệu nền | PM đã ghi lead time và lỗi sau release của 1–2 sprint gần nhất | PM |

Không đọc giá trị secret. Mục không kiểm được bằng lệnh (S13, S14, S15): hỏi người chạy, ghi đúng câu trả lời.

## Bước 2: Báo cáo

```markdown
# Sprint 0 — <repo> — <ngày>

| # | Mục | Kết quả | Còn thiếu | Ai lo |
|---|---|---|---|---|

**Sẵn sàng cho sprint 1:** <có | chưa — còn N mục>

---
Đã chạy: ...
Chỉ đọc: ...
Còn là claim: ...
```

Đưa cho người chạy; lưu `docs/sprint0-report.md` khi được đồng ý. Không đăng lên issue.

## Luật

- Chỉ đọc. Không sửa branch protection, secret, workflow, CODEOWNERS (contract mục 8).
- Không in giá trị secret, token.
- Cổng của Sprint 0 là con người: Tech Lead và Security ký bộ chuẩn và quyền truy cập, Designer ký
  design system. Skill chỉ báo cáo.
