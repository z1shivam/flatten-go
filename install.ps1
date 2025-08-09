$repo = "yourusername/flatten-go"
$version = (Invoke-RestMethod "https://api.github.com/repos/$repo/releases/latest").tag_name
$os = "windows"
$arch = "amd64"

$url = "https://github.com/$repo/releases/download/$version/flatten-$os-$arch.exe"
$dest = "$env:USERPROFILE\.local\bin"

New-Item -ItemType Directory -Force -Path $dest | Out-Null
Invoke-WebRequest -Uri $url -OutFile "$dest\flatten.exe"

$env:PATH += ";$dest"
[Environment]::SetEnvironmentVariable("PATH", $env:PATH, [System.EnvironmentVariableTarget]::User)

Write-Host "✅ Installed flatten $version"
