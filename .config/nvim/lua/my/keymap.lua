local function map(mode, lhs, rhs, opts)
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

-- Leader key: Space
vim.g.mapleader = " "

-- Exit insert mode pressing jk or jj
map("i", [[jk]], [[<ESC>]])
map("i", [[jj]], [[<ESC>]])

-- window management
map("n", "<leader>sv", "<C-w>v") -- split window vertically
map("n", "<leader>sh", "<C-w>s") -- split window horizontally
map("n", "<leader>se", "<C-w>=") -- make split windows equal width & height
map("n", "<leader>sx", "<cmd>close<CR>") -- close current split window
map("n", "<leader>st", "<cmd>tabnew<CR>") -- open new tab

-- Don't copy deleted content with x
map("n", "x", '"_x')
map("n", "X", '"_X')

-- Center screen on scroll
map("n", [[<C-f>]], [[<C-f>zz]])
map("n", [[<C-u>]], [[<C-u>zz]])

map("n", "K", function()
	vim.lsp.buf.hover({
		focus = false,
	})
end)

-- Telescope
-- map("n", "<C-p>", "<cmd>Telescope find_files hidden=true no_ignore=false<cr>")
map("n", "<C-p>", "<cmd>Telescope find_files hidden=true no_ignore=false<cr>")
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")

-- Dir tree
local dirtree_ok = pcall(require, "nvim-tree")
if dirtree_ok then
	map("n", "<C-b>", "<cmd>NvimTreeToggle<cr>")
end

-- Code actions
map("n", "<C-.>", function()
	vim.lsp.buf.code_action()
end)

-- Go to definition
map("n", "gd", function()
	vim.lsp.buf.definition()
end)

-- Trouble
map("n", "<leader>xx", "<cmd>TroubleToggle<cr>")

local debug_leader = vim.g.mapleader .. "d"

-- Debugger
map("n", debug_leader .. "b", function()
	require("dap").toggle_breakpoint()
end, { desc = "Toggle breakpoint" })

map("n", debug_leader .. "d", function()
	local dap = require("dap")
	dap.continue()
end, { desc = "Next breakpoint" })

map("n", debug_leader .. "n", function()
	require("dap").step_over()
end, { desc = "Step over" })
