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
			local code_actions = builtins.code_actions
			local formatting = builtins.formatting
			local diagnostics = builtins.diagnostics
			-- local completion = builtins.completion
			local hover = builtins.hover

			local prefer_local_node_modules = { prefer_local = "node_modules/.bin" }

			null_ls.setup({
				root_dir = require("null-ls.utils").root_pattern(".null-ls-root", "node_modules", "Makefile", ".git"),
				on_attach = function(client)
					local setup = require("my.commands").setup_lsp_commands
					setup(client)
				end,
				sources = {
					diagnostics.todo_comments,
					formatting.prettierd,
					null_ls.builtins.completion.luasnip,

					-- xml
					formatting.xmllint,

					-- markdown
					diagnostics.markdownlint,
					formatting.markdownlint,

					-- git
					code_actions.gitsigns.with({
						config = {
							-- filter out blame actions
							filter_actions = function(title)
								return title:lower():match("blame") == nil
							end,
						},
					}),

					-- shell
					formatting.beautysh,
					hover.printenv,

					-- lua
					formatting.stylua,

					-- js
					diagnostics.tsc.with(prefer_local_node_modules),
					code_actions.eslint_d.with(prefer_local_node_modules),
					diagnostics.eslint_d.with(vim.tbl_extend("force", prefer_local_node_modules, {
						filter = function(diagnostic)
							return diagnostic.code ~= "prettier/prettier"
						end,
						extra_args = {
							"--report-unused-disable-directives",
						},
					})),
					formatting.eslint_d.with(prefer_local_node_modules),

					-- python
					formatting.black,
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
	{ "tpope/vim-commentary" },
	{ "shaunsingh/nord.nvim" },
	{ "tpope/vim-eunuch" },
	{ "tpope/vim-surround" },
	{ "ggandor/lightspeed.nvim" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{
		"hrsh7th/nvim-cmp",
		requires = {
			{ "L3MON4D3/LuaSnip", tag = "v1.*" },
			{ "onsails/lspkind.nvim" },
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")

			local select_config = { behavior = cmp.SelectBehavior.Select }

			cmp.setup({
				formatting = {
					format = lspkind.cmp_format(),
				},
				preselect = cmp.PreselectMode.None,
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				window = {
					-- completion = cmp.config.window.bordered(),
					-- documentation = cmp.config.window.bordered(),
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
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
				}),
			})
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
