local M = {
  {
    "nvim-neo-tree/neo-tree.nvim",
    lazy = true,
    opts = {
      filesystem = {
        hijack_netrw_behavior = "open_current",
      },
    },
  },
}

return M
