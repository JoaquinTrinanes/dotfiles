local M = {
  {
    "mrjones2014/smart-splits.nvim",
    dependencies = {
      { "kwkarlwang/bufresize.nvim", config = true, lazy = true },
    },
    version = "*",
    -- keys = {
    --   { "<A-h>", require("smart-splits").resize_left },
    --   { "<A-j>", require("smart-splits").resize_down },
    --   { "<A-k>", require("smart-splits").resize_up },
    --   { "<A-l>", require("smart-splits").resize_right },
    --   -- -- moving between splits
    --   { "<C-h>", require("smart-splits").move_cursor_left },
    --   { "<C-j>", require("smart-splits").move_cursor_down },
    --   { "<C-k>", require("smart-splits").move_cursor_up },
    --   { "<C-l>", require("smart-splits").move_cursor_right },
    --   -- -- swapping buffers between windows
    --   { "<leader><leader>h", require("smart-splits").swap_buf_left },
    --   { "<leader><leader>h", require("smart-splits").swap_buf_down },
    --   { "<leader><leader>h", require("smart-splits").swap_buf_up },
    --   { "<leader><leader>h", require("smart-splits").swap_buf_right },
    -- },
    config = function()
      local smart_splits = require("smart-splits")
      smart_splits.setup({
        on_leave = require("bufresize").register,
      })
      vim.keymap.set("n", "<A-h>", smart_splits.resize_left)
      vim.keymap.set("n", "<A-j>", smart_splits.resize_down)
      vim.keymap.set("n", "<A-k>", smart_splits.resize_up)
      vim.keymap.set("n", "<A-l>", smart_splits.resize_right)
      -- moving between splits
      vim.keymap.set("n", "<C-h>", smart_splits.move_cursor_left)
      vim.keymap.set("n", "<C-j>", smart_splits.move_cursor_down)
      vim.keymap.set("n", "<C-k>", smart_splits.move_cursor_up)
      vim.keymap.set("n", "<C-l>", smart_splits.move_cursor_right)
      -- swapping buffers between windows
      vim.keymap.set("n", "<leader><leader>h", smart_splits.swap_buf_left)
      vim.keymap.set("n", "<leader><leader>j", smart_splits.swap_buf_down)
      vim.keymap.set("n", "<leader><leader>k", smart_splits.swap_buf_up)
      vim.keymap.set("n", "<leader><leader>l", smart_splits.swap_buf_right)
    end,
    lazy = false,
  },
}

return M
