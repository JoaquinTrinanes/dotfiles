---@type wezterm
local wezterm = require("wezterm")
local keys = require("keys")
local H = require("helpers")

local M = {}

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

---@param pane PaneObj
M.has_mux = function(pane)
	local is_zellij = H.has_foreground_process("zellij", pane)
	local is_tmux = H.has_foreground_process("tmux", pane)

	-- this is set by the smart-splits.nvim plugin, and unset on ExitPre in Neovim
	local is_vim = pane:get_user_vars().IS_NVIM == "true"

	return is_vim or is_tmux or is_zellij
end

---@param resize_or_move "resize" | "move"
---@param key string
local function split_nav(resize_or_move, key)
	local mods = resize_or_move == "resize" and "ALT" or "CTRL"
	return {
		key = key,
		mods = mods,
		action = wezterm.action_callback(function(win, pane)
			if M.has_mux(pane) then
				-- pass the keys through
				win:perform_action({
					SendKey = {
						key = key,
						-- zellij doesn't support Ctrl+j, so we override with Alt
						mods = H.has_foreground_process("zellij", pane) and "ALT" or mods,
					},
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

M.nav_bindings = {
	split_nav("move", "h"),
	split_nav("move", "j"),
	split_nav("move", "k"),
	split_nav("move", "l"),
	-- resize panes
	split_nav("resize", "h"),
	split_nav("resize", "j"),
	split_nav("resize", "k"),
	split_nav("resize", "l"),
}

M.zellij_only_map = function(key, mods, action, default)
	return keys.conditional_map(key, mods, action, function(_, pane)
		return H.has_foreground_process("zellij", pane)
	end, default)
end

return M
