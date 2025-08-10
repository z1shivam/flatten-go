#!/usr/bin/env bash
set -e

INSTALL_DIR="$HOME/.local/bin"
BINARY_PATH="$INSTALL_DIR/flatten"

echo "🗑️  Uninstalling flatten..."

# Remove the binary
if [ -f "$BINARY_PATH" ]; then
    rm "$BINARY_PATH"
    echo "✅ Removed flatten binary from: $INSTALL_DIR"
else
    echo "⚠️  flatten not found at: $BINARY_PATH"
fi

# Remove from PATH in shell config files
BASHRC="$HOME/.bashrc"
ZSHRC="$HOME/.zshrc"

# Function to remove PATH entry from a file
remove_path_from_file() {
    local file="$1"
    if [ -f "$file" ]; then
        # Create a backup
        cp "$file" "${file}.backup.$(date +%s)"
        
        # Remove lines that add our install directory to PATH
        grep -v "export PATH.*$INSTALL_DIR" "$file" > "${file}.tmp" || true
        mv "${file}.tmp" "$file"
        
        echo "✅ Removed PATH entries from: $file"
    fi
}

# Remove from common shell config files
if [ -f "$BASHRC" ]; then
    remove_path_from_file "$BASHRC"
fi

if [ -f "$ZSHRC" ]; then
    remove_path_from_file "$ZSHRC"
fi

# Clean up empty directory if it only contained our binary
if [ -d "$INSTALL_DIR" ]; then
    if [ -z "$(ls -A "$INSTALL_DIR")" ]; then
        rmdir "$INSTALL_DIR"
        echo "✅ Removed empty directory: $INSTALL_DIR"
    else
        echo "ℹ️  Directory $INSTALL_DIR contains other files, keeping it"
    fi
fi

echo ""
echo "✅ flatten has been successfully uninstalled!"
echo "   You may need to restart your terminal for PATH changes to take effect."
echo "   Shell config backups were created with timestamp suffix."
