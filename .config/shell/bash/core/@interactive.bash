#
# Core configuration module for bash.
#

if command -v starship &>/dev/null; then
    eval "$(starship init bash)"
fi

if command -v direnv &>/dev/null; then
    eval "$(direnv hook bash)"
fi

alias reload='exec "$XSHELL"' # reload the current shell configuration
