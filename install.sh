#!/bin/bash
# rvenv - System Installation Script

# Define paths
CONFIG_DIR="$HOME/.config/rvenv"
CONFIG_FILE="$CONFIG_DIR/user.json"

# Initialize System
mkdir -p "$CONFIG_DIR"

echo -e "\e[32m[+]\e[0m rvenv initialization..."

# Onboarding (Required for engine identity)
if [ ! -f "$CONFIG_FILE" ]; then
    read -p "Enter System Name: " NAME
    read -p "Enter System Handle (username): " UNAME
    echo "{\"name\": \"$NAME\", \"username\": \"$UNAME\"}" > "$CONFIG_FILE"
else
    echo -e "\e[32m[+]\e[0m Identity configuration detected."
fi

# Finalizing
echo -e "\e[32m[+]\e[0m System ready. Binary located in ./bin/rvenv"