set number
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4

" Use system clipboard ?
"set clipboard+=unnamedplus
" Workaround for neovim wl-clipboard and netrw interaction hang 
" (see: https://github.com/neovim/neovim/issues/6695 and
" https://github.com/neovim/neovim/issues/9806) 
let g:clipboard = {
      \   'name': 'myClipboard',
      \   'copy': {
      \      '+': 'wl-copy',
      \      '*': 'wl-copy',
      \    },
      \   'paste': {
      \      '+': 'wl-paste -o',
      \      '*': 'wl-paste -o',
      \   },
      \   'cache_enabled': 0,
      \ }


" Plugins go here
call plug#begin('~/.vim/plugged')

Plug 'ctrlpvim/ctrlp.vim'

Plug 'ervandew/supertab'

Plug 'editorconfig/editorconfig-vim'

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
let g:deoplete#enable_at_startup = 1
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

Plug 'Chiel92/vim-autoformat'

Plug 'mrk21/yaml-vim'

Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

Plug 'sheerun/vim-polyglot'


call plug#end()

