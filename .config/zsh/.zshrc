autoload -Uz compinit bashcompinit
compinit
bashcompinit

# loading the plugins defines a lot of aliases, we do it beforehand
# to override them in the common config
. $ZDOTDIR/plugins/load.zsh

. ~/.profile

. $ZDOTDIR/autocomplete.zsh

# CTRL+{left,right} to navigate whole words
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word


HISTFILE="$CONFIG_DIR/zsh/.history"
SAVEHIST=1000

