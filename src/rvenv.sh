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
        echo "usage: rvenv <command> [<args>]"
        echo ""
        echo "commands:"
        echo "  user      Set or update your Guardian identity (name/handle)"
        echo "  status    Show current identity and session state"
        echo "  init      Initialize a new vault in the current directory"
        echo "  put       Store a secret key-value pair in the local vault"
        echo "  list      List all stored secret keys (hides values)"
        echo "  enter     Spawn a localized subshell with the leaf prompt"
        echo "  uptime    View the duration of the current active session"
        echo "  version   Show current rvenv version"
        echo ""
        ;;
esac