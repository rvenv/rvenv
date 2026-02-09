#!/bin/bash
# rvenv - Environment Engine

CONFIG_FILE="$HOME/.config/rvenv/user.json"

function enter() {
    # Fix SC2155: Declare, then assign
    local HANDLE
    HANDLE=$(grep -oP '(?<="username": ")[^"]*' "$CONFIG_FILE" 2>/dev/null || echo "user")
    
    local BIN_PATH
    BIN_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../bin" && pwd )"
    
    # Track time
    date +%s > /tmp/rvenv_start
    
    echo -e "\e[32m[+]\e[0m Entering environment..."
    echo -e "\e[32m[+]\e[0m PATH updated with rvenv binaries."

    # Fix SC2028: Use printf for reliable escape sequences
    # We construct the RC file content safely
    local RC_CONTENT
    RC_CONTENT="source ~/.bashrc\n"
    RC_CONTENT+="export PATH=\"$BIN_PATH:\$PATH\"\n"
    RC_CONTENT+="export PS1='\[\e[32m\]🍃 \[\e[36m\]$HANDLE\[\e[0m\]@rvenv:\[\e[34m\]\w\[\e[0m\] \$ '\n"
    RC_CONTENT+="echo -e 'Environment active. Type \e[1mstatus\e[0m for info or \e[1mexit\e[0m to leave.'"

    exec bash --rcfile <(printf "%b" "$RC_CONTENT")
}

function uptime() {
    if [ ! -f /tmp/rvenv_start ]; then
        echo "rvenv: No active session detected."
        return
    fi
    
    # Fix SC2155: Split declaration
    local START
    START=$(cat /tmp/rvenv_start)
    
    local NOW
    NOW=$(date +%s)
    
    local DIFF=$((NOW - START))
    local MIN=$((DIFF / 60))
    local SEC=$((DIFF % 60))
    
    echo -e "🍃 \e[32mrvenv uptime:\e[0m ${MIN}m ${SEC}s"
}

function status() {
    # Fix SC2155
    local HANDLE
    HANDLE=$(grep -oP '(?<="username": ")[^"]*' "$CONFIG_FILE" 2>/dev/null || echo "unknown")
    
    local NAME
    NAME=$(grep -oP '(?<="name": ")[^"]*' "$CONFIG_FILE" 2>/dev/null || echo "unknown")
    
    echo -e "\e[1m--- rvenv status report ---\e[0m"
    echo -e "Guardian:  $NAME (@$HANDLE)"
    
    if [ -f /tmp/rvenv_start ]; then
        echo -e "Session:   \e[32mActive\e[0m"
        uptime
    else
        echo -e "Session:   \e[31mInactive\e[0m"
    fi
    echo -e "\e[1m---------------------------\e[0m"
}

case "$1" in
    enter)  enter ;;
    uptime) uptime ;;
    status) status ;;
esac