#!/usr/bin/env bash

playbook='site.yml'

# Check if the 'debug' argument is passed
if [[ " $@ " =~ " --debug " ]]; then
    # Remove the '--debug' argument
    ARGS=$(echo "$@" | sed 's/--debug//')
    ansible-playbook "$playbook" $ARGS
else
    ansible-playbook "$playbook" --skip-tags debug $@
fi
