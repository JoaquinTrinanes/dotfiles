autoload -Uz compinit
compinit

# loading the plugins defines a lot of aliases, we do it beforehand
# to override them in the common config
. $ZDOTDIR/plugins/load.zsh

. ~/.profile

# CTRL+{left,right} to navigate whole words
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

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

