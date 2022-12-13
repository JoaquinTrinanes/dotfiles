local wo = vim.wo
local o = vim.o

vim.api.nvim_set_hl(0, 'Conceal', {
    ctermbg = nil,
    ctermfg = 'gray'
})

vim.fn.matchadd('Conceal', '\\v(^ *)@<= ', -1, -1, {
    conceal = '·'
})

wo.list = true
vim.opt.listchars = ({
    tab = "→ ",
    trail = "·",
    precedes = "←",
    extends = "→"
})
wo.conceallevel = 2
