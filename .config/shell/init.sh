#!/bin/sh

if [ "$(uname -s)" = "Darwin" ]; then
    export IS_MAC=0
fi

shell_config_dir="$(dirname $0)"

. $shell_config_dir/env.sh
. $shell_config_dir/path.sh
. $shell_config_dir/aliases.sh
. $shell_config_dir/bootstrap.sh
