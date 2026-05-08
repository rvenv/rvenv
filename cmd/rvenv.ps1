#!/usr/bin/env pwsh
# rvenv - PowerShell router for localized environments and identity vaults

$VERSION = '1.0.0'
$ROOT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path

# Import core components
. "$ROOT_DIR/common.ps1"
. "$ROOT_DIR/engine.ps1"
. "$ROOT_DIR/identity.ps1"
. "$ROOT_DIR/vault.ps1"

function Show-Help {
    Write-Host "`e[1;32m🍃 rvenv`e[0m - Localized environment & identity vault"
    Write-Host ""
    Write-Host "`e[1mUSAGE:`e[0m"
    Write-Host "  rvenv.ps1 <command> [<args>]"
    Write-Host ""
    Write-Host "`e[1mIDENTITY COMMANDS:`e[0m"
    Write-Host "  user --name NAME        Set global display name"
    Write-Host "  user --username HANDLE  Set global username/handle"
    Write-Host ""
    Write-Host "`e[1mCONFIGURATION:`e[0m"
    Write-Host "  config --encryption METHOD  Set encryption backend (openssl/age)"
    Write-Host ""
    Write-Host "`e[1mVAULT COMMANDS:`e[0m"
    Write-Host "  init                     Initialize vault in the current directory"
    Write-Host "  put KEY VALUE            Store or update a secret in the vault"
    Write-Host "  list                     List all keys in the current vault"
    Write-Host ""
    Write-Host "`e[1mENVIRONMENT:`e[0m"
    Write-Host "  enter                    Start a session with decrypted secrets"
    Write-Host "  status                   Display identity and session information"
    Write-Host "  uptime                   Show duration of the current session"
    Write-Host ""
    Write-Host "`e[1mSYSTEM:`e[0m"
    Write-Host "  version, -v, --version   Show version information"
    Write-Host "  help                     Show this help message"
}

# Command Router
$cmd = $args[0]
$params = $args[1..($args.Count-1)]

switch ($cmd) {
    { $_ -in "-v", "--version", "version" } { Write-Host "rvenv version $VERSION"; exit 0 }
    
    "user" {
        if ($params[0] -eq "--name") { Update-Field -Key "name" -Value $params[1] -Label "Name" }
        elseif ($params[0] -eq "--username") { Update-Field -Key "username" -Value $params[1] -Label "Username" }
        else { Show-Help }
    }
    
    "config" {
        if ($params[0] -eq "--encryption") { Set-Encryption -Method $params[1] }
        else { Show-Help }
    }
    
    "status" { Get-RvenvStatus }
    "uptime" { Write-Host "Session started at: $env:RVENV_START_TIME" }
    "init"   { Init-Project }
    "put"    { Put-Secret -Key $params[0] -Value $params[1] }
    "list"   { List-Secrets }
    "enter"  { Invoke-Rvenv }
    
    Default { Show-Help }
}
