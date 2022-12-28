local opt = vim.opt

-- improve performance on large files
opt.synmaxcol = 2048

-- 4 spaces wide tabs, the rest is handled by vim-sleuth
opt.tabstop = 4

-- Ignore case by default, don't if there are uppercase characters in search
opt.ignorecase = true
opt.smartcase = true
opt.smarttab = true

opt.number = true
opt.relativenumber = true

-- Time to show hover info
opt.updatetime = 300

-- Use system clipboard
opt.clipboard:append("unnamedplus")

-- Split!
opt.splitright = true
opt.splitbelow = true

opt.iskeyword:append("-")

opt.cursorline = true
opt.termguicolors = true
opt.background = "dark"
-- opt.background = "light"
opt.signcolumn = "yes"
opt.backspace = { "indent", "eol", "start" }
opt.completeopt = { "menu", "preview", "noinsert" }

-- disable netrw
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

-- show lines before the window border
vim.g.scrolloff = 5
vim.g.sidescrolloff = 5

-- reload file on change
opt.autoread = true

-- disable compatible mode
opt.compatible = false
