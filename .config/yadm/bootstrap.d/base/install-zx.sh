#!/bin/bash

PNPM_HOME="$HOME/.local/share/pnpm"

cleanup_temp_node_install() {
    if pnpm env -g list lts | grep "" &> /dev/null; then
        echo "Deleting temporal node..."
        pnpm -g rm zx > /dev/null
        pnpm env -g remove lts > /dev/null

        echo "Installing global zx for final node version..."
        pnpm i -g zx > /dev/null
    fi
}

# Install pnpm
if ! [ -f "$PNPM_HOME/pnpm" ]; then
    echo "Installing pnpm"
    # The install script will try to update the current shell config, this is avoided by unsetting it
    curl -fsSL https://get.pnpm.io/install.sh | env SHELL="" sh - | grep -v "ERR_PNPM_UNSUPPORTED_SHELL" || true
fi

if ! command -v node > /dev/null; then
    echo "No node version detected, installing temporal one"
    pnpm env -g use lts
fi

if ! pnpm -g ls zx | grep "" > /dev/null; then
    echo "Installing zx"
    pnpm i -g zx
fi

export -f cleanup_temp_node_install
