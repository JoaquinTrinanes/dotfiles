local wez = require("wezterm")
local act = wez.action

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

local nu_paths = { home .. "/.cargo/bin/nu", "/usr/local/bin/nu" }
local nu_path = "nu"

for _, file in ipairs(nu_paths) do
	if file_exists(file) then
		nu_path = file
		break
	end
end

wez.add_to_config_reload_watch_list(home .. "/.config/wezterm/colors/flavours.toml")

-- Navigator.nvim
local function isViProcess(pane)
	-- get_foreground_process_name On Linux, macOS and Windows,
	-- the process can be queried to determine this path. Other operating systems
	-- (notably, FreeBSD and other unix systems) are not currently supported
	return pane:get_foreground_process_name():find("n?vim") ~= nil
	-- return pane:get_title():find("n?vim") ~= nil
end

local function conditionalActivatePane(window, pane, pane_direction, vim_direction)
	if isViProcess(pane) then
		window:perform_action(
			-- This should match the keybinds you set in Neovim.
			act.SendKey({ key = vim_direction, mods = "CTRL" }),
			pane
		)
	else
		window:perform_action(act.ActivatePaneDirection(pane_direction), pane)
	end
end

-- local function conditionalSwitchTab(window, pane, pane_direction, vim_direction)
-- 	local tabs = window:mux_window():tabs_with_info()
-- 	-- act.ActivateTabRelative
-- 	if isViProcess(pane) then
-- 		window:perform_action(
-- 			-- This should match the keybinds you set in Neovim.
-- 			act.SendKey({ key = vim_direction, mods = "CTRL" }),
-- 			pane
-- 		)
-- 	else
-- 		window:perform_action(act.ActivatePaneDirection(pane_direction), pane)
-- 	end
-- end

wez.on("ActivatePaneDirection-right", function(window, pane)
	conditionalActivatePane(window, pane, "Right", "l")
end)
wez.on("ActivatePaneDirection-left", function(window, pane)
	conditionalActivatePane(window, pane, "Left", "h")
end)
wez.on("ActivatePaneDirection-up", function(window, pane)
	conditionalActivatePane(window, pane, "Up", "k")
end)
wez.on("ActivatePaneDirection-down", function(window, pane)
	conditionalActivatePane(window, pane, "Down", "j")
end)
-- wez.on("ActivatePaneDirection-nextTab", function(window, pane)
-- 	conditionalActivatePane(window, pane, "Down", "j")
-- end)
-- wez.on("ActivatePaneDirection-prevTab", function(window, pane)
-- 	conditionalActivatePane(window, pane, "Down", "j")
-- end)

return {
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
	color_scheme = "flavours",
	font = wez.font_with_fallback({
		"Fira Code",
		{ family = "JoyPixels", assume_emoji_presentation = true },
		{ family = "Symbols Nerd Font", assume_emoji_presentation = true },
		"DejaVu Sans Mono",
	}),
	font_size = 16,
	keys = {
		{ key = "h", mods = "CTRL", action = act.EmitEvent("ActivatePaneDirection-left") },
		{ key = "j", mods = "CTRL", action = act.EmitEvent("ActivatePaneDirection-down") },
		{ key = "k", mods = "CTRL", action = act.EmitEvent("ActivatePaneDirection-up") },
		{ key = "l", mods = "CTRL", action = act.EmitEvent("ActivatePaneDirection-right") },
		-- { key = "Tab", mods = "CTRL", action = act.EmitEvent("ActivatePaneDirection-nextTab") },
		-- { key = "Tab", mods = "CTRL|SHIFT", action = act.EmitEvent("ActivatePaneDirection-prevTab") },
	},
	use_fancy_tab_bar = false,
	default_cursor_style = "SteadyBar",
	cursor_blink_rate = 0,
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
