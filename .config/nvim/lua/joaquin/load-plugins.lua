local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
		vim.cmd [[packadd packer.nvim]]
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

local plugins = {
	'editorconfig/editorconfig-vim',
	{
		"folke/trouble.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("trouble").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end
	},
	'folke/lsp-colors.nvim',
	'gpanders/editorconfig.nvim',
	'jeffkreeftmeijer/vim-numbertoggle',
	{ 'jose-elias-alvarez/null-ls.nvim',
		run = function()
			local null_ls = require("null-ls")

			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.diagnostics.eslint,
					null_ls.builtins.completion.spell,
				},
			})
		end
	},
	{
		'lewis6991/gitsigns.nvim',
		config = function()
			require('gitsigns').setup({
				current_line_blame = true,
				yadm = {
					enable = true
				}
			})
		end
	},
	'mrk21/yaml-vim',
	{
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		requires = {
			{ 'nvim-lua/plenary.nvim' },
			{
				'nvim-treesitter/nvim-treesitter',
				run = function()
					local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
					ts_update()
				end,
			},
			{ 'nvim-telescope/telescope-fzf-native.nvim',
				run = 'make' }
		},
		run = function()
			local hasFd = os.execute('command -v fd &> /dev/null')
			local hasRipgrep = os.execute('command -v rg &> /dev/null')
			if hasFd == 0 or hasRipgrep == 0 then
				return
			end
			error('fd or ripGrep are not installed')
			require('telescope').setup()
			require('telescope').load_extension('fzf')
		end
	},
	'neovim/nvim-lspconfig',
	{ 'scrooloose/nerdcommenter', config = function()
		vim.g.NERDCreateDefaultMappings = true
		vim.g.NERDSpaceDelims = 2
		vim.g.NERDCompactSexyComs = 1
	end },
	{ 'sheerun/vim-polyglot', config = 'vim.g.did_load_filetypes = nil' },
	'Shougo/deoplete-clangx',
	'stephpy/vim-yaml',
	'tpope/vim-eunuch',
	'tpope/vim-surround',
	{ "williamboman/mason.nvim",
		after = { 'nvim-lspconfig' },
		requires = {
			'williamboman/mason-lspconfig.nvim',
		},
		config = function()
			require('mason').setup({ automatic_installation = true })
			require('mason-lspconfig').setup({
				automatic_installation = true
			})

			require("mason-lspconfig").setup_handlers {
				-- The first entry (without a key) will be the default handler
				-- and will be called for each installed server that doesn't have
				-- a dedicated handler.
				function(server_name) -- default handler (optional)
					require("lspconfig")[server_name].setup {}
				end,
			}
		end,
	}
}

return require('packer').startup({ function(use)
	use 'wbthomason/packer.nvim'
	for _, plugin in ipairs(plugins) do
		use(plugin)
	end
	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require('packer').sync()
	end
end, config = {} })

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
