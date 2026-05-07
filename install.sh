#!/bin/bash
# 1. Trigger the Makefile
make build
# 2. Handle Global Path
read -r -p "   Enable global access (allows typing 'rvenv' anywhere)? [y/N]: " GLOBAL_ANS
if [[ "$GLOBAL_ANS" =~ ^([yY][eE][sS]|[yY])$ ]]; then
  make link-global
else
  echo "   (Skipping global link. Use './bin/rvenv' for local execution.)"
fi

# 3. Identity and Vault Configuration
echo ''
echo '   --- Initial Configuration ---'
source ./src/common.sh
init_config

read -r -p '   Display Name: ' NAME
[[ -n "$NAME" ]] && ./bin/rvenv user --name "$NAME"

read -r -p '   Username/Handle: ' HANDLE
[[ -n "$HANDLE" ]] && ./bin/rvenv user --username "$HANDLE"

# 4. Master Password Setup
read -r -p '   Configure local master password (auto-unlock)? [y/N]: ' PASS_ANS
if [[ "$PASS_ANS" =~ ^([yY][eE][sS]|[yY])$ ]]; then

  NEW_PASS=''
  while [[ -z "$NEW_PASS" ]]; do
    read -r -s -p '   Master Password: ' NEW_PASS
    echo
    [[ -z "$NEW_PASS" ]] && echo '   [!] Password cannot be empty.'
  done
  echo "$NEW_PASS" > "$VAULT_PASS_FILE"
  chmod 600 "$VAULT_PASS_FILE"
  echo "   -> [OK] Master password saved to $VAULT_PASS_FILE"
  fi
echo ''
echo "   Setup complete. Type 'rvenv help' to begin."
