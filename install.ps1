$repo = "z1shivam/flatten-go"
$latestRelease = Invoke-RestMethod -Uri "https://api.github.com/repos/$repo/releases/latest"
$version = $latestRelease.tag_name
$asset = $latestRelease.assets | Where-Object { $_.name -match "windows" } | Select-Object -First 1

if (-not $asset) {
    Write-Error "No Windows binary found in the latest release."
    exit 1
}

$outFile = "$env:TEMP\$($asset.name)"
Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $outFile

# Choose install location
$installDir = "$env:USERPROFILE\.local\bin"
if (-not (Test-Path $installDir)) {
    New-Item -ItemType Directory -Force -Path $installDir | Out-Null
}

Move-Item -Force $outFile "$installDir\flatten-go.exe"

# Add to PATH if needed
if ($env:PATH -notlike "*$installDir*") {
    setx PATH "$($env:PATH);$installDir"
    Write-Host "Added $installDir to PATH. Restart your terminal."
}

Write-Host "✅ flatten-go v$version installed successfully."
