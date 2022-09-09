autoload -Uz compinit
compinit

# loading the plugins defines a lot of aliases, we do it beforehand
# to override them in the common config
. $ZDOTDIR/plugins/load.zsh

. ~/.profile

# autocomplete with same color as ls
if [ $IS_MAC ]; then
    export CLICOLOR=1
else
    eval "$(dircolors)"
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

# tab select autocomplete
zstyle ':completion:*' menu select

unsetopt share_history

