#!/bin/sh

alias .="cd .."

# alias vi="vim"
# alias vim="nvim"

export VIMCONFIG="$HOME/.config/nvim/init.vim"

alias gerp="grep"

alias k9s="k9s --readonly"

alias open="xdg-open"

export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$HOME/.local/bin:$PATH"

#source $HOME/.asdf/asdf.sh
#source $HOME/.asdf/completions/asdf.bash

source /etc/profile.d/autojump.sh
