local lsp_formatting = function(bufnr)
	vim.lsp.buf.format({
		filter = function(client)
			-- apply whatever logic you want (in this example, we'll only use null-ls)
			return client.name == "null-ls"
		end,
		bufnr = bufnr,
	})
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup,
	callback = function(ev)
		lsp_formatting(ev.buf)
	end,
})

vim.api.nvim_create_user_command("Autoformat", function()
	lsp_formatting(0)
end, {})
