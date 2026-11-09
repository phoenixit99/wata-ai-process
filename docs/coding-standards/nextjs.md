# Coding standard — Next.js (web, admin)

> **Bản khởi đầu.** Tech Lead của project copy về, chỉnh theo phiên bản và quy ước thực tế, rồi khai
> báo đường dẫn ở `apps[].standard` trong `.claude/project.yml`. AI đọc file này trước khi code và
> dùng nó khi review.

## Cấu trúc

- Theo feature: `src/features/<feature>/{components,hooks,api,types}`; `src/app/` chỉ chứa route,
  layout, và ghép component.
- Component dùng chung thật sự mới đưa vào `src/components/`. Không tạo bản sao của component đã có.

## Server và Client Component

- Mặc định **Server Component**. Chỉ thêm `"use client"` khi cần state, effect, event handler,
  hoặc API trình duyệt; đặt ranh giới client càng sâu càng tốt.
- Lấy dữ liệu ở server khi có thể; không fetch trong `useEffect` nếu server làm được.
- Không đưa secret hay biến môi trường không có tiền tố public xuống client.

## Gọi API

- Mọi lời gọi API qua **một client có kiểu** (`src/lib/api-client.ts` hoặc tương đương) dùng kiểu từ
  contract chung (`@<project>/shared`). Không `fetch` rải rác với URL viết tay.
- Mỗi lời gọi xử lý đủ **loading / lỗi / rỗng**. Lỗi hiển thị thông báo người dùng hiểu được; không
  nuốt lỗi im lặng.
- Danh sách có phân trang; không tải toàn bộ.

## Giao diện

- Tailwind theo token của design system; không hard-code màu/cỡ chữ ngoài token.
- Văn bản hiển thị qua i18n nếu project dùng.
- Phần tử mà test e2e cần tương tác có `data-testid="<feature>-<phần tử>"`.
- Truy cập được: nút là `<button>`, ảnh có `alt`, form có `label`.

## Kiểu và chất lượng

- TypeScript `strict`; không `any` (dùng `unknown` rồi thu hẹp). Không `// @ts-ignore` không lý do.
- Form validate bằng schema (ví dụ zod) dùng chung với kiểu.
- Không để `console.log`, code chết, TODO không kèm số issue.

## Test

- Logic thuần (hook, util, mapper): unit test.
- Component có điều kiện hiển thị quan trọng: test với Testing Library (theo role/label, không theo class).
- Luồng người dùng: Playwright trong `e2e/`, tên test bắt đầu bằng mã test case.
