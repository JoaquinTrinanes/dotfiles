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
        tailwindcss = {
          settings = {
            tailwindCSS = {
              experimental = {
                classRegex = {
                  -- classNames="...", classNames: "..."
                  classNamePropNameRegex
                    .. [[\s*[:=]\s*]]
                    .. quotedStringRegex,
                  --classNames={...} prop
                  classNamePropNameRegex
                    .. [[\s*[:=]\s*]]
                    .. quotedStringRegex
                    .. [[\s*}]],
                  -- classNames(...)
                  { [[class[nN]ames\(([^)]*)\)]], quotedStringRegex },
                },
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

              local client = vim.lsp.get_clients({ bufnr = event.buf, name = "eslint" })[1]
              if client then
                vim.cmd("EslintFixAll")
              end
            end,
          })
        end,
      },
    },
  },
  { "folke/noice.nvim", opts = { lsp = { hover = { silent = true } } } },
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
        dependencies = { { "nvimtools/none-ls.nvim" } },
        ft = { "nu" },
        config = function()
          local ok, null_ls = pcall(require, "null-ls")
          if not ok then
            return
          end
          null_ls.register(require("nu-ls"))
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
