#!/bin/bash

# Install pnpm
if ! command -v pnpm > /dev/null; then
    echo "Installing pnpm"
    curl -fsSL https://get.pnpm.io/install.sh | sh -
fi

if ! command -v node > /dev/null; then
    echo "No node version detected, installing temporal one"
    pnpm env use -g lts
fi

if ! command -v zx > /dev/null; then
    pnpm i -g zx
fi

