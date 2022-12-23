local CLIENT_NAME = "null-ls"

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

local lsp_formatting = function(bufnr)
	vim.lsp.buf.format({
		filter = function(client)
			-- apply whatever logic you want (in this example, we'll only use null-ls)
			return client.name == CLIENT_NAME
		end,
		bufnr = bufnr,
	})
end

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

-- On LSP attach, add handlers for formatting and completion
local lsp_augroup = vim.api.nvim_create_augroup("LspAugroup", { clear = true })

local function setup_lsp(client)
	if client.server_capabilities.documentFormattingProvider then
		vim.api.nvim_create_user_command("Autoformat", function()
			lsp_formatting(0)
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
	group = my_augroup,
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client.name ~= CLIENT_NAME then
			return
		end
		setup_lsp(client)
	end,
})
