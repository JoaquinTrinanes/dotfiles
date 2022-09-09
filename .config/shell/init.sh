#!/bin/sh

# TODO: move to external config folder? Like .config/shell

export CONFIG_DIR=~/.config


. $CONFIG_DIR/shell/env

for f in $CONFIG_DIR/shell/config/*; do
    . $f
done

# smartcase when searching
export LESS="$LESS -i -R"

export XDG_CONFIG_HOME="$HOME/.config"
export CONFIG_DIR=$XDG_CONFIG_HOME

# Android stuff
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$ANDROID_HOME/emulator:$PATH"
export PATH="$ANDROID_HOME/tools:$PATH"
export PATH="$ANDROID_HOME/tools/bin:$PATH"
export PATH="$ANDROID_HOME/platform-tools:$PATH"
export ANDROID_SDK_ROOT="$HOME/Android/Sdk"

export EDITOR="nvim"

export VIMCONFIG="$CONFIG_DIR/nvim/init.vim"

# Rust
[ -f $HOME/.cargo/env ] && . "$HOME/.cargo/env"

# GO
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$HOME/.local/bin:$PATH"

[ -f /etc/profile.d/autojump.sh ] && . /etc/profile.d/autojump.sh
[ -f /usr/local/etc/profile.d/autojump.sh ] && source /usr/local/etc/profile.d/autojump.sh

