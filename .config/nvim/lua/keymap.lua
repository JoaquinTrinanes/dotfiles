local function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- trigger InsertLeave when using Ctrl-C
-- map('n', '<C-c>', '<ESC>')

-- <TAB>: completion.
map('n', '<expr><TAB>', 'pumvisible() ? "\\<C-n>" : "\\<TAB>"')
