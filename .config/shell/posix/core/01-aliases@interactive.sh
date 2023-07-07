alias dots="yadm"
alias c="yadm"
alias grep="grep -E"


# what do you mean, command not found?
alias gerp="grep"
alias k0s="k9s"

alias k9s="k9s --readonly"


# Creates a wrapper around a command
# Arguments:
#   $1: Path to the program to wrap. Can be relative.
#   $2: Name of the command
# Example:
#   createWrapper vendor/bin/sail composer

commandExists() {
    command -v $1 &>/dev/null
}

if commandExists lvim; then
    alias vim="lvim"
else
    alias vim="nvim"
fi


if commandExists xdg-open; then
    alias open="xdg-open"
fi

if commandExists exa; then
    args=""
    if fc-list | grep "Nerd Font" &> /dev/null; then
        args=" --icons"
    fi
    alias ls="exa${args}"
    alias la="ls -la"
fi

if commandExists bat; then
    export BAT_THEME="$THEME"
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
    alias cat="bat -p"
fi

if commandExists helix; then
    alias hx="helix"
fi

# function .() {
#     if [ $# -gt 0 ]; then
#         builtin . "$@"
#     else
#         cd ..
#     fi
# }

unset -f commandExists
