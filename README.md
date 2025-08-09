# flatten-go

**flatten-go** is a lightweight CLI tool written in Go that flattens the structure of a folder by moving all files (from nested directories) into a single output folder.

## ✨ Features
- **Simple** — One command, one folder, done.
- **Safe** — Prompts before overwriting existing folders.
- **Cross-platform** — Works on Windows, macOS, and Linux.
- **No dependencies** — Single binary; no need to install Python, Node, etc.
- **Version flag** — Quickly check the installed version.

---

## 📦 Installation

### From GitHub Releases
1. Go to the [Releases page](https://github.com/yourusername/flatten-go/releases).
2. Download the binary for your OS.
3. Place it somewhere in your `PATH`.

Example (Linux/Mac):
```bash
sudo mv flatten /usr/local/bin/
chmod +x /usr/local/bin/flatten
```

Example (Windows PowerShell):
```powershell
Move-Item .\flatten.exe $HOME\.local\bin\
$env:PATH += ";$HOME\.local\bin"
```

---

## 🛠 Building from Source
You need [Go](https://go.dev/dl/) installed.

```bash
git clone https://github.com/yourusername/flatten-go.git
cd flatten-go
go build -ldflags "-X main.version=v0.0.1" -o flatten
```

On Windows:
```powershell
go build -ldflags "-X main.version=v0.0.1" -o flatten.exe
```

---

## 🚀 Usage

```bash
flatten <folder-name>
```

### Example
```bash
flatten photos
```
This will:
1. Check if the folder exists.
2. Create a new folder named `flatten_photos`.
3. Move **all files** from `photos` and its subfolders into `flatten_photos`.

---

## ⚠ Rules & Behavior
- **Only one folder** can be given at a time.
- If the folder doesn’t exist → Error: `Folder not found`.
- If `flatten_<folder>` already exists → Prompt:  
  ```
  ⚠️  folder 'flatten_<folder>' already exists. Overwrite? (y/N):
  ```
  - Default = `N`  
  - If `N` and `_1` exists, prompt again with `_2`, and so on.
- Version check:
```bash
flatten --version
```

---

## 📄 License
MIT License — feel free to use, modify, and distribute.

---

## 💡 Example Run
```bash
$ flatten music
Flattening folder: music → flatten_music
Done! All files moved into 'flatten_music'.
```
```bash
$ flatten --version
flatten version v0.0.1
```
