if (vivid themes | grep '^flavours$' >/dev/null); then
	LS_COLORS="$(vivid generate flavours)"
	export LS_COLORS
fi

set -o noclobber
