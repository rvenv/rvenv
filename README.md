## 🍃 rvenv

**The localized environment & identity vault.**

`rvenv` is a lightweight shell-based framework designed to manage project-specific identities and secure environment variables without polluting your global configuration. It allows developers to "step into" a workspace where the `PATH`, `PS1`, and `Secrets` are automatically scoped to that specific project.

### Architecture

The project is structured for transparency, security, and ease of build:

* **`src/`**: Contains the core logic including the Command Router, Identity Management, and the Environment Engine.
* **`bin/`**: The directory for compiled/linked binaries. This is ignored by version control to ensure platform-specific builds.
* **`Makefile`**: The orchestration layer used to automate the build, installation, and permission handling.
* **`.config/`**: Persistent storage for your global "Guardian" identity, kept separate from project source code.

## Installation

To install `rvenv` on your local machine, ensure you have `make` and `bash` installed, then follow these steps:

### 1. Clone the Repository
```bash
git clone [https://github.com/rvenv/rvenv.git](https://github.com/rvenv/rvenv.git)
cd rvenv
```
### 2. Run the Build & Install
The Makefile will compile the binary structure, set the necessary executable permissions, and guide you through your initial identity setup.

```Bash
make build
```
### 3. Verify Installation
After the installer finishes, you can verify the binary is ready by checking the local build:
```Bash
./bin/rvenv status
```
### 4. Setting upthe global command
Right after the local build is done, its time to make the `rvenv` command global, run:
```Bash
bash install.sh
```
### 5. Entering the environment
To enter your `rvenv` environment run:
```Bash
rvenv enter
```
## Contributing

We maintain high standards for code quality. Before submitting a Pull Request:

- Branching: Always work on a feature or fix branch (git checkout -b feature/name).

- Linting: Ensure all scripts pass ShellCheck analysis. We aim for zero warnings to ensure POSIX compliance and execution stability.

- Documentation: Update the CONTRIBUTING.md if adding internal logic.
