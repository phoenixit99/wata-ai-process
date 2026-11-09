# Design system — <TÊN PROJECT>

> Designer điền ở Sprint 0. Đây là **đầu vào bắt buộc** để AI soạn brief UI, tạo/tinh chỉnh Figma và code giao
> diện (`design-brief`, `implement --figma`, `pr-review --design`). Viết cụ thể để máy đọc được: giá trị, tên token,
> quy tắc. Quản lý phiên bản như code.

Phiên bản: 0.1 · Figma library: <link> · Người duyệt: <Designer>

## 1. Màu

| Token | Giá trị | Dùng cho |
|---|---|---|
| `color.primary` | `#______` | Nút chính, link |
| `color.danger` | `#______` | Lỗi, xoá |
| `color.text` | `#______` | Chữ chính |
| `color.surface` | `#______` | Nền thẻ |

Độ tương phản tối thiểu: 4.5:1 cho chữ thường.

## 2. Chữ

| Token | Font | Cỡ / dòng | Đậm | Dùng cho |
|---|---|---|---|---|
| `text.h1` | | | | |
| `text.body` | | | | |

## 3. Khoảng cách và lưới

Bước khoảng cách: 4 / 8 / 12 / 16 / 24 / 32. Lưới: <số cột, gutter>. Breakpoint: <...>.

## 4. Component

| Component | Biến thể | Trạng thái bắt buộc | Code (web / mobile) |
|---|---|---|---|
| Button | primary, secondary, danger | default, hover, disabled, loading | `<path>` / `<path>` |
| Input | | default, focus, error, disabled | |
| Empty state | | | |

## 5. Quy tắc layout

- <ví dụ: form một cột trên mobile, hai cột từ 1024px>
- <ví dụ: hành động chính ở góc phải dưới của form>

## 6. Nguyên tắc UX

- Mọi màn hình tải dữ liệu có đủ trạng thái: đang tải, lỗi (kèm thử lại), rỗng.
- Thông báo lỗi nói điều người dùng cần làm.
- <nguyên tắc riêng của sản phẩm>

## 7. Tài sản và bản quyền

Chỉ dùng ảnh, icon, font từ: <thư viện đã được cấp phép>. Ghi nguồn ở đây.
