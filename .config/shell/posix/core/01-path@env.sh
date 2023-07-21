prepend_path () {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            export PATH="$1${PATH:+:$PATH}"
    esac
}

export NVIM_HOME="$XDG_CONFIG_HOME/nvim"
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"

# Rust
export CARGO_HOME="$XDG_DATA_HOME/cargo"
prepend_path "$CARGO_HOME/bin"

# GO
export GOPATH="$XDG_DATA_HOME/go"
export GOBIN="$XDG_BIN_HOME/go/bin"
prepend_path "$GOBIN"

# pip-installed binaries
if command -v python &> /dev/null; then
    prepend_path "$(python -m site --user-base)/bin"
fi

# pnpm
export PNPM_HOME="$XDG_DATA_HOME/pnpm"
prepend_path "$PNPM_HOME"

prepend_path "$XDG_BIN_HOME"

unset -f prepend_path
