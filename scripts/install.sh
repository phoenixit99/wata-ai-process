#!/usr/bin/env bash
# Cài bộ quy trình WATA AI Agent vào repo của một project.
#
#   scripts/install.sh <project-dir>            cài lần đầu: không ghi đè file đã có
#   scripts/install.sh <project-dir> --upgrade  nâng cấp: ghi đè lớp lõi, xoá skill đã bỏ
#   scripts/install.sh <project-dir> --check    kiểm tra cấu hình project; chỉ đọc
#
# Lớp lõi (thuộc repo trung tâm, ghi đè khi --upgrade):
#   .claude/skills/*, docs/agents/* (contract + tài liệu quy trình),
#   .github/workflows/wata-*.yml, .github/labels.yml
#   — đây là nơi chứa tên label, heading và luật chuyển trạng thái; phải cùng phiên bản với nhau.
# Lớp cấu hình (thuộc project, không bao giờ ghi đè):
#   .claude/project.yml, .claude/settings.json, CLAUDE.md, .mcp.json, .github/CODEOWNERS,
#   .github/ISSUE_TEMPLATE/*, .github/pull_request_template.md, .github/workflows/ci.yml,
#   apps/<app>/CODING_STANDARD.md (coding standard đặt trong thư mục của mỗi app)
#   — khi nâng cấp, so sánh tay với template mới.
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST="${1:?Cách dùng: install.sh <project-dir> [--upgrade|--check]}"
MODE="${2:-install}"
DEST="$(cd "$DEST" && pwd)"
VERSION="$(cat "$SRC/VERSION")"

[ -d "$DEST/.git" ] || { echo "Lỗi: $DEST không phải git repo." >&2; exit 1; }
[ "$DEST" != "$SRC" ] || { echo "Lỗi: không cài vào chính repo quy trình." >&2; exit 1; }

UPGRADE=false
[ "$MODE" = "--upgrade" ] && UPGRADE=true
case "$MODE" in install|--upgrade|--check) ;; *) echo "Lỗi: tham số không hợp lệ '$MODE'." >&2; exit 1 ;; esac

# ---------------------------------------------------------------------------------------------
# --check: kiểm tra cấu hình project đã đủ cho quy trình (chỉ đọc, không in giá trị secret).
# ---------------------------------------------------------------------------------------------
if [ "$MODE" = "--check" ]; then
  cd "$DEST"
  pass=0; fail=0
  ok()  { printf '  [OK]    %-3s %s\n' "$1" "$2"; pass=$((pass+1)); }
  bad() { printf '  [THIẾU] %-3s %s  → %s\n' "$1" "$2" "$3"; fail=$((fail+1)); }
  repo=$(sed -n 's/^repo: *//p' .claude/project.yml 2>/dev/null | tr -d '"')
  echo "Kiểm tra cấu hình — $(basename "$DEST") — $(date +%Y-%m-%d)"

  pinned=$(sed -n 's/^process_version: *"\{0,1\}\([^"]*\)"\{0,1\}.*/\1/p' .claude/project.yml 2>/dev/null)
  installed=$(cat docs/agents/VERSION 2>/dev/null || true)
  [ -n "$installed" ] && [ "$installed" = "$pinned" ] && ok C1 "Bộ quy trình v$installed đã cài, khớp project.yml" \
    || bad C1 "Phiên bản" "docs/agents/VERSION='$installed', process_version='$pinned'"
  grep -qE '<owner>|<repo>' .claude/project.yml 2>/dev/null && bad C2 "project.yml" "còn <owner>/<repo>" || ok C2 "project.yml đã điền repo"
  missing_std=""
  for f in $(sed -n 's/^ *standard: *\([^ #]*\).*/\1/p' .claude/project.yml 2>/dev/null | sort -u); do
    [ -f "$f" ] || missing_std="$missing_std $f"
  done
  [ -z "$missing_std" ] && ok C3 "Coding standard trong thư mục từng app" || bad C3 "Coding standard" "thiếu:${missing_std}"
  grep -q '<TÊN PROJECT>\|<lệnh>' CLAUDE.md 2>/dev/null && bad C4 "CLAUDE.md" "còn placeholder" || ok C4 "CLAUDE.md đã điền"
  if [ -f .mcp.json ] && grep -qi github .mcp.json && grep -qi figma .mcp.json && grep -qi playwright .mcp.json; then ok C5 "MCP: GitHub, Figma, Playwright"
  else bad C5 "MCP" ".mcp.json thiếu GitHub/Figma/Playwright"; fi
  if command -v gh >/dev/null && gh auth status >/dev/null 2>&1 && [ -n "$repo" ] && [ "${repo#*<}" = "$repo" ]; then
    want=$(sed -n 's/^ *- *{name: *"\([^"]*\)".*/\1/p' .github/labels.yml | sort)
    have=$(gh label list --repo "$repo" --limit 300 --json name --jq '.[].name' 2>/dev/null | sort || true)
    lack=$(comm -23 <(echo "$want") <(echo "$have") | tr '\n' ',')
    [ -z "$lack" ] && ok C6 "Label trạng thái và loại công việc đủ" || bad C6 "Label" "thiếu: ${lack%,} (chạy scripts/setup-labels.sh)"
  else
    bad C6 "Label" "gh chưa đăng nhập hoặc thiếu repo; không kiểm được"
  fi
  echo
  echo "Kết quả: $pass đạt, $fail thiếu."
  [ "$fail" -eq 0 ]; exit $?
fi
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

# Điền repo: <owner>/<repo> từ remote origin trên GitHub. Chỉ thay placeholder, không đụng giá trị đã điền.
yml="$DEST/.claude/project.yml"
if [ -f "$yml" ] && grep -q '^repo: *<owner>/<repo>' "$yml"; then
  url="$(git -C "$DEST" remote get-url origin 2>/dev/null || true)"
  slug="$(printf '%s' "$url" | sed -nE 's#^(git@github\.com:|ssh://git@github\.com/|https://github\.com/)([^/]+/[^/]+)$#\2#p' | sed 's/\.git$//')"
  if [ -n "$slug" ]; then
    sed -i.bak "s#^repo: *<owner>/<repo>#repo: $slug#" "$yml" && rm -f "$yml.bak"
    echo "  ~ .claude/project.yml: repo: $slug (từ git remote origin)"
  fi
fi

echo "Coding standard (bản khởi đầu, đặt trong thư mục của mỗi app; Tech Lead chỉnh):"
# Mỗi app trong .claude/project.yml nhận <stack>-coding-standard tại đường dẫn apps[].standard.
while IFS=$'\t' read -r stack std; do
  srcf="$SRC/docs/coding-standards/$stack-coding-standard.md"
  if [ -f "$srcf" ] && [ -n "$std" ]; then place "$srcf" "$DEST/$std" config
  else echo "  ! không có coding standard khởi đầu cho stack '$stack' ($std)"; fi
done < <(python3 -I - "$DEST/.claude/project.yml" <<'PY'
import re, sys
apps, in_apps = [], False
for line in open(sys.argv[1], encoding="utf-8"):
    if re.match(r"^apps:\s*$", line):
        in_apps = True; continue
    if in_apps and re.match(r"^\S", line):
        break
    if in_apps and re.match(r"^\s*-\s", line):
        apps.append({})
    m = re.match(r"^[\s-]+(stack|standard):\s*([^\s#]+)", line)
    if in_apps and apps and m:
        apps[-1][m.group(1)] = m.group(2)
for a in apps:
    print(f"{a.get('stack', '')}\t{a.get('standard', '')}")
PY
)

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

if $UPGRADE; then
  # Skill của bản 1.2–1.5 (catalog "retired"): xoá để Claude Code không nạp skill không còn trong quy trình.
  for name in $(python3 -I -c 'import json,sys; print(" ".join(json.load(open(sys.argv[1])).get("retired", {})))' "$SRC/skills/catalog.json"); do
    if [ -d "$DEST/.claude/skills/$name" ]; then
      rm -rf "$DEST/.claude/skills/$name"
      echo "  - .claude/skills/$name/ (không còn trong quy trình 1.0, xem CHANGELOG)"
    fi
  done
fi

if $UPGRADE; then
  # File lõi của bản 1.2–1.5 không còn trong quy trình 1.0 (workflow và tài liệu do script này cài trước đây).
  for rel in .github/workflows/wata-status-guard.yml .github/workflows/wata-sla-reminder.yml \
             .github/workflows/wata-pr-merged.yml .github/workflows/wata-mention.yml \
             docs/agents/raci.md docs/agents/risk-tiers.md docs/agents/sprint-0.md \
             docs/agents/definition-of-done.md docs/agents/glossary.md docs/agents/roles \
             docs/agents/en/raci.md docs/agents/en/risk-tiers.md docs/agents/en/sprint-0.md \
             docs/agents/en/definition-of-done.md docs/agents/en/glossary.md docs/agents/en/roles \
             docs/agents/en/coding-standards; do
    if [ -e "$DEST/$rel" ]; then rm -rf "${DEST:?}/$rel"; echo "  - $rel (không còn trong quy trình 1.0)"; fi
  done
fi

echo "Contract và tài liệu quy trình (docs/agents/):"
while IFS= read -r -d '' f; do
  rel="${f#$SRC/docs/}"
  case "$rel" in coding-standards/*|en/coding-standards/*|index.md|en/index.md|public/*|.vitepress/*) continue ;; esac
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
