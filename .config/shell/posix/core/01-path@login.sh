prepend_path () {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            PATH="$1${PATH:+:$PATH}"
    esac
}

# Android
export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
prepend_path "$ANDROID_HOME/emulator"
prepend_path "$ANDROID_HOME/tools"
prepend_path "$ANDROID_HOME/tools/bin"
prepend_path "$ANDROID_HOME/platform-tools"
# End Android

# Rust
[ -f $HOME/.cargo/env ] && . "$HOME/.cargo/env"
prepend_path "$HOME/.cargo/bin"

# GO
export GOPATH="$HOME/go"
prepend_path "$GOPATH/bin"

if [ "$(uname -s)" = "Darwin" ]; then
    export IS_MAC=0
fi

[ -f /etc/profile.d/autojump.sh ] && . /etc/profile.d/autojump.sh
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
prepend_path "$PNPM_HOME"

prepend_path "$HOME/.local/bin"

# asdf: why is it not in a normal path?
if [ $IS_MAC ];then
    prepend_path "$(brew --prefix asdf)/bin"
else
    prepend_path "/opt/asdf-vm/bin"
fi
# asdf: detect global versions outside projects without using the shims
prepend_path "$HOME/.asdf/shims"

unset -f prepend_path
