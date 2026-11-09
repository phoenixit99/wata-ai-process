---
name: figma-to-code
description: "Kỹ năng hỗ trợ trong Bước 4 của quy trình WATA. Lấy thiết kế từ link frame Figma qua Figma MCP (layout, màu, font, khoảng cách, ảnh frame), map sang component và theme có sẵn của app theo coding standard, code UI, rồi đối chiếu ảnh chụp với frame. Được github-issue-implement gọi khi issue có link Figma; cũng dùng riêng khi \"code theo Figma\", \"so UI với thiết kế\"."
---

# figma-to-code — từ frame Figma ra UI

> **Vai trò:** Dev · **Bước:** 4 · **Chế độ:** tương tác · **Kích hoạt:** người gọi · **Đọc:** — · **Ghi:** không ghi lên issue

`$ARGUMENTS`: `<link frame Figma> [số issue]`.

**Đọc `docs/agents/contract.md` và coding standard của app đích trước.** Skill này ghi code chỉ khi
được `github-issue-implement` gọi (hoặc người chạy đồng ý); bản thân nó không mở PR.

## Bước 1: Đọc thiết kế

- Qua Figma MCP: cấu trúc layout, auto-layout/khoảng cách, màu, typography, trạng thái (hover, lỗi,
  rỗng, loading), ảnh chụp frame. Không có quyền truy cập → báo và dừng, không đoán từ mô tả.
- Liệt kê điều thiết kế không nói: trạng thái lỗi/rỗng/loading, responsive, text dài, quyền khác nhau.
  Đó là câu hỏi cho Designer, không tự bịa.

## Bước 2: Map sang code có sẵn

- **Tái sử dụng trước:** tìm component, token màu/spacing, theme hiện có (`file:line`). Không tạo style
  mới khi đã có tương đương; không hard-code màu/cỡ chữ (web: token Tailwind; Flutter: `Theme`).
- Khác biệt nhỏ giữa Figma và token có sẵn (lệch vài px, màu gần giống): dùng token có sẵn, ghi chú
  để Designer xác nhận.
- Component mới chỉ khi thật sự chưa có; đặt đúng chỗ theo cấu trúc feature của app.

## Bước 3: Code

- Theo coding standard; đủ trạng thái loading/lỗi/rỗng; `data-testid` cho phần tử test case `auto` cần.
- Văn bản hiển thị qua cơ chế i18n của app nếu có.

## Bước 4: Đối chiếu

- Chạy app (web: localhost + Playwright MCP chụp màn hình; mobile: simulator/emulator nếu có).
- So ảnh chụp với frame: bố cục, khoảng cách, màu, chữ, trạng thái. Ghi lệch còn lại và lý do.
- Không chạy được app → nói rõ "chưa đối chiếu bằng ảnh", ghi vào write-up.

## Kết quả

Đưa cho skill gọi (hoặc người chạy): danh sách file, component tái sử dụng, lệch so với Figma và câu
hỏi cho Designer. Mục này đi vào `## Build write-up` của issue.

## Luật

- Không đoán thiết kế khi không mở được Figma; báo và dừng.
- Tái sử dụng component và token có sẵn trước khi tạo mới; không hard-code màu/cỡ chữ.
- Không mở PR, không đổi label: phần đó thuộc `github-issue-implement`.
