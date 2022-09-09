#!/bin/sh

for f in $(dirname $0)/*; do
    if [ $f = $0 ]; then continue; fi
    . $f
done

