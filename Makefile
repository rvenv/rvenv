# --- Configuration ---
BINARY_NAME = rvenv
BIN_DIR = bin
SRC_DIR = src
INSTALL_PATH = /usr/local/bin/$(BINARY_NAME)

# --- Colors for Terminal Output ---
BLUE   = \033[1;34m
GREEN  = \033[1;32m
CYAN   = \033[1;36m
RED    = \033[1;31m
RESET  = \033[0m

.PHONY: all build install link-global clean verify

# Default target: build and verify
all: build verify

## 1. Build: Prepares the local environment
build:
	@echo " $(BLUE)[BUILD]$(RESET) Preparing rvenv components..."
	@mkdir -p $(BIN_DIR)
	@cp $(SRC_DIR)/rvenv.sh $(BIN_DIR)/$(BINARY_NAME)
	@cp $(SRC_DIR)/engine.sh $(BIN_DIR)/engine.sh
	@cp $(SRC_DIR)/identity.sh $(BIN_DIR)/identity.sh
	@cp $(SRC_DIR)/vault.sh $(BIN_DIR)/vault.sh
	@chmod +x $(BIN_DIR)/*
	@echo "   -> $(GREEN)✔$(RESET) Binaries prepared in ./$(BIN_DIR)"

## 2. Verify: Catch CI bugs locally
verify:
	@echo " $(CYAN)[VERIFY]$(RESET) Validating build..."
	@if [ -f "$(BIN_DIR)/$(BINARY_NAME)" ]; then \
		echo "   -> $(GREEN)✔$(RESET) Binary exists"; \
	else \
		echo "   -> $(RED)✘$(RESET) Binary missing"; exit 1; \
	fi
	@./$(BIN_DIR)/$(BINARY_NAME) --version > /dev/null 2>&1 || (echo "   -> $(RED)✘$(RESET) --version check failed (check src/rvenv.sh logic)"; exit 1)
	@echo " $(GREEN)[SUCCESS]$(RESET) Build is stable."

## 3. Install: The end-user entry point
install: build
	@echo " $(BLUE)[INSTALL]$(RESET) Launching interactive installer..."
	@bash install.sh

## 4. Link-Global: For developers (quick symlinking)
link-global: build
	@echo " $(CYAN)[LINK]$(RESET) Linking $(BINARY_NAME) to $(INSTALL_PATH)..."
	@sudo ln -sf $$(pwd)/$(BIN_DIR)/$(BINARY_NAME) $(INSTALL_PATH)
	@echo "   -> $(GREEN)✔$(RESET) Global link active."

clean:
	@echo " $(RED)[CLEAN]$(RESET) Removing $(BIN_DIR) directory..."
	@rm -rf $(BIN_DIR)
	@echo " Done."