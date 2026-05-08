# rvenv PowerShell Common - Shared utilities and constants
# Port of src/common.sh

$global:CONFIG_DIR = Join-Path $HOME ".config/rvenv"
$global:CONFIG_FILE = Join-Path $global:CONFIG_DIR "user.json"
$global:VAULT_PASS_FILE = Join-Path $global:CONFIG_DIR ".vault_pass"

# Icons
$global:ICON_PLUS = "[+]"
$global:ICON_INFO = "[*]"
$global:ICON_WARN = "[!]"
$global:ICON_ERROR = "[!]"

function Init-Config {
    if (-not (Test-Path $global:CONFIG_DIR)) {
        New-Item -ItemType Directory -Path $global:CONFIG_DIR -Force | Out-Null
    }
    if (-not (Test-Path $global:CONFIG_FILE)) {
        '{"name": "", "username": "", "encryption": "openssl"}' | Out-File -FilePath $global:CONFIG_FILE -Encoding utf8
    }
}

function Get-VaultPassword {
    if (Test-Path $global:VAULT_PASS_FILE) {
        Get-Content $global:VAULT_PASS_FILE
    } else {
        $password = Read-Host -Prompt "Enter vault password" -AsSecureString
        # Convert SecureString back to plaintext if necessary for CLI tools, 
        # or use as-is if the tool handles it.
        [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
    }
}

function Get-JsonValue {
    param([string]$Key, [string]$FilePath)
    if (Test-Path $FilePath) {
        $json = Get-Content $FilePath | ConvertFrom-Json
        return $json.$Key
    }
    return ""
}

function Set-JsonValue {
    param([string]$Key, [string]$Value, [string]$FilePath)
    if (Test-Path $FilePath) {
        $json = Get-Content $FilePath | ConvertFrom-Json
        $json.$Key = $Value
        $json | ConvertTo-Json | Out-File -FilePath $FilePath -Encoding utf8
    }
}
