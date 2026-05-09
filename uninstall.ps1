# rvenv uninstall script
# Removes the global PowerShell module and the wrapper script

$modulePath = Join-Path $env:PSModulePath.Split(';')[0] "Rvenv"
$wrapperPath = "C:\Users\ASUS\AppData\Local\Microsoft\WinGet\Links\rvenv.ps1"
$configPath = Join-Path $HOME"\.config\rvenv\config.json"
$global:CONFIG_FILE = Join-Path $HOME ".config\rvenv\user.json"

if (Test-Path $modulePath) {
    Remove-Item -Path $modulePath -Recurse -Force
    Write-Host "rvenv module removed."
}

if (Test-Path $wrapperPath) {
    Remove-Item -Path $wrapperPath -Force
    Write-Host "rvenv wrapper removed."
}

if (Test-Path $global:CONFIG_FILE) {
    Remove-Item -Path $global:CONFIG_FILE -Recurse -Force
    Write-Host "config removed."
}

Write-Host "rvenv uninstalled successfully."
