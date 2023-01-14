local colorscheme_path = vim.fn.expand("~/.config/nvim/colors/flavours.lua")
local w = vim.loop.new_fs_event()

local function set_colorscheme()
	vim.cmd([[colorscheme flavours]])
end

local function on_change()
	set_colorscheme()
end

local function watch_file()
	w:start(
		colorscheme_path,
		{},
		vim.schedule_wrap(function(...)
			on_change(...)
		end)
	)
end

local group = vim.api.nvim_create_augroup("ReloadTheme", {})
vim.api.nvim_create_autocmd("VimEnter", {
	group = group,
	callback = function()
		watch_file()
	end,
})

set_colorscheme()
