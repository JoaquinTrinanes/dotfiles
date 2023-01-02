#!/usr/bin/env fish

set PATH "$PATH:/usr/local/bin"

set fisher_path "$__fish_config_dir/plugins"

starship init fish | source
direnv hook fish | source

source /usr/local/opt/asdf/libexec/asdf.fish

# fisher plugins
! set --query fisher_path[1] || test "$fisher_path" = $__fish_config_dir && exit

set fish_complete_path $fish_complete_path[1] $fisher_path/completions $fish_complete_path[2..]
set fish_function_path $fish_function_path[1] $fisher_path/functions $fish_function_path[2..]

for file in $fisher_path/conf.d/*.fish
    source $file
end
