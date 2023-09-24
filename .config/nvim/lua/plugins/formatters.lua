local M = {
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      if type(opts.sources) == "table" then
        local null_ls = require("null-ls")
        local formatting = null_ls.builtins.formatting
        local diagnostics = null_ls.builtins.diagnostics
        local code_actions = null_ls.builtins.code_actions
        -- local completions = null_ls.builtins.completions

        vim.list_extend(opts.sources, {
          formatting.prettierd,
          formatting.stylua,
          formatting.taplo,

          -- php
          formatting.pint,

          --python
          formatting.black,
          -- diagnostics.flake8,

          diagnostics.shellcheck.with({
            cwd = function()
              local util = require("null-ls.utils")
              -- falls back to root if return value is nil
              return util.root_pattern(".shellcheckrc")(vim.fn.expand("%:p"))
            end,
          }),
        })
      end
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "prettierd",
        "stylua",

        --python
        "black",
        -- "flake8",
      })
    end,
  },
}

return M
