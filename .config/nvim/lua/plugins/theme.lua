local M = {
  {
    "shaunsingh/nord.nvim",
    name = "nord",
    config = function()
      vim.g.nord_borders = true
      vim.g.nord_contrast = true
    end,
  },
  { "ellisonleao/gruvbox.nvim", name = "gruvbox" },
}

return M
