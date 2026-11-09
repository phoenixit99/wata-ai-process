<p align="center"><img src="docs/public/wata-logo.png" alt="WATA Software" width="320"></p>

# WATA AI Process

Bộ quy trình phát triển phần mềm và **quản lý dự án Scrum** sử dụng AI Agent của WATA Software, dùng chung
cho mọi project. Gồm hai lớp: [quy trình phát triển](docs/process.md) (từng issue: label, cổng, skill) và
[quy trình Scrum](docs/scrum.md) (sprint, sự kiện, năng lực, effort).
Repo này **không thuộc dự án nào**; mỗi project cài bộ quy trình từ đây và ghim phiên bản.

**Bản gốc của quy trình là [`docs/process.md`](docs/process.md)** (tiếng Việt); bản tiếng Anh ở
[`docs/en/`](docs/en/). Mọi bản khác (PDF, Claude Doc, slide) là bản sao và phải đồng bộ theo file này.

**Website song ngữ:** thư mục `docs/` là một site VitePress (tiếng Việt ở `/`, English ở `/en/`), màu
theo tài liệu PDF của WATA, deploy lên Vercel (xem mục Website bên dưới).

## Bắt đầu từ đâu

| Bạn là | Đọc |
|---|---|
| Bất kỳ ai | [`docs/process.md`](docs/process.md) mục 1, 4, 6 và [`docs/glossary.md`](docs/glossary.md) |
| PO | [`docs/roles/po.md`](docs/roles/po.md), [`docs/writing-acceptance-criteria.md`](docs/writing-acceptance-criteria.md) |
| BA | [`docs/roles/ba.md`](docs/roles/ba.md) |
| PM | [`docs/roles/pm.md`](docs/roles/pm.md), [`docs/raci.md`](docs/raci.md) |
| Designer | [`docs/roles/designer.md`](docs/roles/designer.md) |
| Developer | [`docs/roles/dev.md`](docs/roles/dev.md) |
| Tech Lead | [`docs/roles/tech-lead.md`](docs/roles/tech-lead.md), [`docs/setup-guide.md`](docs/setup-guide.md), [`docs/risk-tiers.md`](docs/risk-tiers.md) |
| QA | [`docs/roles/qa.md`](docs/roles/qa.md) |
| Người viết/sửa skill | [`docs/contract.md`](docs/contract.md) |

## Cấu trúc

```
wata-ai-process/
├── docs/                           Tài liệu + nguồn website (VitePress)
│   ├── index.md                    Trang chủ website
│   ├── process.md                  Quy trình (bản gốc)
│   ├── scrum.md                    Quy trình Scrum ứng dụng AI
│   ├── sprint-0.md, definition-of-done.md
│   ├── skills.md                   Danh mục skill (sinh tự động)
│   ├── en/                         Bản tiếng Anh của mọi trang
│   ├── .vitepress/                 Cấu hình site, theme màu WATA
│   ├── contract.md                 Luật chung cho AI: label, heading, chế độ chạy, việc cấm
│   ├── roles/                      Hướng dẫn 9 vai trò: po, ba, pm, designer, dev, tech-lead, qa, ai-enablement, security
│   ├── raci.md                     Ai làm gì ở từng trạng thái, SLA đề xuất
│   ├── risk-tiers.md               Phân loại rủi ro và cổng được rút gọn
│   ├── writing-acceptance-criteria.md
│   ├── glossary.md
│   ├── setup-guide.md              Cài cho một project, checklist điều kiện áp dụng
│   └── coding-standards/           Bản khởi đầu: nextjs, nestjs, flutter
├── skills/                         13 skill + catalog.json (nguồn duy nhất)
├── template/                       File cài vào repo project
│   ├── CLAUDE.md
│   ├── .mcp.json
│   ├── .claude/{settings.json, project.yml}
│   └── .github/{ISSUE_TEMPLATE/, workflows/, labels.yml, CODEOWNERS, pull_request_template.md}
├── scripts/
│   ├── install.sh                  Cài / nâng cấp vào một project
│   ├── setup-labels.sh             Tạo bộ label trên GitHub
│   ├── gen-effort-chart.py         Sinh biểu đồ effort cho trang Scrum
│   ├── sync-skills.py              Sinh header skill, bảng skill, mục skill ở trang vai trò từ catalog
│   └── check-consistency.py        Kiểm tra mọi thứ đồng bộ (chạy trong CI)
├── .github/workflows/check.yml     CI của repo này
├── package.json, vercel.json       Build và deploy website
├── .claude-plugin/                 Manifest để phân phối dạng plugin Claude Code (tuỳ chọn)
├── CHANGELOG.md
└── VERSION
```

## Skill

Từ v1.5.0 có **13 skill** (gộp từ 27): mỗi skill ứng với một bước hoặc một cổng, việc phụ của bước đó là một
chế độ (`--approve`, `--fix`, `--design`, `--manual`, `--merge`, `--run`, `--batch`). Bảng tên cũ → lời gọi mới
nằm ở `retired` trong [`skills/catalog.json`](skills/catalog.json) và trong [`CHANGELOG.md`](CHANGELOG.md).

**Lệnh cần nhớ:**

| Vai trò | Lệnh |
|---|---|
| Dev, Tech Lead | `/dev-pipeline <issue>`: đọc label, chọn bước |
| PM, Scrum | `/sprint plan\|daily\|review\|retro\|report\|release` |
| PO, BA, QA, Designer | `@claude <yêu cầu>` trên GitHub; workflow `wata-mention` chọn skill theo trạng thái issue |

Kiểm tra Sprint 0: `scripts/install.sh <repo> --check` (thay skill kiểm tra Sprint 0 trước đây).

Mỗi vai trò có ít nhất một skill tự gọi được. Cách làm của các bước 2–6 (điểm dừng
chờ đồng ý, cách đọc ticket, review hai lượt, footer ba phần) học từ quy trình đã chạy thực tế ở một
dự án khác, nhưng nội dung viết lại chung cho GitHub và cho WATA.

Bảng dưới sinh tự động từ [`skills/catalog.json`](skills/catalog.json) bằng `scripts/sync-skills.py`.

<!-- skills:start -->
| Bước | Skill | Dùng khi | Vai trò | Kích hoạt |
|---|---|---|---|---|
| - | [`dev-pipeline`](skills/dev-pipeline/SKILL.md) | Định tuyến theo label; bảng việc theo vai trò | PO, BA, PM, Designer, Dev, Tech Lead, QA, AI Enablement, Security | người gọi |
| 1 | [`issue-create`](skills/issue-create/SKILL.md) | Soạn issue đúng mẫu từ ngôn ngữ tự nhiên | PO, BA | người gọi |
| 0, refinement | [`refine`](skills/refine/SKILL.md) | Phân tích epic (mặc định); refinement hàng loạt, size S–XL, cờ human-code (`--batch`) | PO, BA, Tech Lead | label `type:epic` (tự động) hoặc người gọi |
| 2 | [`triage`](skills/triage/SKILL.md) | Kiểm tra Definition of Ready R1–R11 | AI (tự động) | label `status:backlog` (tự động) hoặc người gọi |
| design | [`design-brief`](skills/design-brief/SKILL.md) | Brief UI từ design system, phương án giao diện, duyệt thiết kế trước khi code | Designer | người gọi |
| 3 | [`test-design`](skills/test-design/SKILL.md) | Test case và plan trước khi code (mặc định); hỗ trợ người ký G2 (`--approve`) | Dev, Tech Lead, QA | label `status:test-design` (tự động) hoặc người gọi |
| 4, 6b | [`implement`](skills/implement/SKILL.md) | Code theo plan, mở PR (mặc định); sửa sau QA/UAT (`--fix`); frame Figma thành UI (`--figma`) | Dev | label `status:ready-to-dev`, `status:in-progress` (tự động) hoặc người gọi |
| 5 | [`pr-review`](skills/pr-review/SKILL.md) | Review PR ở session riêng, hai lượt (mặc định); Designer so UI với Figma (`--design`) | Designer, Dev, Tech Lead | label `status:in-review` (tự động) hoặc người gọi |
| 6 | [`qa`](skills/qa/SKILL.md) | Automation và kết luận QA (mặc định); QA test manual/mobile (`--manual`) | QA | label `status:qa` (tự động) hoặc người gọi |
| 7–8 | [`merge-gate`](skills/merge-gate/SKILL.md) | Refutation brief cho G3 (mặc định); kiểm tra trước merge G4 (`--merge`) | Tech Lead, Security | label `status:qa-passed` (tự động) hoặc người gọi |
| 9 | [`uat`](skills/uat/SKILL.md) | Checklist UAT cho PO (mặc định); PO nghiệm thu, soạn kết luận (`--run`) | PO | label `status:uat` (tự động) hoặc người gọi |
| hotfix | [`hotfix`](skills/hotfix/SKILL.md) | Sửa khẩn cấp production | Tech Lead, Dev | người gọi |
| planning, daily, review, retro | [`sprint`](skills/sprint/SKILL.md) | Sự kiện Scrum: `plan`, `daily`, `review`, `retro`, `report`, `release` | PO, PM, Tech Lead, AI Enablement | người gọi |
<!-- skills:end -->

## Cài vào một project

```bash
scripts/install.sh <đường-dẫn-repo-project>
scripts/setup-labels.sh <owner>/<repo> <đường-dẫn-repo-project>/.claude/project.yml
```
Sau đó làm theo [`docs/setup-guide.md`](docs/setup-guide.md). Nâng cấp: `scripts/install.sh <repo> --upgrade`.

Khi nâng cấp, script chỉ ghi đè **lớp lõi**: skill, `docs/agents/*`, `.github/workflows/wata-*.yml`,
`.github/labels.yml` (nơi chứa tên label, heading, luật chuyển trạng thái; phải cùng phiên bản). **Lớp
cấu hình** của project (`project.yml`, `settings.json`, `CLAUDE.md`, `.mcp.json`, CODEOWNERS, issue/PR
template, `ci.yml`, coding standard) không bao giờ bị ghi đè.

**Plugin (tuỳ chọn):** repo có `.claude-plugin/` để cài như plugin Claude Code từ marketplace nội bộ.
Khi cài dạng plugin, skill có tiền tố `wata:` (ví dụ `/wata:dev-pipeline`); workflow mặc định gọi tên
không tiền tố vì dùng bản copy trong `.claude/skills/`. Kiểm tra định dạng manifest với tài liệu
Claude Code hiện hành trước khi phát hành.

## Website

```bash
npm install
npm run docs:dev        # xem trước tại http://localhost:5173
npm run docs:build      # build ra docs/.vitepress/dist
```

**Deploy lên Vercel:** vào vercel.com → Add New → Project → import repo `phoenixit99/wata-ai-process`.
`vercel.json` đã khai báo framework, lệnh build và thư mục output, nên không cần cấu hình thêm. Mỗi lần
push vào `main` Vercel tự build lại. Lưu ý: site trên Vercel mặc định công khai; nếu nội dung chỉ dành
cho nội bộ, bật Deployment Protection trong cài đặt project trên Vercel.

## Sửa skill hoặc tài liệu

1. Sửa skill trong `skills/<tên>/SKILL.md`; thêm/bớt skill hoặc đổi vai trò, label, heading thì sửa
   `skills/catalog.json` (và `docs/contract.md` nếu thêm heading).
2. Sửa tài liệu ở **cả hai** ngôn ngữ: `docs/<trang>.md` và `docs/en/<trang>.md`.
3. Chạy `npm run sync` rồi `npm run check`. CI chạy lại `check` và build site trên mỗi PR.

## Phiên bản và đóng góp

- Semver: patch = sửa nhỏ; minor = thêm bước/tiêu chí; major = đổi luồng trạng thái hoặc tên label/heading.
- Thay đổi qua PR vào repo này, có review của process owner, ghi [`CHANGELOG.md`](CHANGELOG.md).
- Mọi người đều có thể đề xuất bằng issue. Bài học từ các project (Needs human, lỗi G3 bắt được, UAT
  rejected) là nguồn cải tiến chính.

## Tình trạng

| Phần | Tình trạng |
|---|---|
| Tài liệu quy trình, vai trò, contract | Hoàn chỉnh v1.2, chờ team review |
| Skill (13) | Viết xong; đồng bộ với catalog (`scripts/check-consistency.py` xanh); **chưa chạy trên repo thật** |
| Workflow GitHub Actions | Viết xong. Đã kiểm: YAML parse được; logic định tuyến của `wata-agent` chạy giả lập 10 tình huống (gh/yq giả). **Chưa** chạy actionlint/shellcheck (máy không có) và **chưa chạy trên GitHub** |
| `install.sh`, `setup-labels.sh` | `install.sh` đã chạy thử trên repo trống (cài, nâng cấp, mọi đường dẫn tài liệu skill tham chiếu đều tồn tại). `setup-labels.sh`: đã thử phần đọc file, chưa gọi `gh` thật |
| Cần đối chiếu trước khi bật | Action có nạp `.claude/skills` khi chạy bằng `@claude` không (tài liệu không nói; đã có câu gọi dự phòng); định dạng `.claude-plugin/*.json`; địa chỉ Figma MCP trong `.mcp.json`; `yq` có sẵn trên runner (đúng với runner GitHub-hosted theo hiểu biết hiện tại, chưa kiểm) |
| Coding standard | Bản khởi đầu, Tech Lead từng project chỉnh |
| SLA, WIP, ngân sách AI, ngưỡng rủi ro | **Đề xuất**, team chốt trước pilot |

**Câu hỏi mở:** ai là process owner; project dùng tracker của khách hàng (Azure DevOps, Jira) có nằm
trong giai đoạn đầu không.
