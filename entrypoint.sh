#!/bin/sh
set -eu

if [ -z "$INPUT_REMOTE_HOST" ]; then
    echo "Input remote_host is required!"
    exit 1
fi

if [ -z "$INPUT_SSH_KEY" ]; then
    echo "Input key is required!"
    exit 1
fi

# Extra handling for SSH-based connections.
if [ ${INPUT_REMOTE_HOST#"ssh://"} != "$INPUT_REMOTE_HOST" ]; then
    SSH_HOST=${INPUT_REMOTE_HOST#"ssh://"}
    SSH_HOST=${SSH_HOST#*@}
    mkdir -p ~/.ssh
    echo "$INPUT_SSH_KEY" > ~/.ssh/host_key
    ssh-copy-id -i ~/.ssh/host_key ${SSH_HOST}
    
fi

echo "Connecting to $INPUT_REMOTE_HOST..."
docker --log-level debug --host "$INPUT_REMOTE_HOST" "$@" 2>&1
