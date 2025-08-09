#!/usr/bin/env bash
set -e

REPO="z1shivam/flatten-go"
LATEST=$(curl -s https://api.github.com/repos/$REPO/releases/latest | grep tag_name | cut -d '"' -f 4)

OS=$(uname | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case $ARCH in
    x86_64) ARCH="amd64" ;;
    aarch64 | arm64) ARCH="arm64" ;;
esac

ASSET_URL=$(curl -s https://api.github.com/repos/$REPO/releases/latest \
    | grep browser_download_url \
    | grep "$OS" \
    | grep "$ARCH" \
    | cut -d '"' -f 4)

if [ -z "$ASSET_URL" ]; then
    echo "❌ No binary found for $OS-$ARCH."
    exit 1
fi

INSTALL_DIR="$HOME/.local/bin"
mkdir -p "$INSTALL_DIR"

curl -L "$ASSET_URL" -o "$INSTALL_DIR/flatten-go"
chmod +x "$INSTALL_DIR/flatten-go"

if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo "export PATH=\"\$PATH:$INSTALL_DIR\"" >> "$HOME/.bashrc"
    echo "export PATH=\"\$PATH:$INSTALL_DIR\"" >> "$HOME/.zshrc" 2>/dev/null || true
    echo "Added $INSTALL_DIR to PATH. Restart your terminal."
fi

echo "✅ flatten-go $LATEST installed successfully."
