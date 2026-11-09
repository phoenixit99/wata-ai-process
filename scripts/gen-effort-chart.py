#!/usr/bin/env python3
"""Sinh biểu đồ effort (truyền thống và có AI) cho trang Scrum, bản tiếng Việt và tiếng Anh.

Số liệu theo tài liệu "Quy trình Scrum ứng dụng AI Agent" v1.0, mục 7 (tổng truyền thống = 100 đơn vị).
Chạy:  python3 -I scripts/gen-effort-chart.py   → docs/public/effort-vi.svg, docs/public/effort-en.svg
"""
import html
import pathlib

ROOT = pathlib.Path(__file__).resolve().parent.parent

# (nhãn VI, nhãn EN, truyền thống, có AI)
ROWS = [
    ("Khám phá & yêu cầu", "Discovery & requirements", 10, 12),
    ("Refinement & DoR", "Refinement & DoR", 5, 8),
    ("Sprint planning", "Sprint planning", 3, 3),
    ("Thiết kế UI & kiến trúc", "UI design & architecture", 8, 6),
    ("Lập trình", "Coding", 40, 12),
    ("Unit test", "Unit tests", 7, 2),
    ("Code review", "Code review", 5, 7),
    ("Test case & QA thủ công", "Test cases & manual QA", 10, 5),
    ("Automation test", "Test automation", 5, 2),
    ("CI/CD & triển khai", "CI/CD & deployment", 3, 2),
    ("Sprint review & UAT", "Sprint review & UAT", 4, 5),
    ("Vận hành nền tảng AI (mới)", "AI platform operations (new)", 0, 4),
]
assert sum(r[2] for r in ROWS) == 100 and sum(r[3] for r in ROWS) == 68

TXT = {
    "vi": {"title": "Effort theo giai đoạn: Scrum truyền thống và có AI", "trad": "Truyền thống", "ai": "Có AI",
           "axis": "Effort (đơn vị, tổng truyền thống = 100)", "new": "mới", "total": "Tổng: 100 → 68 (−32%)"},
    "en": {"title": "Effort by stage: traditional Scrum vs with AI", "trad": "Traditional", "ai": "With AI",
           "axis": "Effort (units, traditional total = 100)", "new": "new", "total": "Total: 100 → 68 (−32%)"},
}

GREY, RED, INK, MUTED, GRID = "#c9c4c0", "#9e1b20", "#2b2b2b", "#6b6b6b", "#e6e2df"


def chart(lang):
    t = TXT[lang]
    left, width, top, row_h, bar_h = 230, 560, 70, 34, 11
    scale = width / 40
    h = top + len(ROWS) * row_h + 70
    out = [f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 900 {h}" role="img" aria-label="{t["title"]}" '
           f'font-family="Inter, system-ui, sans-serif" font-size="13">',
           f'<rect width="900" height="{h}" fill="#ffffff"/>',
           f'<text x="24" y="32" font-size="16" font-weight="600" fill="{INK}">{t["title"]}</text>',
           f'<text x="24" y="54" fill="{MUTED}">{t["total"]}</text>']
    for v in range(0, 41, 10):
        x = left + v * scale
        out.append(f'<line x1="{x}" y1="{top - 8}" x2="{x}" y2="{top + len(ROWS) * row_h}" stroke="{GRID}"/>')
        out.append(f'<text x="{x}" y="{top + len(ROWS) * row_h + 18}" text-anchor="middle" fill="{MUTED}" font-size="11.5">{v}</text>')
    for i, (vi, en, trad, ai) in enumerate(ROWS):
        y = top + i * row_h
        label = html.escape(vi if lang == "vi" else en)
        out.append(f'<text x="{left - 12}" y="{y + 15}" text-anchor="end" fill="{INK}">{label}</text>')
        out.append(f'<rect x="{left}" y="{y + 2}" width="{trad * scale:.1f}" height="{bar_h}" rx="2" fill="{GREY}"/>')
        out.append(f'<rect x="{left}" y="{y + 2 + bar_h + 2}" width="{ai * scale:.1f}" height="{bar_h}" rx="2" fill="{RED}"/>')
        change = t["new"] if trad == 0 else (f"{round((ai - trad) / trad * 100):+d}%" if ai != trad else "0%")
        colour = RED if (trad == 0 or ai > trad) else MUTED
        out.append(f'<text x="{left + max(trad, ai) * scale + 8:.1f}" y="{y + 18}" fill="{colour}" font-weight="600" '
                   f'font-size="12">{change.replace("-", "−")}</text>')
    ly = top + len(ROWS) * row_h + 44
    out.append(f'<text x="{left + width / 2}" y="{ly}" text-anchor="middle" fill="{MUTED}" font-size="11.5">{t["axis"]}</text>')
    gy = 50  # chú thích ở góc trên bên phải, không đè nhãn trục
    out.append(f'<rect x="{left + width - 170}" y="{gy - 10}" width="12" height="12" fill="{GREY}"/>'
               f'<text x="{left + width - 152}" y="{gy}" fill="{INK}" font-size="12">{t["trad"]}</text>'
               f'<rect x="{left + width - 70}" y="{gy - 10}" width="12" height="12" fill="{RED}"/>'
               f'<text x="{left + width - 52}" y="{gy}" fill="{INK}" font-size="12">{t["ai"]}</text>')
    out.append("</svg>")
    return "\n".join(out) + "\n"


if __name__ == "__main__":
    for lang in ("vi", "en"):
        p = ROOT / "docs/public" / f"effort-{lang}.svg"
        p.write_text(chart(lang), encoding="utf-8")
        print("wrote", p.relative_to(ROOT))
