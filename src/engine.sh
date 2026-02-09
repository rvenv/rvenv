#!/bin/bash
# rvenv - Environment Engine (Full Version)

CONFIG_FILE="$HOME/.config/rvenv/user.json"

function enter() {
    # 1. Extract Identity
    local HANDLE=$(grep -oP '(?<="username": ")[^"]*' "$CONFIG_FILE" 2>/dev/null || echo "user")
    
    # 2. Locate the bin folder relative to this script to inject into PATH
    # This allows you to just type 'rvenv' instead of './bin/rvenv'
    local BIN_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../bin" && pwd )"
    
    # 3. Mark the Pulse (Start Time)
    date +%s > /tmp/rvenv_start
    
    echo -e "\e[32m[+]\e[0m Entering environment..."
    echo -e "\e[32m[+]\e[0m PATH updated with rvenv binaries."

    # 4. Launch the Subshell
    # We pass the PATH and the Custom Prompt (PS1)
    exec bash --rcfile <(echo "
        source ~/.bashrc
        export PATH=\"$BIN_PATH:\$PATH\"
        export PS1='\[\e[32m\]🍃 \[\e[36m\]$HANDLE\[\e[0m\]@rvenv:\[\e[34m\]\w\[\e[0m\] \$ '
        echo -e 'Environment active. Type \e[1mstaus\e[0m for info or \e[1mexit\e[0m to leave.'
    ")
}

function uptime() {
    if [ ! -f /tmp/rvenv_start ]; then
        echo "rvenv: No active session detected."
        return
    fi
    local START=$(cat /tmp/rvenv_start)
    local NOW=$(date +%s)
    local DIFF=$((NOW - START))
    
    local MIN=$((DIFF / 60))
    local SEC=$((DIFF % 60))
    
    echo -e "🍃 \e[32mrvenv uptime:\e[0m ${MIN}m ${SEC}s"
}

function status() {
    local HANDLE=$(grep -oP '(?<="username": ")[^"]*' "$CONFIG_FILE" 2>/dev/null || echo "unknown")
    local NAME=$(grep -oP '(?<="name": ")[^"]*' "$CONFIG_FILE" 2>/dev/null || echo "unknown")
    
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

# Route the internal engine calls
case "$1" in
    enter)  enter ;;
    uptime) uptime ;;
    status) status ;;
esac