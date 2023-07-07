#
# Core configuration module for zsh.
#

autoload -Uz compinit
compinit

setopt no_beep
setopt extended_glob
setopt interactive_comments

if command -v direnv &>/dev/null; then
    eval "$(direnv hook zsh)"
fi

if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi
