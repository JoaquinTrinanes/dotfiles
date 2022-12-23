local ok, nord = pcall(require, "nord")
if not ok then
	return
end

local g = vim.g

g.nord_contrast = true
g.nord_disable_background = true
g.nord_borders = true
g.nord_italic = false

nord.set()
vim.cmd([[colorscheme nord]])
