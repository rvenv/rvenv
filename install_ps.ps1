# rvenv global setup script
# This script copies the module to the user's PowerShell Modules folder

$modulePath = Join-Path $env:PSModulePath.Split(';')[0] "Rvenv"
if (-not (Test-Path $modulePath)) {
    New-Item -ItemType Directory -Path $modulePath -Force | Out-Null
}
Copy-Item "$PSScriptRoot/ps/*" -Destination $modulePath -Recurse -Force
Write-Host "rvenv installed globally as a PowerShell module."
