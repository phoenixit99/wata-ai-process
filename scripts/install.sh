#!/usr/bin/env bash
# Cài bộ quy trình WATA AI Agent vào repo của một project.
#
#   scripts/install.sh <project-dir>            cài lần đầu: không ghi đè file đã có
#   scripts/install.sh <project-dir> --upgrade  nâng cấp: ghi đè lớp lõi
#
# Lớp lõi (thuộc repo trung tâm, ghi đè khi --upgrade):
#   .claude/skills/*, docs/agents/* (contract + tài liệu quy trình),
#   .github/workflows/wata-*.yml, .github/labels.yml
#   — đây là nơi chứa tên label, heading và luật chuyển trạng thái; phải cùng phiên bản với nhau.
# Lớp cấu hình (thuộc project, không bao giờ ghi đè):
#   .claude/project.yml, .claude/settings.json, CLAUDE.md, .mcp.json, .github/CODEOWNERS,
#   .github/ISSUE_TEMPLATE/*, .github/pull_request_template.md, .github/workflows/ci.yml,
#   docs/coding-standards/*
#   — khi nâng cấp, so sánh tay với template mới.
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST="${1:?Cách dùng: install.sh <project-dir> [--upgrade]}"
MODE="${2:-install}"
DEST="$(cd "$DEST" && pwd)"
VERSION="$(cat "$SRC/VERSION")"

[ -d "$DEST/.git" ] || { echo "Lỗi: $DEST không phải git repo." >&2; exit 1; }
[ "$DEST" != "$SRC" ] || { echo "Lỗi: không cài vào chính repo quy trình." >&2; exit 1; }

UPGRADE=false
[ "$MODE" = "--upgrade" ] && UPGRADE=true
skipped=()

is_core_template() {   # đường dẫn tương đối trong template/
  case "$1" in
    .github/workflows/wata-*.yml|.github/labels.yml) return 0 ;;
    *) return 1 ;;
  esac
}

place() {   # $1 nguồn, $2 đích, $3 core|config
  local src="$1" dst="$2" layer="$3"
  if [ -e "$dst" ] && { [ "$layer" = config ] || ! $UPGRADE; }; then
    skipped+=("${dst#$DEST/}")
    return
  fi
  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
  echo "  + ${dst#$DEST/}"
}

echo "Cài WATA AI dev process v$VERSION vào $DEST ($MODE)"

echo "Template:"
while IFS= read -r -d '' f; do
  rel="${f#$SRC/template/}"
  if is_core_template "$rel"; then place "$f" "$DEST/$rel" core; else place "$f" "$DEST/$rel" config; fi
done < <(find "$SRC/template" -type f -print0)

echo "Coding standards (bản khởi đầu, project tự chỉnh):"
for f in "$SRC"/docs/coding-standards/*.md; do
  place "$f" "$DEST/docs/coding-standards/$(basename "$f")" config
done

echo "Skills:"
mkdir -p "$DEST/.claude/skills"
for d in "$SRC"/skills/*/; do
  name="$(basename "$d")"
  if [ -e "$DEST/.claude/skills/$name" ] && ! $UPGRADE; then
    skipped+=(".claude/skills/$name/")
  else
    rm -rf "$DEST/.claude/skills/$name"
    cp -R "$d" "$DEST/.claude/skills/$name"
    echo "  + .claude/skills/$name/"
  fi
done

echo "Contract và tài liệu quy trình (docs/agents/):"
while IFS= read -r -d '' f; do
  rel="${f#$SRC/docs/}"
  case "$rel" in coding-standards/*|index.md|en/index.md|public/*|.vitepress/*) continue ;; esac
  place "$f" "$DEST/docs/agents/$rel" core
done < <(find "$SRC/docs" -path "$SRC/docs/.vitepress" -prune -o -type f -name '*.md' -print0)
printf '%s\n' "$VERSION" > "$DEST/docs/agents/VERSION"
cp "$SRC/skills/catalog.json" "$DEST/docs/agents/skill-catalog.json"

if $UPGRADE && [ -f "$DEST/.claude/project.yml" ]; then
  echo
  echo "Nhớ cập nhật process_version trong .claude/project.yml thành \"$VERSION\" và đọc CHANGELOG.md."
fi

if [ ${#skipped[@]} -gt 0 ]; then
  echo
  echo "Bỏ qua (đã tồn tại, so sánh và gộp tay nếu cần):"
  printf '  - %s\n' "${skipped[@]}"
fi

echo
echo "Tiếp theo: làm theo docs/agents/setup-guide.md từ mục 2."
