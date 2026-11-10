#!/usr/bin/env bash
# Cài WATA AI dev process bằng một lệnh, chạy từ thư mục gốc của repo project:
#
#   curl -fsSL https://raw.githubusercontent.com/phoenixit99/wata-ai-process/main/scripts/bootstrap.sh | bash
#   curl -fsSL .../bootstrap.sh | bash -s -- --upgrade     # nâng cấp
#   curl -fsSL .../bootstrap.sh | bash -s -- --check       # kiểm tra Sprint 0
#
# Biến môi trường:
#   WATA_REF=v1.5.0   cài từ tag/nhánh cụ thể (mặc định: main). Nên ghim tag cho ổn định.
#   WATA_SRC=/path    dùng bản repo quy trình có sẵn trên máy, không tải (để thử nghiệm).
#
# Script tải repo quy trình vào thư mục tạm, chạy scripts/install.sh "$PWD" <chế độ>, rồi xoá thư mục tạm.
# Toàn bộ thân nằm trong hàm main gọi ở dòng cuối: tải dở dang thì không chạy gì.

main() {
  set -euo pipefail
  local repo="phoenixit99/wata-ai-process"
  local ref="${WATA_REF:-main}"
  local mode="${1:-install}"
  local src

  case "$mode" in install|--upgrade|--check) ;; *)
    echo "Lỗi: tham số không hợp lệ '$mode' (dùng: không tham số, --upgrade hoặc --check)." >&2; return 1 ;;
  esac

  local dest
  dest="$(git rev-parse --show-toplevel 2>/dev/null)" || {
    echo "Lỗi: $PWD không nằm trong git repo. Hãy cd vào thư mục repo project rồi chạy lại." >&2; return 1; }
  [ "$dest" = "$PWD" ] || echo "Lưu ý: cài vào gốc repo $dest (không phải $PWD)."

  local need
  for need in python3 tar; do
    command -v "$need" >/dev/null || { echo "Lỗi: cần cài '$need' trước." >&2; return 1; }
  done

  if [ -n "${WATA_SRC:-}" ]; then
    src="$(cd "$WATA_SRC" && pwd)"
    echo "Dùng repo quy trình tại $src"
  else
    command -v curl >/dev/null || { echo "Lỗi: cần cài 'curl' trước." >&2; return 1; }
    WATA_TMP="$(mktemp -d)"
    trap 'rm -rf "${WATA_TMP:-}"' EXIT
    echo "Tải $repo@$ref ..."
    curl -fsSL "https://codeload.github.com/$repo/tar.gz/$ref" | tar -xz -C "$WATA_TMP" \
      || { echo "Lỗi: không tải được $repo@$ref (kiểm tra mạng hoặc WATA_REF)." >&2; return 1; }
    src="$(find "$WATA_TMP" -mindepth 1 -maxdepth 1 -type d | head -1)"
  fi

  [ -x "$src/scripts/install.sh" ] || { echo "Lỗi: $src không có scripts/install.sh." >&2; return 1; }
  "$src/scripts/install.sh" "$dest" "$mode"

  if [ "$mode" != "--check" ]; then
    echo
    echo "Xong. Mở Claude Code từ chính thư mục này để nạp skill:"
    echo "  cd \"$dest\" && claude"
    echo "Kiểm tra cấu hình còn thiếu: chạy lại lệnh cài với '| bash -s -- --check'."
  fi
}

main "$@"
