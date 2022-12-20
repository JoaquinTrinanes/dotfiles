local function map(mode, lhs, rhs, opts)
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

-- Leader key: Space
vim.g.mapleader = " "

-- Exit insert mode pressing jk
map("i", [[jk]], [[<ESC>]])

-- window management
map("n", "<leader>sv", "<C-w>v") -- split window vertically
map("n", "<leader>sh", "<C-w>s") -- split window horizontally
map("n", "<leader>se", "<C-w>=") -- make split windows equal width & height
map("n", "<leader>sx", "<cmd>close<CR>") -- close current split window

-- Don't copy deleted content with x
map("n", "x", '"_x')
map("n", "X", '"_X')

-- Center screen on scroll
map("n", [[<C-f>]], [[<C-f>zz]])
map("n", [[<C-u>]], [[<C-u>zz]])

-- Telescope
map("n", "<C-p>", "<cmd>Telescope find_files hidden=true no_ignore=false<cr>")
-- map('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")

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

-- trigger InsertLeave when using Ctrl-C
-- map("i", "<C-c>", "<ESC>")

-- <TAB>: completion.
-- 'pumvisible() ? "\\<C-n>" : "\\<TAB>"'
-- map("n", "<expr><TAB>", function()
-- local x = vim.fn.pumvisible() and [[\<C-n>]] or [[\<TAB>]]
-- print(x)
-- return x
-- end)
