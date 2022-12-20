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
	"kyazdani42/nvim-web-devicons",
	{
		"ms-jpq/coq_nvim",
		as = "coq",
		branch = "coq",
		run = function()
			require("coq").deps()
		end,
		requires = {
			{ "ms-jpq/coq.artifacts", branch = "artifacts" },
			{
				"ms-jpq/coq.thirdparty",
				branch = "3p",
				config = function()
					require("coq_3p")({
						{ src = "nvimlua", conf_only = true, short_name = "nLUA" },
						{
							src = "repl",
							sh = "zsh",
							shell = { p = "perl", n = "node" },
							max_lines = 99,
							deadline = 500,
							unsafe = { "rm", "poweroff", "mv" },
						},
					})
				end,
			},
		},
		setup = function()
			vim.g.coq_settings = {
				auto_start = "shut-up",
				clients = {
					lsp = {
						-- Show LSP results first
						always_on_top = {},
						resolve_timeout = 10,
					},
				},
				keymap = {
					recommended = true,
					jump_to_mark = "",
				},
				display = {
					pum = { fast_close = false },
				},
			}
		end,
	},
	{
		"williamboman/mason.nvim",
		as = "mason",
		requires = {
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
		},
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
			require("mason-lspconfig").setup_handlers({
				function(server_name) -- default handler (optional)
					require("lspconfig")[server_name].setup({})
				end,
				["sumneko_lua"] = function()
					require("lspconfig").sumneko_lua.setup({
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

			null_ls.setup({
				sources = {
					formatting.prettierd,

					-- git
					code_actions.gitsigns.with({
						config = {
							filter_actions = function(title)
								return title:lower():match("blame") == nil -- filter out blame actions
							end,
						},
					}),

					-- shell
					formatting.beautysh,
					hover.printenv,

					-- lua
					formatting.stylua,

					-- js
					diagnostics.tsc,
					code_actions.eslint_d,
					diagnostics.eslint_d.with({
						filter = function(diagnostic)
							return diagnostic.code ~= "prettier/prettier"
						end,
						extra_args = {
							"--report-unused-disable-directives",
						},
					}),
					formatting.eslint_d,

					-- python
					formatting.black,
				},
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
	"folke/lsp-colors.nvim",
	"gpanders/editorconfig.nvim",
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
	"knubie/vim-kitty-navigator",
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
			local telescope = require("telescope")
			telescope.setup({})
			telescope.load_extension("fzf")
		end,
	},
	{ "tpope/vim-commentary" },
	"shaunsingh/nord.nvim",
	"tpope/vim-eunuch",
	"tpope/vim-surround",
}

return require("packer").startup({
	function(use)
		use("wbthomason/packer.nvim")
		for _, plugin in ipairs(plugins) do
			use(plugin)
		end
		-- Automatically set up your configuration after cloning packer.nvim
		-- Put this at the end after all plugins
		if packer_bootstrap then
			require("packer").sync()
		end
	end,
	config = {},
})

-- Missing config
-- let g:LanguageClient_serverCommands = {
--     \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
--     \ 'javascript': ['/usr/local/bin/javascript-typescript-stdio'],
--     \ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
--     \ 'python': ['~/.local/bin/pyls'],
--     \ 'ruby': ['~/.rbenv/shims/solargraph', 'stdio'],
--     \ 'c': ['clangd'],
--     \ 'cpp': ['clangd'],
--     \ 'cuda': ['clangd'],
--     \ }
-- let g:LanguageClient_diagnosticsMaxSeverity = "Warning"
-- set completeopt-=preview
-- " autocmd InsertLeave * silent! pclose!

-- let g:echodoc#enable_at_startup = 1
-- let g:echodoc#type = "floating"
