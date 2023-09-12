local M = {
  { "lewis6991/gitsigns.nvim", opts = { yadm = { enable = true } } },
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
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
    opts = {
      defaults = {
        preview = {
          mime_hook = function(filepath, bufnr, opts)
            local is_image = function()
              local image_extensions = { "png", "jpg" } -- Supported image formats
              local split_path = vim.split(filepath:lower(), ".", { plain = true })
              local extension = split_path[#split_path]
              return vim.tbl_contains(image_extensions, extension)
            end
            if is_image() then
              local term = vim.api.nvim_open_term(bufnr, {})
              local function send_output(_, data, _)
                for _, d in ipairs(data) do
                  vim.api.nvim_chan_send(term, d .. "\r\n")
                end
              end
              local win = vim.api.nvim_get_current_win()
              -- vim.wo[win].wrap = false
              local width = vim.api.nvim_win_get_width(win)
              vim.fn.jobstart({
                "catimg",
                "-w",
                width,
                filepath, -- Terminal image viewer command
              }, { on_stdout = send_output, stdout_buffered = true, pty = true })
            else
              require("telescope.previewers.utils").set_preview_message(bufnr, opts.winid, "Binary cannot be previewed")
            end
          end,
        },
      },
    },
  },
  {
    "stevearc/dressing.nvim",
    opts = {
      input = { relative = "cursor" },
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
  -- {
  --   "toppair/peek.nvim",
  --   build = "deno task --quiet build:fast",
  --   config = function(_, opts)
  --     require("peek").setup(opts)
  --     vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
  --     vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
  --   end,
  --   ft = { "markdown" },
  --   cmd = { "PeekOpen", "PeekClose" },
  --   opts = {
  --     auto_load = true, -- whether to automatically load preview when entering another markdown buffer
  --     -- close_on_bdelete = true,  -- close preview window on buffer delete
  --     -- syntax = true,            -- enable syntax highlighting, affects performance
  --     -- theme = 'dark',           -- 'dark' or 'light'
  --     -- update_on_change = true,
  --     -- app = 'webview',          -- 'webview', 'browser', string or a table of strings
  --   },
  -- },
}

return M
