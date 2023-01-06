# Some plugin config must be set before they are loaded
for f in $(dirname "$0")/plugin_config/*.zsh; do
    . $f
done

typeset -gU cdpath fpath mailpath path

antidote_dir=${ZDOTDIR:-~}/.antidote
plugins_txt=${ZDOTDIR:-~}/zsh_plugins.txt
static_file=${ZDOTDIR:-~}/.zsh_plugins.zsh

# Clone antidote if necessary and generate a static plugin file.
if [[ ! $static_file -nt $plugins_txt ]]; then
    [[ -e $antidote_dir ]] ||
    git clone --depth=1 https://github.com/mattmc3/antidote.git $antidote_dir
    (
        source $antidote_dir/antidote.zsh
        [[ -e $plugins_txt ]] || touch $plugins_txt
        antidote bundle <$plugins_txt >$static_file
    )
fi

autoload -Uz $antidote_dir/functions/antidote

source $static_file

unset antidote_dir plugins_txt static_file f
