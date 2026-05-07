## Installation

To install `rvenv` on your local machine, follow the instructions for your environment.

### For Bash/Unix Environments

Ensure you have `make` and `bash` installed:

1. **Clone the Repository**
   ```bash
   git clone https://github.com/rvenv/rvenv.git
   cd rvenv
   ```
2. **Build the Project**
   ```bash
   make build
   ```
3. **Run the Interactive Installer**
   ```bash
   make install
   ```

### For PowerShell (Windows/Linux/macOS)

Ensure you have [PowerShell Core](https://github.com/PowerShell/PowerShell) installed:

1. **Clone the Repository**
   ```bash
   git clone https://github.com/rvenv/rvenv.git
   cd rvenv
   ```
2. **Install Globally**
   Run the installation script in PowerShell:
   ```powershell
   ./install.ps1
   ```
3. **Verify Installation**
   ```powershell
   Import-Module Rvenv
   Get-RvenvStatus
   ```

## Usage

### Identity Management

#### Bash
```bash
# Set your identity
rvenv user --name "John Doe" --username "johndoe"
# View current status
rvenv status
```

#### PowerShell
```powershell
# Set your identity
Update-Field -Key "name" -Value "John Doe" -Label "Name"
Update-Field -Key "username" -Value "johndoe" -Label "Username"

# View current status
Get-RvenvStatus
```

## Dependencies

- **Bash**: Required for Unix scripts.
- **PowerShell**: Required for cross-platform modules.
- **OpenSSL**: Required for encryption.
- **Age**: Optional (install via your package manager).
