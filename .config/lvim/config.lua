local watch_file = require("user.watch_file")

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
vim.opt.list = true
-- vim.opt.listchars:append("lead:⋅")
vim.opt.listchars:append("tab:→ ")

-- general
lvim.log.level = "info"
lvim.format_on_save.enabled = true
lvim.format_on_save.timeout = 10000
lvim.format_on_save.pattern = nil
lvim.lsp.document_highlight = true

-- keymappings <https://www.lunarvim.org/docs/configuration/keybindings>
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["x"] = [["_x]]
lvim.keys.normal_mode["X"] = [["_X]]
lvim.keys.normal_mode["<C-.>"] = vim.lsp.buf.code_action

-- Remap for dealing with word wrap
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
-- lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"

-- -- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["W"] = { "<cmd>noautocmd w<cr>", "Save without formatting" }
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }

-- -- Change theme settings
lvim.colorscheme = "flavours"

-- Show previewer when searching git files with default <leader>f
lvim.builtin.which_key.mappings["f"] = {
	require("lvim.core.telescope.custom-finders").find_project_files,
	"Find File",
}

-- Show previewer when searching buffers with <leader>bf
lvim.builtin.which_key.mappings.b.f = {
	"<cmd>Telescope buffers<cr>",
	"Find",
}

lvim.builtin.which_key.mappings.l.g = { vim.lsp.buf.definition, "Go to definition" }

lvim.builtin.telescope.defaults.layout_config.horizontal = {
	prompt_position = "top",
}
lvim.builtin.telescope.defaults.layout_config.vertical = {
	prompt_position = "top",
	mirror = false,
}
lvim.builtin.telescope.defaults.layout_config.preview_cutoff = 120
lvim.builtin.telescope.defaults.layout_strategy = "horizontal"

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.alpha.dashboard.opts.theme = "doom"
-- lvim.builtin.alpha.dashboard.section.header.val = {
-- 	"             ___            ___  ",
-- 	"            (o o)          (o o) ",
-- 	"           (  V  ) NeoVim (  V  ) ",
-- 	"           --m-m------------m-m--",
-- 	"                                     ",
-- 	-- "    Your day is going to be a real hoot!  ",
-- }

local function get_mason_package(package_name)
	local mason_registry = require("mason-registry")
	return mason_registry.get_package(package_name)
end

lvim.builtin.dap.active = true
lvim.builtin.dap.on_config_done = function(dap)
	local php_debug_adapter = get_mason_package("php-debug-adapter")

	dap.adapters.php = {
		type = "executable",
		command = "sh",
		args = { php_debug_adapter:get_install_path() .. "/php-debug-adapter" },
	}
	dap.configurations.php = {
		{
			type = "php",
			request = "launch",
			name = "Listen for Xdebug",
			port = 9003,
			proxy = {
				key = "vsc",
			},
			pathMappings = {
				["/var/www/html"] = vim.fn.getcwd(),
			},
		},
	}
end

lvim.builtin.terminal.active = true
lvim.builtin.terminal.shell = "nu"

lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false
lvim.builtin.nvimtree.setup.renderer.indent_markers.enable = true
lvim.builtin.nvimtree.setup.renderer.group_empty = true
lvim.builtin.nvimtree.setup.select_prompts = true

lvim.builtin.breadcrumbs.active = true

local components = require("lvim.core.lualine.components")
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
	components.diagnostics,
	components.lsp,
	components.filetype,
}
lvim.builtin.lualine.sections.lualine_y = {
	components.encoding,
	"filesize",
	components.location,
}

lvim.builtin.lir.show_hidden_files = true
vim.list_extend(lvim.builtin.lir.ignore, { ".DS_Store", "node_modules", ".git" })

lvim.builtin.gitsigns.active = true
lvim.builtin.gitsigns.opts.yadm.enable = true
lvim.builtin.gitsigns.opts.current_line_blame = true

lvim.builtin.cmp.experimental.ghost_text = true

lvim.builtin.treesitter.highlight.enable = true
lvim.builtin.treesitter.autotag.enable = true
lvim.builtin.treesitter.matchup.enable = true
lvim.builtin.treesitter.auto_install = true
lvim.builtin.treesitter.highlight.additional_vim_regex_highlighting = true
lvim.builtin.treesitter.ensure_installed = "all"

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

-- vim.list_extend(vim.lsp.automatic_configuration.skipped_servers, {})
-- lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
-- 	return not vim.list_contains({
-- 		"beautysh",
-- 		"black",
-- 		"eslint-lsp",
-- 		"eslint_d",
-- 		"intelephense",
-- 		"lua-language-server",
-- 		"prettierd",
-- 		"stylua",
-- 		"tailwindcss-language-server",
-- 		"typescript-language-server",
-- 	}, server)
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

local enabled_lsps = { "taplo" }
for _, lsp in ipairs(enabled_lsps) do
	require("lvim.lsp.manager").setup(lsp)
end

require("lvim.lsp.manager").setup("eslint", {
	on_attach = function(client, bufnr)
		client.server_capabilities.document_formatting = true
		if client.server_capabilities.document_formatting then
			local au_lsp = vim.api.nvim_create_augroup("eslint_lsp", { clear = true })
			vim.api.nvim_create_autocmd("BufWritePre", {
				desc = "Autoformat with eslint",
				callback = function()
					vim.cmd.EslintFixAll()
				end,
				group = au_lsp,
			})
		end
	end,
	settings = {
		rulesCustomizations = { { rule = "prettier/prettier", severity = "off" } },
	},
})

local classNameRegex = "[cC][lL][aA][sS][sS][nN][aA][mM][eE][sS]?"
local classNamePropNameRegex = "(?:" .. classNameRegex .. "|(?:enter|leave)(?:From|To)?)"
local quotedStringRegex = [[(?:["'`]([^"'`]*)["'`])]]
require("lvim.lsp.manager").setup("tailwindcss", {
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
})

require("lvim.lsp.manager").setup("intelephense", {
	settings = {
		files = {
			max_size = 100000,
		},
	},
})

-- linters and formatters <https://www.lunarvim.org/docs/languages#lintingformatting>
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	{
		name = "prettierd",
		-- extra_args = { "--print-width", "100" },
		-- filetypes = { "typescript", "typescriptreact" },
	},
	{ name = "stylua" },
	{ name = "beautysh" },
	{ name = "pint" },
})

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
		"akinsho/git-conflict.nvim",
		event = "BufRead",
		version = "*",
		name = "git-conflict",
		opts = {
			default_mappings = false,
			highlights = {
				incoming = "DiffText",
				current = "DiffAdd",
			},
		},
		init = function()
			lvim.builtin.which_key.mappings["gf"] = {
				name = "Conflicts",
				o = {
					"<Plug>(git-conflict-ours)",
					"Choose ours",
				},
				t = {
					"<Plug>(git-conflict-theirs)",
					"Choose theirs",
				},
				b = {
					"<Plug>(git-conflict-both)",
					"Choose both",
				},
				n = {
					"<Plug>(git-conflict-none)",
					"Choose none",
				},
			}
		end,
		config = true,
	},
	{
		"echasnovski/mini.nvim",
		event = "VeryLazy",
		version = false,
		config = function()
			require("mini.map").setup()
			local minimap = require("mini.map")
			minimap.setup({
				integrations = {
					minimap.gen_integration.builtin_search(),
					minimap.gen_integration.diagnostic({
						error = "DiagnosticFloatingError",
						warn = "DiagnosticFloatingWarn",
						info = "DiagnosticFloatingInfo",
						hint = "DiagnosticFloatingHint",
					}),
					minimap.gen_integration.gitsigns(),
				},
				symbols = {
					encode = minimap.gen_encode_symbols.dot("4x2"),
				},
				window = {
					focusable = true,
					side = "right",
					winblend = 50,
					show_integration_count = false,
				},
			})
			vim.api.nvim_create_user_command("MinimapToggle", function()
				minimap.toggle()
			end, {})
		end,
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
	},
	{
		"windwp/nvim-ts-autotag",
		config = true,
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		event = "BufRead",
	},
	{
		"nvim-treesitter/playground",
		cmd = "TSPlaygroundToggle",
	},
	{
		"rktjmp/lush.nvim",
	},
	{
		"folke/lsp-colors.nvim",
		event = "LspAttach",
	},
	{
		"ray-x/lsp_signature.nvim",
		opts = {
			bind = true,
			handler_opts = {
				border = "rounded", -- double, single, shadow, none
			},
			hint_prefix = "",
			noice = true,
			floating_window_above_cur_line = true,
			hi_parameter = "Search",
		},
		config = true,
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
		config = true,
	},
	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
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
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		opts = {
			lsp = {
				signature = {
					enabled = false,
				},
				hover = { enabled = true, silent = true },
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			presets = {
				long_message_to_split = true, -- long messages will be sent to a split
				lsp_doc_border = true, -- add a border to hover docs and signature help
				command_palette = true, -- position the cmdline and popupmenu together
			},
		},
		config = true,
	},
	{
		"zbirenbaum/copilot-cmp",
		dependencies = {
			"zbirenbaum/copilot.lua",
			opts = { suggestion = { enabled = false }, panel = { enabled = false } },
			config = true,
		},
		config = true,
	},
	{ "tpope/vim-repeat" },
	{
		"norcalli/nvim-colorizer.lua",
		event = "BufRead",
		config = function()
			require("colorizer").setup()
		end,
	},
	{
		"LhKipp/nvim-nu",
		event = "BufRead",
		build = ":TSInstall nu",
		opts = {
			use_lsp_features = true,
			all_cmd_names = [[nu -c 'help commands | get name | str join (char newline)']],
		},
		config = true,
	},
	{
		"zioroboco/nu-ls.nvim",
		ft = { "nu" },
		config = function()
			require("null-ls").register(require("nu-ls"))
		end,
	},
	{ "imsnif/kdl.vim" },
	{
		"mrjones2014/smart-splits.nvim",
		dependencies = {
			{ "kwkarlwang/bufresize.nvim", config = true, lazy = true },
		},
		version = "*",
		keys = {
			{ "<A-h>", require("smart-splits").resize_left },
			{ "<A-j>", require("smart-splits").resize_down },
			{ "<A-k>", require("smart-splits").resize_up },
			{ "<A-l>", require("smart-splits").resize_right },
			-- -- moving between splits
			{ "<C-h>", require("smart-splits").move_cursor_left },
			{ "<C-j>", require("smart-splits").move_cursor_down },
			{ "<C-k>", require("smart-splits").move_cursor_up },
			{ "<C-l>", require("smart-splits").move_cursor_right },
			-- -- swapping buffers between windows
			{ "<leader><leader>h", require("smart-splits").swap_buf_left },
			{ "<leader><leader>h", require("smart-splits").swap_buf_down },
			{ "<leader><leader>h", require("smart-splits").swap_buf_up },
			{ "<leader><leader>h", require("smart-splits").swap_buf_right },
		},
		opts = {
			hooks = {
				on_leave = require("bufresize").register,
			},
		},
		lazy = false,
	},
}

vim.api.nvim_create_user_command("WhatHl", function()
	print(vim.inspect(currentHl()))
end, {})

lvim.autocommands = {
	{
		"VimEnter",
		{
			callback = function()
				local colorscheme_path = vim.fn.expand("~/.config/lvim/colors/flavours.lua")
				watch_file(colorscheme_path, function()
					vim.cmd("colorscheme flavours")
				end)
			end,
		},
	},
}
