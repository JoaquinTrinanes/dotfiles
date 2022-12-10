. ~/.profile

# brew autocompletion
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

autoload -Uz compinit bashcompinit
compinit
bashcompinit

# l: lowercase
# a: array
# U: unique
typeset -laU CUSTOM_ZSH_OPTIONS

local load_plugins_path=$ZDOTDIR/config/load_plugins.zsh
local zsh_config_files_path=$ZDOTDIR/config

for f in $zsh_config_files_path/*.zsh; do
    if [ "$f" != "$load_plugins_path" ]; then
        . $f
    fi
done

# all options should be set before loading the plugins
. $load_plugins_path

# CTRL+{left,right} to navigate whole words
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# setopt all the options in CUSTOM_ZSH_OPTIONS
setopt "${CUSTOM_ZSH_OPTIONS[@]}"

unset CUSTOM_ZSH_OPTIONS
