#!/bin/sh

CONFIG_DIR=${XDG_CONFIG_HOME:-$HOME/.config}

if [ "$(uname -s)" == "Darwin" ]; then
    IS_MAC=0
fi

command_exists() {
    command -v "$@" &> /dev/null
}

install_package_if_missing() {
    local package=$1
    local bin=${2:-$package}

    if command_exists $bin; then
        echo "$package already installed, skipping"
        return
    fi

    echo "Installing $package"
    install_package "$package"
}


# Install antidote
if [ ! -d ${ZDOTDIR:-~}/.antidote ]; then
    git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
fi

# Install pnpm
if ! command_exists pnpm; then
    curl -fsSL https://get.pnpm.io/install.sh | sh -
fi

# Set kitty's theme based on the $THEME var
if [ -z "$THEME" ] && ! [ -f $CONFIG_DIR/kitty/theme.conf ]; then
    ln -s $CONFIG_DIR/kitty/themes/${THEME}.conf $CONFIG_DIR/kitty/theme.conf
fi

if [ -z "$(ls -A $XDG_DATA_HOME/nvim/site/pack/packer/start/packer.nvim)" ]; then
    echo "Bootstraping Vim"
    nvim '+PackerInstall' '+qall'
fi

install(){
    install_package_if_missing jq
    cat "$(dirname $0)/packagesToInstall.jsonc" |\
        grep -v '//' |\
        jq -r '.[] | if type!="object" then . else ([if $ENV.IS_MAC == "0" and has("mac") then .mac elif has("linux") then .linux else .name // .default end, .bin]  | @tsv) end' |\
        while IFS=$'\t' read -r pkgname bin; do
        if [ -z $pkgname ];then
            continue
        fi
        install_package_if_missing $pkgname $bin
    done

}

install
