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

local packer_bootstrap = ensure_packer()

local plugins = {
	{
		'ms-jpq/coq_nvim', run = ":COQdeps",
		requires = {
			{ 'ms-jpq/coq.artifacts', branch = 'artifacts' }
		},
		config = function()
			vim.g.coq_settings = { ['auto_start'] = 'shut-up' }
		end
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
				ensure_installed = { "sumneko_lua" },
			})
			require("mason-lspconfig").setup_handlers({
				-- The first entry (without a key) will be the default handler
				-- and will be called for each installed server that doesn't have
				-- a dedicated handler.
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
										[vim.fn.expand("$VIM_RUNTIME/lua")] = true,
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
			null_ls.setup({
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.diagnostics.eslint,
				null_ls.builtins.completion.spell,
				null_ls.builtins.completion.tags,
				null_ls.builtins.completion.luasnip,
				null_ls.builtins.formatting.prettierd,
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
		requires = "kyazdani42/nvim-web-devicons",
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
	{
		"knubie/vim-kitty-navigator",
		cond = function()
			return os.getenv("TERM") == "xterm-kitty"
		end,
		opt = true,
		run = "cp ./*.py ~/.config/kitty/vim-navigation",
	},
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		requires = {
			{ "nvim-lua/plenary.nvim" },
			{
				"nvim-treesitter/nvim-treesitter",
				run = function()
					local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
					ts_update()
				end,
			},
			{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
		},
		run = function()
			local hasFd = os.execute("command -v fd &> /dev/null")
			local hasRipgrep = os.execute("command -v rg &> /dev/null")
			if hasFd == 0 or hasRipgrep == 0 then
				return
			end
			error("fd or ripGrep are not installed")
			require("telescope").setup()
			require("telescope").load_extension("fzf")
		end,
	},
	{
		"scrooloose/nerdcommenter",
		config = function()
			vim.g.NERDCreateDefaultMappings = true
			vim.g.NERDSpaceDelims = 2
			vim.g.NERDCompactSexyComs = 1
		end,
	},
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
