#!/bin/bash
# rvenv common - Shared constants and utilities

# Paths
export CONFIG_DIR="$HOME/.config/rvenv"
export CONFIG_FILE="$CONFIG_DIR/user.json"
export VAULT_PASS_FILE="$CONFIG_DIR/.vault_pass"

# Colors
export BOLD='\e[1m'
export BLUE='\e[34m'
export CYAN='\e[36m'
export GREEN='\e[32m'
export RED='\e[31m'
export YELLOW='\e[33m'
export RESET='\e[0m'

# Icons
export ICON_PLUS="${GREEN}[+]${RESET}"
export ICON_INFO="${BLUE}[*]${RESET}"
export ICON_WARN="${YELLOW}[!]${RESET}"
export ICON_ERROR="${RED}[!]${RESET}"

# Initialize config if it doesn't exist
function init_config() {
  mkdir -p "$CONFIG_DIR"
  if [ ! -f "$CONFIG_FILE" ]; then
    echo '{"name": "", "username": "", "encryption": "openssl"}' > "$CONFIG_FILE"
  fi
}

# Retrieves the vault password, either from storage or by prompting the user
function get_vault_password() {
  if [ -f "$VAULT_PASS_FILE" ]; then
    cat "$VAULT_PASS_FILE"
  else
    local password=""
    while [ -z "$password" ]; do
      read -r -s -p "Enter vault password: " password >&2
      echo >&2
      if [ -z "$password" ]; then
        echo -e "${ICON_ERROR} Password cannot be empty." >&2
      fi
    done
    echo "$password"
  fi
}

# Simple JSON value extractor (handles basic string values)
# Usage: get_json_val "key" "file"
function get_json_val() {
  local key="$1"
  local file="$2"
  grep -oP "(?<=\"$key\": \")[^\"]*" "$file" 2> /dev/null || echo ""
}

# Simple JSON value updater (handles basic string values)
# Usage: set_json_val "key" "value" "file"
function set_json_val() {
  local key="$1"
  local val="$2"
  local file="$3"
  sed -i "s/\"$key\": \"[^\"]*\"/\"$key\": \"$val\"/" "$file"
}
