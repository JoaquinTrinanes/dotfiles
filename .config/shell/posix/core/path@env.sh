prepend_path () {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            export PATH="$1${PATH:+:$PATH}"
    esac
}

# Rust
[ -f $HOME/.cargo/env ] && . "$HOME/.cargo/env"
prepend_path "$HOME/.cargo/bin"

# GO
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
prepend_path "$GOPATH/bin"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
prepend_path "$PNPM_HOME"

prepend_path "$HOME/.local/bin"

# pip-installed binaries
if command -v python &> /dev/null; then
    prepend_path "$(python -m site --user-base)/bin"
fi

unset -f prepend_path
