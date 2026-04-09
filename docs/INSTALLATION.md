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