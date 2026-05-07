# rvenv PowerShell Vault - Encryption and vault management
# Port of src/vault.sh

. $PSScriptRoot/Common.ps1

$global:VAULT_FILE = ".rvenv_vault"

function Get-Method {
    $method = Get-JsonValue -Key "encryption" -FilePath $global:CONFIG_FILE
    if ([string]::IsNullOrWhiteSpace($method)) { "openssl" } else { $method }
}

function Encrypt-Data {
    param([string]$PlainText, [string]$Password)
    $method = Get-Method
    if ($method -eq "openssl") {
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($PlainText)
        # Using OpenSSL via CLI for parity with Bash implementation
        $encoded = $PlainText | openssl enc -aes-256-cbc -a -salt -k "$Password" -pbkdf2
        return $encoded
    }
    # Age support could be added here later
    Write-Host "$global:ICON_ERROR Unsupported encryption method: $method"
}

function Decrypt-Data {
    param([string]$EncryptedText, [string]$Password)
    $method = Get-Method
    if ($method -eq "openssl") {
        $decoded = $EncryptedText | openssl enc -aes-256-cbc -a -d -salt -k "$Password" -pbkdf2
        return $decoded
    }
}

function Init-Project {
    if (Test-Path $global:VAULT_FILE) {
        Write-Host "$global:ICON_WARN Vault already exists in $(Get-Location)"
    } else {
        '{}' | Out-File -FilePath $global:VAULT_FILE -Encoding utf8
        Write-Host "$global:ICON_PLUS Initialized vault in $(Get-Location)"
    }
}

function Put-Secret {
    param([string]$Key, [string]$Value)
    if ([string]::IsNullOrWhiteSpace($Key) -or [string]::IsNullOrWhiteSpace($Value)) {
        Write-Host "Usage: rvenv put <KEY> <VALUE>"
        return
    }

    if (-not (Test-Path $global:VAULT_FILE)) {
        Write-Host "$global:ICON_ERROR No vault found. Run 'rvenv init' first."
        return
    }

    $password = Get-VaultPassword
    $encrypted = Encrypt-Data -PlainText $Value -Password $password

    $json = Get-Content $global:VAULT_FILE | ConvertFrom-Json
    $json | Add-Member -MemberType NoteProperty -Name $Key -Value $encrypted -Force
    $json | ConvertTo-Json | Out-File -FilePath $global:VAULT_FILE -Encoding utf8
    Write-Host "$global:ICON_PLUS secret stored: $Key"
}

function List-Secrets {
    if (-not (Test-Path $global:VAULT_FILE)) {
        Write-Host "$global:ICON_ERROR No vault found. Run 'rvenv init' first."
        return
    }
    Write-Host "$global:BLUE$global:BOLD--- Vault Keys ---$global:RESET"
    $json = Get-Content $global:VAULT_FILE | ConvertFrom-Json
    foreach ($property in $json.PSObject.Properties) {
        Write-Host "  - $($property.Name)"
    }
}
