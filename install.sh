#!/usr/bin/env bash
set -euo pipefail

HELPER_RELEASE_BASE="${SEMSAS_HELPER_RELEASE_BASE:-https://github.com/ayhanmalkoc/semsas-helper/releases/latest/download}"
INSTALL_DIR="${SEMSAS_HELPER_INSTALL_DIR:-${AGENT_VOICE_INSTALL_DIR:-$HOME/.local/bin}}"
SCRIPT_URL="$HELPER_RELEASE_BASE/semsas_pair.py"
TARGET="$INSTALL_DIR/semsas-pair"

mkdir -p "$INSTALL_DIR"

if ! command -v python3 >/dev/null 2>&1; then
  echo "error: python3 is required" >&2
  exit 1
fi

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

curl -fsSL "$SCRIPT_URL" -o "$tmp"
python3 -m py_compile "$tmp"
install -m 0755 "$tmp" "$TARGET"

echo "Installed semsas-pair to $TARGET"
case ":$PATH:" in
  *":$INSTALL_DIR:"*) ;;
  *)
    echo "Add this to your shell profile if semsas-pair is not found:"
    echo "  export PATH=\"$INSTALL_DIR:\$PATH\""
    ;;
esac
echo "Run: semsas-pair"
