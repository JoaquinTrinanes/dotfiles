local wez = require("wezterm")

local function file_exists(name)
	local f = io.open(name, "r")
	if f ~= nil then
		io.close(f)
		return true
	else
		return false
	end
end

local home = wez.home_dir
local last_theme_path = home .. "/.cache/wal/last_used_theme"

local function get_current_theme()
	local f = io.open(last_theme_path, "r")
	if not f then
		return nil
	end
	local theme_file = f:read("l")
	local theme = theme_file:gmatch("(.-)%..-")()
	return theme
end

local nu_paths = { home .. "/.cargo/bin/nu", "/usr/local/bin/nu" }
local nu_path = "nu"

for _, file in ipairs(nu_paths) do
	if file_exists(file) then
		nu_path = file
		break
	end
end

local themes_dir = home .. "/.cache/wal"
wez.add_to_config_reload_watch_list(themes_dir .. "/wezterm-wal.toml")
wez.add_to_config_reload_watch_list(last_theme_path)

local theme = get_current_theme()

return {
	set_environment_variables = {
		THEME = theme,
	},
	default_prog = {
		nu_path,
		-- "-l",
		"-i",
		"--config",
		home .. "/.config/nushell/config.nu",
		"--env-config",
		home .. "/.config/nushell/env.nu",
		"--plugin-config",
		home .. "/.config/nushell/plugin.nu",
	},
	color_scheme = "wezterm-wal",
	color_scheme_dirs = { themes_dir },
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
