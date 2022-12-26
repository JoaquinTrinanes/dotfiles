local my_augroup = vim.api.nvim_create_augroup("MyAugroup", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	group = my_augroup,
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Initialization
vim.api.nvim_create_autocmd("VimEnter", {
	group = my_augroup,
	callback = function(ev)
		-- show file picker when opening dirs
		local ok, telescope = pcall(require, "telescope.builtin")
		if not ok or vim.fn.isdirectory(ev.file) ~= 1 then
			return
		end
		vim.cmd([[bd!]])
		telescope.find_files()
	end,
})
