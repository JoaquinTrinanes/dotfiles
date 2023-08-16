local M = {
  {
    "echasnovski/mini.pairs",
    enabled = false,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
    opts = function(_, opts)
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      opts.experimental.ghost_text.enabled = true
    end,
  },
}

return M
