#!/bin/bash

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
if ! command -v pnpm > /dev/null; then
    echo "Installing pnpm"
    curl -fsSL https://get.pnpm.io/install.sh | sh -
fi

if ! command -v node > /dev/null; then
    echo "No node version detected, installing temporal one"
    pnpm env -g use lts
fi

if ! command -v zx > /dev/null; then
    echo "Installing zx"
    pnpm i -g zx
fi

export -f cleanup_temp_node_install
