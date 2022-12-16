install_asdf_plugin_if_missing() {
    local plugin=$1
    local version=$2

    if ! asdf list 2> /dev/null | grep "$plugin" &> /dev/null; then
        asdf plugin add $plugin
        if [ ! -z $version ]; then
            asdf plugin update $plugin $version
        fi
    fi
}

install_asdf_plugin_if_missing nodejs
install_asdf_plugin_if_missing direnv

