autoload -Uz compinit
compinit

# autocomplete with same color as ls
eval "$(dircolors)"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# tab select autocomplete
zstyle ':completion:*' menu select

# TODO: move elsewhere
export ZSH_DOTENV_PROMPT=false
export NVM_COMPLETION=true
export NVM_AUTO_USE=true

# source antidote
source ${ZDOTDIR:-~}/.antidote/antidote.zsh

# initialize plugins statically with ${ZDOTDIR:-~}/.zsh_plugins.txt
antidote load

unsetopt share_history

. ~/.profile

