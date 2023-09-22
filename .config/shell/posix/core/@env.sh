#
# Core configuration module.
#

# smartcase when searching
export LESS="-i -R -F"

if command -v nvim >/dev/null 2>&1; then
	export EDITOR="nvim"
else
	export EDITOR="vim"
fi

export VISUAL="$EDITOR"
