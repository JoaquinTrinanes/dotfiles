---@type wezterm
local wezterm = require("wezterm")
local mux = require("mux")

wezterm.add_to_config_reload_watch_list(wezterm.config_dir .. "/colors/flavours.toml")

---@type WeztermConfig
local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.hide_tab_bar_if_only_one_tab = true

config.enable_wayland = false
config.color_scheme = "flavours"
config.font = wezterm.font_with_fallback({
	"FiraCode Nerd Font",
	"DejaVu Sans Mono",
	{ family = "JoyPixels", assume_emoji_presentation = true },
	{ family = "Symbols Nerd Font Mono", assume_emoji_presentation = true },
	"Noto Sans Mono CJK HK",
	"Noto Sans Mono CJK JP",
	"Noto Sans Mono CJK SC",
	"Noto Sans Mono CJK TC",
})
config.font_size = 16
config.use_fancy_tab_bar = false
config.default_cursor_style = "SteadyBar"
config.cursor_blink_rate = 0
config.enable_scroll_bar = true
config.audible_bell = "Disabled"
config.unicode_version = 15
config.hide_mouse_cursor_when_typing = false

config.keys = {
	mux.zellij_only_map("c", "CTRL|SHIFT", wezterm.action.SendKey({ key = "c", mods = "ALT" })),
	-- mux.zellij_map("t", "ALT", wezterm.action.DisableDefaultAssignment),
	{
		key = "\\",
		mods = "CTRL|ALT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "|",
		mods = "CTRL|ALT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "-",
		mods = "CTRL|ALT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "f",
		mods = "ALT",
		action = wezterm.action.TogglePaneZoomState,
	},
	{
		key = "l",
		mods = "CTRL|ALT",
		action = wezterm.action.RotatePanes("Clockwise"),
	},
	{
		key = "h",
		mods = "CTRL|ALT",
		action = wezterm.action.RotatePanes("CounterClockwise"),
	},
	{ key = "p", mods = "CTRL|SHIFT", action = wezterm.action.ActivateCommandPalette },
	{ key = "s", mods = "ALT", action = wezterm.action.CharSelect({ copy_on_select = true }) },
	table.unpack(mux.nav_bindings),
}

return config
