install:
	@echo "Installing rvenv..."
	@mkdir -p bin
	@cp src/rvenv.sh src/identity.sh src/engine.sh bin/
	# Rename it to the final command name
	@mv bin/rvenv.sh bin/rvenv
	@chmod +x bin/*
	@./install.sh
	@echo "Build complete. Run ./bin/rvenv"