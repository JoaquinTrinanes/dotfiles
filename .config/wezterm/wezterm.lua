local wez = require("wezterm")

return {
	--	default_prog = { "/usr/local/bin/oil", "-l" },
	default_prog = {
		"/usr/local/bin/nu",
		"-l",
		"--config",
		"~/.config/nushell/config.nu",
		"--env-config",
		"~/.config/nushell/env.nu",
	},
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
	hyperlink_rules = {
		-- Linkify things that look like URLs and the host has a TLD name.
		-- Compiled-in default. Used if you don't specify any hyperlink_rules.
		{
			regex = "\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b",
			format = "$0",
		},

		-- linkify email addresses
		-- Compiled-in default. Used if you don't specify any hyperlink_rules.
		{
			regex = [[\b\w+@[\w-]+(\.[\w-]+)+\b]],
			format = "mailto:$0",
		},

		-- file:// URI
		-- Compiled-in default. Used if you don't specify any hyperlink_rules.
		{
			regex = [[\bfile://\S*\b]],
			format = "$0",
		},

		-- Linkify things that look like URLs with numeric addresses as hosts.
		-- E.g. http://127.0.0.1:8000 for a local development server,
		-- or http://192.168.1.1 for the web interface of many routers.
		{
			regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S?*\b]],
			format = "$0",
		},

		-- localhost links
		{
			regex = [[\b\w+://localhost(:\d+)?\b]],
			format = "$0",
		},
	},
}
