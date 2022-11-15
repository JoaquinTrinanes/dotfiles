# Some plugins need this activated
autoload -Uz compinit bashcompinit
compinit
bashcompinit

typeset -la CUSTOM_ZSH_OPTIONS

# loading the plugins defines a lot of aliases, we do it beforehand
# to override them in the common config
. $ZDOTDIR/plugins/load.zsh

. ~/.profile

for f in $ZDOTDIR/config/*.zsh; do
    . $f
done

. $ZDOTDIR/load_zsh_options.zsh

# CTRL+{left,right} to navigate whole words
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

unset CUSTOM_ZSH_OPTIONS
