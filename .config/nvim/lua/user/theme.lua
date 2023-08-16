---@diagnostic disable: assign-type-mismatch
local M = {}

M.get_theme = function()
  ---@type string
  local current_theme = vim.fn.systemlist({ "flavours", "current" })[1]

  return current_theme
end

local themes_with_prefix = { "catppuccin" }
local themes_without_prefix = { "gruvbox" }

M.get_colorscheme = function()
  local theme = M.get_theme()
  ---@type table
  local themes = vim.fn.getcompletion("", "color")

  local has_override = vim.list_contains(themes, theme)
    or theme == "nord"
    or vim.tbl_contains(themes_with_prefix, function(prefix)
      return vim.startswith(theme, prefix)
    end, { predicate = true })

  if has_override then
    return theme
  end

  local split_index = string.find(theme, "-")
  if split_index then
    local theme_base_name = string.sub(theme, 0, split_index - 1)
    if vim.list_contains(themes_without_prefix, theme_base_name) then
      return theme_base_name
    end
  end

  return "flavours"
end

return M
