local function map(mode, lhs, rhs, opts)
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

-- vim options
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.relativenumber = true
vim.opt.timeoutlen = 500
vim.opt.wrap = true

-- general
lvim.log.level = "info"
lvim.format_on_save = {
	enabled = true,
	-- pattern = "*.lua",
	timeout = 1000,
}
-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false

-- keymappings <https://www.lunarvim.org/docs/configuration/keybindings>
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
-- Remap for dealing with word wrap
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
-- lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"

-- -- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["W"] = { "<cmd>noautocmd w<cr>", "Save without formatting" }
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }

-- -- Change theme settings
-- lvim.colorscheme = "lunar"
lvim.colorscheme = "flavours"

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"

lvim.builtin.dap.active = true

lvim.builtin.terminal.active = true
lvim.builtin.terminal.shell = "nu"

lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

lvim.builtin.breadcrumbs.active = true

local components = require("lvim.core.lualine.components")
local function buftype()
	return vim.bo.buftype
end
local function currentHl()
	local line = vim.fn.line(".")
	local col = vim.fn.col(".")
	local result = vim.fn.synstack(line, col)

	local highlight_names = vim.tbl_map(function(item)
		return vim.fn.synIDattr(item, "name")
	end, result)
	return highlight_names
end
lvim.builtin.lualine.sections.lualine_x = {
	function()
		return vim.inspect(currentHl())
	end,
	components.diagnostics,
	components.lsp,
	-- components.spaces,
	buftype,
	components.filetype,
}
lvim.builtin.lualine.sections.lualine_y = {
	components.encoding,
	"filesize",
	components.location,
}

lvim.builtin.gitsigns.active = true
lvim.builtin.gitsigns.opts.yadm.enable = true
lvim.builtin.gitsigns.opts.current_line_blame = true

lvim.builtin.cmp.experimental.ghost_text = true

-- Automatically install missing parsers when entering buffer
lvim.builtin.treesitter.highlight.enable = true
lvim.builtin.treesitter.auto_install = true
lvim.builtin.treesitter.highlight.additional_vim_regex_highlighting = true
lvim.builtin.treesitter.ensure_installed = {
	"markdown",
	"regex",
	"vim",
	"markdown_inline",
}
-- lvim.builtin.lualine.style = "default" -- or "none"

-- lvim.builtin.treesitter.ignore_install = { "haskell" }

-- -- generic LSP settings <https://www.lunarvim.org/docs/languages#lsp-support>

-- --- disable automatic installation of servers
-- lvim.lsp.installer.setup.automatic_installation = false

-- ---configure a server manually. IMPORTANT: Requires `:LvimCacheReset` to take effect
-- ---see the full default list `:lua =lvim.lsp.automatic_configuration.skipped_servers`
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)

-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. IMPORTANT: Requires `:LvimCacheReset` to take effect
-- ---`:LvimInfo` lists which server(s) are skipped for the current filetype
-- lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
--   return server ~= "emmet_ls"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

require("lvim.lsp.manager").setup("eslint", {
	settings = {
		rulesCustomizations = { { rule = "prettier/prettier", severity = "off" } },
	},
})

-- -- linters and formatters <https://www.lunarvim.org/docs/languages#lintingformatting>
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	-- { name = "eslint" },
	{ name = "prettierd" },
	{ name = "stylua" },
})
-- formatters.setup {
--   { command = "stylua" },
--   {
--     command = "prettier",
--     extra_args = { "--print-width", "100" },
--     filetypes = { "typescript", "typescriptreact" },
--   },
-- }
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { command = "flake8", filetypes = { "python" } },
--   {
--     command = "shellcheck",
--     args = { "--severity", "warning" },
--   },
-- }

-- -- Additional Plugins <https://www.lunarvim.org/docs/plugins#user-plugins>
lvim.plugins = {
	{
		"echasnovski/mini.map",
		event = "BufEnter",
		config = function()
			require("mini.map").setup()
			local map = require("mini.map")
			map.setup({
				integrations = {
					map.gen_integration.builtin_search(),
					map.gen_integration.diagnostic({
						error = "DiagnosticFloatingError",
						warn = "DiagnosticFloatingWarn",
						info = "DiagnosticFloatingInfo",
						hint = "DiagnosticFloatingHint",
					}),
				},
				symbols = {
					encode = map.gen_encode_symbols.dot("4x2"),
				},
				window = {
					focusable = true,
					side = "right",
					width = 20, -- set to 1 for a pure scrollbar :)
					winblend = 15,
					show_integration_count = false,
				},
			})
			MiniMap.open()
		end,
	},
	{
		"ggandor/leap.nvim",
		event = "BufRead",
		config = function()
			require("leap").add_default_mappings()
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		filetypes = {
			"typescriptreact",
		},
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
	{
		"folke/lsp-colors.nvim",
		event = "LspAttach",
	},
	{
		"ray-x/lsp_signature.nvim",
		event = "LspAttach",
		config = function()
			local cfg = {
				bind = true,
				handler_opts = {
					border = "rounded", -- double, single, shadow, none
				},
				hint_prefix = "",
			}
			require("lsp_signature").on_attach(cfg)
		end,
	},
	{
		"folke/trouble.nvim",
		init = function()
			lvim.builtin.which_key.mappings["t"] = {
				name = "Diagnostics",
				t = { "<cmd>TroubleToggle<cr>", "trouble" },
				w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "workspace" },
				d = { "<cmd>TroubleToggle document_diagnostics<cr>", "document" },
				q = { "<cmd>TroubleToggle quickfix<cr>", "quickfix" },
				l = { "<cmd>TroubleToggle loclist<cr>", "loclist" },
				r = { "<cmd>TroubleToggle lsp_references<cr>", "references" },
			}
		end,
		cmd = "TroubleToggle",
	},
	{
		"kylechui/nvim-surround",
		config = function()
			require("nvim-surround").setup({})
		end,
	},
	{
		"stevearc/dressing.nvim",
		event = "VimEnter",
		config = function()
			local telescope_themes = require("telescope.themes")
			require("dressing").setup({
				input = { relative = "cursor" },
				select = {
					get_config = function(opts)
						print(opts.kind)
						if opts.kind == "codeaction" or opts.kind == "hover" then
							return { telescope = telescope_themes.get_cursor() }
						end
					end,
					telescope = telescope_themes.get_dropdown(),
				},
			})
		end,
	},
	{
		"folke/noice.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("telescope").load_extension("noice")
			require("noice").setup({
				lsp = {
					signature = {
						enabled = false,
					},
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
				},
				presets = {
					lsp_doc_border = true,
					long_message_to_split = true,
				},
				popupmenu = { backend = "cmp" },
			})
		end,
	},
}

vim.api.nvim_create_user_command("WhatHl", function()
	print(vim.inspect(currentHl()))
end, {})

-- lvim.autocommands = {
--   {
--     "BufEnter", -- see `:h autocmd-events`
--     { -- this table is passed verbatim as `opts` to `nvim_create_autocmd`
--         pattern = { "*.json", "*.jsonc" }, -- see `:h autocmd-events`
--         command = "setlocal wrap",
--     }
-- },
-- }
