#!/usr/bin/env python3
"""Kiểm tra skill, workflow, contract và tài liệu đồng bộ với skills/catalog.json và với quy trình 1.0
(PDF "Quy trình phát triển dự án sử dụng AI Agent" và "Quy trình Scrum ứng dụng AI Agent").

Chạy:  python3 -I scripts/check-consistency.py      (thoát mã 1 nếu có lỗi)
"""
import importlib.util
import json
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
errors = []

# Tên trong quy trình 1.0: không được đổi.
PDF_SKILLS = ["github-issue-create", "github-issue-triage", "github-issue-implement", "github-pr-review",
              "qa-test-cases", "e2e-playwright", "figma-to-code", "dev-pipeline"]
PDF_STANDARDS = ["nextjs-coding-standard", "nestjs-coding-standard", "flutter-coding-standard"]
PDF_STATUSES = ["Backlog", "Fail to dev", "Ready to dev", "In progress", "In review", "QA", "QA passed", "QA failed"]
# Khái niệm của bản 1.1–1.5, không có trong quy trình 1.0.
FORBIDDEN = [r"\bR11\b", r"\bG[1-5]\b", r"\b(?:status|type|risk|round|priority|size):[a-z]", r"\bhuman-code\b",
             r"Refs #", r"needs-human", r"Needs human", r"\b(?:9|11) tiêu chí", r"\b(?:9|11) criteria"]


def err(msg):
    errors.append(msg)


def read(rel):
    return (ROOT / rel).read_text(encoding="utf-8")


def files(*globs):
    out = []
    for g in globs:
        for p in ROOT.glob(g):
            if p.is_file() and "node_modules" not in p.parts and ".vitepress" not in p.parts:
                out.append(p)
    return out


cat = json.loads(read("skills/catalog.json"))
names = [s["name"] for s in cat["skills"]]

# 1. Đúng 8 skill của quy trình, thư mục khớp catalog.
if sorted(names) != sorted(PDF_SKILLS):
    err(f"catalog phải có đúng các skill của quy trình 1.0: {PDF_SKILLS}; đang có {names}")
dirs = sorted(p.parent.name for p in (ROOT / "skills").glob("*/SKILL.md"))
for d in sorted(set(dirs) - set(names)):
    err(f"skill '{d}' có thư mục nhưng thiếu trong catalog")
for n in sorted(set(names) - set(dirs)):
    err(f"skill '{n}' có trong catalog nhưng thiếu skills/{n}/SKILL.md")
if [c["name"] for c in cat.get("coding_standards", [])] != PDF_STANDARDS:
    err(f"catalog coding_standards phải là {PDF_STANDARDS}")
for c in cat.get("coding_standards", []):
    if not (ROOT / c["source"]).exists():
        err(f"thiếu {c['source']}")
    en = c["source"].replace("docs/", "docs/en/", 1)
    if not (ROOT / en).exists():
        err(f"thiếu {en}")

# 2. Cấu trúc từng SKILL.md.
for n in names:
    p = ROOT / "skills" / n / "SKILL.md"
    if not p.exists():
        continue
    t = p.read_text(encoding="utf-8")
    m = re.match(r"---\nname: ([a-z0-9-]+)\ndescription: (.+?)\n---\n", t, re.S)
    if not m or m.group(1) != n:
        err(f"{n}: frontmatter thiếu hoặc name không khớp thư mục")
    else:
        desc = m.group(2).strip()
        try:
            ok = desc.startswith('"') and isinstance(json.loads(desc), str) and json.loads(desc).strip()
        except ValueError:
            ok = False
        if not ok:
            err(f"{n}: description phải là chuỗi trong ngoặc kép, ví dụ description: \"...\"")
    if "docs/agents/contract.md" not in t:
        err(f"{n}: không yêu cầu đọc docs/agents/contract.md")
    if not re.search(r"^## Luật\s*$", t, re.M):
        err(f"{n}: thiếu mục '## Luật'")
    if not re.search(r"^> \*\*Vai trò:\*\*", t, re.M):
        err(f"{n}: thiếu khối header '> **Vai trò:**'")

# 3. Heading trong catalog phải có trong contract.
contract = read("docs/contract.md")
contract_heads = set(re.findall(r"`(## [^`]+)`", contract))
for s in cat["skills"]:
    for h in s["writes"] + s["reads"]:
        if h not in contract_heads:
            err(f"{s['name']}: heading '{h}' không có trong docs/contract.md")

# 4. Label kích hoạt trong catalog khớp route của wata-agent.
agent = read("template/.github/workflows/wata-agent.yml")
route = set()
for lbl, body in re.findall(r'^\s+"([^"]+)"\)\s*(.*?)(?:;;|$)', agent, re.M):
    for s in re.findall(r'(?:skill|next)="([a-z0-9-]+)"', body):
        route.add((lbl, s))
if '"In progress")' in agent and 'skill="github-issue-implement"' in agent:
    route.add(("In progress", "github-issue-implement"))
expected = {(lbl, s["name"]) for s in cat["skills"] for lbl in s["triggers"]}
for pair in sorted(expected - route):
    err(f"catalog: {pair[1]} kích hoạt bởi '{pair[0]}' nhưng wata-agent không định tuyến")
for pair in sorted(route - expected):
    err(f"wata-agent định tuyến '{pair[0]}' → {pair[1]} nhưng catalog không khai báo")

# 5. dev-pipeline biết mọi skill.
dp = read("skills/dev-pipeline/SKILL.md")
for n in names:
    if n != "dev-pipeline" and f"`{n}`" not in dp:
        err(f"dev-pipeline không nhắc tới skill '{n}'")

# 6. Label: đúng 8 trạng thái của quy trình; mọi trạng thái có trong contract và process.
labels = re.findall(r'name: "([^"]+)"', read("template/.github/labels.yml"))
status = [l for l in labels if l in PDF_STATUSES]
if status != PDF_STATUSES:
    err(f"labels.yml phải có đúng 8 trạng thái theo thứ tự {PDF_STATUSES}; đang có {status}")
for st in PDF_STATUSES:
    if f"`{st}`" not in contract:
        err(f"docs/contract.md thiếu trạng thái `{st}`")
    if f"| {st} |" not in read("docs/process.md"):
        err(f"docs/process.md mục 4 thiếu trạng thái '{st}'")

# 7. Tên skill trong tài liệu quy trình đúng như PDF mục 3.2.
proc = read("docs/process.md")
for n in PDF_SKILLS:
    if f"`{n}`" not in proc:
        err(f"docs/process.md mục 3.2 thiếu skill `{n}`")

# 8. Phiên bản: bộ công cụ thống nhất; tài liệu quy trình là 1.0.
versions = {
    "VERSION": read("VERSION").strip(),
    "catalog": cat["version"],
    "plugin.json": json.loads(read(".claude-plugin/plugin.json"))["version"],
    "package.json": json.loads(read("package.json"))["version"],
    "project.yml": re.search(r'process_version:\s*"([^"]+)"', read("template/.claude/project.yml")).group(1),
    "CHANGELOG": re.search(r"^## (\d+\.\d+\.\d+)", read("CHANGELOG.md"), re.M).group(1),
}
if len(set(versions.values())) != 1:
    err(f"phiên bản bộ công cụ lệch: {versions}")
for f, pat in {"docs/process.md": "Phiên bản: 1.0", "docs/scrum.md": "Phiên bản: 1.0",
               "docs/en/process.md": "Version: 1.0", "docs/en/scrum.md": "Version: 1.0"}.items():
    if pat not in read(f):
        err(f"{f}: thiếu '{pat}'")
cfg = read("docs/.vitepress/config.mts")
short = ".".join(versions["VERSION"].split(".")[:2])
for pat in (f"copyright: 'Phiên bản {short}'", f"copyright: 'Version {short}'"):
    if pat not in cfg:
        err(f"docs/.vitepress/config.mts: thiếu '{pat}'")

# 9. Không còn khái niệm của bản 1.1–1.5 (ngoài CHANGELOG).
for p in files("skills/**/*.md", "template/**/*", "template/**/.*", "template/.github/**/*", "template/.claude/*",
               "docs/**/*.md", "README.md", "scripts/*.sh"):
    text = p.read_text(encoding="utf-8", errors="ignore")
    for pat in FORBIDDEN:
        m = re.search(pat, text)
        if m:
            err(f"{p.relative_to(ROOT)}: còn '{m.group(0)}' (không có trong quy trình 1.0)")

# 10. Tên skill đã bỏ (catalog "retired") không còn được gọi như skill.
retired = cat.get("retired", {})
for p in files("skills/**/*.md", "template/**/*", "template/.github/**/*", "docs/**/*.md", "README.md"):
    text = p.read_text(encoding="utf-8", errors="ignore")
    for old in retired:
        if re.search(r"[`/]" + re.escape(old) + r"(?:`| <| --)", text):
            err(f"{p.relative_to(ROOT)}: còn gọi skill đã bỏ '{old}'")
for old in retired:
    if (ROOT / "skills" / old).exists():
        err(f"skills/{old}/ vẫn còn dù '{old}' không thuộc quy trình 1.0")

# 11. Song ngữ.
docs = ROOT / "docs"


def pages(base, skip_en):
    out = set()
    for p in base.rglob("*.md"):
        rel = p.relative_to(base)
        if ".vitepress" in rel.parts or "public" in rel.parts or (skip_en and rel.parts[0] == "en"):
            continue
        out.add(str(rel))
    return out


vi_pages, en_pages = pages(docs, True), pages(docs / "en", False)
for p in sorted(vi_pages - en_pages):
    err(f"docs/{p} chưa có bản tiếng Anh docs/en/{p}")
for p in sorted(en_pages - vi_pages):
    err(f"docs/en/{p} không có bản tiếng Việt docs/{p}")

# 12. Coding standard trong thư mục của mỗi app.
for std in re.findall(r"^\s+standard:\s*(\S+)", read("template/.claude/project.yml"), re.M):
    if not re.fullmatch(r"apps/[a-z0-9-]+/CODING_STANDARD\.md", std):
        err(f"project.yml: standard '{std}' phải nằm trong thư mục app (apps/<app>/CODING_STANDARD.md)")

# 13. Phần sinh tự động chưa được sinh lại.
spec = importlib.util.spec_from_file_location("sync_skills", ROOT / "scripts/sync-skills.py")
sync = importlib.util.module_from_spec(spec)
spec.loader.exec_module(sync)
sync.DRY = True
sync.run_all()
for f in sync.STALE:
    err(f"{f}: lệch với catalog; chạy python3 -I scripts/sync-skills.py")

if errors:
    print(f"FAIL — {len(errors)} lỗi:")
    for e in errors:
        print("  -", e)
    sys.exit(1)
print(f"OK — {len(names)} skill, {len(PDF_STATUSES)} trạng thái, bộ công cụ {versions['VERSION']}, quy trình 1.0")
