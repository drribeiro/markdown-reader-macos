#!/bin/zsh
# Compila e empacota o app em build/Markdown Reader.app.
# Uso: ./build.sh            -> só gera o .app
#      ./build.sh --install  -> gera e copia para /Applications
set -euo pipefail
cd "$(dirname "$0")"

# Força arm64 mesmo se o terminal estiver rodando sob Rosetta.
[[ "$(sysctl -n hw.optional.arm64 2>/dev/null)" == "1" ]] && SWIFT=(arch -arm64 swift) || SWIFT=(swift)

"${SWIFT[@]}" build -c release
BIN="$("${SWIFT[@]}" build -c release --show-bin-path)/MarkdownReader"

APP="build/Markdown Reader.app"
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
cp "$BIN" "$APP/Contents/MacOS/MarkdownReader"
cp Resources/Info.plist "$APP/Contents/Info.plist"
cp Resources/AppIcon.icns "$APP/Contents/Resources/AppIcon.icns"
codesign --force --sign - "$APP"

echo "OK: $APP"

if [[ "${1:-}" == "--install" ]]; then
  rm -rf "/Applications/Markdown Reader.app"
  cp -R "$APP" /Applications/
  echo "Instalado em /Applications/Markdown Reader.app"
fi
