# Flatten Go

A CLI tool to flatten complex data structures into a simple, human-readable format.

## Installation

### Linux / macOS
```bash
curl -fsSL https://raw.githubusercontent.com/yourusername/flatten-go/main/install.sh | bash
```

### Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/yourusername/flatten-go/main/install.ps1 | iex
```

### Manual Installation
1. Go to the [Releases](https://github.com/yourusername/flatten-go/releases) page.
2. Download the binary for your OS and architecture:
   - **Linux/macOS:** `flatten-linux-amd64` or `flatten-darwin-arm64`, etc.
   - **Windows:** `flatten-windows-amd64.exe`
3. Place the binary somewhere in your system `PATH`:
   - **Linux/macOS:** Move it to `/usr/local/bin` and run `chmod +x flatten`
   - **Windows:** Move it to a folder in your `PATH` or update `PATH` via System Settings.

## Usage
```bash
flatten --version
flatten input.json
```

## Development

### Build
```bash
go build -o flatten main.go
```

### Run Tests
```bash
go test ./...
```

## How It Works
1. Detects your OS and architecture.
2. Downloads the latest binary from GitHub Releases.
3. Places it into your system's PATH.
4. Makes it executable and ready to use.
