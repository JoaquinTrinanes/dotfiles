#!/bin/bash

ORIGINAL_PNPM_HOME="${PNPM_HOME:=$HOME/.local/share/pnpm}"
ORIGINAL_PATH="$PATH"

PATH="$PNPM_HOME:$PATH"

cleanup_temp_node_install() {
    echo "Deleting temporal node..."
    if pnpm env -g rm lts > /dev/null; then
        echo "Installing global zx for final node version..."
        pnpm add -g zx
    fi
    PNPM_HOME="$ORIGINAL_PNPM_HOME"
    PATH="$ORIGINAL_PATH"
}

# trap cleanup_temp_node_install EXIT
export PNPM_HOME=$PNPM_HOME
# Install pnpm
if ! [ -f "$PNPM_HOME/pnpm" ]; then
    echo "Installing pnpm"
    # The install script will try to update the current shell config, this is avoided by unsetting it
    #curl -fsSL https://get.pnpm.io/install.sh | env SHELL="" sh - | grep -v "ERR_PNPM_UNSUPPORTED_SHELL" || true
    curl -fsSL https://get.pnpm.io/install.sh | sh - | grep -v "ERR_PNPM_UNSUPPORTED_SHELL" || true
fi

if ! command -v node > /dev/null; then
    echo "No node version detected, installing"
    #PNPM_HOME="$(mktemp -d)"
    #PATH="$PNPM_HOME:$PATH"
    #    PATH=$PATH PNPM_HOME=$PNPM_HOME
    pnpm env -g use lts
fi

echo "Installing zx"
pnpm add -g zx --prefer-offline
