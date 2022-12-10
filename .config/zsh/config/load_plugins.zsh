# Some plugin config must be set before they are loaded
for f in $(dirname "$0")/plugin_config/*.zsh; do
    . $f
done

typeset -gU cdpath fpath mailpath path

# You can change the names/locations of these if you prefer.
antidote_dir=${ZDOTDIR:-~}/.antidote

source $antidote_dir/antidote.zsh
antidote load

unset antidote_dir
