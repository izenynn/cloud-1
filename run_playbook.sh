#!/usr/bin/env bash

playbook="site.yml"

# Check for Vault password in the environment variable and run the playbook
if [ -z "$ANSIBLE_VAULT_PASSWORD" ]; then
    echo 'Info: Vault password environment variable (ANSIBLE_VAULT_PASSWORD) not set.'
    ansible-playbook \
        "$playbook" \
        --ask-vault-pass \
        "$@"
else
    ansible-playbook \
        "$playbook" \
        --vault-password-file <(echo "$ANSIBLE_VAULT_PASSWORD") \
        "$@"
fi
