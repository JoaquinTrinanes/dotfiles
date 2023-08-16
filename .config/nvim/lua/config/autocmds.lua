-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local watch_file = require("user.watch_file")
local theme = require("user.theme")

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local colorscheme_path = vim.fn.expand(vim.fn.stdpath("config") .. "/colors/flavours.lua")
    watch_file(colorscheme_path, function()
      local current_theme = theme.get_theme()
      if string.match(current_theme, "light") then
        vim.o.background = "light"
      else
        vim.o.background = "dark"
      end
      vim.cmd("colorscheme " .. theme.get_colorscheme())
    end)
  end,
})
