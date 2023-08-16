export ANTIDOTE_HOME="$XDG_DATA_HOME/antidote"

if [ ! -e "$ANTIDOTE_HOME" ]; then
	git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_HOME"
fi

local bundlefile="${0:a:h}/plugins.txt"
zstyle ':antidote:bundle' file "$bundlefile"

local staticfile=$ANTIDOTE_HOME/zsh_static.zsh
zstyle ':antidote:static' file "$staticfile"

zstyle ':antidote:bundle' use-friendly-names 'yes'

. "$ANTIDOTE_HOME/antidote.zsh"

antidote load
