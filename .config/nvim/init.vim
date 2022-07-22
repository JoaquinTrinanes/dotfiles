set number
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4

" improve performance on large files
set synmaxcol=2048

set ignorecase
set smartcase

syntax on

source ~/.config/nvim/installPlug.vim
source ~/.config/nvim/plugins.vim

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

set cmdheight=2

" colorscheme onedark
