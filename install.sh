#!/usr/bin/env bash
set -e

REPO="yourusername/flatten-go"
VERSION=$(curl -s https://api.github.com/repos/$REPO/releases/latest | grep '"tag_name":' | cut -d'"' -f4)

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
[ "$ARCH" = "x86_64" ] && ARCH="amd64"
[ "$ARCH" = "arm64" ] && ARCH="arm64"

URL="https://github.com/$REPO/releases/download/$VERSION/flatten-$OS-$ARCH"
[ "$OS" = "windows" ] && URL="$URL.exe"

DEST="/usr/local/bin/flatten"
sudo curl -L "$URL" -o "$DEST"
sudo chmod +x "$DEST"

echo "✅ Installed flatten $VERSION"
    