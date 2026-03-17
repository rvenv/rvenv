#!/bin/bash
# rvenv - Identity Management

CONFIG_FILE="$HOME/.config/rvenv/user.json"

# Ensure config directory and file exist
mkdir -p "$HOME/.config/rvenv"
if [ ! -f "$CONFIG_FILE" ]; then
    echo '{"name": "", "username": "", "encryption": "openssl"}' > "$CONFIG_FILE"
fi

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
    --encryption)
        if [[ "$2" == "openssl" || "$2" == "age" ]]; then
            sed -i "s/\"encryption\": \"[^\"]*\"/\"encryption\": \"$2\"/" "$CONFIG_FILE"
            echo -e "\e[32m[+]\e[0m Encryption method set to: $2"
        else
            echo "Invalid encryption method. Choose 'openssl' or 'age'."
        fi
        ;;
    config)
        if [ "$2" == "--encryption" ]; then
            if [[ "$3" == "openssl" || "$3" == "age" ]]; then
                sed -i "s/\"encryption\": \"[^\"]*\"/\"encryption\": \"$3\"/" "$CONFIG_FILE"
                echo -e "\e[32m[+]\e[0m Encryption method set to: $3"
            else
                echo "Invalid encryption method. Choose 'openssl' or 'age'."
            fi
        else
            echo "Usage: rvenv config --encryption [openssl|age]"
        fi
        ;;
    *)
        echo "Usage: rvenv user [--name name | --username username]"
        echo "       rvenv config --encryption [openssl|age]"
        ;;
esac