#!/bin/bash
# rvenv identity - Profile and configuration management

# shellcheck disable=SC1090
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

init_config

# --- Core Functions ---

# Update a specific configuration field
# Usage: update_field <key> <value> <label>
update_field() {
  local key="$1"
  local val="$2"
  local label="$3"

  if [[ -z "$val" ]]; then
    echo -e "${ICON_ERROR} No value provided for $label"
    return 1
  fi

  set_json_val "$key" "$val" "$CONFIG_FILE"
  echo -e "${ICON_PLUS} $label updated: ${CYAN}$val${RESET}"
}

# Configure the global encryption backend
# Usage: set_encryption <method>
set_encryption() {
  local method="$1"

  if [[ "$method" == 'openssl' || "$method" == 'age' ]]; then
    set_json_val 'encryption' "$method" "$CONFIG_FILE"
    echo -e "${ICON_PLUS} Encryption backend: ${CYAN}$method${RESET}"
  else
    echo -e "${ICON_ERROR} Invalid backend. Choose 'openssl' or 'age'."
    return 1
  fi
}

# --- Router ---

case "$1" in
  --name) update_field 'name' "$2" 'Name' ;;
  --username) update_field 'username' "$2" 'Username' ;;
  --encryption) set_encryption "$2" ;;
  config)
    if [[ "$2" == '--encryption' ]]; then
      set_encryption "$3"
    else
      echo 'Usage: rvenv config --encryption [openssl|age]'
    fi
    ;;
  *)
    echo 'Usage: rvenv user [--name name | --username username]'
    echo '       rvenv config --encryption [openssl|age]'
    ;;
esac
