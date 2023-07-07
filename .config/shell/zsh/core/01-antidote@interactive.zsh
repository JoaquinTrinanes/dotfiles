export ANTIDOTE_HOME=${XDG_DATA_HOME:-~/.cache}/antidote
if [ ! -e $ANTIDOTE_HOME ]; then
    git clone --depth=1 https://github.com/mattmc3/antidote.git $ANTIDOTE_HOME
fi

local bundlefile=${0:a:h}/plugins.txt
zstyle ':antidote:bundle' file $bundlefile

local staticfile=${XDG_CACHE_HOME:-~/.cache}/antidote/zsh_static.zsh
zstyle ':antidote:static' file $staticfile

. $ANTIDOTE_HOME/antidote.zsh

antidote load

if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi
