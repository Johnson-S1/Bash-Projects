
# User Lifecycle Management Automation Script

This script automates user provisioning tasks including user creation, group assignment, ACL configuration, and SSH key deployment.

## Features

- User creation with home directory
- Group creation and assignment
- ACL configuration for specific directories
- SSH key-based authentication setup
- Idempotent design (safe to run multiple times)

## How it Works

The script takes a username and public SSH key as input. It ensures the user exists, assigns required groups, configures permissions, and sets up secure SSH access.

## Usage

```bash
chmod +x user_setup.sh
./user_setup.sh <username> "<ssh-public-key>"

## Usage

./user_setup.sh devuser "ssh-rsa AAAAB3NzaC1..."

## Sample STDOUT

2026-02-25 16:30:34 | Starting user lifecycle setup for daphne
2026-02-25 16:30:35 | Username daphne Successfully Created
2026-02-25 16:30:35 | Group support create
2026-02-25 16:30:35 | Added daphne to support group
2026-02-25 16:30:35 | Group developers create
2026-02-25 16:30:35 | Added daphne to developers group
2026-02-25 16:30:35 | ACL set for daphne on /tmp
2026-02-25 16:30:35 | SSH key deployed for daphne
2026-02-25 16:30:35 | User lifecycle setup completed

## Notes

- Only public key is required (private key remains on client side)
- Ensures .ssh directory and permissions are correctly set
- Uses setfacl for fine-grained access control
