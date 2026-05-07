## Installation

To install `rvenv` on your local machine, ensure you have `make` and `bash` installed, then follow these steps:

### 1. Clone the Repository

```bash
git clone https://github.com/rvenv/rvenv.git
cd rvenv
```

### 2. Build the Project

```bash
make build
```

### 3. Run the Interactive Installer

```bash
make install
```

This will guide you through:

- Enabling global access (linking `rvenv` to `/usr/local/bin`)
- Setting up your identity (Name and Username)
- Initializing a Master Vault Password (stored locally at `~/.config/rvenv/.vault_pass`)

### 4. Verify Installation

```bash
rvenv --version
rvenv status
```

## Dependencies

- **Bash**: Required for script execution.
- **OpenSSL**: Default encryption backend (usually pre-installed).
- **Age**: Optional backend for modern encryption (install via `apt install age`, `brew install age`, etc.).
- **Make**: Required for the build process.

## Usage

### Identity Management

```bash
# Set your identity
rvenv user --name "John Doe" --username "johndoe"

# View current status
rvenv status
```
