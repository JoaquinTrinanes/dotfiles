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
    { 'autozimu/LanguageClient-neovim', branch = 'next', run = 'bash install.sh' },
    'Chiel92/vim-autoformat',
    'chrisbra/Colorizer',
    'ctrlpvim/ctrlp.vim',
    'editorconfig/editorconfig-vim',
    'ervandew/supertab',
    'itchyny/lightline.vim',
    'jeffkreeftmeijer/vim-numbertoggle',
    'junegunn/fzf',
    'junegunn/goyo.vim',
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
    'preservim/nerdtree',
    'rafi/awesome-vim-colorschemes',
    'scrooloose/nerdcommenter',
    { 'sheerun/vim-polyglot', config = 'vim.g.did_load_filetypes = nil' },
    'Shougo/deoplete-clangx',
    'Shougo/echodoc.vim',
    'stephpy/vim-yaml',
    'tpope/vim-eunuch',
    'tpope/vim-surround',
    'Xuyuanp/nerdtree-git-plugin',
    { 'Shougo/deoplete.nvim', run = ':UpdateRemotePlugins' },
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
