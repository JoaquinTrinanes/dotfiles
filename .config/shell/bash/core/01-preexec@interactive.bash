local PREEXEC_DIR="${XDG_CACHE_HOME}/bash"
local PREEXEC_PATH="$PREEXEC_DIR/bash-preexec.sh"

if [[ ! -f "$PREEXEC_PATH" ]]; then
    mkdir -p "$PREEXEC_DIR"
    curl https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh -o "$PREEXEC_PATH"
fi

source "$PREEXEC_PATH"
