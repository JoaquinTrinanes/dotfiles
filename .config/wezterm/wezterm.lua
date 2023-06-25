local wezterm = require("wezterm")

local function file_exists(name)
	local f = io.open(name, "r")
	if f ~= nil then
		io.close(f)
		return true
	else
		return false
	end
end

local home = wezterm.home_dir

local nu_paths = { home .. "/.cargo/bin/nu", "/usr/local/bin/nu" }
local nu_path = "nu"

for _, file in ipairs(nu_paths) do
	if file_exists(file) then
		nu_path = file
		break
	end
end

wezterm.add_to_config_reload_watch_list(wezterm.config_dir .. "/colors/flavours.toml")

local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.set_environment_variables = {
	SHELL = nu_path,
}

config.color_scheme = "flavours"
config.font = wezterm.font_with_fallback({
	"FiraCode Nerd Font",
	{ family = "JoyPixels", assume_emoji_presentation = true },
	"DejaVu Sans Mono",
})
config.font_size = 16
config.use_fancy_tab_bar = false
config.default_cursor_style = "SteadyBar"
config.cursor_blink_rate = 0
config.enable_scroll_bar = true
config.audible_bell = "Disabled"
config.unicode_version = 15
config.hide_mouse_cursor_when_typing = false

return config
