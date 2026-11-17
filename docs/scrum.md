# Quy trình Scrum ứng dụng AI Agent

Vai trò, các giai đoạn, quality gate và sự chuyển dịch effort so với Scrum truyền thống

Phiên bản: 1.0 · Ngày tạo: 16-10-2026 · WATA Software · Tài liệu nội bộ

---

## 1. Mục đích và phạm vi

Tài liệu định nghĩa quy trình Scrum của team sau khi đưa AI Agent vào phát triển phần mềm. Khung Scrum giữ
nguyên (vai trò, sự kiện, artifacts), nhưng **phân công công việc giữa người và AI** và **trọng tâm effort**
của từng giai đoạn thay đổi.

Áp dụng cho các **project** phát triển phần mềm của công ty, đặc biệt các project tổ chức theo monorepo (web,
admin, API, mobile trong cùng một repository).

::: tip Nguyên tắc cốt lõi
AI đảm nhận phần thực thi lặp lại (viết code, test, review vòng 1). Con người chịu trách nhiệm về **giá trị**
(làm gì, vì sao), **quyết định** (kiến trúc, merge, release) và **nghiệm thu**.
:::

## 2. Tổng quan quy trình Scrum có AI

Sprint gồm 10 bước liên tiếp. Màu của từng bước thể hiện hướng chuyển dịch effort so với Scrum truyền thống:

- **Nền đỏ nhạt:** effort của con người tăng. Đây là các khâu trở thành nút thắt mới.
- **Nền xanh lá nhạt:** AI đảm nhận chính, effort của con người giảm mạnh.
- **Nền xám:** effort gần như giữ nguyên.

| # | Bước | Phân công người – AI | Effort |
|---|---|---|---|
| 1 | Khám phá & viết yêu cầu | Người: PO/BA · AI: soạn story, gợi ý AC | Đỏ nhạt (tăng) |
| 2 | Refinement & kiểm tra DoR | Người: PO + Team · AI: triage tự động | Đỏ nhạt (tăng) |
| 3 | Sprint planning | Người: cả team · AI: dữ liệu năng lực review/QA | Xám (giữ) |
| 4 | Thiết kế UI & kiến trúc | AI: tạo Figma, đề xuất kiến trúc · Người: Designer duyệt UI · Tech Lead chốt kiến trúc | Xanh nhạt (giảm) |
| 5 | Lập trình + unit test | AI: code, test · Người: giao việc, giám sát | Xanh nhạt (giảm) |
| 6 | Code review | AI: review vòng 1 · Người: duyệt cuối | Đỏ nhạt (tăng) |
| 7 | QA: test case + automation | AI: sinh & chạy · Người: duyệt, test khám phá | Xanh nhạt (giảm) |
| 8 | CI/CD & triển khai | Tự động · Người: phê duyệt release | Xanh nhạt (giảm) |
| 9 | Sprint review & UAT | Người: PO, khách hàng | Đỏ nhạt (tăng) |
| 10 | Retrospective | Người: cả team · Cải tiến cả quy trình lẫn skill AI | Xám (giữ) |

Bước 6 → 5: sửa (review yêu cầu sửa thì quay lại lập trình). Bước 10 → 1: sprint kế tiếp.

*Hình 1. Vòng lặp sprint và phân công người – AI*

## 3. Vai trò và trách nhiệm

| Vai trò | Scrum truyền thống | Scrum có AI | Effort |
|---|---|---|---|
| Product Owner / BA | Viết story, ưu tiên backlog, nghiệm thu | Như cũ, nhưng viết AC chặt hơn, trả lời nhanh các story Fail to dev, nghiệm thu nhiều hơn | ▲ Tăng |
| Scrum Master / PM | Điều phối sự kiện, gỡ vướng | Thêm: theo dõi nút thắt review/QA, giới hạn WIP, theo dõi chi phí AI | ● Giữ |
| Tech Lead | Kiến trúc, review, hỗ trợ dev | Kiến trúc, duyệt cuối PR, sở hữu coding standard | ▲ Tăng |
| Developer | Viết code, unit test, sửa lỗi | Thiết kế giải pháp, giao việc cho AI, kiểm tra và chịu trách nhiệm code | ▼ Giảm |
| QA | Viết test case, test thủ công, viết automation | Duyệt test case AI sinh, test khám phá/UX, test thiết bị thật | ▼ Giảm |
| Designer | Thiết kế từng màn hình, bàn giao cho dev | Xây dựng và mô tả design system, viết brief UI, duyệt và tinh chỉnh Figma do AI tạo, chịu trách nhiệm UX | ▼ Giảm (tăng ở Sprint 0) |
| AI Enablement (mới) | — | Bảo trì skill, coding standard, cấu hình MCP; phân tích lỗi AI lặp lại. Có thể kiêm nhiệm bởi Tech Lead | Mới |

### 3.1 Ma trận RACI theo giai đoạn

R = thực hiện, A = chịu trách nhiệm cuối, C = tham vấn, I = được thông báo.

| Giai đoạn | PO | Designer | Tech Lead | Dev | QA | AI |
|---|---|---|---|---|---|---|
| Viết yêu cầu | A/R | C | C | I | C | R (soạn nháp) |
| Refinement / DoR | A | C | R | C | C | R (triage) |
| Thiết kế UI (Figma) | C | A | I | I | I | R |
| Thiết kế kỹ thuật | C | I | A/R | C | I | C (đề xuất) |
| Lập trình | I | I | C | A | I | R |
| Code review | I | I | A | R | I | R (vòng 1) |
| Test case & automation | C | I | I | C | A | R |
| Merge & release | I | I | A/R | C | C | — |
| Nghiệm thu | A/R | C | C | I | C | — |

::: tip
AI không bao giờ giữ vai trò A (chịu trách nhiệm cuối). Mọi đầu ra của AI đều có một người cụ thể chịu trách
nhiệm.
:::

## 4. Artifacts và tiêu chuẩn

| Artifact | Thay đổi so với truyền thống |
|---|---|
| Product Backlog | Story bắt buộc theo template: Description, Acceptance Criteria, brief UI, app bị ảnh hưởng; link Figma được gắn sau khi thiết kế được duyệt. Mỗi story có đúng một label trạng thái. |
| Sprint Backlog | Thêm giới hạn WIP cho cột In review và QA để tránh dồn ứ. |
| Increment | Đi kèm bộ test case và automation phủ toàn bộ AC. |
| Definition of Ready | Chặt hơn: 10 tiêu chí, AI kiểm tra tự động. Story có giao diện cần có mô tả màn hình/brief UI. Story không đạt không được vào sprint. |
| Definition of Done | Thêm: automation phủ mọi AC, CI xanh, người duyệt cuối đã approve, không còn Blocker/Major, giao diện khớp với Figma đã duyệt. |
| Design System (mới) | Màu, font, khoảng cách, component, quy tắc layout và nguyên tắc UX do Designer mô tả ở dạng AI đọc được; là đầu vào bắt buộc để AI tạo Figma. Được quản lý phiên bản. |
| Tài sản AI (mới) | Skill, coding standard dạng máy đọc được, CLAUDE.md, cấu hình MCP. Được quản lý phiên bản và review như code. |

## 5. Sự kiện Scrum và timebox

Tham chiếu sprint 2 tuần. Team có thể rút sprint xuống 1 tuần khi luồng review và nghiệm thu đã ổn định.

| Sự kiện | Truyền thống | Có AI | Ghi chú |
|---|---|---|---|
| Sprint Planning | 4 giờ | 3–4 giờ | Lập kế hoạch theo năng lực review/QA |
| Daily Scrum | 15 phút | 15 phút | Dashboard label thay báo cáo; họp tập trung vào việc bị chặn |
| Backlog Refinement | ≤ 10% sprint | 20–25% sprint | Tăng mạnh nhất |
| Sprint Review | 2 giờ | 2–3 giờ | Nhiều tính năng cần demo hơn |
| Retrospective | 1,5 giờ | 1,5 giờ | Thêm phần cải tiến skill/standard |
| Review queue (mới) | — | 2 khung/ngày | Khung giờ cố định để duyệt PR, tránh tồn đọng |
| Duyệt thiết kế (mới) | — | 30–60 phút/nhóm story | PO + Designer + khách hàng, trong 1–2 ngày đầu sprint |

## 6. Quy trình chi tiết theo giai đoạn

Mỗi giai đoạn mô tả: mục tiêu, phân công người và AI, đầu ra, cổng chất lượng, và mức chuyển dịch effort so
với Scrum truyền thống.

### 6.1 Sprint 0: Thiết lập nền tảng (một lần mỗi dự án)

**Mục tiêu:** Chuẩn bị môi trường để AI làm việc đúng chuẩn ngay từ sprint đầu.

| Hạng mục | Nội dung |
|---|---|
| Đầu vào | Hợp đồng, phạm vi tổng thể, stack công nghệ. |
| Con người làm | Tech Lead: chọn kiến trúc, viết coding standard cho từng công nghệ · PM: thiết lập label trạng thái, board, CI, quyền truy cập · Security: duyệt chính sách dữ liệu, token, phạm vi quyền của AI · Designer: xây dựng và mô tả design system (màu, font, khoảng cách, component, quy tắc layout), chuẩn bị brief mẫu để AI tạo Figma |
| AI làm | Dựng khung monorepo, CI, template issue/PR · Sinh bản nháp coding standard, skill workflow · Thiết lập công cụ AI có khả năng tạo/ghi thiết kế vào Figma (công cụ cụ thể do team thử nghiệm và lựa chọn) |
| Đầu ra | Repository, skill, coding standard, design system, Definition of Ready/Done, kết nối MCP (GitHub, Figma, Playwright). |
| Cổng chất lượng | Tech Lead và Security ký duyệt bộ chuẩn và quyền truy cập; Designer duyệt design system. |

**Chuyển dịch effort: ▲ Tăng.** Giai đoạn mới so với truyền thống (khoảng 1–2 tuần). Đây là khoản đầu tư ban
đầu, được dùng lại cho các sprint sau.

### 6.2 Khám phá và viết yêu cầu (Product Backlog)

**Mục tiêu:** Biến nhu cầu của khách hàng thành user story rõ ràng, kiểm thử được.

| Hạng mục | Nội dung |
|---|---|
| Đầu vào | Nhu cầu khách hàng, biên bản họp. |
| Con người làm | PO/BA: làm việc với khách, quyết định giá trị và độ ưu tiên · PO/BA: chốt Acceptance Criteria (AC) · Designer: mô tả yêu cầu giao diện (brief UI) trong story |
| AI làm | Soạn user story theo mẫu từ biên bản họp · Đề xuất AC dạng Given/When/Then, chỉ ra trường hợp biên còn thiếu · Tách story lớn thành story nhỏ độc lập |
| Đầu ra | Story ở trạng thái Backlog, có Description, AC, Design, app bị ảnh hưởng. |
| Cổng chất lượng | Story có đủ các mục bắt buộc của template. |

**Chuyển dịch effort: ▲ Tăng khoảng +20%.** AI soạn nhanh, nhưng PO/BA phải viết chi tiết và chính xác hơn
trước vì AI thực thi đúng theo chữ, không tự bù chỗ thiếu như dev có kinh nghiệm.

### 6.3 Backlog Refinement và kiểm tra Definition of Ready

**Mục tiêu:** Đảm bảo mọi story vào sprint đều đủ điều kiện để AI làm.

| Hạng mục | Nội dung |
|---|---|
| Đầu vào | Story ở trạng thái Backlog. |
| Con người làm | PO + Tech Lead: trả lời câu hỏi, chốt phạm vi, đánh giá rủi ro kỹ thuật · PO: bổ sung story bị Fail to dev |
| AI làm | Triage tự động theo 10 tiêu chí DoR · Chuyển Ready to dev hoặc Fail to dev, comment rõ phần thiếu và gợi ý cách viết lại |
| Đầu ra | Danh sách story Ready to dev. |
| Cổng chất lượng | Đạt toàn bộ tiêu chí DoR bắt buộc. |

**Chuyển dịch effort: ▲ Tăng khoảng +60%**, từ ~10% lên ~20–25% thời gian sprint của PO và Tech Lead. Đây là
khâu quyết định chất lượng đầu ra khi có AI.

### 6.4 Sprint Planning

**Mục tiêu:** Chọn khối lượng việc vừa với năng lực thực của team trong sprint.

| Hạng mục | Nội dung |
|---|---|
| Đầu vào | Story Ready to dev, số liệu các sprint trước. |
| Con người làm | Cả team: chọn story, cam kết Sprint Goal · Tech Lead: xác định story cần người code trực tiếp (phức tạp, nhạy cảm) |
| AI làm | Cung cấp số liệu: lead time, số PR mỗi người review được, tỉ lệ Fail to dev · Gợi ý chia nhỏ hoặc gom story |
| Đầu ra | Sprint Backlog, Sprint Goal. |
| Cổng chất lượng | Tổng khối lượng không vượt năng lực review và QA của team. |

**Chuyển dịch effort: ● Giữ nguyên.** Effort giữ nguyên, nhưng tiêu chí thay đổi: lập kế hoạch theo năng lực
review/nghiệm thu thay vì năng lực code.

### 6.5 Thiết kế UI (AI tạo Figma) và kiến trúc

**Mục tiêu:** Chốt giao diện và giải pháp kỹ thuật trước khi code.

| Hạng mục | Nội dung |
|---|---|
| Đầu vào | Story trong sprint, brief UI, design system. |
| Con người làm | Designer: viết brief, duyệt và tinh chỉnh Figma do AI tạo, kiểm tra UX và khả năng tiếp cận · PO + khách hàng: chọn và xác nhận phương án giao diện · Tech Lead: quyết định kiến trúc, contract API, mô hình dữ liệu |
| AI làm | Tạo Figma theo design system, đủ trạng thái bình thường, lỗi, rỗng, đang tải · Đưa ra 2–3 phương án giao diện, cập nhật theo góp ý · Đề xuất phương án kỹ thuật, so sánh ưu nhược |
| Đầu ra | Frame Figma đã duyệt, gắn vào story; thiết kế kỹ thuật ngắn gọn. |
| Cổng chất lượng | Designer duyệt và khách xác nhận UI trước khi bắt đầu code; Tech Lead duyệt kiến trúc với story phức tạp. |

**Chuyển dịch effort: ▼ Giảm khoảng −25%.** AI tạo bản thiết kế và các phương án; Designer chuyển từ vẽ từng
màn hình sang mô tả, duyệt và tinh chỉnh. Quyết định kiến trúc vẫn do người.

### 6.6 Lập trình và unit test

**Mục tiêu:** Hiện thực story đúng AC, đúng coding standard.

| Hạng mục | Nội dung |
|---|---|
| Đầu vào | Story Ready to dev, coding standard, Figma đã duyệt, thiết kế kỹ thuật. |
| Con người làm | Developer: giao việc cho AI, theo dõi, xử lý phần AI làm sai hoặc phần phức tạp · Developer: chịu trách nhiệm cuối cùng về code |
| AI làm | Tạo branch, lập bảng AC → thay đổi → test · Viết code và unit test, chạy lint/typecheck/build · Mở Pull Request liên kết story |
| Đầu ra | Pull Request kèm bảng đối chiếu AC. |
| Cổng chất lượng | CI xanh: lint, typecheck, unit test, build. |

**Chuyển dịch effort: ▼ Giảm khoảng −70%.** Đây là khâu giảm nhiều nhất. Dev chuyển từ viết code sang thiết
kế, giao việc và kiểm tra.

### 6.7 Code review

**Mục tiêu:** Đảm bảo code đúng, an toàn, dễ bảo trì trước khi vào QA.

| Hạng mục | Nội dung |
|---|---|
| Đầu vào | Pull Request. |
| Con người làm | Reviewer/Tech Lead: duyệt cuối, tập trung vào nghiệp vụ, kiến trúc, bảo mật · Quyết định chấp nhận hoặc yêu cầu sửa |
| AI làm | Review vòng 1 theo checklist 8 tiêu chí, comment theo dòng · Tự sửa lỗi Blocker/Major (tối đa 3 vòng) |
| Đầu ra | PR được duyệt, story chuyển sang QA. |
| Cổng chất lượng | Không còn Blocker/Major; người duyệt cuối đã approve. |

**Chuyển dịch effort: ▲ Tăng khoảng +40%.** Lượng code tăng mạnh nên tổng effort review tăng, dù mỗi PR được
AI lọc trước. Đây là nút thắt mới, cần giới hạn số PR chờ review.

### 6.8 QA: test case và automation

**Mục tiêu:** Chứng minh mọi AC hoạt động, không gây lỗi hồi quy.

| Hạng mục | Nội dung |
|---|---|
| Đầu vào | PR đã qua review, AC của story. |
| Con người làm | QA: duyệt bộ test case, bổ sung kịch bản nghiệp vụ · QA: test khám phá, test UX, test trên thiết bị thật (mobile) |
| AI làm | Sinh test case: luồng chính, dữ liệu sai, giá trị biên, chuyển trạng thái · Viết và chạy automation Playwright, phân loại lỗi, tự sửa (tối đa 3 vòng) · Báo cáo kết quả lên PR |
| Đầu ra | Bộ test case, automation test, báo cáo QA passed/failed. |
| Cổng chất lượng | Mọi AC có ít nhất 1 test; automation xanh. |

**Chuyển dịch effort: ▼ Giảm.** Test case và QA thủ công khoảng −50%, automation khoảng −60%. QA chuyển từ
viết và chạy test sang duyệt và khám phá. Độ phủ automation tăng.

### 6.9 Tích hợp và triển khai (CI/CD)

**Mục tiêu:** Đưa code lên môi trường staging/production an toàn.

| Hạng mục | Nội dung |
|---|---|
| Đầu vào | PR QA passed. |
| Con người làm | Tech Lead: merge PR · PM/Tech Lead: phê duyệt release production |
| AI làm | CI tự chạy toàn bộ kiểm tra; AI soạn release note |
| Đầu ra | Bản build trên staging/production, release note. |
| Cổng chất lượng | Chỉ con người được merge và phê duyệt release. |

**Chuyển dịch effort: ▼ Giảm khoảng −33%**, nhờ tự động hoá kiểm tra và release note.

### 6.10 Sprint Review và UAT

**Mục tiêu:** Khách hàng và PO nghiệm thu tính năng.

| Hạng mục | Nội dung |
|---|---|
| Đầu vào | Increment trên staging. |
| Con người làm | PO + khách hàng: demo, nghiệm thu, đưa phản hồi · PO: cập nhật backlog theo phản hồi |
| AI làm | Soạn tài liệu demo, tóm tắt thay đổi theo sprint · Chuyển phản hồi thành story mới |
| Đầu ra | Tính năng được nghiệm thu, backlog cập nhật. |
| Cổng chất lượng | Khách hàng/PO chấp nhận theo AC. |

**Chuyển dịch effort: ▲ Tăng khoảng +25%.** Mỗi sprint giao nhiều tính năng hơn nên khối lượng nghiệm thu
tăng. Cần thống nhất trước với khách về thời gian phản hồi.

### 6.11 Sprint Retrospective

**Mục tiêu:** Cải tiến cách làm việc của cả người và AI.

| Hạng mục | Nội dung |
|---|---|
| Đầu vào | Số liệu sprint, các lỗi AI lặp lại. |
| Con người làm | Cả team: đánh giá, chọn hành động cải tiến · Người phụ trách nền tảng AI: cập nhật skill, coding standard, DoR |
| AI làm | Tổng hợp số liệu và các lỗi lặp lại từ comment review/QA |
| Đầu ra | Hành động cải tiến; phiên bản mới của skill/standard. |
| Cổng chất lượng | Mỗi lỗi AI lặp lại ≥ 2 lần phải có hành động sửa skill hoặc standard. |

**Chuyển dịch effort: ● Giữ nguyên.** Effort họp giữ nguyên, phát sinh thêm việc bảo trì skill (khoảng 4% tổng
effort, tính ở mục Vận hành nền tảng AI).

## 7. Tổng hợp chuyển dịch effort

Bảng và biểu đồ dưới đây quy đổi tổng effort của một sprint truyền thống thành **100 đơn vị** để dễ so sánh.
Đây là số liệu tham khảo ban đầu dựa trên một project web/mobile thông thường; team cần thay bằng số đo thực
tế sau 2–3 sprint thí điểm.

![Effort theo giai đoạn: truyền thống và có AI](/effort-vi.svg)

*Hình 2. Effort theo giai đoạn: truyền thống và có AI*

| Giai đoạn | Truyền thống | Có AI | Thay đổi | Ai gánh phần thay đổi |
|---|---|---|---|---|
| Khám phá & yêu cầu | 10 | 12 | ▲ +20% | PO/BA |
| Refinement & DoR | 5 | 8 | ▲ +60% | PO, Tech Lead |
| Sprint planning | 3 | 3 | ● 0% | Cả team |
| Thiết kế UI & kiến trúc | 8 | 6 | ▼ −25% | Designer, Tech Lead |
| Lập trình | 40 | 12 | ▼ −70% | Developer |
| Unit test | 7 | 2 | ▼ −71% | Developer |
| Code review | 5 | 7 | ▲ +40% | Tech Lead, Reviewer |
| Test case & QA thủ công | 10 | 5 | ▼ −50% | QA |
| Automation test | 5 | 2 | ▼ −60% | QA |
| CI/CD & triển khai | 3 | 2 | ▼ −33% | Tech Lead |
| Sprint review & UAT | 4 | 5 | ▲ +25% | PO, khách hàng |
| Vận hành nền tảng AI | 0 | 4 | Mới | AI Enablement |
| **Tổng** | **100** | **68** | **▼ −32%** | |

### 7.1 Cơ cấu effort thay đổi thế nào

| Nhóm công việc | Tỉ trọng truyền thống | Tỉ trọng có AI |
|---|---|---|
| Yêu cầu, refinement, nghiệm thu (PO/BA, khách) | 19% | 37% |
| Thiết kế, kiến trúc, review, release (Designer, Tech Lead) | 16% | 22% |
| Thực thi: code, unit test, QA, automation | 62% | 31% |
| Lập kế hoạch & vận hành nền tảng AI | 3% | 10% |

::: tip Kết luận
Tổng effort giảm khoảng 32%, nhưng điều quan trọng hơn là trọng tâm dịch chuyển. Phần thực thi giảm từ khoảng
62% xuống 31% tổng effort. Phần yêu cầu, quyết định và nghiệm thu tăng từ khoảng 35% lên gần 60%. Team cần
nhiều năng lực BA, review và kiến trúc hơn, và ít năng lực code thuần hơn.
:::

## 8. Ước lượng và đo lường

### 8.1 Thay đổi cách ước lượng

- Story point không còn phản ánh công sức code. Ước lượng theo độ phức tạp nghiệp vụ, độ mơ hồ và công
  review/nghiệm thu.
- Dùng thang S / M / L / XL cho story. Gắn cờ "cần người code" cho story có rủi ro cao (bảo mật, thanh toán,
  thuật toán).
- Năng lực sprint tính theo số PR team review được và số story PO nghiệm thu được, không theo velocity code.

### 8.2 Chỉ số theo dõi

| Chỉ số | Cách đo | Mục tiêu tham khảo |
|---|---|---|
| Lead time | Ready to dev → QA passed | Giảm ≥ 40% sau 3 sprint |
| Thời gian chờ review | PR mở → người duyệt cuối approve | < 1 ngày làm việc |
| Tỉ lệ Fail to dev | Story Fail to dev / story được triage | < 20% và giảm dần |
| Tỉ lệ đạt review vòng 1 | PR không cần sửa Blocker/Major | ≥ 60% |
| Độ phủ AC bằng automation | AC có test tự động / tổng AC | ≥ 80% (web/admin/api) |
| Lỗi lọt sau release | Bug phát hiện sau merge | Không tăng so với truyền thống |
| Chi phí AI mỗi story | Token/license chia theo story | Theo dõi xu hướng |

## 9. Rủi ro và kiểm soát

| Rủi ro | Kiểm soát |
|---|---|
| PR dồn ứ chờ review (nút thắt mới) | Giới hạn WIP cột In review; khung giờ review cố định mỗi ngày; AI review vòng 1 trước |
| Yêu cầu mơ hồ → AI làm nhanh nhưng sai | DoR 10 tiêu chí kiểm tra tự động; tăng thời gian refinement |
| Reviewer tin AI quá mức | Người duyệt cuối bắt buộc kiểm tra nghiệp vụ và bảo mật; kiểm tra ngẫu nhiên PR đã duyệt |
| Khách hàng không nghiệm thu kịp | Thống nhất SLA phản hồi trong hợp đồng; nghiệm thu theo lô hằng tuần |
| Junior thiếu cơ hội học | Luân phiên story "cần người code"; junior tham gia review cùng Tech Lead |
| Bảo mật dữ liệu, bản quyền code | Token giới hạn theo repo; điều khoản AI trong hợp đồng; không đưa dữ liệu thật của khách vào prompt |
| Thiết kế AI tạo ra rập khuôn, lệch thương hiệu, kém khả năng tiếp cận | Bắt buộc dùng design system làm đầu vào; Designer duyệt mọi màn hình trước khi code |
| Bản quyền tài sản thiết kế (ảnh, icon, font do AI tạo) | Chỉ dùng tài sản từ thư viện đã được cấp phép; ghi nguồn trong design system |
| Khách duyệt thiết kế chậm làm trễ sprint | Giới hạn duyệt trong 1–2 ngày đầu sprint; story có UI lớn thì tách phần thiết kế làm trước một sprint |
| Phụ thuộc nhà cung cấp AI | Skill và standard viết dạng Markdown trung lập, dùng được cho nhiều công cụ |
