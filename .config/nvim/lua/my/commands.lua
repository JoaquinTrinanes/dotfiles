local lsp_formatting = function(bufnr)
	vim.lsp.buf.format({
		filter = function(client)
			-- apply whatever logic you want (in this example, we'll only use null-ls)
			return client.name == "null-ls"
		end,
		bufnr = bufnr,
	})
end

local formatting_group = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
	group = formatting_group,
	callback = function(ev)
		lsp_formatting(ev.buf)
	end,
})

local hover_group = vim.api.nvim_create_augroup("OnHover", { clear = true })
vim.api.nvim_create_autocmd("CursorHold", {
	group = hover_group,
	callback = function(ev)
		vim.lsp.buf.hover()
	end,
})

local highlight_yank_group = vim.api.nvim_create_augroup("OnHover", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	group = highlight_yank_group,
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_user_command("Autoformat", function()
	lsp_formatting(0)
end, {})
