.PHONY: build clean link-global

build:
	@echo " \033[1;34m[BUILD]\033[0m Starting compilation of rvenv components..."
	@mkdir -p bin
	@cp src/rvenv.sh bin/rvenv ...
	@chmod +x bin/* && echo "   -> \033[32m\033[0m Set executable permissions on all binaries" 
	@echo "\033[1;32m[SUCCESS]\033[0m Build complete in ./bin/"

link-global:
	@echo " \033[1;36m[LINK]\033[0m Creating global symlink in /usr/local/bin..."
	@sudo ln -sf $$(pwd)/bin/rvenv /usr/local/bin/rvenv
	@echo "   -> \033[32m\033[0m /usr/local/bin/rvenv -> $$(pwd)/bin/rvenv"

clean:
	@echo " \033[1;31m[CLEAN]\033[0m Removing build artifacts..."
	@rm -rf bin
	@echo "Done."