#!/bin/bash

PNPM_HOME="$HOME/.local/share/pnpm"

ORIGINAL_PNPM_HOME="$PNPM_HOME"
ORIGINAL_PATH="$PATH"


# Install pnpm
if ! [ -f "$PNPM_HOME/pnpm" ]; then
    echo "Installing pnpm"
    # The install script will try to update the current shell config, this is avoided by unsetting it
    curl -fsSL https://get.pnpm.io/install.sh | env SHELL="" sh - | grep -v "ERR_PNPM_UNSUPPORTED_SHELL" || true
fi

if ! command -v node > /dev/null; then
    echo "No node version detected, installing temporal one"
    PNPM_HOME="$(mktemp -d)"
    PATH="$PNPM_HOME:$PATH"
    pnpm env -g use lts
fi

if ! (pnpm -g ls zx | grep "" > /dev/null); then
    echo "Installing zx"
    pnpm add -g zx
fi

cleanup_temp_node_install() {
    if (pnpm env -g list lts | grep ""); then
        echo "Deleting temporal node..."
        # pnpm -g rm zx # > /dev/null
        pnpm env -g rm lts # > /dev/null

        PNPM_HOME="$ORIGINAL_PNPM_HOME"
        PATH="$ORIGINAL_PATH"

        echo "Installing global zx for final node version..."
        pnpm add -g zx # > /dev/null
    fi
}

export -f cleanup_temp_node_install
