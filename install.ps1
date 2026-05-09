# rvenv global setup script
# This script copies the module to the user's PowerShell Modules folder and sets up a global wrapper

$modulePath = Join-Path $env:PSModulePath.Split(';')[0] "Rvenv"
if (-not (Test-Path $modulePath)) {
    New-Item -ItemType Directory -Path $modulePath -Force | Out-Null
}
Copy-Item "$PSScriptRoot/cmd/*" -Destination $modulePath -Recurse -Force

# Create wrapper script in user's PATH (WinGet links is generally in PATH)
$wrapperPath = "C:\Users\ASUS\AppData\Local\Microsoft\WinGet\Links\rvenv.ps1"
$wrapperContent = '& "' + (Join-Path $modulePath "rvenv.ps1") + '" @args'
$wrapperContent | Out-File -FilePath $wrapperPath -Encoding ascii -Force

Write-Host "rvenv installed globally as a PowerShell module and command."
