layout_laravel() {
    layout php

    lib_dir="$(direnv_layout_dir)/laravel_sail"
    bin_dir="$lib_dir/bin"
    mkdir -p "$bin_dir"
    local scripts=(
        composer
        artisan
        tinker
    )
    for script in ${scripts[@]}; do
        echo "sail $script \$@" > $bin_dir/$script
    done

    chmod -R u+x $bin_dir
    PATH_add "$bin_dir"
}
