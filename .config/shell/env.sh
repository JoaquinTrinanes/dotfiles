#!/bin/sh

# smartcase when searching
export LESS="$LESS -i -R"

export EDITOR="nvim"
export VISUAL="code"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export CONFIG_DIR=$XDG_CONFIG_HOME

export VIMCONFIG="$CONFIG_DIR/nvim/init.vim"
