#!/bin/bash
# rvenv core router - Symlink-Aware Version

# Version Definition
VERSION="1.0.0"

# This magic line follows symlinks to find the actual source folder
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  ROOT_DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$ROOT_DIR/$SOURCE"
done
ROOT_DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

# shellcheck disable=SC1091

case "$1" in
    # Version checks
    -v|--version|version)
        echo "rvenv version $VERSION"
        exit 0
        ;;

    # setup and identity
    user)   source "$ROOT_DIR/identity.sh" "${@:2}" ;;
    config) source "$ROOT_DIR/identity.sh" "config" "${@:2}" ;;
    status) source "$ROOT_DIR/engine.sh" "status" ;;
    uptime) source "$ROOT_DIR/engine.sh" "uptime" ;;

    # work in the vault
    init)   source "$ROOT_DIR/vault.sh" "init" ;;
    put)    source "$ROOT_DIR/vault.sh" "put" "$2" "$3" ;;
    list)   source "$ROOT_DIR/vault.sh" "list" ;;

    # session management
    enter)  source "$ROOT_DIR/engine.sh" "enter" ;;

    # Specific command 'help' OR anything else '*'
    help|*)
        echo "🍃 rvenv - The localized environment & identity vault"
        echo ""
        echo "USAGE:"
        echo "  rvenv <command> [<args>]"
        echo ""
        echo "IDENTITY COMMANDS:"
        echo "  user --name NAME        Set your display name"
        echo "  user --username HANDLE  Set your username/handle"
        echo ""
        echo "CONFIGURATION:"
        echo "  config --encryption METHOD  Set encryption backend (openssl/age)"
        echo ""
        echo "VAULT COMMANDS:"
        echo "  init                     Initialize encrypted vault in current directory"
        echo "  put KEY VALUE            Store encrypted secret in vault"
        echo "  list                     List all vault keys (values hidden)"
        echo ""
        echo "ENVIRONMENT:"
        echo "  enter                    Start session with decrypted secrets loaded"
        echo "  status                   Show current identity and session info"
        echo "  uptime                   Show current session duration"
        echo ""
        echo "OTHER:"
        echo "  version                  Show rvenv version"
        echo "  help                     Show this help message"
        echo ""
        echo "ENCRYPTION BACKENDS:"
        echo "  openssl (default)        AES-256-CBC, no extra dependencies"
        echo "  age                      ChaCha20-Poly1305, modern encryption"
        echo "                           (falls back to openssl if age not installed)"
        echo ""
        echo "EXAMPLES:"
        echo "  rvenv user --name \"John Doe\" --username \"johndoe\""
        echo "  rvenv config --encryption age"
        echo "  rvenv init"
        echo "  rvenv put API_KEY \"secret\""
        echo "  rvenv enter"
        echo ""
        ;;
esac