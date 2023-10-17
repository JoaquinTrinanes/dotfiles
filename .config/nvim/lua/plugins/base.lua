local M = {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      yadm = { enable = true },
      -- show columnsign at the left
      sign_priority = 0,
      current_line_blame = true,
    },
  },
  {
    "folke/noice.nvim",
    opts = {
      ---@type NoicePresets
      presets = {
        lsp_doc_border = true,
      },
    },
  },
  {
    "telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
    },
  },
  {
    "stevearc/dressing.nvim",
    opts = {
      input = {
        get_config = function()
          if vim.api.nvim_win_get_width(0) < 50 then
            return {
              relative = "editor",
            }
          end
        end,
        relative = "cursor",
      },
      select = {
        get_config = function(inner_opts)
          if inner_opts.kind == "codeaction" or inner_opts.kind == "hover" then
            return { telescope = require("telescope.themes").get_cursor() }
          end
        end,
        telescope = require("telescope.themes").get_dropdown(),
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      -- disable clock
      opts.sections.lualine_z = {}
    end,
  },
}

return M
