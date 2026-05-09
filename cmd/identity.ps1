# rvenv PowerShell Identity - Profile and configuration management
# Port of src/identity.sh

. $PSScriptRoot/Common.ps1

Init-Config

function Update-Field {
    param([string]$Key, [string]$Value, [string]$Label)
    if ([string]::IsNullOrWhiteSpace($Value)) {
        Write-Host "$global:ICON_ERROR No value provided for $Label"
        return
    }
    Set-JsonValue -Key $Key -Value $Value -FilePath $global:CONFIG_FILE
    Write-Host "$global:ICON_PLUS $Label updated: $global:CYAN$Value$global:RESET"
}

function Set-Encryption {
    param([string]$Method)
    if ($Method -eq 'openssl' -or $Method -eq 'age') {
        Set-JsonValue -Key 'encryption' -Value $Method -FilePath $global:CONFIG_FILE
        Write-Host "$global:ICON_PLUS Encryption backend: $global:CYAN$Method$global:RESET"
    } else {
        Write-Host "$global:ICON_ERROR Invalid backend. Choose 'openssl' or 'age'."
    }
}
