#!/bin/sh

alias .="cd .."

# Android stuff
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$ANDROID_HOME/emulator:$PATH"
export PATH="$ANDROID_HOME/tools:$PATH"
export PATH="$ANDROID_HOME/tools/bin:$PATH"
export PATH="$ANDROID_HOME/platform-tools:$PATH"
export ANDROID_SDK_ROOT="$HOME/Android/Sdk"

export EDITOR="nvim"

export VIMCONFIG="$HOME/.config/nvim/init.vim"

alias gerp="grep"

# just a little bit of extra security
alias k9s="k9s --readonly"

alias open="xdg-open"

export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$HOME/.local/bin:$PATH"

#source $HOME/.asdf/asdf.sh
#source $HOME/.asdf/completions/asdf.bash

source /etc/profile.d/autojump.sh
