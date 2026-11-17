---
name: figma-to-code
description: "Kỹ năng của quy trình WATA, dùng trong Bước 3 (code) và Bước 4 (đối chiếu thiết kế khi review). Lấy thiết kế từ link frame Figma qua Figma MCP (cấu trúc layout, màu sắc, font, ảnh chụp frame), chuyển thành code theo coding standard của từng app, rồi đối chiếu UI với frame. Được github-issue-implement gọi khi issue có link Figma; cũng dùng riêng khi \"code theo Figma\", \"so UI với thiết kế\"."
---

# figma-to-code — từ frame Figma ra code UI

> **Vai trò:** Designer, Developer · **Bước:** 3 · **Chế độ:** tương tác · **Kích hoạt:** người gọi · **Đọc:** — · **Ghi:** không ghi lên issue

`$ARGUMENTS`: `<link frame Figma> [số issue]`.

**Đọc `docs/agents/contract.md` và coding standard của app đích (`apps/<app>/CODING_STANDARD.md`)
trước.** Skill này không mở PR và không đổi label; phần đó thuộc `github-issue-implement`.

## Bước 1: Đọc thiết kế

- Qua Figma MCP: cấu trúc layout, màu sắc, font, khoảng cách, ảnh chụp frame. Không có quyền truy cập
  → báo và dừng, không đoán thiết kế.
- Liệt kê điều thiết kế không nói (trạng thái lỗi/rỗng/loading, text dài). Đó là câu hỏi cho Designer.

## Bước 2: Chuyển thành code theo chuẩn từng app

- Tái sử dụng component, token màu và theme có sẵn trước khi tạo mới. Không hard-code màu (web:
  Tailwind; Flutter: `Theme`).
- Theo coding standard của app: cấu trúc theo feature, đủ trạng thái loading/lỗi/rỗng, `data-testid`
  cho automation.

## Bước 3: Đối chiếu UI

- Chạy app, chụp màn hình (web: Playwright MCP), so với frame: bố cục, khoảng cách, màu, chữ.
- Ghi lệch còn lại và lý do. Không chạy được app → nói rõ "chưa đối chiếu bằng ảnh".

## Kết quả

Đưa cho skill gọi (hoặc người chạy): danh sách file, component tái sử dụng, lệch so với Figma, câu hỏi
cho Designer. Nội dung này đi vào comment `## Implementation` của issue.

## Luật

- Không đoán thiết kế khi không mở được Figma.
- Không mở PR, không đổi label.
