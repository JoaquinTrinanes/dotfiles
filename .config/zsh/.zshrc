[ -f $HOME/.zshrc.local ] && source $HOME/.zshrc.local

autoload -Uz compinit
compinit

# source antidote
source ${ZDOTDIR:-~}/.antidote/antidote.zsh

# initialize plugins statically with ${ZDOTDIR:-~}/.zsh_plugins.txt
antidote load
#
# Antigen (plugin) stuff
#antigen init ~/.antigenrc

unsetopt share_history

. ~/.profile

