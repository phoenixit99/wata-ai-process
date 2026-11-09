---
layout: home

hero:
  name: Quy trình phát triển dự án với AI Agent
  text: Từ issue đến UAT, AI làm việc lặp lại, con người ra quyết định
  tagline: WATA Software · Áp dụng cho mọi project · Phiên bản 1.3
  actions:
    - theme: brand
      text: Đọc quy trình
      link: /process
    - theme: alt
      text: Tôi là... (hướng dẫn theo vai trò)
      link: /roles/po
    - theme: alt
      text: Danh mục skill
      link: /skills

features:
  - title: 5 cổng con người
    details: PO xác nhận yêu cầu (G1), Tech Lead và QA duyệt plan (G2), reviewer phản biện (G3), Tech Lead merge (G4), PO nghiệm thu (G5). AI không bao giờ tự qua cổng.
  - title: 20 skill, mọi vai trò
    details: Mỗi bước và mỗi vai trò có skill riêng, gọi trong Claude Code hoặc bằng @claude trên GitHub. Một catalog duy nhất giữ mọi thứ đồng bộ.
  - title: Label là nguồn sự thật
    details: Mỗi issue đúng một label status:*. Nhìn label là biết việc đang ở đâu, ai đang xử lý, và bước tự động nào sẽ chạy tiếp.
  - title: Test trước, code sau
    details: Test case được thiết kế từ Acceptance Criteria trước khi có code. Review chạy ở session riêng để AI không tự đồng ý với chính mình.
  - title: Guardrail phía server
    details: Branch protection, CODEOWNERS, required checks và workflow guard. Lời dặn trong prompt chỉ là lớp dự phòng.
  - title: Báo cáo trung thực
    details: Mọi báo cáo của AI tách rõ điều đã chạy, điều chỉ đọc, và điều còn là claim. Không báo kết quả không tận mắt thấy.
---

## Bắt đầu theo vai trò

| Bạn là | Đọc trước | Skill chính |
|---|---|---|
| PO | [Hướng dẫn PO](/roles/po), [Viết AC](/writing-acceptance-criteria) | `github-issue-create`, `uat-run` |
| BA | [Hướng dẫn BA](/roles/ba) | `feature-analysis`, `github-issue-create` |
| PM | [Hướng dẫn PM](/roles/pm), [RACI](/raci) | `status-report`, `release-plan` |
| Designer | [Hướng dẫn Designer](/roles/designer) | `design-review` |
| Developer | [Hướng dẫn Dev](/roles/dev) | `github-issue-implement`, `qa-failed-fix` |
| Tech Lead | [Hướng dẫn Tech Lead](/roles/tech-lead), [Cài đặt](/setup-guide) | `plan-approval`, `merge-readiness`, `hotfix` |
| QA | [Hướng dẫn QA](/roles/qa) | `plan-approval`, `qa-manual-session` |

Mọi vai trò đều dùng được `dev-pipeline` để xem việc của mình hôm nay.
