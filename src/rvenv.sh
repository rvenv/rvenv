#!/bin/bash
# rvenv core router - Symlink-Aware Version

# This magic line follows symlinks to find the actual source folder
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  ROOT_DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$ROOT_DIR/$SOURCE"
done
ROOT_DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

# Now ShellCheck won't complain because we tell it where to look
# shellcheck disable=SC1091

case "$1" in
    user)   source "$ROOT_DIR/identity.sh" "${@:2}" ;;
    enter)  source "$ROOT_DIR/engine.sh" "enter" ;;
    status) source "$ROOT_DIR/engine.sh" "status" ;;
    uptime) source "$ROOT_DIR/engine.sh" "uptime" ;;
    init)   source "$ROOT_DIR/vault.sh" "init" ;;
    put)    source "$ROOT_DIR/vault.sh" "put" "$2" "$3" ;;
    list)   source "$ROOT_DIR/vault.sh" "list" ;;

    # Specific command 'help' OR anything else '*'
    # This MUST be the last block in the case statement
    help|*)
        echo "usage: rvenv <command> [<args>]"
        echo ""
        echo "These are common rvenv commands used in various situations:"
        echo "usage: rvenv <command> [--name|name] [--username|username] [<args>]"
        echo ""
        echo "These are common rvenv commands used in various situations:"
        echo ""
        echo "setup and identity"
        echo "   user       Set or update your Guardian identity (name/handle)"
        echo "   status     Show current identity and session state"
        echo ""
        echo "work in the vault"
        echo "   init       Initialize a new vault in the current directory"
        echo "   put        Store a secret key-value pair in the local vault"
        echo "   list       List all stored secret keys (hides values)"
        echo ""
        echo "session management"
        echo "   enter      Spawn a localized subshell with the leaf prompt"
        echo "   uptime     View the duration of the current active session"
        echo ""
        ;;
esac