#!/bin/bash
# rvenv - Identity Management

CONFIG_FILE="$HOME/.config/rvenv/user.json"

case "$1" in
    --name)
        # Update name in JSON (using sed for simple text replacement)
        sed -i "s/\"name\": \"[^\"]*\"/\"name\": \"$2\"/" "$CONFIG_FILE"
        echo -e "\e[32m[+]\e[0m Name updated to: $2"
        ;;
    --username)
        # Update username in JSON
        sed -i "s/\"username\": \"[^\"]*\"/\"username\": \"$2\"/" "$CONFIG_FILE"
        echo -e "\e[32m[+]\e[0m Username updated to: $2"
        ;;
    *)
        echo "Usage: rvenv user [--name name | --username username]"
        ;;
esac