local M = {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = {
          prefix = "icons",
        },
      },
      inlay_hints = {
        enabled = true,
      },
      ---@type lspconfig.options
      servers = {
        eslint = {
          settings = {
            -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
            workingDirectory = { mode = "auto" },
          },
        },
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              -- prevent locking cargo compilation
              ---@diagnostic disable-next-line: assign-type-mismatch
              checkOnSave = {
                extraArgs = { "--target-dir", "/tmp/rust-analyzer-check" },
              },
            },
          },
          keys = {
            {
              "<leader>cE",
              function()
                require("rust-tools").expand_macro.expand_macro()
              end,
              desc = "Expand Macro (Rust)",
            },
          },
        },
      },
      setup = {
        eslint = function()
          vim.api.nvim_create_autocmd("BufWritePre", {
            callback = function(event)
              if not require("lazyvim.plugins.lsp.format").enabled() then
                -- exit early if autoformat is not enabled
                return
              end

              local client = vim.lsp.get_active_clients({ bufnr = event.buf, name = "eslint" })[1]
              if client then
                -- local diag = vim.diagnostic.get(event.buf, { namespace = vim.lsp.diagnostic.get_namespace(client.id) })
                -- if #diag > 0 then
                vim.cmd("EslintFixAll")
                -- end
              end
            end,
          })
        end,
      },
    },
  },
  { "folke/noice.nvim", opts = { lsp = { hover = { silent = true } } } },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = "all"
      -- if type(opts.ensure_installed) == "table" then
      --   opts.ensure_installed = "all"
      --   -- vim.list_extend(opts.ensure_installed, { "typescript", "tsx" })
      -- end
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, _opts)
      local opts = _opts
      opts.ensure_installed = opts.ensure_installed or {}

      vim.list_extend(opts.ensure_installed, { "taplo", "eslint-lsp", "intelephense", "pyright" })
    end,
  },
  {
    "LhKipp/nvim-nu",
    dependencies = {
      {
        "zioroboco/nu-ls.nvim",
        ft = { "nu" },
        config = function()
          require("null-ls").register(require("nu-ls"))
        end,
      },
    },
    event = "BufRead",
    build = ":TSInstall nu",
    opts = {
      use_lsp_features = true,
      all_cmd_names = [[nu -c 'help commands | get name | str join (char newline)']],
    },
    config = true,
  },
  {
    "windwp/nvim-ts-autotag",
    ft = {
      "html",
      "javascriptreact",
      "typescriptreact",
      "svelte",
      "vue",
      "tsx",
      "jsx",
      "rescript",
      "xml",
      "php",
      "markdown",
      "astro",
      "glimmer",
      "handlebars",
      "hbs",
    },
    opts = function(plugin, opts)
      opts.filetypes = plugin.ft
    end,
  },
  { "imsnif/kdl.vim", ft = { "kdl" } },
}

return M
