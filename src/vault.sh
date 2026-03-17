#!/bin/bash
# rvenv vault - Secret Management Logic

VAULT_FILE=".rvenv_vault"
CONFIG_FILE="$HOME/.config/rvenv/user.json"

# Get encryption method from config
get_encryption_method() {
    grep -oP '(?<="encryption": ")[^"]*' "$CONFIG_FILE" 2>/dev/null || echo "openssl"
}

# Encryption helper functions
encrypt_data() {
    local data="$1"
    local password="$2"
    local method
    method=$(get_encryption_method)
    
    if [ "$method" = "age" ]; then
        if command -v age >/dev/null 2>&1; then
            AGE_PASSPHRASE="$password" echo "$data" | age -p -a 2>/dev/null
        else
            echo "age not installed, falling back to openssl" >&2
            echo "$data" | openssl enc -aes-256-cbc -a -salt -k "$password" 2>/dev/null
        fi
    else
        echo "$data" | openssl enc -aes-256-cbc -a -salt -k "$password" 2>/dev/null
    fi
}

decrypt_data() {
    local encrypted="$1"
    local password="$2"
    local method
    method=$(get_encryption_method)
    
    if [ "$method" = "age" ]; then
        if command -v age >/dev/null 2>&1; then
            AGE_PASSPHRASE="$password" echo "$encrypted" | age -d -a 2>/dev/null
        else
            echo "age not installed, falling back to openssl" >&2
            echo "$encrypted" | openssl enc -aes-256-cbc -a -d -salt -k "$password" 2>/dev/null
        fi
    else
        echo "$encrypted" | openssl enc -aes-256-cbc -a -d -salt -k "$password" 2>/dev/null
    fi
}

# Initialize a new vault in the current directory
function init_project() {
    if [ -f "$VAULT_FILE" ]; then
        echo -e "\e[33m[!]\e[0m Project already initialized in $(pwd)"
    else
        echo "{}" > "$VAULT_FILE"
        echo -e "\e[32m[+]\e[0m Initialized rvenv in $(pwd)"
        echo -e "\e[32m[+]\e[0m Created $VAULT_FILE (Vault)"
    fi
}

# Store a key-value pair in the vault
function put_secret() {
    local KEY=$1
    local VAL=$2
    
    if [[ -z "$KEY" || -z "$VAL" ]]; then
        echo "Usage: rvenv put [KEY] [VALUE]"
        return 1
    fi

    read -s -p "Enter vault password: " password
    echo

    local ENCRYPTED=$(encrypt_data "$VAL" "$password")

    if [ ! -f "$VAULT_FILE" ]; then
        echo "{\"$KEY\": \"$ENCRYPTED\"}" > "$VAULT_FILE"
        echo -e "\e[32m[+]\e[0m Stored $KEY in vault."
    else
        # Check if empty object
        if [ "$(cat "$VAULT_FILE")" = "{}" ]; then
            echo "{\"$KEY\": \"$ENCRYPTED\"}" > "$VAULT_FILE"
            echo -e "\e[32m[+]\e[0m Stored $KEY in vault."
        elif grep -q "\"$KEY\":" "$VAULT_FILE"; then
            # Replace existing
            sed -i "s|\"$KEY\": \"[^\"]*\"|\"$KEY\": \"$ENCRYPTED\"|" "$VAULT_FILE"
            echo -e "\e[34m[*]\e[0m Updated $KEY in vault."
        else
            # Add new key
            sed -i "s|}$|, \"$KEY\": \"$ENCRYPTED\" }|" "$VAULT_FILE"
            echo -e "\e[32m[+]\e[0m Stored $KEY in vault."
        fi
    fi
}

# List all keys currently in the vault (hiding values for safety)
function list_secrets() {
    if [ ! -f "$VAULT_FILE" ]; then
        echo -e "\e[31m[!] No vault found. Run 'rvenv init' first.\e[0m"
        return 1
    fi

    echo "--- Current Secrets ---"
    # Extract keys from JSON
    sed 's/[{}"]//g' "$VAULT_FILE" | tr ',' '\n' | awk -F: '{print "  - " $1}'
}

# Router for vault sub-commands
case "$1" in
    init) init_project ;;
    put)  put_secret "$2" "$3" ;;
    list) list_secrets ;;
esac