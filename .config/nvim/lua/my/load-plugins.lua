local C = require("my.constants")

local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local config_path = vim.fn.stdpath("config") .. "/lua/" .. C.CONFIG_PATH

local packer_bootstrap = ensure_packer()

local augroup = vim.api.nvim_create_augroup("SyncOnPackerSave", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup,
	pattern = config_path .. "/load-plugins.lua",
	command = "PackerCompile",
})

local plugins = {
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		requires = {
			{
				"nvim-treesitter/nvim-treesitter",
				as = "treesitter",
				run = function()
					local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
					ts_update()
				end,
				config = function()
					require("nvim-treesitter.configs").setup({
						auto_install = true,
						sync_install = true,
						ensure_installed = { "typescript", "javascript" },
						highlight = {
							enable = false,
						},
						context_commentstring = {
							enable = true,
						},
					})
				end,
			},
		},
	},
	{
		"mfussenegger/nvim-dap-python",
		after = "nvim-dap",
		config = function()
			require("dap-python").setup()
		end,
	},
	{
		"mfussenegger/nvim-dap",
		requires = {
			{
				"rcarriga/nvim-dap-ui",
				config = function()
					require("dapui").setup()
				end,
			},
			{
				"theHamsta/nvim-dap-virtual-text",
				after = { "treesitter" },
				config = function()
					require("nvim-dap-virtual-text").setup()
				end,
			},
		},
		config = function()
			local dap, dapui = require("dap"), require("dapui")
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end,
	},
	{
		"stevearc/dressing.nvim",
		after = { "telescope" },
		config = function()
			local telescope_themes = require("telescope.themes")
			require("dressing").setup({
				input = { relative = "cursor" },
				select = {
					get_config = function(opts)
						if opts.kind == "codeaction" or opts.kind == "hover" then
							return { telescope = telescope_themes.get_cursor() }
						end
					end,
					telescope = telescope_themes.get_dropdown(),
				},
			})
		end,
	},
	{ "kyazdani42/nvim-web-devicons" },
	{
		"williamboman/mason.nvim",
		as = "mason",
		requires = {
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
			"simrat39/rust-tools.nvim",
		},
		after = { "cmp-nvim-lsp" },
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"sumneko_lua",
					"tsserver",
					"tailwindcss",
					"pyright",
				},
			})
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			require("mason-lspconfig").setup_handlers({
				function(server_name)
					require("lspconfig")[server_name].setup({ capabilities = capabilities })
				end,
				["rust_analyzer"] = function()
					local rt = require("rust-tools")
					rt.setup({
						capabilities = capabilities,
						tools = { hover_actions = { auto_hover = true } },
					})
				end,
				["sumneko_lua"] = function()
					require("lspconfig").sumneko_lua.setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								diagnostics = { globals = { "vim" } },
								workspace = {
									library = {
										[vim.fn.expand("$VIMRUNTIME/lua")] = true,
										[vim.fn.stdpath("config") .. "/lua"] = true,
									},
								},
							},
						},
					})
				end,
			})
		end,
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		as = "null-ls",
		after = { "mason" },
		config = function()
			local null_ls = require("null-ls")
			local builtins = null_ls.builtins
			local ca = builtins.code_actions
			local f = builtins.formatting
			local d = builtins.diagnostics
			local c = builtins.completion
			local h = builtins.hover

			local prefer_local_node_modules = { prefer_local = "node_modules/.bin" }

			null_ls.setup({
				root_dir = require("null-ls.utils").root_pattern(".null-ls-root", "node_modules", "Makefile", ".git"),
				sources = {
					d.todo_comments,
					f.prettierd,
					c.luasnip,

					-- xml
					f.xmllint,

					-- markdown
					d.markdownlint,
					f.markdownlint,

					-- git
					ca.gitsigns.with({
						config = {
							-- filter out blame actions
							filter_actions = function(title)
								return title:lower():match("blame") == nil
							end,
						},
					}),

					-- shell
					f.beautysh,
					h.printenv,

					-- lua
					f.stylua,

					-- js
					d.tsc.with(prefer_local_node_modules),
					ca.eslint_d.with(prefer_local_node_modules),
					d.eslint_d.with(vim.tbl_extend("force", prefer_local_node_modules, {
						filter = function(diagnostic)
							return diagnostic.code ~= "prettier/prettier"
						end,
						extra_args = {
							"--report-unused-disable-directives",
						},
					})),
					f.eslint_d.with(prefer_local_node_modules),

					-- python
					f.black,
				},
			})
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		tag = "nightly",
		as = "nvim-tree",
		config = function()
			require("nvim-tree").setup({
				open_on_setup = false,
				live_filter = {
					always_show_folders = false,
				},
				view = {
					mappings = {
						list = {
							{ key = "<space>", action = "edit" },
							{ key = "u", action = "dir_up" },
						},
					},
				},
			})
		end,
	},
	{
		"jayp0521/mason-nvim-dap.nvim",
		after = { "mason" },
		config = function()
			local mason_dap = require("mason-nvim-dap")
			mason_dap.setup({ automatic_setup = true })
			mason_dap.setup_handlers({
				function(source_name)
					require("mason-nvim-dap.automatic_setup")(source_name)
				end,
			})
		end,
	},
	{
		"jayp0521/mason-null-ls.nvim",
		after = { "mason", "null-ls" },
		config = function()
			require("mason-null-ls").setup({
				ensure_installed = nil,
				automatic_installation = true,
				automatic_setup = true,
			})
			require("mason-null-ls").setup_handlers()
		end,
	},
	{
		"folke/trouble.nvim",
		config = function()
			require("trouble").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	},
	{ "folke/lsp-colors.nvim" },
	{ "gpanders/editorconfig.nvim" },
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				current_line_blame = true,
				yadm = {
					enable = true,
				},
			})
		end,
	},
	{ "knubie/vim-kitty-navigator" },
	{
		"nvim-telescope/telescope.nvim",
		as = "telescope",
		branch = "0.1.x",
		requires = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
		},
		run = function()
			local hasFd = os.execute("command -v fd &> /dev/null")
			local hasRipgrep = os.execute("command -v rg &> /dev/null")
			if hasFd == 0 or hasRipgrep == 0 then
				return
			end
			error("fd or ripGrep are not installed")
		end,
		config = function()
			local telescope = require("telescope")
			telescope.setup({})
			telescope.load_extension("fzf")
		end,
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		after = { "telescope" },
		config = function()
			require("telescope").load_extension("file_browser")
		end,
	},
	{ "shaunsingh/nord.nvim" },
	{ "tpope/vim-commentary" },
	{ "tpope/vim-eunuch" },
	{ "tpope/vim-sleuth" },
	{ "tpope/vim-surround" },
	{ "ggandor/lightspeed.nvim" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{
		"hrsh7th/nvim-cmp",
		requires = {
			{ "L3MON4D3/LuaSnip", tag = "v1.*" },
			{ "onsails/lspkind.nvim" },
			{ "hrsh7th/cmp-cmdline" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-emoji" },
			{
				"github/copilot.vim",
				setup = function()
					vim.g.copilot_no_tab_map = true
				end,
			},
			{ "hrsh7th/cmp-copilot" },
			{ "rcarriga/cmp-dap" },
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")

			local select_config = { behavior = cmp.SelectBehavior.Select }

			cmp.setup({
				enabled = function()
					return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
				end,
				experimental = {
					ghost_text = true,
				},
				view = {
					entries = { name = "custom", selection_order = "near_cursor" },
					-- 	entries = "native", -- can be "custom", "wildmenu" or "native"
				},
				formatting = {
					fields = { "kind", "abbr", "menu" },
					format = lspkind.cmp_format({ mode = "symbol" }),
				},
				preselect = cmp.PreselectMode.None,
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = {
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item(select_config)
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item(select_config)
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
					}),
				},
				sources = cmp.config.sources({
					{ name = "copilot" },
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
				}, {
					{ name = "emoji" },
				}),
			})
			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				view = {
					entries = { name = "wildmenu", separator = "|" },
				},
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{
						name = "cmdline",
					},
				}),
			})
			cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
				sources = {
					{ name = "dap" },
				},
			})
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		requires = { "arkav/lualine-lsp-progress" },
		config = function()
			local function diff_source()
				local gitsigns = vim.b.gitsigns_status_dict
				if gitsigns then
					return {
						added = gitsigns.added,
						modified = gitsigns.changed,
						removed = gitsigns.removed,
					}
				end
			end

			require("lualine").setup({
				extensions = { "nvim-tree" },
				options = {
					globalstatus = true,
					ignore_focus = {
						"Trouble",
						"NvimTree",
						"Help",
						"TelescopePrompt",
						"",
					},
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = {
						{ "b:gitsigns_head", icon = "" },
						{ "diff", source = diff_source },
						{
							"diagnostics",
							on_click = function()
								local ok, trouble = pcall(require, "trouble")
								if not ok then
									return
								end
								trouble.toggle()
							end,
						},
					},
					lualine_c = { "filename", "lsp_progress" },
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
			})
		end,
	},
	{
		"rcarriga/nvim-notify",
		after = "telescope",
		config = function()
			local notify = require("notify")
			local original_notify = vim.notify
			notify.setup()
			vim.notify = function(message)
				-- Hack: if one LSP doesn't return data an error shows up alongside the results
				if message == "No information available" then
					original_notify(message)
					return
				end
				notify(message)
			end
			require("telescope").load_extension("notify")
		end,
	},
}

return require("packer").startup({
	function(use)
		use("wbthomason/packer.nvim")
		for _, plugin in ipairs(plugins) do
			use(plugin)
		end
		if packer_bootstrap then
			require("packer").sync()
		end
	end,
	config = {},
})
