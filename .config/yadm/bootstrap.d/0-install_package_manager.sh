#!/bin/sh

declare -a package_managers_to_install=(yay brew)
declare -a package_manager_order=(yay pacman apt-get brew)

current_package_manager() {
    for package_manager in "${package_manager_order[@]}"; do
        if command -v "$package_manager" > /dev/null; then
            echo "$package_manager"
            return
        fi
    done
}

get_is_installed_command() {
    local package_manager="$(current_package_manager)"
    case $package_manager in
        yay) echo "yay -Q" ;;
        pacman) echo "pacman -Q" ;;
        apt-get) echo "sudo apt-get -qq list --installed" ;;
        brew) echo "brew list --quiet" ;;
    esac
}

get_install_command(){
    local package_manager="$(current_package_manager)"
    case $package_manager in
        yay) echo "yay --noprogressbar --noconfirm -S" ;;
        pacman) echo "sudo pacman --noprogressbar --noconfirm -S" ;;
        apt-get) echo "sudo apt-get -qq --yes install" ;;
        brew) echo "brew install --quiet" ;;
    esac
}

install_brew() {
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
}

install_yay() {
    local tmp_dir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git $tmpdir
    cd $tmp_dir
    makepkg -si
}

install_package_manager_if_missing() {
    if ! command -v yay brew > /dev/null; then
        inf "Installing package manager"
        case  $(uname -s) in
            Darwin)
                install_brew
                ;;
            Linux)
                install_yay
                ;;
        esac
    fi
}

install_package() {
    local package_manager=$(current_package_manager)
    inf "Installing $1 with $package_manager"
    local install_command="$(get_install_command)"
    $install_command "$@"
}

is_package_installed() {
    local is_installed_command="$(get_is_installed_command)"
    $is_installed_command "$@" &> /dev/null
}

install_package_manager_if_missing

export -f install_package is_package_installed