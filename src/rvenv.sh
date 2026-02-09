#!/bin/bash
# rvenv core router - Self-Locating Version

# Get the directory where THIS script is actually located
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

case "$1" in
    user)
        source "$ROOT_DIR/identity.sh" "${@:2}"
        ;;
    enter)
        source "$ROOT_DIR/engine.sh" "enter"
        ;;
    status)
        source "$ROOT_DIR/engine.sh" "status"
        ;;
    uptime)
        source "$ROOT_DIR/engine.sh" "uptime"
        ;;
    *)
        echo "Usage: rvenv [user|enter|status|uptime]"
        ;;
esac