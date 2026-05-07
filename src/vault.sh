#!/bin/bash
# rvenv vault - Encryption and vault management

# shellcheck disable=SC1090
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

VAULT_FILE=".rvenv_vault"

# --- Utilities ---

# Retrieve encryption method from configuration
get_method() {
  local method
  method=$(get_json_val 'encryption' "$CONFIG_FILE")
  echo "${method:-openssl}"
}

# Encrypt data using the configured backend
# Usage: encrypt_data <plain_text> <password>
encrypt_data() {
  local data="$1"
  local password="$2"
  local method
  method=$(get_method)

  if [[ "$method" == 'age' ]]; then
    if command -v age > /dev/null 2>&1; then
      AGE_PASSPHRASE="$password" echo "$data" | age -p -a 2> /dev/null
    else
      echo -e "${ICON_WARN} age not installed; falling back to openssl" >&2
      echo "$data" | openssl enc -aes-256-cbc -a -salt -k "$password" -pbkdf2 2> /dev/null
    fi
  else
    echo "$data" | openssl enc -aes-256-cbc -a -salt -k "$password" -pbkdf2 2> /dev/null
  fi
}

# Decrypt data using the configured backend
# Usage: decrypt_data <encrypted_text> <password>
decrypt_data() {
  local encrypted="$1"
  local password="$2"
  local method
  method=$(get_method)

  if [[ "$method" == 'age' ]]; then
    if command -v age > /dev/null 2>&1; then
      AGE_PASSPHRASE="$password" echo "$encrypted" | age -d -a 2> /dev/null
    else
      echo -e "${ICON_WARN} age not installed; falling back to openssl" >&2
      echo "$encrypted" | openssl enc -aes-256-cbc -a -d -salt -k "$password" -pbkdf2 2> /dev/null
    fi
  else
    echo "$encrypted" | openssl enc -aes-256-cbc -a -d -salt -k "$password" -pbkdf2 2> /dev/null
  fi
}

# --- Core Operations ---

# Initialize a new encrypted vault
init_project() {
  if [[ -f "$VAULT_FILE" ]]; then
    echo -e "${ICON_WARN} Vault already exists in $(pwd)"
  else
    echo '{}' > "$VAULT_FILE"
    echo -e "${ICON_PLUS} Initialized vault in $(pwd)"
  fi
}

# Store or update a secret in the vault
put_secret() {
  local key="$1"
  local val="$2"

  if [[ -z "$key" || -z "$val" ]]; then
    echo 'Usage: rvenv put <KEY> <VALUE>'
    return 1
  fi

  # Validate key (must be a valid Bash identifier)
  if [[ ! "$key" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
    echo -e "${ICON_ERROR} Invalid key: '$key'"
    echo -e '   Keys must follow Bash naming conventions (start with letter/underscore).'
    return 1
  fi

  if [[ ! -f "$VAULT_FILE" ]]; then
    echo -e "${ICON_ERROR} No vault found. Run 'rvenv init' first."
    return 1
  fi

  local password
  password=$(get_vault_password)

  local encrypted
  encrypted=$(encrypt_data "$val" "$password")

  if [[ -z "$encrypted" ]]; then
    echo -e "${ICON_ERROR} Encryption failed."
    return 1
  fi

  if [[ "$(cat "$VAULT_FILE")" == '{}' ]]; then
    echo "{\"$key\": \"$encrypted\"}" > "$VAULT_FILE"
  elif grep -q "\"$key\":" "$VAULT_FILE"; then
    sed -i "s|\"$key\": \"[^\"]*\"|\"$key\": \"$encrypted\"|" "$VAULT_FILE"
  else
    sed -i "s|}$|, \"$key\": \"$encrypted\" }|" "$VAULT_FILE"
  fi
  echo -e "${ICON_PLUS} secret stored: $key"
}

# List secret keys (values remain hidden)
list_secrets() {
  if [[ ! -f "$VAULT_FILE" ]]; then
    echo -e "${ICON_ERROR} No vault found. Run 'rvenv init' first."
    return 1
  fi

  echo -e "${BLUE}${BOLD}--- Vault Keys ---${RESET}"
  sed 's/[{}]//g' "$VAULT_FILE" | tr ',' '\n' | while IFS=: read -r key val; do
    key=$(echo "$key" | tr -d ' "')
    [[ -n "$key" ]] && echo "  - $key"
  done
}

# --- Entry Point ---

case "$1" in
  init) init_project ;;
  put) put_secret "$2" "$3" ;;
  list) list_secrets ;;
esac
