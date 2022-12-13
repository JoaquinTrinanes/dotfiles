local function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

-- Leader key: Space
vim.g.mapleader = ' '

-- Center screen on scroll
map('n', [[<C-f>]], [[<C-f>zz]])
map('n', [[<C-u>]], [[<C-u>zz]])

-- Telescope
map('n', '<C-p>', '<cmd>Telescope find_files<cr>')
-- map('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
map('n', '<leader>fg', '<cmd>Telescope live_grep<cr>')
map('n', '<leader>fb', '<cmd>Telescope buffers<cr>')
map('n', '<leader>fh', '<cmd>Telescope help_tags<cr>')
map('n', '<leader>ft', '<cmd>Telescope treesitter<cr>')

-- Trouble
map('n', '<leader>xx', '<cmd>TroubleToggle<cr>')

-- trigger InsertLeave when using Ctrl-C
-- map('n', '<C-c>', '<ESC>')

-- <TAB>: completion.
--  'pumvisible() ? "\\<C-n>" : "\\<TAB>"'
-- map('n', '<expr><TAB>', function()
--     local x = vim.fn.pumvisible() and [[\<C-n>]] or [[\<TAB>]]
--     print(x)
--     return x
-- end)
