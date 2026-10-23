#!/bin/zsh
# Gera Resources/AppIcon.icns a partir de scripts/make-icon.swift.
set -euo pipefail
cd "$(dirname "$0")/.."

[[ "$(sysctl -n hw.optional.arm64 2>/dev/null)" == "1" ]] && SWIFT=(arch -arm64 swift) || SWIFT=(swift)

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
"${SWIFT[@]}" scripts/make-icon.swift "$TMP/icon.png"

SET="$TMP/AppIcon.iconset"
mkdir -p "$SET"
for px in 16 32 128 256 512; do
  sips -z $px $px "$TMP/icon.png" --out "$SET/icon_${px}x${px}.png" >/dev/null
  sips -z $((px * 2)) $((px * 2)) "$TMP/icon.png" --out "$SET/icon_${px}x${px}@2x.png" >/dev/null
done
iconutil -c icns "$SET" -o Resources/AppIcon.icns
cp "$TMP/icon.png" Resources/AppIcon.png
echo "OK: Resources/AppIcon.icns"
