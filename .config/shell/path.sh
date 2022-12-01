#!/bin/sh

export CONFIG_DIR=~/.config

export XDG_CONFIG_HOME="$HOME/.config"
export CONFIG_DIR=$XDG_CONFIG_HOME

# Android
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$ANDROID_HOME/emulator:$PATH"
export PATH="$ANDROID_HOME/tools:$PATH"
export PATH="$ANDROID_HOME/tools/bin:$PATH"
export PATH="$ANDROID_HOME/platform-tools:$PATH"
export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
# End Android

export VIMCONFIG="$CONFIG_DIR/nvim/init.vim"

# Rust
[ -f $HOME/.cargo/env ] && . "$HOME/.cargo/env"

# GO
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$HOME/.local/bin:$PATH"

[ -f /etc/profile.d/autojump.sh ] && . /etc/profile.d/autojump.sh
[ -f /usr/local/etc/profile.d/autojump.sh ] && source /usr/local/etc/profile.d/autojump.sh

if [ $IS_MAC ]; then
    export PNPM_HOME="/Users/joaquin/Library/pnpm"
    export PATH="$PNPM_HOME:$PATH"
else
    export PNPM_HOME="/home/joaquin/.local/share/pnpm" 
    export PATH="$PNPM_HOME:$PATH"
fi

