#
# Core configuration module for zsh.
#

setopt no_beep
setopt extended_glob
setopt interactive_comments
setopt noclobber

if command -v direnv &>/dev/null; then
    eval "$(direnv hook zsh)"
fi

if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh --cmd j)"
fi
