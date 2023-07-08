commandExists() {
    command -v $1 &>/dev/null
}

alias reload='exec "$XSHELL"' # reload the current shell configuration

alias k9s="k9s --readonly"
alias dots="yadm"
alias c="yadm"

# if command -v sd &> /dev/null; then
#     alias sed="sd"
# fi

if commandExists rg; then
    alias grep="rg"
else
    alias grep="grep -E"
fi

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

unset -f commandExists