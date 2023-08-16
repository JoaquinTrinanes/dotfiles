local classNameRegex = "[cC][lL][aA][sS][sS][nN][aA][mM][eE][sS]?"
local classNamePropNameRegex = "(?:" .. classNameRegex .. "|(?:enter|leave)(?:From|To)?)"
local quotedStringRegex = [[(?:["'`]([^"'`]*)["'`])]]

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
            rulesCustomizations = {
              { rule = "prettier/prettier", severity = "off" },
            },
          },
        },
        tailwindcss = {
          settings = {
            tailwindCSS = {
              experimental = {
                classRegex = {
                  -- classNames="...", classNames: "..."
                  classNamePropNameRegex
                    .. "\\s*[:=]\\s*"
                    .. quotedStringRegex,
                  --classNames={...} prop
                  classNamePropNameRegex
                    .. "\\s*[:=]s*"
                    .. quotedStringRegex
                    .. "\\s*}",
                  -- classNames(...)
                  { "class[nN]ames\\(([^)]*)\\)", quotedStringRegex },
                },
              },
            },
          },
          intelephense = {
            settings = {
              files = {
                max_size = 100000,
              },
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
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "taplo", "eslint-lsp", "intelephense" })
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
    config = true,
  },
}

return M
