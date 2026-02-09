#!/bin/bash
# rvenv Installer - Talkative Version

set -e

echo -e "\033[1;32m🍃 rvenv Installer\033[0m"
echo "-----------------------------------------------"

# 1. Trigger the Makefile
echo "Building binaries from source..."
make build

# 2. Handle Global Path
echo ""
echo "System Integration"
read -p "   Enable global access (allows typing 'rvenv' anywhere)? [y/N]: " GLOBAL_ANS

if [[ "$GLOBAL_ANS" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    make link-global
else
    echo "   (Skipping global link. Use './bin/rvenv' for local execution.)"
fi

# 3. Identity Check
echo ""
echo "Identity Verification"
CONFIG_DIR="$HOME/.config/rvenv"
if [ ! -f "$CONFIG_DIR/user.json" ]; then
    echo "   [!] No identity found. Initializing Guardian setup..."
    ./bin/rvenv user
else
    NAME=$(grep -oP '(?<="name": ")[^"]*' "$CONFIG_DIR/user.json")
    echo "   [+] Identity confirmed: Welcome back, $NAME."
fi

echo ""
echo "-----------------------------------------------"
echo -e "\033[1;32m Installation Complete!\033[0m"