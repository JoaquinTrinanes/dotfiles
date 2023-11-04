local M = {
  {
    "echasnovski/mini.pairs",
    enabled = false,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
    --- @param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      opts.experimental.ghost_text = true

      local prev_format = opts.formatting.format
      local max_menu_length = 15

      opts.formatting.format = function(entry, _item)
        local item = prev_format(entry, _item)
        if entry.completion_item.detail ~= nil and entry.completion_item.detail ~= "" then
          item.menu = entry.completion_item.detail
          item.menu_hl_group = "Comment"

          local truncated = string.sub(item.menu, 1, max_menu_length)
          if #truncated < #item.menu then
            item.menu = string.sub(truncated, 1, max_menu_length - 1) .. "…"
          end
          -- else
          --   vim_item.menu = ({
          --     nvim_lsp = "[LSP]",
          --     luasnip = "[Snippet]",
          --     buffer = "[Buffer]",
          --     path = "[Path]",
          --   })[entry.source.name]
        end
        return item
      end
    end,
  },
}

return M
