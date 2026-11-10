---
layout: home

hero:
  name: Quy trình phát triển dự án với AI Agent
  text: Từ issue đến UAT, AI làm việc lặp lại, con người ra quyết định
  tagline: WATA Software · Áp dụng cho mọi project · Phiên bản 1.5
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
    - theme: alt
      text: Quy trình Scrum
      link: /scrum

  image:
    src: /wata-logo.png
    alt: WATA Software

features:
  - title: Scrum ứng dụng AI
    details: Sprint 10 bước, sự kiện và timebox mới, lập kế hoạch theo năng lực review/QA, effort dịch chuyển từ thực thi sang yêu cầu, quyết định và nghiệm thu.
  - title: 5 cổng con người
    details: PO xác nhận yêu cầu (G1), Tech Lead và QA duyệt plan (G2), reviewer phản biện (G3), Tech Lead merge (G4), PO nghiệm thu (G5). AI không bao giờ tự qua cổng.
  - title: 13 skill, ba lệnh cần nhớ
    details: Dev gọi /dev-pipeline, PM gọi /sprint, các vai trò khác comment @claude trên GitHub; AI tự chọn đúng skill theo trạng thái issue. Một catalog duy nhất giữ mọi thứ đồng bộ.
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
| PO | [Hướng dẫn PO](/roles/po), [Viết AC](/writing-acceptance-criteria) | `issue-create`, `uat --run` |
| BA | [Hướng dẫn BA](/roles/ba) | `refine`, `issue-create` |
| PM | [Hướng dẫn PM](/roles/pm), [RACI](/raci) | `sprint report`, `sprint release` |
| Designer | [Hướng dẫn Designer](/roles/designer) | `design-brief`, `pr-review --design` |
| Developer | [Hướng dẫn Dev](/roles/dev) | `implement`, `implement --fix` |
| Tech Lead | [Hướng dẫn Tech Lead](/roles/tech-lead), [Cài đặt](/setup-guide) | `test-design --approve`, `merge-gate --merge`, `hotfix` |
| QA | [Hướng dẫn QA](/roles/qa) | `test-design --approve`, `qa --manual` |
| AI Enablement | [Hướng dẫn AI Enablement](/roles/ai-enablement) | `sprint retro`, [`--check`](/setup-guide) |
| Security | [Hướng dẫn Security](/roles/security) | `merge-gate`, [`--check`](/setup-guide) |

Mọi vai trò đều dùng được `dev-pipeline` để xem việc của mình hôm nay.
