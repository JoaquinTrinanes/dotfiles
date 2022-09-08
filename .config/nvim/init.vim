let $CONFIG_DIR=$CONFIG_DIR."/nvim"

set number
set relativenumber
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4

" improve performance on large files
set synmaxcol=2048

set ignorecase
set smartcase

set cmdheight=2

syntax on

source $CONFIG_DIR/installPlug.vim
source $CONFIG_DIR/plugins.vim

for rcfile in split(globpath("$CONFIG_DIR/config", "*.vim"), '\n')
      execute('source '.rcfile)
endfor


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


" colorscheme onedark
