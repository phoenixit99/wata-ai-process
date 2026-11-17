#!/usr/bin/env python3
"""Sinh lại mọi phần phụ thuộc vào skills/catalog.json, để skill và tài liệu luôn đồng bộ.

Chạy:  python3 -I scripts/sync-skills.py
Sinh:
  - khối header "> **Vai trò:** ..." trong mỗi skills/<name>/SKILL.md
  - bảng skill trong README.md (giữa <!-- skills:start --> và <!-- skills:end -->)
  - docs/skills.md và docs/en/skills.md (danh mục skill và coding standard)
Sau đó chạy scripts/check-consistency.py để kiểm tra.
"""
import json
import pathlib
import re

ROOT = pathlib.Path(__file__).resolve().parent.parent
CAT = json.loads((ROOT / "skills/catalog.json").read_text(encoding="utf-8"))
REPO_URL = "https://github.com/phoenixit99/wata-ai-process/blob/main"

MODE = {
    "vi": {"interactive": "tương tác", "auto": "tự động", "both": "tự động + tương tác"},
    "en": {"interactive": "interactive", "auto": "automatic", "both": "automatic + interactive"},
}
T = {
    "vi": {"ai": "AI (tự động)", "caller": "người gọi", "auto": "tự động", "or": "hoặc", "none": "không ghi lên issue",
           "label": "label", "roles": "Vai trò", "step": "Bước", "mode": "Chế độ", "trigger": "Kích hoạt",
           "summary": "Dùng khi", "how": "Cách gọi", "skill": "Skill"},
    "en": {"ai": "AI (automatic)", "caller": "on demand", "auto": "automatic", "or": "or", "none": "no issue comment",
           "label": "label", "roles": "Roles", "step": "Step", "mode": "Mode", "trigger": "Trigger",
           "summary": "Purpose", "how": "How to call", "skill": "Skill"},
}


def role_names(roles, lang):
    if not roles:
        return T[lang]["ai"]
    return ", ".join(CAT["role_names"][r][lang] for r in roles)


def trigger_text(s, lang):
    t = T[lang]
    if s["triggers"]:
        labels = ", ".join(f"`{x}`" for x in s["triggers"])
        text = f"{t['label']} {labels} ({t['auto']})"
        return text + (f" {t['or']} {t['caller']}" if s["roles"] or s["mode"] == "both" else "")
    return t["caller"]


def header_line(s):
    reads = ", ".join(f"`{h}`" for h in s["reads"]) or "—"
    writes = ", ".join(f"`{h}`" for h in s["writes"]) or T["vi"]["none"]
    return (f"> **Vai trò:** {role_names(s['roles'], 'vi')} · **Bước:** {s['step']} · "
            f"**Chế độ:** {MODE['vi'][s['mode']]} · **Kích hoạt:** {trigger_text(s, 'vi')} · "
            f"**Đọc:** {reads} · **Ghi:** {writes}")


DRY = False      # check-consistency.py đặt True: chỉ ghi nhận file lệch, không ghi
STALE = []


def write_if_changed(path, text):
    old = path.read_text(encoding="utf-8") if path.exists() else None
    if old != text:
        if DRY:
            STALE.append(str(path.relative_to(ROOT)))
            return
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text, encoding="utf-8")
        print("  updated", path.relative_to(ROOT))


def sync_skill_headers():
    for s in CAT["skills"]:
        p = ROOT / "skills" / s["name"] / "SKILL.md"
        text = p.read_text(encoding="utf-8")
        line = header_line(s)
        if re.search(r"^> \*\*Vai trò:\*\*.*$", text, re.M):
            text = re.sub(r"^> \*\*Vai trò:\*\*.*$", lambda _: line, text, count=1, flags=re.M)
        else:
            text = re.sub(r"^(# .+\n)", lambda m: m.group(1) + "\n" + line + "\n", text, count=1, flags=re.M)
        write_if_changed(p, text)


def replace_block(text, start, end, body):
    block = f"{start}\n{body}\n{end}"
    if start in text:
        return re.sub(re.escape(start) + r".*?" + re.escape(end), lambda _: block, text, flags=re.S)
    return text.rstrip() + "\n\n" + block + "\n"


def skills_table(lang, link_prefix):
    t = T[lang]
    rows = [f"| {t['step']} | {t['skill']} | {t['summary']} | {t['roles']} | {t['trigger']} |",
            "|---|---|---|---|---|"]
    for s in CAT["skills"]:
        rows.append(f"| {s['step']} | [`{s['name']}`]({link_prefix}{s['name']}/SKILL.md) | {s['summary'][lang]} | "
                    f"{role_names(s['roles'], lang)} | {trigger_text(s, lang)} |")
    return "\n".join(rows)


def sync_readme():
    p = ROOT / "README.md"
    text = p.read_text(encoding="utf-8")
    text = replace_block(text, "<!-- skills:start -->", "<!-- skills:end -->", skills_table("vi", "skills/"))
    write_if_changed(p, text)


def sync_catalog_pages():
    pages = {
        "vi": (ROOT / "docs/skills.md", "# Danh mục skill",
               "Danh sách sinh tự động từ `skills/catalog.json`, nguồn duy nhất cho skill, vai trò và cách kích hoạt. "
               "Nội dung từng skill (dành cho AI) nằm trong repo; bấm vào tên để xem."),
        "en": (ROOT / "docs/en/skills.md", "# Skill catalog",
               "Generated from `skills/catalog.json`, the single source for skills, roles and triggers. "
               "Each skill's instructions (written for the AI, in Vietnamese) live in the repo; click a name to read it."),
    }
    for lang, (path, title, lead) in pages.items():
        if lang == "en" and not path.parent.exists():
            continue
        by_role = []
        for role in CAT["roles"]:
            names = ", ".join(f"`{s['name']}`" for s in CAT["skills"] if role in s["roles"])
            by_role.append(f"| {CAT['role_names'][role][lang]} | {names} |")
        role_head = "## Theo vai trò" if lang == "vi" else "## By role"
        all_head = "## Tất cả skill" if lang == "vi" else "## All skills"
        col = "| Vai trò | Skill |" if lang == "vi" else "| Role | Skills |"
        if lang == "vi":
            cs_head, cs_lead, cs_col = ("## Coding standard", "Coding standard riêng cho từng công nghệ, đặt trong thư mục "
                                        "của mỗi app (`apps/<app>/CODING_STANDARD.md`). AI bắt buộc đọc trước khi code và "
                                        "dùng khi review.", "| Tên | App | Bản khởi đầu |")
        else:
            cs_head, cs_lead, cs_col = ("## Coding standards", "One coding standard per technology, placed in each app's "
                                        "folder (`apps/<app>/CODING_STANDARD.md`). The AI must read it before coding and "
                                        "uses it when reviewing.", "| Name | Apps | Starter |")
        cs_rows = [f"| `{c['name']}` | {c['apps']} | [`{c['source']}`]({REPO_URL}/{c['source']}) |"
                   for c in CAT["coding_standards"]]
        body = "\n".join([
            "<!-- Sinh tự động bởi scripts/sync-skills.py. Không sửa tay. -->", "",
            title, "", lead, "", all_head, "", skills_table(lang, f"{REPO_URL}/skills/"), "",
            cs_head, "", cs_lead, "", cs_col, "|---|---|---|", *cs_rows, "",
            role_head, "", col, "|---|---|", *by_role, ""])
        write_if_changed(path, body)


def run_all():
    sync_skill_headers()
    sync_readme()
    sync_catalog_pages()


if __name__ == "__main__":
    run_all()
    print("sync done")
