local wez = require("wezterm")

return {
	color_scheme = "nord",
	font = wez.font_with_fallback({
		"Fira Code",
		{ family = "JoyPixels", assume_emoji_presentation = true },
		{ family = "Symbols Nerd Font", assume_emoji_presentation = true },
		"DejaVu Sans Mono",
	}),
	font_size = 16,
	use_fancy_tab_bar = false,
	default_cursor_style = "SteadyBar",
	enable_scroll_bar = true,
	audible_bell = "Disabled",
	unicode_version = 15,
}
