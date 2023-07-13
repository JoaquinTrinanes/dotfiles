if (vivid themes | grep '^flavours$' > /dev/null); then
    export LS_COLORS="$(vivid generate flavours)"
fi

set -o noclobber
