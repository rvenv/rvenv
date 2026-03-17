## 🍃 rvenv

**The localized environment & identity vault.**

`rvenv` is a lightweight shell-based framework designed to manage project-specific identities and secure environment variables without polluting your global configuration. It allows developers to "step into" a workspace where the `PATH`, `PS1`, and encrypted secrets are automatically scoped to that specific project.

### Key Features

- **Encrypted Vault**: Store sensitive environment variables securely with AES-256 or ChaCha20 encryption
- **Identity Management**: Project-specific user identities and configurations
- **Environment Isolation**: Scoped shell environment per project
- **Configurable Encryption**: Choose between OpenSSL (default) or age for encryption
- **Modular Architecture**: Clean separation of concerns with router, engine, and vault components

### Architecture

The project is structured for transparency, security, and ease of build:

* **`src/`**: Contains the core logic including the Command Router, Identity Management, Environment Engine, and Vault operations.
* **`bin/`**: The directory for compiled/linked binaries. This is ignored by version control to ensure platform-specific builds.
* **`Makefile`**: The orchestration layer used to automate the build, installation, and permission handling.
* **`.config/`**: Persistent storage for your global "Guardian" identity and preferences, kept separate from project source code.
* **`.rvenv_vault`**: Project-specific encrypted vault file (per directory).

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

### 3. Install Globally (Optional)
```bash
make link-global
# OR for manual installation:
# sudo cp bin/rvenv /usr/local/bin/
```

### 4. Setup Your Identity
```bash
rvenv user --name "Your Name" --username "yourhandle"
```

### 5. Configure Encryption (Optional)
```bash
# Use modern age encryption (requires age to be installed)
rvenv config --encryption age

# Or stick with default OpenSSL
rvenv config --encryption openssl
```

### 6. Verify Installation
```bash
rvenv --version
rvenv status
```

## Usage

### Identity Management
```bash
# Set your identity
rvenv user --name "John Doe" --username "johndoe"

# View current status
rvenv status
```

### Vault Operations
```bash
# Initialize vault in current directory
rvenv init

# Store encrypted secrets
rvenv put API_KEY "your-secret-key"
rvenv put DB_PASSWORD "secure-password"

# List stored keys
rvenv list

# Enter environment (decrypts and loads secrets)
rvenv enter
```

### Configuration
```bash
# Choose encryption backend
rvenv config --encryption openssl  # Default, no extra deps
rvenv config --encryption age      # Modern, requires age
```

### Environment Session
```bash
# Start an rvenv session
rvenv enter

# Inside session: secrets are available as environment variables
echo $API_KEY      # Decrypted value available
echo $DB_PASSWORD  # Decrypted value available

# Exit session
exit
```

## Encryption Options

### OpenSSL (Default)
- **Pros**: Pre-installed on most systems, no dependencies
- **Cons**: Older cryptography (AES-256-CBC)
- **Use case**: Reliable default for all environments

### Age
- **Pros**: Modern cryptography (ChaCha20-Poly1305), simpler UX
- **Cons**: Requires installation (`apt install age`, `brew install age`)
- **Use case**: Enhanced security for advanced users

**Note**: If age is selected but not installed, rvenv automatically falls back to OpenSSL.

## Commands Reference

| Command | Description |
|---------|-------------|
| `rvenv user --name NAME` | Set your display name |
| `rvenv user --username HANDLE` | Set your username/handle |
| `rvenv config --encryption METHOD` | Choose encryption backend |
| `rvenv status` | Show current identity and session info |
| `rvenv init` | Initialize vault in current directory |
| `rvenv put KEY VALUE` | Store encrypted secret |
| `rvenv list` | List vault keys |
| `rvenv enter` | Start environment session with decrypted secrets |
| `rvenv uptime` | Show current session duration |
| `rvenv --version` | Show version information |

## Security

- **Encryption at Rest**: All secrets are encrypted using industry-standard algorithms
- **Password Protection**: Vault requires password for encryption/decryption
- **Session-Scoped**: Secrets only available during active rvenv sessions
- **No Plaintext Storage**: Secrets never stored in plaintext
- **Isolated Config**: User config separate from project code

## Contributing

We maintain high standards for code quality. Before submitting a Pull Request:

- Branching: Always work on a feature or fix branch (`git checkout -b feature/name`).
- Linting: Ensure all scripts pass ShellCheck analysis. We aim for zero warnings to ensure POSIX compliance and execution stability.
- Documentation: Update the README.md if adding user-facing features.
- Testing: Test encryption functionality thoroughly across different systems.
## Contributing

We maintain high standards for code quality. Before submitting a Pull Request:

- Branching: Always work on a feature or fix branch (git checkout -b feature/name).

- Linting: Ensure all scripts pass ShellCheck analysis. We aim for zero warnings to ensure POSIX compliance and execution stability.

- Documentation: Update the CONTRIBUTING.md if adding internal logic.
