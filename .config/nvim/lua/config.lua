local o = vim.o
local wo = vim.wo
local bo = vim.bo

bo.expandtab = true
bo.shiftwidth = 4
-- improve performance on large files
bo.synmaxcol = 2048
bo.tabstop = 4

o.cmdheight = 2
o.ignorecase = true
o.smartcase = true
o.smarttab = true

wo.number = true
