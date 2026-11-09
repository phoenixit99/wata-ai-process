#!/usr/bin/env python3
"""Kiểm tra skill, workflow, contract và tài liệu đồng bộ với skills/catalog.json.

Chạy:  python3 -I scripts/check-consistency.py      (thoát mã 1 nếu có lỗi)
"""
import importlib.util
import json
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
errors = []


def err(msg):
    errors.append(msg)


def read(rel):
    return (ROOT / rel).read_text(encoding="utf-8")


cat = json.loads(read("skills/catalog.json"))
names = [s["name"] for s in cat["skills"]]

# 1. Thư mục skill khớp catalog.
dirs = sorted(p.parent.name for p in (ROOT / "skills").glob("*/SKILL.md"))
for d in sorted(set(dirs) - set(names)):
    err(f"skill '{d}' có thư mục nhưng thiếu trong catalog")
for n in sorted(set(names) - set(dirs)):
    err(f"skill '{n}' có trong catalog nhưng thiếu skills/{n}/SKILL.md")
if len(names) != len(set(names)):
    err("catalog có tên skill trùng")

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
        # description phải là chuỗi trong ngoặc kép (JSON hợp lệ, cũng là YAML hợp lệ). Không có ngoặc,
        # một chuỗi ": " bên trong làm YAML hỏng và Claude Code không nạp được skill.
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
route = set(re.findall(r'((?:status|type):[a-z0-9-]+)\)\s+skill="([a-z0-9-]+)"', agent))
if "status:in-progress)" in agent and 'skill="implement"' in agent:
    route.add(("status:in-progress", "implement"))
expected = {(lbl, s["name"]) for s in cat["skills"] for lbl in s["triggers"]}
for pair in sorted(expected - route):
    err(f"catalog: {pair[1]} kích hoạt bởi {pair[0]} nhưng wata-agent không định tuyến")
for pair in sorted(route - expected):
    err(f"wata-agent định tuyến {pair[0]} → {pair[1]} nhưng catalog không khai báo")
dispatch = set(re.findall(r"^\s+([a-z0-9-]+)\)\s+has status:", agent, re.M))
for d in sorted(dispatch - {s["name"] for s in cat["skills"] if s["triggers"]}):
    err(f"wata-agent dispatch nhận '{d}' nhưng skill này không có trigger trong catalog")

# 5. Vai trò nào cũng có skill riêng (ngoài dev-pipeline), và có trang hướng dẫn.
for r in cat["roles"]:
    own = [s["name"] for s in cat["skills"] if r in s["roles"] and s["name"] != "dev-pipeline"]
    if not own:
        err(f"vai trò '{r}' không có skill riêng")
    if not (ROOT / "docs/roles" / f"{r}.md").exists():
        err(f"thiếu docs/roles/{r}.md")
    if (ROOT / "docs/en").exists() and not (ROOT / "docs/en/roles" / f"{r}.md").exists():
        err(f"thiếu docs/en/roles/{r}.md")

# 6. dev-pipeline biết mọi skill.
dp = read("skills/dev-pipeline/SKILL.md")
for n in names:
    if n != "dev-pipeline" and f"`{n}`" not in dp:
        err(f"dev-pipeline không nhắc tới skill '{n}'")

# 7. Phiên bản thống nhất.
versions = {
    "VERSION": read("VERSION").strip(),
    "catalog": cat["version"],
    "plugin.json": json.loads(read(".claude-plugin/plugin.json"))["version"],
    "project.yml": re.search(r'process_version:\s*"([^"]+)"', read("template/.claude/project.yml")).group(1),
    "CHANGELOG": re.search(r"^## (\d+\.\d+\.\d+)", read("CHANGELOG.md"), re.M).group(1),
}
if len(set(versions.values())) != 1:
    err(f"phiên bản lệch: {versions}")

# 8. Label dùng ở bất kỳ đâu phải có trong labels.yml.
defined = set(re.findall(r'name: "([^"]+)"', read("template/.github/labels.yml")))
for p in list((ROOT / "skills").rglob("*.md")) + list((ROOT / "template").rglob("*")) + list((ROOT / "docs").rglob("*.md")):
    if not p.is_file() or "node_modules" in p.parts:
        continue
    for lbl in set(re.findall(r"\b((?:status|type|risk|round|priority):[a-z0-9-]+)", p.read_text(encoding="utf-8", errors="ignore"))):
        if lbl not in defined:
            err(f"{p.relative_to(ROOT)}: label '{lbl}' không có trong labels.yml")

# 9. Song ngữ: mỗi trang tiếng Việt có bản tiếng Anh tương ứng và ngược lại.
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

# 10. Tên skill đã bỏ (catalog "retired") không còn xuất hiện ngoài CHANGELOG và catalog.
retired = cat.get("retired", {})
for p in list((ROOT / "skills").rglob("*.md")) + list((ROOT / "template").rglob("*")) + list((ROOT / "docs").rglob("*.md")) \
        + [ROOT / "README.md"] + list((ROOT / "scripts").glob("*")):
    if not p.is_file() or "node_modules" in p.parts or ".vitepress" in p.parts:
        continue
    text = p.read_text(encoding="utf-8", errors="ignore")
    for old in retired:
        if re.search(r"(?<![\w-])" + re.escape(old) + r"(?![\w-])", text):
            err(f"{p.relative_to(ROOT)}: còn tên skill đã bỏ '{old}' (dùng '{retired[old]}')")
for old in retired:
    if (ROOT / "skills" / old).exists():
        err(f"skills/{old}/ vẫn còn dù '{old}' đã bỏ")

# 11. Phần sinh tự động không bị sửa tay / chưa được sinh lại.
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
print(f"OK — {len(names)} skill, {len(cat['roles'])} vai trò, phiên bản {versions['VERSION']}")
