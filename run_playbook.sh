#!/usr/bin/env bash

playbook="site.yml"

# Android (termux) bug with '~/.ansible/tmp' work around
os_name=$(uname -o)
if [ "$os_name" = "Android" ]; then
	export ANSIBLE_REMOTE_TMP='$HOME/.ansible/tmp'
fi

# Clean up function to ensure password file is deleted
cleanup() {
    echo "Cleaning up vault password file..."
    rm -f "$vault_password_file"
}

# Load environment variables from .env file
if [ -f .env ]; then
    export $(cat .env | xargs)
fi

# Check for Vault password in the environment variable and run the playbook
if [ -z "$ANSIBLE_VAULT_PASSWORD" ]; then
    echo 'Info: Vault password environment variable (ANSIBLE_VAULT_PASSWORD) not set.'
    ansible-playbook \
        "$playbook" \
        --ask-vault-pass \
        "$@"
else
    # Create a temporary file for the vault password
    vault_password_file=$(mktemp)
    echo "$ANSIBLE_VAULT_PASSWORD" > "$vault_password_file"
    echo "Info: Vault password stored in: $vault_password_file."
    trap cleanup EXIT

    ansible-playbook \
        "$playbook" \
        --vault-password-file "$vault_password_file" \
        "$@"
fi
