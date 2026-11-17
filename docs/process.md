# Quy trình phát triển dự án sử dụng AI Agent

Từ GitHub Issue đến Pull Request, Code Review, QA và Automation Test

Phiên bản: 1.0 · Ngày tạo: 16-10-2026 · WATA Software · Tài liệu nội bộ

---

## 1. Tóm tắt

Tài liệu này mô tả quy trình phát triển phần mềm chuẩn áp dụng cho các project của công ty: toàn bộ
source code của một project (web, admin, API, mobile) nằm trong một repository duy nhất, và AI Agent
(Claude) đảm nhận phần lớn công việc lặp lại, từ kiểm tra chất lượng yêu cầu, viết code, review, đến
viết test case và chạy automation test.

Con người giữ vai trò ra quyết định: viết yêu cầu (issue), xác nhận phạm vi, và merge code vào nhánh
chính. Mọi bước đều để lại dấu vết trên GitHub (label, comment, PR) nên dễ theo dõi và kiểm soát.

| Hạng mục | Nội dung |
|---|---|
| Mục tiêu | Rút ngắn thời gian từ yêu cầu đến tính năng chạy được; chuẩn hoá chất lượng code và test. |
| Phạm vi | Áp dụng cho mọi project; cấu trúc tham chiếu gồm 4 ứng dụng: web (Next.js), admin (Next.js), api (NestJS), mobile (Flutter). |
| Công cụ chính | GitHub (Issue, PR, Actions), Claude Code + Skills, MCP: GitHub, Figma, Playwright. |
| Kiểm soát | Label trạng thái bắt buộc, Definition of Ready, CI tự động, merge chỉ do con người. |

## 2. Kiến trúc Monorepo của project

Mỗi project được tổ chức theo cấu trúc monorepo chuẩn dưới đây; tên thư mục và công nghệ có thể điều
chỉnh theo từng project. Tất cả ứng dụng nằm chung một repository. Nhờ vậy AI Agent nhìn thấy toàn bộ
hệ thống trong một lần, sửa được một tính năng xuyên suốt nhiều app trong cùng một Pull Request, và các
app dùng chung một bộ kiểu dữ liệu (contract).

```
<project>/
├── apps/
│   ├── web/        Next.js – ứng dụng người dùng
│   ├── admin/      Next.js – trang quản trị
│   ├── api/        NestJS  – backend REST API (Prisma)
│   └── mobile/     Flutter – ứng dụng di động
├── packages/shared/    Kiểu dữ liệu dùng chung (@<project>/shared)
├── e2e/                Playwright automation + test case
├── .claude/skills/     Kỹ năng (skill) cho AI Agent
├── .mcp.json           Kết nối MCP: GitHub, Figma, Playwright
├── .github/            Issue/PR template, CI workflow
└── CLAUDE.md           Hướng dẫn chung cho AI Agent
```

| Thành phần | Công nghệ | Vai trò |
|---|---|---|
| apps/web | Next.js 15, React 19, Tailwind | Giao diện cho người dùng cuối |
| apps/admin | Next.js 15, Tailwind | Quản trị, thống kê, vận hành |
| apps/api | NestJS 10, Prisma | REST API, nghiệp vụ, dữ liệu; tài liệu Swagger |
| apps/mobile | Flutter 3, Riverpod | Ứng dụng iOS/Android |
| packages/shared | TypeScript | Contract dùng chung giữa api, web và admin |
| e2e | Playwright | Test tự động API, web, admin |

::: tip Lợi ích chính
Một nơi duy nhất cho code, coding standard, CI và tài liệu. AI Agent có đủ ngữ cảnh để làm việc chính
xác, không phải chuyển qua lại giữa nhiều repository.
:::

## 3. Công cụ và tích hợp

### 3.1 MCP (Model Context Protocol)

MCP là chuẩn kết nối để AI Agent làm việc trực tiếp với các hệ thống bên ngoài. Dự án cấu hình sẵn 3 kết
nối trong file `.mcp.json`:

| Kết nối | AI Agent làm được gì | Xác thực |
|---|---|---|
| GitHub | Đọc/tạo issue, đổi label, comment, tạo branch, mở PR, review có comment theo từng dòng | Personal Access Token (fine-grained, giới hạn trong repo) |
| Figma | Đọc thiết kế: cấu trúc layout, màu sắc, font, ảnh chụp frame để code và đối chiếu UI | Đăng nhập OAuth Figma, hoặc Figma Desktop (Dev Mode) |
| Playwright | Mở trình duyệt, khám phá giao diện, chụp màn hình phục vụ viết test | Không cần |

### 3.2 Skills (kỹ năng của AI Agent)

Mỗi skill là một bản hướng dẫn chuẩn để AI Agent làm một việc giống nhau mỗi lần, theo đúng quy định của
team. Skill được quản lý như code: có review và lịch sử thay đổi.

| Skill | Chức năng |
|---|---|
| `github-issue-create` | Tạo issue đúng mẫu (Description, Acceptance Criteria, Design), vào Backlog |
| `github-issue-triage` | Kiểm tra issue được giao theo Definition of Ready → Ready to dev hoặc Fail to dev |
| `github-issue-implement` | Tạo branch, code theo coding standard, viết unit test, mở Pull Request |
| `github-pr-review` | Review PR theo Acceptance Criteria và coding standard, comment trên từng dòng |
| `qa-test-cases` | Sinh test case (positive, negative, biên, trạng thái) từ Acceptance Criteria |
| `e2e-playwright` | Viết và chạy automation test, phân loại lỗi, báo cáo kết quả lên PR |
| `figma-to-code` | Lấy thiết kế từ Figma, chuyển thành code theo chuẩn từng app, đối chiếu UI |
| `dev-pipeline` | Chạy toàn bộ luồng trên cho các issue được giao |
| `nextjs` / `nestjs` / `flutter-coding-standard` | Coding standard riêng cho từng công nghệ, đặt trong thư mục của mỗi app |

## 4. Luồng trạng thái công việc

Mỗi issue luôn có đúng một label trạng thái. Label là nguồn sự thật duy nhất: nhìn label là biết công
việc đang ở đâu, ai (người hay AI) đang xử lý.

| Trạng thái | Ý nghĩa | Ai chuyển sang |
|---|---|---|
| Backlog | Issue mới tạo, chưa kiểm tra | PO / AI (skill tạo issue), GitHub Action |
| Fail to dev | Thiếu mô tả hoặc tiêu chí nghiệm thu; comment ghi rõ phần thiếu | AI (triage) |
| Ready to dev | Đạt Definition of Ready, sẵn sàng code | AI (triage) |
| In progress | Đang code trên branch riêng | AI (implement) |
| In review | Đã mở Pull Request, đang review | AI (implement) |
| QA | Review đạt; đang viết test case và chạy automation | AI (review) |
| QA passed | Toàn bộ automation test đạt, chờ con người merge | AI (automation) |
| QA failed | Còn lỗi sản phẩm sau 3 vòng tự sửa, cần người xử lý | AI (automation) |

```
   ┌─────────────┐  Thiếu thông tin   ┌───────────┐
   │ Fail to dev │◄───────────────────┤  Backlog  │
   │             ├───────────────────►│           │
   └─────────────┘     PO bổ sung     └─────┬─────┘
                                            │ Triage đạt
                                            ▼
                        ┌──────────────┐◄───┘
                        │ Ready to dev │
                        └──────┬───────┘
                               │ AI code
                               ▼
                        ┌──────────────┐
                        │ In progress  │◄──┐
                        └──────┬───────┘   │
                               │ Mở PR     │ Request changes
                               ▼           │
                        ┌──────────────┐   │
                        │  In review   ├───┘
                        └──────┬───────┘
                               │ Review đạt
                               ▼
                        ┌──────────────┐
                        │      QA      │
                        └──┬────────┬──┘
           Automation xanh │        │ Lỗi sau 3 vòng
                           ▼        ▼
                  ┌───────────┐  ┌───────────┐
                  │ QA passed │  │ QA failed │
                  └─────┬─────┘  └───────────┘
                        ▼
                ┌────────────────┐
                │     Merge      │
                │  (con người)   │
                └────────────────┘
```

*Hình 1. Vòng đời của một issue*

## 5. Definition of Ready: điều kiện để bắt đầu code

Yêu cầu không rõ là nguyên nhân phổ biến nhất gây làm lại. Vì vậy AI chỉ code khi issue đạt đủ các điều
kiện dưới đây; nếu không, issue chuyển sang Fail to dev kèm danh sách phần còn thiếu và gợi ý cách viết
lại.

| # | Điều kiện | Bắt buộc |
|---|---|---|
| R1 | Có người được assign | Có |
| R2 | Tiêu đề cụ thể, nói rõ thay đổi gì | Có |
| R3 | Có mục Description giải thích vấn đề và lý do (khuyến khích dạng user story) | Có |
| R4 | Có mục Acceptance Criteria với ít nhất 1 tiêu chí | Có |
| R5 | Mỗi tiêu chí kiểm thử được: có hành động và kết quả quan sát được (không dùng từ mơ hồ như "nhanh", "đẹp") | Có |
| R6 | Xác định được app bị ảnh hưởng (web / admin / api / mobile) | Có |
| R7 | Không còn TBD, "???" hoặc phần mẫu chưa điền | Có |
| R8 | Không bị chặn bởi issue khác chưa xong | Có |
| R9 | Với bug: có bước tái hiện, kết quả mong đợi và kết quả thực tế | Có (bug) |
| R10 | Thay đổi API mô tả request/response; thay đổi UI có link frame Figma | Khuyến nghị |

::: tip Ví dụ
"Người dùng quản lý được đơn hàng" → không đạt (không kiểm thử được). "Khi người dùng bấm Xoá, đơn hàng
biến mất khỏi danh sách và API không còn trả về đơn hàng đó" → đạt.
:::

## 6. Chi tiết từng bước

### Bước 1: Tạo issue

- PO hoặc thành viên mô tả yêu cầu bằng ngôn ngữ tự nhiên; AI soạn issue theo mẫu chuẩn gồm
  Description, Acceptance Criteria, Affected apps, Design (link Figma), Technical notes.
- Issue tự động nhận label Backlog, loại công việc (feature/bug/chore) và app liên quan.
- Những điểm AI phải giả định được đánh dấu rõ để PO xác nhận.

### Bước 2: Triage (kiểm tra issue)

- AI lấy các issue được assign, đối chiếu với 10 điều kiện Definition of Ready.
- Kết quả được ghi bằng comment dạng bảng trên issue; label chuyển sang Ready to dev hoặc Fail to dev.
- Issue Fail to dev được kiểm tra lại tự động sau khi người viết cập nhật.

### Bước 3: Code và mở Pull Request

- AI chuyển issue sang In progress, tạo branch theo quy ước (ví dụ `feat/42-due-date`).
- Lập bảng đối chiếu Acceptance Criteria → thay đổi code → test trước khi code.
- Đọc coding standard của từng app bị ảnh hưởng; nếu có link Figma thì lấy thiết kế qua Figma MCP.
- Code theo thứ tự: contract dùng chung → API → web/admin → mobile; viết unit test.
- Bắt buộc qua lint, kiểm tra kiểu, unit test và build trước khi mở PR. PR liên kết issue (`Closes #số`),
  issue chuyển sang In review.

### Bước 4: Code review

AI review PR theo checklist 8 tiêu chí và phân loại phát hiện thành Blocker / Major / Minor:

| Tiêu chí | Nội dung kiểm tra |
|---|---|
| Acceptance Criteria | Mọi tiêu chí được hiện thực; không làm ngoài phạm vi |
| Tính đúng | Trường hợp biên, xử lý lỗi, mã trạng thái HTTP |
| Coding standard | Cấu trúc, đặt tên, kiểu dữ liệu, không còn code thừa |
| Contract | Kiểu dữ liệu dùng chung đồng bộ giữa API, web, admin, mobile |
| Bảo mật | Validate input, không lộ secret, không có lỗ hổng injection |
| Test | Có unit test cho logic mới; có test id cho automation |
| Hiệu năng | Không truy vấn thừa, có phân trang |
| Thiết kế | Giao diện khớp với frame Figma |

- Có Blocker/Major → AI tự sửa và review lại (tối đa 3 vòng). Đạt → issue chuyển sang QA.

### Bước 5: Viết test case

- Từ mỗi Acceptance Criteria, AI sinh test case: luồng chính, dữ liệu sai, giá trị biên, chuyển trạng
  thái, đồng bộ giữa các app.
- Mỗi test case có mã (TC-số issue-số thứ tự), độ ưu tiên P1–P3 và đánh dấu tự động hoá hay kiểm
  thủ công.
- Bảng test case được lưu trong repository và tóm tắt trên issue, nên QA của team review được.

### Bước 6: Automation test với Playwright

- AI viết test Playwright cho các test case tự động hoá được; tên test bắt đầu bằng mã test case nên lỗi
  truy ngược được tới Acceptance Criteria.
- Khi test lỗi, AI phân loại: lỗi do test, lỗi sản phẩm, hay lỗi môi trường; rồi sửa đúng chỗ (tối đa 3
  vòng).
- Kết quả (đạt / lỗi / kiểm thủ công) được báo cáo bằng bảng trên PR. Toàn bộ đạt → QA passed; còn
  lỗi → QA failed kèm nguyên nhân.

### Bước 7: Merge (con người)

- Tech Lead / Reviewer xem PR, kết quả review của AI và báo cáo automation, rồi quyết định merge.
- Khi merge, issue tự đóng nhờ liên kết `Closes #số`.

## 7. Coding standard thống nhất

Mỗi công nghệ có một bộ coding standard riêng, đặt ngay trong thư mục của app. AI Agent bắt buộc đọc
trước khi code và dùng chính bộ chuẩn này khi review, nên code do AI hay do người viết đều theo cùng một
phong cách.

| Công nghệ | Nội dung chính của coding standard |
|---|---|
| Next.js (web, admin) | Cấu trúc theo feature; ưu tiên Server Component; mọi gọi API qua một client có kiểu; xử lý đủ trạng thái loading/lỗi/rỗng; Tailwind; data-testid cho automation |
| NestJS (api) | Mỗi tính năng một module; controller chỉ xử lý HTTP, logic nằm ở service; DTO có validate và Swagger; lỗi chuẩn hoá; phân trang; unit test cho service |
| Flutter (mobile) | Cấu trúc theo feature (data / domain / presentation); Riverpod; model đồng bộ với contract chung; dùng Theme thay vì hard-code màu; lint chặt; unit + widget test |

Ngoài ra còn các quy ước chung: tên branch, commit theo Conventional Commits, mẫu PR có checklist, và CI
tự động chạy lint, test, build, automation cho mỗi PR.

## 8. Phân vai: con người và AI

| Vai trò | Trách nhiệm | Công việc AI hỗ trợ |
|---|---|---|
| PO / BA | Viết yêu cầu, Acceptance Criteria; trả lời câu hỏi khi issue Fail to dev | Soạn issue đúng mẫu, chỉ ra phần thiếu |
| Designer | Thiết kế trên Figma, cung cấp link frame | Đọc thiết kế, code UI, đối chiếu giao diện |
| Developer / Tech Lead | Duyệt kiến trúc, review cuối, merge PR, xử lý ca phức tạp | Code, unit test, review sơ bộ |
| QA | Duyệt test case, kiểm thử thủ công phần còn lại (mobile, UX) | Sinh test case, viết và chạy automation |
| Quản lý | Theo dõi tiến độ qua label và board | Báo cáo trạng thái theo bảng |

## 9. Kiểm soát rủi ro

| Rủi ro | Biện pháp kiểm soát |
|---|---|
| AI code sai yêu cầu | Definition of Ready chặt; bảng đối chiếu AC → code → test; review và automation theo AC |
| Code chất lượng kém, không đồng nhất | Coding standard bắt buộc cho từng app; CI chặn PR không đạt lint/test/build |
| AI tự ý đưa code lên production | Cấm push vào main, cấm force-push; chỉ con người được merge |
| Vòng lặp sửa lỗi vô hạn | Giới hạn 3 vòng cho review và automation, sau đó dừng và báo người |
| Lộ thông tin nhạy cảm | Token GitHub giới hạn quyền theo repo; không ghi secret vào comment/log |
| Thiếu minh bạch | Mọi bước đều để lại label và comment trên GitHub, truy vết được đầy đủ |

## 10. Chỉ số đo lường đề xuất

| Chỉ số | Cách đo | Ý nghĩa |
|---|---|---|
| Lead time | Thời gian từ Ready to dev đến QA passed | Tốc độ giao tính năng |
| Tỉ lệ Fail to dev | Số issue Fail to dev / tổng issue được triage | Chất lượng yêu cầu đầu vào |
| Tỉ lệ đạt review lần đầu | PR đạt review ngay vòng 1 | Chất lượng code ban đầu |
| Độ phủ AC bằng automation | Số AC có test tự động / tổng AC | Mức độ an toàn khi phát hành |
| Lỗi lọt sau release | Số bug phát hiện sau merge | Hiệu quả của toàn bộ quy trình |
