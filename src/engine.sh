#!/bin/bash
# rvenv engine - Session management and environment orchestration

# shellcheck disable=SC1090
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
# shellcheck disable=SC1090
source "$(dirname "${BASH_SOURCE[0]}")/vault.sh"

UPTIME_FILE="/tmp/rvenv_start_$USER"

# --- Session Management ---

# Initialize a project-scoped environment session
enter() {
  local handle
  handle=$(get_json_val 'username' "$CONFIG_FILE")
  handle="${handle:-user}"

  local bin_path
  bin_path="$(cd "$(dirname "${BASH_SOURCE[0]}")/../bin" && pwd 2> /dev/null || echo "")"

  # Prevent recursive sessions
  if [[ -n "$RVENV_SESSION" ]]; then
    echo -e "${ICON_ERROR} Session already active. Use 'exit' to leave."
    return 1
  fi

  # Record session start time
  date +%s > "$UPTIME_FILE"

  echo -e "${ICON_PLUS} Entering environment..."
  [[ -n "$bin_path" ]] && echo -e "${ICON_PLUS} PATH updated with rvenv binaries."

  local rc_content="source ~/.bashrc\n"

  # Load and decrypt vault secrets
  if [[ -f "$VAULT_FILE" && "$(cat "$VAULT_FILE")" != '{}' ]]; then
    local password
    password=$(get_vault_password)
    echo -e "${ICON_PLUS} Decrypting secrets..."

    local success_count=0
    local total_count=0

    while IFS=: read -r key enc_val; do
      key=$(echo "$key" | tr -d ' "{},')
      enc_val=$(echo "$enc_val" | tr -d ' "{},')

      if [[ -n "$key" && -n "$enc_val" ]]; then
        total_count=$((total_count + 1))

        # Filter for valid Bash identifiers
        if [[ ! "$key" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
          echo -e "${ICON_WARN} Skipping invalid identifier: $key"
          continue
        fi

        local decrypted
        if decrypted=$(decrypt_data "$enc_val" "$password"); then
          rc_content+="export $key=\"$decrypted\"\n"
          success_count=$((success_count + 1))
        fi
      fi
    done < <(sed 's/[{}]//g' "$VAULT_FILE" | tr ',' '\n')

    if [[ "$success_count" -eq 0 && "$total_count" -gt 0 ]]; then
      echo -e "${ICON_ERROR} Decryption failed. Verify your password."
      return 1
    fi
    echo -e "${ICON_PLUS} Loaded $success_count secrets."
  fi

  # Configure subshell environment
  [[ -n "$bin_path" ]] && rc_content+="export PATH=\"$bin_path:\$PATH\"\n"
  rc_content+="export RVENV_SESSION=1\n"
  rc_content+="export PS1='\[${GREEN}\]rvenv \[${CYAN}\]${handle}\[${RESET}\]@rvenv:\[${BLUE}\]\w\[${RESET}\] \$ '\n"
  rc_content+="echo -e \"Environment active. Use 'status' for info or 'exit' to leave.\""

  # Spawn subshell with ephemeral configuration
  exec bash --rcfile <(printf "%b" "$rc_content")
}

# Report current session duration
uptime() {
  if [[ ! -f "$UPTIME_FILE" ]]; then
    echo "rvenv: No active session."
    return
  fi

  local start
  read -r start < "$UPTIME_FILE"
  local diff=$(($(date +%s) - start))
  printf "${GREEN}rvenv uptime:${RESET} %dm %ds\n" $((diff / 60)) $((diff % 60))
}

# Display environment identity and status
status() {
  local handle=$(get_json_val 'username' "$CONFIG_FILE")
  local name=$(get_json_val 'name' "$CONFIG_FILE")
  handle="${handle:-unknown}"
  name="${name:-unknown}"

  echo -e "${BLUE}${BOLD}┍━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┑${RESET}"
  echo -e "  ${CYAN}${BOLD}RVENV ENGINE${RESET} | ${BOLD}v1.0.0${RESET}"
  echo -e "${BLUE}┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┙${RESET}"
  printf " ${BOLD}Identity:${RESET}  %s (${CYAN}@%s${RESET})\n" "$name" "$handle"

  if [[ -n "$RVENV_SESSION" ]]; then
    echo -e " ${BOLD}Status:${RESET}    ${GREEN}● ACTIVE${RESET}"
    echo -n " "
    uptime
  else
    echo -e " ${BOLD}Status:${RESET}    ${RED}○ INACTIVE${RESET}"
  fi
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
}

# --- Router ---

case "$1" in
  enter) enter ;;
  uptime) uptime ;;
  status) status ;;
esac
