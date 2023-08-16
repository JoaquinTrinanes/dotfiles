local M = {
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      if type(opts.sources) == "table" then
        local null_ls = require("null-ls")
        local formatting = null_ls.builtins.formatting
        -- local diagnostics = null_ls.builtins.diagnostics
        -- local code_actions = null_ls.builtins.code_actions
        -- local completions = null_ls.builtins.completions

        vim.list_extend(opts.sources, {
          formatting.prettierd,
          formatting.stylua,
          formatting.pint,
        })
      end
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "prettierd", "stylua" })
    end,
  },
}

return M
