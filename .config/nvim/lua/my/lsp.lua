local lsp_augroup = vim.api.nvim_create_augroup("LspGroup", {
	clear = true,
})

local lsp_formatting = function(bufnr, async)
	vim.lsp.buf.format({
		bufnr = bufnr,
		async = async,
		timeout_ms = 2000,
	})
end

-- Prints the current highlight groups in the cursor position
vim.api.nvim_create_user_command("WhatHl", function()
	local line = vim.fn.line(".")
	local col = vim.fn.col(".")
	local result = vim.fn.synstack(line, col)

	local highlight_names = {}
	for _, item in ipairs(result) do
		local name = vim.fn.synIDattr(item, "name")
		table.insert(highlight_names, 1, name)
	end
	print(vim.inspect(highlight_names))
end, {})

local function setup_lsp(client)
	if client.server_capabilities.documentFormattingProvider then
		vim.api.nvim_create_user_command("Autoformat", function()
			lsp_formatting(0, true)
		end, {})

		-- Format on save
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = lsp_augroup,
			callback = function(ev)
				lsp_formatting(ev.buf)
			end,
		})
	end
	-- Show info on hover
	-- if client.server_capabilities.hoverProvider then
	-- 	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { focus = false })

	-- 	vim.api.nvim_create_autocmd("CursorHold", {
	-- 		group = lsp_augroup,
	-- 		command = "silent! lua vim.lsp.buf.hover()",
	-- 	})
	-- end

	-- if client.server_capabilities.completionProvider then
	-- vim.api.nvim_create_autocmd("CursorMovedI", {
	-- 	group = lsp_augroup,
	-- 	callback = function()
	-- 		vim.lsp.buf.completion()
	-- 	end,
	-- })
	-- end
end

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client.name == "rust_analyzer" then
			local rt = require("rust-tools")
			vim.keymap.set("n", "<C-.>", rt.hover_actions.hover_actions, { remap = true })
			return
		end
		setup_lsp(client)
	end,
})
