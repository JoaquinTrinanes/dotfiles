#!/bin/sh

install_asdf_plugin_if_missing() {
    local plugin=$1
    local version=${2:-""}

    if ! asdf list 2> /dev/null | grep "$plugin" &> /dev/null; then
        asdf plugin add $plugin
    fi
    if ! [ -z $version ] && [ $version != "system" ] && ! asdf list $plugin | grep $version &> /dev/null; then
        asdf install $plugin $version
        asdf global $plugin $version
    fi
}

install_asdf_plugin_if_missing nodejs lts
install_asdf_plugin_if_missing direnv system
