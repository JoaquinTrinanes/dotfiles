#!/bin/sh

commandExists() {
    command -v $1 &> /dev/null
}

if commandExists exa; then
    alias ls="exa"
    alias la="exa -la"
fi

if commandExists bat; then
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
    alias cat="bat -p -p"
fi

alias .="cd .."
alias dots="yadm"
alias grep="egrep"

# what do you mean, command not found?
alias gerp="grep"
alias k0s="k9s"

# Android stuff
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$ANDROID_HOME/emulator:$PATH"
export PATH="$ANDROID_HOME/tools:$PATH"
export PATH="$ANDROID_HOME/tools/bin:$PATH"
export PATH="$ANDROID_HOME/platform-tools:$PATH"
export ANDROID_SDK_ROOT="$HOME/Android/Sdk"

export EDITOR="nvim"

export VIMCONFIG="$HOME/.config/nvim/init.vim"

# just a little bit of extra security
alias k9s="k9s --readonly"

alias open="xdg-open"

export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$HOME/.local/bin:$PATH"

source /etc/profile.d/autojump.sh
