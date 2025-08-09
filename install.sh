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

# Construct the exact asset name that GitHub Actions creates
ASSET_NAME="flatten-${OS}-${ARCH}"

ASSET_URL=$(curl -s https://api.github.com/repos/$REPO/releases/latest \
    | grep browser_download_url \
    | grep "flatten-${OS}-${ARCH}\"" \
    | cut -d '"' -f 4)

if [ -z "$ASSET_URL" ]; then
    echo "❌ No binary found for $OS-$ARCH."
    echo "Expected asset name: $ASSET_NAME"
    echo "Available assets:"
    curl -s https://api.github.com/repos/$REPO/releases/latest | grep "browser_download_url" | cut -d '"' -f 4 | xargs -I {} basename {}
    exit 1
fi

echo "Downloading $ASSET_NAME..."
INSTALL_DIR="$HOME/.local/bin"
mkdir -p "$INSTALL_DIR"

curl -L "$ASSET_URL" -o "$INSTALL_DIR/flatten"
chmod +x "$INSTALL_DIR/flatten"

if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo "export PATH=\"\$PATH:$INSTALL_DIR\"" >> "$HOME/.bashrc"
    echo "export PATH=\"\$PATH:$INSTALL_DIR\"" >> "$HOME/.zshrc" 2>/dev/null || true
    echo "Added $INSTALL_DIR to PATH. Restart your terminal."
fi

echo "✅ flatten $LATEST installed successfully."
echo ""
echo "🎉 You can now use the 'flatten' command!"
echo "   Try: flatten --version"
if [[ ":$PATH:" == *":$INSTALL_DIR:"* ]]; then
    echo "   The binary is ready to use in your current session."
else
    echo "   You may need to restart your terminal for PATH changes to take effect."
fi
