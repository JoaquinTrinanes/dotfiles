-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- don't copy text when deleting single characters
map("n", "x", [["_x]])
map("n", "X", [["_X]])

-- resizing splits
vim.keymap.set("n", "<A-h>", function()
  require("smart-splits").resize_left()
end)
vim.keymap.set("n", "<A-j>", function()
  require("smart-splits").resize_down()
end)
vim.keymap.set("n", "<A-k>", function()
  require("smart-splits").resize_up()
end)
vim.keymap.set("n", "<A-l>", function()
  require("smart-splits").resize_right()
end)

-- moving between splits
vim.keymap.set("n", "<C-h>", function()
  require("smart-splits").move_cursor_left()
end)
vim.keymap.set("n", "<C-j>", function()
  require("smart-splits").move_cursor_down()
end)
vim.keymap.set("n", "<C-k>", function()
  require("smart-splits").move_cursor_up()
end)
vim.keymap.set("n", "<C-l>", function()
  require("smart-splits").move_cursor_right()
end)

-- swapping buffers between windows
vim.keymap.set("n", "<leader><leader>h>", function()
  require("smart-splits").swap_buf_left()
end)
vim.keymap.set("n", "<leader><leader>j>", function()
  require("smart-splits").swap_buf_down()
end)
vim.keymap.set("n", "<leader><leader>k>", function()
  require("smart-splits").swap_buf_up()
end)
vim.keymap.set("n", "<leader><leader>l>", function()
  require("smart-splits").swap_buf_right()
end)
