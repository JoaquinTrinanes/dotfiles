#
# Core configuration module.
#

# smartcase when searching
export LESS="-i -R -F"

if command -v lvim &> /dev/null; then
    export EDITOR="lvim"
else
    export EDITOR="nvim"
fi

export VISUAL="$EDITOR"
