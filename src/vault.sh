#!/bin/bash
# rvenv vault - Secret Management Logic

VAULT_FILE=".rvenv_vars"

# Initialize a new vault in the current directory
function init_project() {
    if [ -f "$VAULT_FILE" ]; then
        echo -e "\e[33m[!]\e[0m Project already initialized in $(pwd)"
    else
        echo "# rvenv local secrets - DO NOT COMMIT" > "$VAULT_FILE"
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

    # Check if key already exists to prevent duplicates
    if grep -q "export $KEY=" "$VAULT_FILE" 2>/dev/null; then
        # Replace existing line
        sed -i "s/^export $KEY=.*/export $KEY=\"$VAL\"/" "$VAULT_FILE"
        echo -e "\e[34m[*]\e[0m Updated $KEY in vault."
    else
        # Append new line
        echo "export $KEY=\"$VAL\"" >> "$VAULT_FILE"
        echo -e "\e[32m[+]\e[0m Stored $KEY in vault."
    fi
}

# List all keys currently in the vault (hiding values for safety)
function list_secrets() {
    if [ ! -f "$VAULT_FILE" ]; then
        echo -e "\e[31m[!] No vault found. Run 'rvenv init' first.\e[0m"
        return 1
    fi

    echo "--- Current Secrets ---"
    grep "export " "$VAULT_FILE" | cut -d' ' -f2 | cut -d'=' -f1 | sed 's/^/  - /'
}

# Router for vault sub-commands
case "$1" in
    init) init_project ;;
    put)  put_secret "$2" "$3" ;;
    list) list_secrets ;;
esac