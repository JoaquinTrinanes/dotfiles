local o = vim.o
local wo = vim.wo
local bo = vim.bo

-- improve performance on large files
bo.synmaxcol = 2048

-- 4 spaces wide tabs
bo.tabstop = 4
bo.shiftwidth = 4
bo.expandtab = true

o.cmdheight = 2
o.ignorecase = true
o.smartcase = true
o.smarttab = true

wo.number = true
