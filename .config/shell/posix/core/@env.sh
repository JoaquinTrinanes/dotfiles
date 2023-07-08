#
# Core configuration module.
#

# smartcase when searching
export LESS="-i -R -F"

if command -v lvim &>/dev/null; then
    export EDITOR="lvim"
else
    export EDITOR="nvim"
fi

export VISUAL="$EDITOR"

export NVIM_HOME="$XDG_CONFIG_HOME/nvim"

export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"
