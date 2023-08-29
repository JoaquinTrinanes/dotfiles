---@type wezterm
local wezterm = require("wezterm")

local M = {}

---@param key string
---@param mods "ALT" | "CTRL" | "SHIFT" | "CTRL|SHIFT" | nil
---@param action fun()
---@param get_should_execute fun(win: WindowObj, pane: PaneObj): boolean
---@param default KeyAssignment?
M.conditional_map = function(key, mods, action, get_should_execute, default)
	return {
		key = key,
		mods = mods,
		action = wezterm.action_callback(function(win, pane)
			if get_should_execute(win, pane) then
				win:perform_action(action, pane)
			else
				win:perform_action(default or wezterm.action.DisableDefaultAssignment, pane)
				-- win:perform_action(wezterm.action.SendKey({ key = key, mods = mods }), pane)
			end
		end),
	}
end

return M
