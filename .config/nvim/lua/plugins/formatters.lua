local M = {
  {
    "stevearc/conform.nvim",
    opts = {
      ---@type table<string, conform.FormatterUnit[]>
      formatters_by_ft = {
        toml = { "taplo" },
        php = { "pint" },
        nix = { { "alejandra", "nixfmt" } },
        markdown = { "injected", "prettier" },
        ["_"] = {
          "trim_whitespace",
        },
      },
      ---@type table<string, conform.FormatterConfig|fun(bufnr: integer): nil|conform.FormatterConfig>
      formatters = {},
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
      })
    end,
  },
}

return M
