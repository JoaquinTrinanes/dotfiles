alias dots="yadm"
alias c="yadm"
alias grep="grep -E"
alias vim="nvim"

# what do you mean, command not found?
alias gerp="grep"
alias k0s="k9s"

alias k9s="k9s --readonly"

function curry() {
    exportfun=$1
    shift
    fun=$1
    shift
    params=$*
    cmd=$"function $exportfun() {
        more_params=\$*;
        $fun $params \$more_params;
    }"
    eval $cmd
}

# Creates a wrapper around a command
# Arguments:
#   $1: Path to the program to wrap. Can be relative.
#   $2: Name of the command
# Example:
#   createWrapper vendor/bin/sail composer
function createWrapper() {
    local wrapperPath="$1"
    shift
    local command="$1"
    [ ! -z "$command" ] && shift
    local wrapperCommandName=${command:-$(basename $wrapperPath)}

    # Calls $command with the given arguments.
    # If $wrapperPath exists, calls the program at $wrapperPath with the command name as argument
    cmd="
    function $wrapperCommandName () {
        if [ -f $wrapperPath ]; then
            $wrapperPath $command "\$*"
        else
            command $wrapperCommandName "\$*"
        fi
    }
    "
    eval $cmd
}

commandExists() {
    command -v $1 &>/dev/null
}

if commandExists xdg-open; then
    alias open="xdg-open"
fi

if commandExists exa; then
    local args=""
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

function .() {
    if [ $# -gt 0 ]; then
        builtin . "$@"
    else
        cd ..
    fi
}
