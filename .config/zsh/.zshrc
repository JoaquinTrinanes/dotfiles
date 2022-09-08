autoload -Uz compinit
compinit

# autocomplete with same color as ls
system_type=$(uname -s)
if [ "$system_type" = "Darwin" ]; then
    export CLICOLOR=1
else
    eval "$(dircolors)"
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

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

