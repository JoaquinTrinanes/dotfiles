local opt = vim.opt

-- improve performance on large files
opt.synmaxcol = 2048

-- 4 spaces wide tabs
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

-- Ignore case by default, don't if there are uppercase characters in search
opt.ignorecase = true
opt.smartcase = true
opt.smarttab = true

opt.number = true
opt.relativenumber = true

-- Use system clipboard
opt.clipboard:append('unnamedplus')

-- Split!
opt.splitright = true
opt.splitbelow = true

opt.iskeyword:append('-')

opt.cursorline = true
opt.termguicolors = true
opt.background = 'dark'
opt.signcolumn = 'yes'
opt.backspace = { 'indent', 'eol', 'start' }

vim.cmd [[colorscheme nord]]
