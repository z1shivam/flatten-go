# PowerShell script to uninstall flatten
$installDir = "$env:USERPROFILE\.local\bin"
$binaryPath = "$installDir\flatten.exe"

Write-Host "Uninstalling flatten..."

# Remove the binary
if (Test-Path $binaryPath) {
    Remove-Item $binaryPath -Force
    Write-Host "Removed flatten binary from: $installDir"
} else {
    Write-Host "flatten.exe not found at: $binaryPath"
}

# Remove from PATH if it was added by our installer
$currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($currentPath -like "*$installDir*") {
    # Remove our directory from PATH
    $pathEntries = $currentPath -split ';' | Where-Object { $_ -ne $installDir -and $_ -ne "" }
    $newPath = $pathEntries -join ';'
    
    # Update PATH permanently
    [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
    
    # Update PATH for current session
    $env:PATH = ($env:PATH -split ';' | Where-Object { $_ -ne $installDir }) -join ';'
    
    Write-Host "Removed $installDir from PATH"
} else {
    Write-Host "$installDir was not in PATH"
}

# Clean up empty directory if it only contained our binary
if (Test-Path $installDir) {
    $items = Get-ChildItem $installDir -Force -ErrorAction SilentlyContinue
    if (-not $items -or $items.Count -eq 0) {
        Remove-Item $installDir -Force
        Write-Host "Removed empty directory: $installDir"
    } else {
        Write-Host "Directory $installDir contains other files, keeping it"
    }
}

Write-Host ""
Write-Host "flatten has been successfully uninstalled!"
Write-Host "You may need to restart your terminal for PATH changes to take effect."
