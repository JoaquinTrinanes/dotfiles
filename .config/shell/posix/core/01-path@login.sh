
# Android
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$ANDROID_HOME/emulator:$PATH"
export PATH="$ANDROID_HOME/tools:$PATH"
export PATH="$ANDROID_HOME/tools/bin:$PATH"
export PATH="$ANDROID_HOME/platform-tools:$PATH"
export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
# End Android

# Rust
[ -f $HOME/.cargo/env ] && . "$HOME/.cargo/env"
export PATH="$HOME/.cargo/bin:$PATH"

# GO
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

if [ "$(uname -s)" = "Darwin" ]; then
    export IS_MAC=0
fi

[ -f /etc/profile.d/autojump.sh ] && . /etc/profile.d/autojump.sh
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

export PATH="$HOME/.local/bin"

# asdf: why is it not in a normal path?
if [ $IS_MAC ];then
    PATH="$(brew --prefix asdf)/bin:$PATH"
else
    PATH="/opt/asdf-vm/bin:$PATH"
fi
# asdf: detect global versions outside projects without using the shims
export PATH="$HOME/.asdf/shims:$PATH"
