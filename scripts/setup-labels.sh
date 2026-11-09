#!/usr/bin/env bash
# Tạo (hoặc cập nhật) bộ label của quy trình trên một repo GitHub.
#   scripts/setup-labels.sh <owner>/<repo> [đường-dẫn/project.yml]
# Cần: gh (đã đăng nhập), python3.
set -euo pipefail

REPO="${1:?Cách dùng: setup-labels.sh <owner>/<repo> [project.yml]}"
PROJECT_YML="${2:-.claude/project.yml}"
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LABELS="$SRC/template/.github/labels.yml"

# labels.yml dùng dạng {name: "...", color: "...", description: "..."} mỗi dòng.
python3 -I - "$LABELS" <<'EOF' | while IFS=$'\t' read -r name color desc; do
import re, sys
for line in open(sys.argv[1], encoding="utf-8"):
    m = re.match(r'\s*-\s*\{name:\s*"([^"]+)",\s*color:\s*"([0-9a-fA-F]{6})",\s*description:\s*"([^"]*)"\}', line)
    if m:
        print("\t".join(m.groups()))
EOF
  gh label create "$name" --repo "$REPO" --color "$color" --description "$desc" --force >/dev/null
  echo "  ✓ $name"
done

# Label app:<name> lấy từ apps[].name trong project.yml.
if [ -f "$PROJECT_YML" ]; then
  python3 -I - "$PROJECT_YML" <<'EOF' | while read -r app; do
import re, sys
in_apps = False
for line in open(sys.argv[1], encoding="utf-8"):
    if re.match(r'^apps:\s*$', line):
        in_apps = True
        continue
    if in_apps and re.match(r'^\S', line):
        break
    m = re.match(r'^\s*-\s*name:\s*([A-Za-z0-9_-]+)', line)
    if in_apps and m:
        print(m.group(1))
EOF
    gh label create "app:$app" --repo "$REPO" --color "0052cc" --description "App $app" --force >/dev/null
    echo "  ✓ app:$app"
  done
else
  echo "Không thấy $PROJECT_YML; bỏ qua label app:*."
fi
