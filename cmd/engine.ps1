# rvenv PowerShell Engine - Environment and session management
# Port of src/engine.sh

. $PSScriptRoot/Common.ps1
. $PSScriptRoot/Vault.ps1

function Invoke-Rvenv {
    Write-Host "_____     _           _         "
    Write-Host "|  __|___| |_ ___ ___|_|___ ___ "
    Write-Host "|  __|   |  _| -_|  _| |   | . |"
    Write-Host "|____|_|_|_| |___|_| |_|_|_|_  |"
    Write-Host "                           |___|"
    Write-Host " Scoping environment to rvenv vault..."

                                 


    $env:RVENV_SESSION = "ACTIVE"
    $env:RVENV_START_TIME = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    
    Write-Host "[+] rvenv session active."
}

function Invoke-Exit {
    if ($env:RVENV_SESSION -eq "ACTIVE") {
        # Using global scope to remove environment variables
        [Environment]::SetEnvironmentVariable("RVENV_SESSION", $null, "Process")
        [Environment]::SetEnvironmentVariable("RVENV_START_TIME", $null, "Process")
        Write-Host "[*] rvenv session terminated."
    } else {
        Write-Host "[!] No active rvenv session found."
    }
}

function Get-RvenvStatus {
    $name = Get-JsonValue -Key "name" -FilePath $global:CONFIG_FILE
    $handle = Get-JsonValue -Key "username" -FilePath $global:CONFIG_FILE





    Write-Host ""
    Write-Host "░█▀▀░▀█▀░█▀█░▀█▀░█░█░█▀▀"
    Write-Host "░▀▀█░░█░░█▀█░░█░░█░█░▀▀█"
    Write-Host "░▀▀▀░░▀░░▀░▀░░▀░░▀▀▀░▀▀▀"
    Write-Host ""
    Write-Host "  | Identity: $name (@$handle) | "
    
    if ($env:RVENV_SESSION -eq "ACTIVE") {
        Write-Host "| Status:   | ACTIVE |"
    } else {
        Write-Host " | Status:   \ INACTIVE |"
    }
}
