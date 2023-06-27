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

local potential_nu_paths = { home .. "/.cargo/bin/nu", "/usr/local/bin/nu" }
local nu_path = "nu"

for _, file in ipairs(potential_nu_paths) do
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

local function is_vim(pane)
	-- this is set by the smart-splits.nvim plugin, and unset on ExitPre in Neovim
	return pane:get_user_vars().IS_NVIM == "true"
end

local direction_keys = {
	Left = "h",
	Down = "j",
	Up = "k",
	Right = "l",
	-- reverse lookup
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

local function split_nav(resize_or_move, key)
	return {
		key = key,
		mods = resize_or_move == "resize" and "ALT" or "CTRL",
		action = wezterm.action_callback(function(win, pane)
			if is_vim(pane) then
				-- pass the keys through to vim/nvim
				win:perform_action({
					SendKey = { key = key, mods = resize_or_move == "resize" and "ALT" or "CTRL" },
				}, pane)
			else
				if resize_or_move == "resize" then
					win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
				else
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end
		end),
	}
end
config.keys = {
	-- 	-- move between split panes
	split_nav("move", "h"),
	split_nav("move", "j"),
	split_nav("move", "k"),
	split_nav("move", "l"),
	-- resize panes
	split_nav("resize", "h"),
	split_nav("resize", "j"),
	split_nav("resize", "k"),
	split_nav("resize", "l"),
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
}

return config
