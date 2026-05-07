# rvenv Usage Guide

This guide covers advanced usage and configuration of `rvenv`.

## Identity & Configuration

### Global Identity

Your global identity is used to customize the shell prompt and status reports.

```bash
rvenv user --name "John Doe" --username "johndoe"
```

### Encryption Backends

`rvenv` supports two encryption backends:

- **openssl** (default): Uses AES-256-CBC. No extra dependencies required on most systems.
- **age**: Uses modern ChaCha20-Poly1305. Requires the `age` tool to be installed.

Switch backends with:

```bash
rvenv config --encryption age
```

## Vault Management

### Key Naming Rules

To ensure secrets can be exported as environment variables, all keys must follow Bash identifier rules:

- Must start with a letter (`a-z`, `A-Z`) or underscore (`_`).
- Can only contain alphanumeric characters and underscores.
- **Examples**: `API_KEY`, `_secret`, `db_pass_123`.

### Master Password

During installation, you can set a master password. This is stored at `~/.config/rvenv/.vault_pass` with restricted permissions (`600`).
If this file exists, `rvenv` will use it to automatically decrypt your vaults.

To manually manage this file:

- **To save/update**: `echo "your-pass" > ~/.config/rvenv/.vault_pass && chmod 600 ~/.config/rvenv/.vault_pass`
- **To remove**: `rm ~/.config/rvenv/.vault_pass`

## Environment Sessions

### Entering a Session

```bash
rvenv enter
```

When you enter a session:

1. `rvenv` looks for a `.rvenv_vault` in the current directory.
2. It decrypts the secrets using your password.
3. It spawns a new Bash subshell.
4. It exports the decrypted secrets as environment variables.
5. It updates your `PATH` to include project-local binaries.
6. It updates your `PS1` (prompt) to show your `rvenv` identity.

### Checking Status

Inside or outside a session, use `status` to see your current environment:

```bash
rvenv status
```

### Session Uptime

To see how long your current session has been active:

```bash
rvenv uptime
```

### Leaving a Session

Simply type `exit` or press `Ctrl+D` to return to your global shell. All environment variables and path changes will be cleared.
