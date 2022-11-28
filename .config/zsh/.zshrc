. ~/.profile

for f in $ZDOTDIR/config/*.zsh; do
    . $f
done

# l: lowercase
# a: array
# U: unique
typeset -laU CUSTOM_ZSH_OPTIONS


. $ZDOTDIR/plugins/load.zsh

# setopt all the options in CUSTOM_ZSH_OPTIONS
. $ZDOTDIR/load_zsh_options.zsh

# CTRL+{left,right} to navigate whole words
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

unset CUSTOM_ZSH_OPTIONS
