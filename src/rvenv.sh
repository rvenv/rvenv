#!/bin/bash
# rvenv - Core router for localized environments and identity vaults

VERSION='1.0.0'

# Resolve the absolute path of the script, following symlinks
SOURCE="${BASH_SOURCE[0]}"
while [[ -L "$SOURCE" ]]; do
  ROOT_DIR="$(cd -P "$(dirname "$SOURCE")" > /dev/null 2>&1 && pwd)"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$ROOT_DIR/$SOURCE"
done
ROOT_DIR="$(cd -P "$(dirname "$SOURCE")" > /dev/null 2>&1 && pwd)"

# shellcheck disable=SC1090
source "$ROOT_DIR/common.sh"

# Display application help and usage information
show_help() {
  echo -e "${GREEN}${BOLD}🍃 rvenv${RESET} - Localized environment & identity vault"
  echo ''
  echo -e "${BOLD}USAGE:${RESET}"
  echo '  rvenv <command> [<args>]'
  echo ''
  echo -e "${BOLD}IDENTITY COMMANDS:${RESET}"
  echo '  user --name NAME        Set global display name'
  echo '  user --username HANDLE  Set global username/handle'
  echo ''
  echo -e "${BOLD}CONFIGURATION:${RESET}"
  echo '  config --encryption METHOD  Set encryption backend (openssl/age)'
  echo ''
  echo -e "${BOLD}VAULT COMMANDS:${RESET}"
  echo '  init                     Initialize vault in the current directory'
  echo '  put KEY VALUE            Store or update a secret in the vault'
  echo '  list                     List all keys in the current vault'
  echo ''
  echo -e "${BOLD}ENVIRONMENT:${RESET}"
  echo '  enter                    Start a session with decrypted secrets'
  echo '  status                   Display identity and session information'
  echo '  uptime                   Show duration of the current session'
  echo ''
  echo -e "${BOLD}SYSTEM:${RESET}"
  echo '  version, -v, --version   Show version information'
  echo '  help                     Show this help message'
  echo ''
  echo -e "${BOLD}ENCRYPTION BACKENDS:${RESET}"
  echo '  openssl (default)        AES-256-CBC'
  echo '  age                      ChaCha20-Poly1305 (modern)'
  echo ''
}

# Command Router
case "$1" in
  -v | --version | version)
    echo "rvenv version $VERSION"
    exit 0
    ;;

  user) source "$ROOT_DIR/identity.sh" "${@:2}" ;;
  config) source "$ROOT_DIR/identity.sh" 'config' "${@:2}" ;;
  status) source "$ROOT_DIR/engine.sh" 'status' ;;
  uptime) source "$ROOT_DIR/engine.sh" 'uptime' ;;
  init) source "$ROOT_DIR/vault.sh" 'init' ;;
  put) source "$ROOT_DIR/vault.sh" 'put' "$2" "$3" ;;
  list) source "$ROOT_DIR/vault.sh" 'list' ;;
  enter) source "$ROOT_DIR/engine.sh" 'enter' ;;

  help | *)
    show_help
    ;;
esac
