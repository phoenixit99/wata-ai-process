# Coding standard — Flutter (mobile)

> **Bản khởi đầu.** Tech Lead của project copy về, chỉnh theo phiên bản và quy ước thực tế, rồi khai
> báo đường dẫn ở `apps[].standard` trong `.claude/project.yml`.

## Cấu trúc

- Theo feature, ba lớp: `lib/features/<feature>/{data,domain,presentation}`.
  - `data`: gọi API, model JSON, repository implementation.
  - `domain`: entity, repository interface, use case (logic thuần, không import Flutter).
  - `presentation`: widget, màn hình, provider/notifier.
- Dùng chung thật sự mới đưa vào `lib/core/`.

## State: Riverpod

- State qua Riverpod (`Notifier`/`AsyncNotifier`); không `setState` cho state nghiệp vụ.
- Widget không gọi API trực tiếp; đi qua provider → repository.
- `AsyncValue` xử lý đủ **loading / lỗi / dữ liệu / rỗng** trên mọi màn hình có tải dữ liệu.

## Model và contract

- Model đồng bộ với contract của API (cùng tên field, kiểu). Dùng code generation (`freezed`,
  `json_serializable`) nếu project dùng.
- **Chịu được thay đổi của API:** field mới không làm crash (bỏ qua field lạ); field có thể thiếu
  phải nullable hoặc có mặc định. App đã phát hành không cập nhật được, nên parser phải khoan dung.
- Enum từ API có giá trị `unknown` cho giá trị chưa biết.

## Giao diện

- Màu, chữ, khoảng cách lấy từ `Theme`/design token; **không hard-code màu**.
- Văn bản hiển thị qua `intl`/l10n; không viết cứng chuỗi.
- Widget mà test cần tìm có `Key('<feature>-<phần tử>')`.
- Hỗ trợ cỡ chữ lớn của hệ thống và màn hình nhỏ; không cố định chiều cao chứa chữ.

## Chất lượng

- `flutter analyze` sạch với bộ lint chặt (`flutter_lints` hoặc `very_good_analysis`).
- Không `print`; dùng logger. Không để code chết, TODO không kèm số issue.
- `async` có xử lý lỗi; không để exception rơi ra khỏi UI.

## Test

- Unit test cho domain và repository (mock data source).
- Widget test cho màn hình có điều kiện hiển thị quan trọng.
- Phần chỉ kiểm được trên thiết bị (camera, push, quyền hệ thống) là test case `mobile` cho QA, ghi rõ
  trong bảng test case.
