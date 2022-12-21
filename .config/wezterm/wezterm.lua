local wez = require("wezterm")

return {
	color_scheme = "nord",
	font = wez.font_with_fallback({ "Fira Code", "Symbols Nerd Font", "DejaVu Sans Mono" }),
	font_size = 16,
	use_fancy_tab_bar = false,
	default_cursor_style = "SteadyBar",
	enable_scroll_bar = true,
	audible_bell = "Disabled",
	unicode_version = 15,
}
