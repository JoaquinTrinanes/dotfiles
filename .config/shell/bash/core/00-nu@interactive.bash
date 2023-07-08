if ! command -v nu &>/dev/null; then
    return
fi

if [[ $(ps --no-header --pid=$PPID --format=comm) != "nu" && -z ${BASH_EXECUTION_STRING} ]]; then
    shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=''
    exec nu $LOGIN_OPTION
fi
