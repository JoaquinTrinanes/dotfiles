. ~/.profile

autoload -Uz compinit
compinit

# autocomplete with same color as ls
if [ $IS_MAC ]; then
    export CLICOLOR=1
else
    eval "$(dircolors)"
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

# tab select autocomplete
zstyle ':completion:*' menu select


# source antidote
. $ZDOTDIR/plugins/load.zsh

unsetopt share_history

