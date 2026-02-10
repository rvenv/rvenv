#!/bin/bash
# rvenv - Environment Engine

CONFIG_FILE="$HOME/.config/rvenv/user.json"

function enter() {
    # Fix SC2155: Declare, then assign
    local HANDLE
    HANDLE=$(grep -oP '(?<="username": ")[^"]*' "$CONFIG_FILE" 2>/dev/null || echo "user")
    
    local BIN_PATH
    BIN_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../bin" && pwd )"
    
    # RECURSIVE CHECK: Prevents opening a subshell within a subshell
    if [ -n "$RVENV_SESSION" ]; then
        printf "\e[31m[!]\e[0m Shell Inception detected. Already in rvenv session.\n"
        printf "    Use 'exit' to leave the current session first.\n"
        return 1
    fi
    
    # Track time
    date +%s > /tmp/rvenv_start
    
    printf "\e[32m[+]\e[0m Entering environment...\n"
    printf "\e[32m[+]\e[0m PATH updated with rvenv binaries.\n"

    # Define subshell configuration
    local RC_CONTENT
    RC_CONTENT="source ~/.bashrc\n"
    RC_CONTENT+="export PATH=\"$BIN_PATH:\$PATH\"\n"
    RC_CONTENT+="export RVENV_SESSION=1\n"
    RC_CONTENT+="export PS1='\[\e[32m\]rvenv \[\e[36m\]$HANDLE\[\e[0m\]@rvenv:\[\e[34m\]\w\[\e[0m\] \$ '\n"
    RC_CONTENT+="echo -e 'Environment active. Type \e[1mstatus\e[0m for info or \e[1mexit\e[0m to leave.'"

    # Execute bash with the session marker and custom prompt
    exec bash --rcfile <(printf "%b" "$RC_CONTENT")
}

function uptime() {
    if [ ! -f /tmp/rvenv_start ]; then
        printf "rvenv: No active session detected.\n"
        return
    fi
    
    local START
    START=$(cat /tmp/rvenv_start)
    
    local NOW
    NOW=$(date +%s)
    
    local DIFF=$((NOW - START))
    local MIN=$((DIFF / 60))
    local SEC=$((DIFF % 60))
    
    printf "\e[32mrvenv uptime:\e[0m %dm %ds\n" "$MIN" "$SEC"
}

function status() {
    local HANDLE
    HANDLE=$(grep -oP '(?<="username": ")[^"]*' "$CONFIG_FILE" 2>/dev/null || echo "unknown")
    
    local NAME
    NAME=$(grep -oP '(?<="name": ")[^"]*' "$CONFIG_FILE" 2>/dev/null || echo "unknown")
    
    printf "\e[1m--- rvenv status report ---\e[0m\n"
    printf "Guardian:  %s (@%s)\n" "$NAME" "$HANDLE"
    
    if [ -n "$RVENV_SESSION" ]; then
        printf "Session:   \e[32mActive\e[0m\n"
        uptime
    else
        printf "Session:   \e[31mInactive\e[0m\n"
    fi
    printf "\e[1m---------------------------\e[0m\n"
}

case "$1" in
    enter)  enter ;;
    uptime) uptime ;;
    status) status ;;
esac