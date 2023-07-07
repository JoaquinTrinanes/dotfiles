#
# Core configuration module for zsh.
#

autoload -Uz compinit
compinit

if command -v direnv &>/dev/null; then
    eval "$(direnv hook zsh)"
fi
