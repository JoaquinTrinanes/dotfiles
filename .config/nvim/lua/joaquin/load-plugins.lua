local C = require("joaquin.constants")

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
	"kyazdani42/nvim-web-devicons",
	{
		"ms-jpq/coq_nvim",
		as = "coq",
		branch = "coq",
		run = ":COQdeps",
		requires = {
			{ "ms-jpq/coq.artifacts", branch = "artifacts" },
			{
				"ms-jpq/coq.thirdparty",
				branch = "3p",
				config = function()
					require("coq_3p")({
						{ src = "nvimlua", conf_only = true },
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
				["keymap.recommended"] = true,
				["keymap.jump_to_mark"] = "",
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
				ensure_installed = { "sumneko_lua" },
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

			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.beautysh,
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.diagnostics.eslint,
					null_ls.builtins.completion.spell,
					null_ls.builtins.completion.tags,
					null_ls.builtins.formatting.prettierd,
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
