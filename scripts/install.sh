#!/usr/bin/env bash
# Cài bộ quy trình WATA AI Agent vào repo của một project.
#
#   scripts/install.sh <project-dir>            cài lần đầu: không ghi đè file đã có
#   scripts/install.sh <project-dir> --upgrade  nâng cấp: ghi đè lớp lõi, xoá skill đã bỏ
#   scripts/install.sh <project-dir> --check    kiểm tra Sprint 0 (S1–S15, docs/sprint-0.md); chỉ đọc
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
# --check: checklist Sprint 0 (thay skill kiểm tra Sprint 0 trước v1.5.0). Chỉ đọc, không in giá trị secret.
# Mục cần người trả lời (S3, S13, S14, S15) được liệt kê để Tech Lead/PM/Security xác nhận.
# ---------------------------------------------------------------------------------------------
if [ "$MODE" = "--check" ]; then
  cd "$DEST"
  pass=0; fail=0; ask=0
  ok()   { printf '  [OK]   %-4s %s\n' "$1" "$2"; pass=$((pass+1)); }
  bad()  { printf '  [THIẾU] %-4s %s  → %s\n' "$1" "$2" "$3"; fail=$((fail+1)); }
  need() { printf '  [HỎI]  %-4s %s  → %s\n' "$1" "$2" "$3"; ask=$((ask+1)); }
  has_gh=false; command -v gh >/dev/null && gh auth status >/dev/null 2>&1 && has_gh=true
  repo=$(sed -n 's/^repo: *//p' .claude/project.yml 2>/dev/null | tr -d '"')
  echo "Sprint 0 — $(basename "$DEST") — $(date +%Y-%m-%d)"
  $has_gh || echo "  (gh chưa đăng nhập: S7, S8, S10 không kiểm được bằng lệnh)"

  pinned=$(sed -n 's/^process_version: *"\{0,1\}\([^"]*\)"\{0,1\}.*/\1/p' .claude/project.yml 2>/dev/null)
  installed=$(cat docs/agents/VERSION 2>/dev/null || true)
  [ -n "$installed" ] && [ "$installed" = "$pinned" ] && ok S1 "Quy trình v$installed đã cài, khớp project.yml" \
    || bad S1 "Phiên bản quy trình" "docs/agents/VERSION='$installed', process_version='$pinned' (Tech Lead)"
  if grep -qE '<owner>|<repo>' .claude/project.yml 2>/dev/null; then bad S2 "project.yml" "còn <owner>/<repo> (Tech Lead, PM)"
  elif grep -qE '^\s+(po|tech_lead|qa|pm): \[\]' .claude/project.yml; then bad S2 "project.yml" "people.* còn trống (PM)"
  else ok S2 "project.yml đã điền"; fi
  need S3 "Lệnh lint/typecheck/test/build chạy được" "Tech Lead chạy thử từng lệnh trong apps[].commands"
  missing_std=""
  for f in $(sed -n 's/^ *standard: *//p' .claude/project.yml 2>/dev/null | sort -u); do
    [ -f "$f" ] || missing_std="$missing_std $f"; grep -q "Bản khởi đầu" "$f" 2>/dev/null && missing_std="$missing_std $f(chưa chỉnh)"
  done
  [ -z "$missing_std" ] && ok S4 "Coding standard cho từng app" || bad S4 "Coding standard" "${missing_std# } (Tech Lead)"
  ds=$(sed -n 's/^design_system: *\([^ #]*\).*/\1/p' .claude/project.yml 2>/dev/null)
  if [ -n "$ds" ] && [ -f "$ds" ] && ! grep -qE '<[^>]*>' "$ds"; then ok S5 "Design system ($ds)"
  else bad S5 "Design system" "${ds:-chưa khai báo} thiếu hoặc còn phần mẫu <...> (Designer)"; fi
  grep -q '<TÊN PROJECT>\|<lệnh>' CLAUDE.md 2>/dev/null && bad S6 "CLAUDE.md" "còn placeholder (Tech Lead)" || ok S6 "CLAUDE.md đã điền"
  if $has_gh && [ -n "$repo" ]; then
    want=$(sed -n 's/^ *- *name: *"\([^"]*\)".*/\1/p' .github/labels.yml | sort)
    have=$(gh label list --repo "$repo" --limit 300 --json name --jq '.[].name' 2>/dev/null | sort || true)
    lack=$(comm -23 <(echo "$want") <(echo "$have") | tr '\n' ' ')
    [ -z "$lack" ] && ok S7 "Label đủ" || bad S7 "Label" "thiếu: $lack(PM: scripts/setup-labels.sh)"
    prot=$(gh api "repos/$repo/branches/main/protection" 2>/dev/null || true)
    echo "$prot" | grep -q '"require_code_owner_reviews":true' && echo "$prot" | grep -q '"required_status_checks"' \
      && ok S8 "Branch protection trên main" || bad S8 "Branch protection" "cần PR, CODEOWNERS, required checks, cấm force-push (Tech Lead, Security)"
    secrets=$(gh secret list --repo "$repo" 2>/dev/null | awk '{print $1}' || true); vars=$(gh variable list --repo "$repo" 2>/dev/null | awk '{print $1}' || true)
    s10=""; for n in WATA_APP_PRIVATE_KEY ANTHROPIC_API_KEY; do echo "$secrets" | grep -qx "$n" || s10="$s10 secret:$n"; done
    echo "$vars" | grep -qx WATA_APP_ID || s10="$s10 var:WATA_APP_ID"
    [ -z "$s10" ] && ok S10 "GitHub App và secret (chỉ kiểm tên)" || bad S10 "GitHub App/secret" "thiếu${s10} (Security)"
  else
    need S7 "Label" "gh chưa đăng nhập hoặc thiếu repo trong project.yml"
    need S8 "Branch protection" "kiểm trên GitHub (Tech Lead, Security)"
    need S10 "GitHub App và secret" "kiểm tên trên GitHub (Security)"
  fi
  grep -q '@<org>' .github/CODEOWNERS 2>/dev/null && bad S9 "CODEOWNERS" "còn @<org>/... (Tech Lead)" \
    || { [ -f .github/CODEOWNERS ] && ok S9 "CODEOWNERS" || bad S9 "CODEOWNERS" "chưa có file (Tech Lead)"; }
  if ls .github/workflows/wata-*.yml >/dev/null 2>&1 && ! grep -q 'TODO(project)' .github/workflows/wata-agent.yml; then ok S11 "Workflow wata-* và toolchain"
  else bad S11 "Workflow" "thiếu wata-*.yml hoặc còn bước TODO(project) trong wata-agent.yml (Tech Lead)"; fi
  if [ -f .mcp.json ] && grep -qi github .mcp.json && grep -qi figma .mcp.json && grep -qi playwright .mcp.json; then ok S12 "MCP: GitHub, Figma, Playwright"
  else bad S12 "MCP" ".mcp.json thiếu GitHub/Figma/Playwright (AI Enablement)"; fi
  need S13 "Chính sách dữ liệu" "hợp đồng cho phép dùng AI; không đưa dữ liệu thật vào prompt (Security, PM)"
  need S14 "DoR/DoD" "team đã đọc và đồng ý docs/agents/definition-of-done.md và R1–R11 (PM)"
  need S15 "Số liệu nền" "lead time và lỗi sau release của 1–2 sprint gần nhất đã ghi (PM)"

  echo
  echo "Kết quả: $pass đạt, $fail thiếu, $ask cần người xác nhận."
  [ "$fail" -eq 0 ] && echo "Sẵn sàng cho sprint 1 khi các mục HỎI đã được xác nhận." || echo "Chưa sẵn sàng: còn $fail mục thiếu."
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

if $UPGRADE; then
  # Skill đã bỏ hoặc đã gộp (catalog "retired"): xoá để Claude Code không nạp cả bản cũ lẫn bản mới.
  for name in $(python3 -I -c 'import json,sys; print(" ".join(json.load(open(sys.argv[1])).get("retired", {})))' "$SRC/skills/catalog.json"); do
    if [ -d "$DEST/.claude/skills/$name" ]; then
      rm -rf "$DEST/.claude/skills/$name"
      echo "  - .claude/skills/$name/ (đã gộp, xem CHANGELOG)"
    fi
  done
fi

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
