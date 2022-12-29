#!/bin/sh

if [ "$(uname -s)" = "Darwin" ]; then
    export IS_MAC=0
fi

local config_dir="$(dirname $0)"

. $config_dir/env.sh
. $config_dir/path.sh
. $config_dir/aliases.sh
. $config_dir/bootstrap.sh
