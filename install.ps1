$repo = "z1shivam/flatten-go"
$latestRelease = Invoke-RestMethod -Uri "https://api.github.com/repos/$repo/releases/latest"
$version = $latestRelease.tag_name

# Detect architecture
$arch = if ([Environment]::Is64BitOperatingSystem) { "amd64" } else { "386" }
if ($env:PROCESSOR_ARCHITECTURE -eq "ARM64") { $arch = "arm64" }

# Construct the exact asset name that GitHub Actions creates
$assetName = "flatten-windows-$arch.exe"
$asset = $latestRelease.assets | Where-Object { $_.name -eq $assetName }

if (-not $asset) {
    Write-Error "No Windows binary found for architecture $arch. Expected: $assetName"
    Write-Host "Available assets:"
    $latestRelease.assets | ForEach-Object { Write-Host "  - $($_.name)" }
    exit 1
}

Write-Host "Downloading $($asset.name)..."
$outFile = "$env:TEMP\$($asset.name)"
Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $outFile

# Choose install location
$installDir = "$env:USERPROFILE\.local\bin"
if (-not (Test-Path $installDir)) {
    New-Item -ItemType Directory -Force -Path $installDir | Out-Null
}

Move-Item -Force $outFile "$installDir\flatten.exe"

# Add to PATH if needed
if ($env:PATH -notlike "*$installDir*") {
    # Update PATH for future sessions
    setx PATH "$($env:PATH);$installDir" | Out-Null
    # Update PATH for current session
    $env:PATH = "$($env:PATH);$installDir"
    Write-Host "Added $installDir to PATH."
}

Write-Host "✅ flatten v$version installed successfully."
Write-Host ""
Write-Host "🎉 You can now use 'flatten' command!"
Write-Host "   Try: flatten --version"
Write-Host "   The binary is ready to use immediately!"
