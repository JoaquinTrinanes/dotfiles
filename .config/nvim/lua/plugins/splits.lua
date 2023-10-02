local M = {
  {
    "mrjones2014/smart-splits.nvim",
    dependencies = {
      { "kwkarlwang/bufresize.nvim", config = true, lazy = true },
    },
    version = "*",
    priority = 1000,
    lazy = false,
  },
}

return M
