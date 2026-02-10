# 1. Trigger the Makefile
make build
# 2. Handle Global Path
read -p "   Enable global access (allows typing 'rvenv' anywhere)? [y/N]: " GLOBAL_ANS
if [[ "$GLOBAL_ANS" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    make link-global
else
    echo "   (Skipping global link. Use './bin/rvenv' for local execution.)"
fi