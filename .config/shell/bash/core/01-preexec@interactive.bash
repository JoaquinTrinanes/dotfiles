PREEXEC_DIR="${XDG_CACHE_HOME}/bash"
PREEXEC_PATH="$PREEXEC_DIR/bash-preexec.sh"

if [[ ! -f "$PREEXEC_PATH" ]]; then
	mkdir -p "$PREEXEC_DIR"
	curl https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh -o "$PREEXEC_PATH"
fi

# shellcheck disable=1090
source "$PREEXEC_PATH"
