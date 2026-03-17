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
    # Colors
    local BOLD="\e[1m"
    local BLUE="\e[34m"
    local CYAN="\e[36m"
    local GREEN="\e[32m"
    local RED="\e[31m"
    local RESET="\e[0m"

    # Data Fetching
    local HANDLE
    HANDLE=$(grep -oP '(?<="username": ")[^"]*' "$CONFIG_FILE" 2>/dev/null || echo "unknown")
    local NAME
    NAME=$(grep -oP '(?<="name": ")[^"]*' "$CONFIG_FILE" 2>/dev/null || echo "unknown")

    # The Header
    printf "${BLUE}${BOLD}┍━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┑${RESET}\n"
    printf "  ${CYAN}${BOLD}RVENV ENGINE${RESET} | ${BOLD}v1.0.0${RESET}\n"
    printf "${BLUE}┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┙${RESET}\n"

    # The Body
    printf " ${BOLD}Identity:${RESET}  %s (${CYAN}@%s${RESET})\n" "$NAME" "$HANDLE"
    
    if [ -n "$RVENV_SESSION" ]; then
        printf " ${BOLD}Status:${RESET}    ${GREEN}● ACTIVE${RESET}\n"
        uptime
    else
        printf " ${BOLD}Status:${RESET}    ${RED}○ INACTIVE${RESET}\n"
    fi
    
    # The Footer
    printf "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
}

case "$1" in
    enter)  enter ;;
    uptime) uptime ;;
    status) status ;;
esac