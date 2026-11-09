# Coding standard — NestJS (api)

> **Bản khởi đầu.** Tech Lead của project copy về, chỉnh theo phiên bản và quy ước thực tế, rồi khai
> báo đường dẫn ở `apps[].standard` trong `.claude/project.yml`.

## Cấu trúc

- Mỗi tính năng một module: `src/modules/<feature>/{<feature>.module.ts, .controller.ts, .service.ts, dto/, entities/}`.
- **Controller chỉ xử lý HTTP** (nhận request, gọi service, trả response). Logic nghiệp vụ nằm ở service.
- Truy cập dữ liệu qua Prisma trong service hoặc repository; không gọi Prisma từ controller.

## DTO, validate, tài liệu

- Mọi input có DTO với `class-validator`; bật `ValidationPipe` toàn cục với `whitelist: true`,
  `forbidNonWhitelisted: true`.
- DTO có decorator Swagger (`@ApiProperty`); mọi endpoint có `@ApiOperation` và response type.
- Kiểu dùng chung với web/admin đặt trong contract chung (`packages/shared`), không định nghĩa hai nơi.

## Lỗi

- Lỗi chuẩn hoá qua exception filter chung: `{ statusCode, error, message, details? }`.
- Dùng exception của Nest (`NotFoundException`, `ForbiddenException`...) với mã HTTP đúng; không trả 200
  kèm `success: false`.
- Không lộ stack trace, câu SQL hay dữ liệu nội bộ ra response ở môi trường production.

## Tương thích ngược (bắt buộc)

- App mobile cũ vẫn gọi API mới trong nhiều tuần. **Không xoá, không đổi tên, không đổi kiểu** field
  trong response mà bản app cũ (theo `mobile.supported_app_versions`) còn dùng.
- Thêm field mới là an toàn. Thay đổi phá vỡ thì tách version endpoint (`/v2/...`) và giữ bản cũ.
- Field mới trong request phải có giá trị mặc định, vì app cũ không gửi.

## Dữ liệu và hiệu năng

- Danh sách luôn phân trang (`limit` có giới hạn trên, `cursor` hoặc `page`).
- Không truy vấn trong vòng lặp; dùng `include`/`select` hoặc truy vấn gộp.
- Migration Prisma: có thể chạy lại an toàn; không xoá cột đang được code cũ đọc trong cùng release.
- Thao tác nhiều bước ghi dữ liệu dùng transaction.

## Bảo mật

- Guard xác thực và phân quyền trên mọi endpoint không public; kiểm tra quyền sở hữu tài nguyên
  (người dùng A không đọc được dữ liệu của B bằng cách đổi id).
- Không log mật khẩu, token, dữ liệu cá nhân.
- Secret qua biến môi trường và config module; không hard-code.

## Test

- Unit test cho service (mock Prisma/phụ thuộc ngoài).
- Test e2e/integration cho endpoint quan trọng (status code, shape response, phân quyền).
- Bug: test tái hiện đỏ trước khi sửa.
