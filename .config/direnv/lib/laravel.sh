layout_laravel() {
	layout php

	lib_dir="$(direnv_layout_dir)/laravel_sail"
	bin_dir="$lib_dir/bin"
	base_dir="$(direnv_layout_dir)/.."
	rm -rf "$bin_dir"
	mkdir -p "$bin_dir"
	local scripts=(
		composer
		# php
		artisan
		tinker
		# npm
		# npx
		# yarn
		# pnpm
	)
	for script in "${scripts[@]}"; do
		echo "\"$base_dir/vendor/bin/sail\" \"$script\" \$@" >"$bin_dir/$script"
	done

	chmod -R u+x $bin_dir
	PATH_add "$bin_dir"
}
