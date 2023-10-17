local M = {
  -- {
  --   "nvimtools/none-ls.nvim",
  --   optional = true,
  --   -- enabled = false,
  --   opts = function(_, opts)
  --     if type(opts.sources) == "table" then
  --       local null_ls = require("null-ls")
  --       local formatting = null_ls.builtins.formatting
  --       local diagnostics = null_ls.builtins.diagnostics
  --       -- local code_actions = null_ls.builtins.code_actions
  --       -- local completions = null_ls.builtins.completions
  --
  --       vim.list_extend(opts.sources, {
  --         -- formatting.prettier,
  --         -- formatting.stylua,
  --         -- formatting.taplo,
  --
  --         -- php
  --         -- formatting.pint,
  --
  --         --python
  --         -- formatting.black,
  --         -- diagnostics.flake8,
  --
  --         diagnostics.shellcheck.with({
  --           runtime_condition = function(params)
  --             return vim.api.nvim_buf_get_name(params.bufnr):find("^.env") == nil
  --           end,
  --           cwd = function()
  --             local util = require("null-ls.utils")
  --             -- falls back to root if return value is nil
  --             return util.root_pattern(".shellcheckrc")(vim.fn.expand("%:p"))
  --           end,
  --         }),
  --       })
  --     end
  --   end,
  -- },
  {
    "stevearc/conform.nvim",
    -- config = function()
    -- require("conform.formatters.shellcheck").condition = function(ctx)
    --   return vim.api.nvim_buf_get_name(ctx.buf):find("^.env") == nil
    -- end
    -- require("conform.formatters.shellcheck").cwd = require("conform.util").root_file({ ".shellcheckrc" })
    -- end,
    opts = {
      ---@type table<string, conform.FormatterUnit[]>
      formatters_by_ft = {
        python = { "black" },
        toml = { "taplo" },
        php = { "pint" },
        ["_"] = {
          "trim_whitespace",
        },
      },
      ---@type table<string, conform.FormatterConfig|fun(bufnr: integer): nil|conform.FormatterConfig>
      -- formatters = {},
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        sh = { "shellcheck" },
      },
      linters = {
        shellcheck = {
          condition = function(ctx)
            return ctx.filename:find(".env$") == nil
          end,
        },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "prettier",
        "stylua",
        "shfmt",

        --python
        "black",
        -- "flake8",
      })
    end,
  },
}

return M
