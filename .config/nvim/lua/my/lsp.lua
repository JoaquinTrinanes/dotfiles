-- local lsp_augroup = vim.api.nvim_create_augroup("LspGroup", {
-- 	clear = true,
-- })

-- local lsp_formatting = function(bufnr, async)
-- 	vim.lsp.buf.format({
-- 		bufnr = bufnr,
-- 		async = async,
-- 		-- filter = function(client)
-- 		-- 	return client.name == "null-ls"
-- 		-- end,
-- 		timeout_ms = 5000,
-- 	})
-- 	if vim.fn.exists(":EslintFixAll") > 0 then
-- 		vim.cmd("EslintFixAll")
-- 	end
-- end

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

-- local function setup_lsp(client, bufnr)
-- 	if client.supports_method("textDocument/format") then
-- 		vim.api.nvim_create_user_command("Autoformat", function()
-- 			lsp_formatting(0, true)
-- 		end, {})

-- 		-- Format on save
-- 		vim.api.nvim_create_autocmd("BufWritePre", {
-- 			group = lsp_augroup,
-- 			callback = function(ev)
-- 				lsp_formatting(ev.buf)
-- 			end,
-- 		})
-- 	end
-- 	-- Show info on hover
-- 	-- if client.supports_method('textDocument/hover') then
-- 	-- 	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { focus = false })

-- 	-- 	vim.api.nvim_create_autocmd("CursorHold", {
-- 	-- 		group = lsp_augroup,
-- 	-- 		command = "silent! lua vim.lsp.buf.hover()",
-- 	-- 	})
-- 	-- end

-- 	-- if client.supports_method('textDocument/completion') then
-- 	-- vim.api.nvim_create_autocmd("CursorMovedI", {
-- 	-- 	group = lsp_augroup,
-- 	-- 	callback = function()
-- 	-- 		vim.lsp.buf.completion()
-- 	-- 	end,
-- 	-- })
-- 	-- end
-- end

-- vim.api.nvim_create_autocmd("LspAttach", {
-- 	once = true,
-- 	callback = function(ev)
-- 		print(vim.inspect(ev))
-- 		print("attach!")
-- 		local client = vim.lsp.get_client_by_id(ev.data.client_id)
-- 		if client.name == "rust_analyzer" then
-- 			local rt = require("rust-tools")
-- 			vim.keymap.set("n", "<C-.>", rt.hover_actions.hover_actions, { remap = true })
-- 			return
-- 		end
-- 		-- elseif client.name == "null-ls" then
-- 		setup_lsp(client)
-- 		-- end
-- 	end,
-- })
