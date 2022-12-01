#!/bin/sh

if [ "$(uname -s)" = "Darwin" ]; then
    export IS_MAC=1
fi

for f in $(dirname $0)/*.sh; do
    if [ $f = $0 ]; then continue; fi
    . $f
done

