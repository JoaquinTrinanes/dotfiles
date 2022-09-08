" Plugins go here
call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next','do': 'bash install.sh' }
Plug 'Chiel92/vim-autoformat'
Plug 'chrisbra/Colorizer'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'ervandew/supertab'
Plug 'itchyny/lightline.vim'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'junegunn/fzf'
Plug 'junegunn/goyo.vim'
Plug 'mrk21/yaml-vim'
Plug 'preservim/nerdtree'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'scrooloose/nerdcommenter'
Plug 'sheerun/vim-polyglot'
Plug 'Shougo/deoplete-clangx'
Plug 'Shougo/echodoc.vim'
Plug 'stephpy/vim-yaml'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
Plug 'Xuyuanp/nerdtree-git-plugin'


if has('nvim')
      Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
      let g:deoplete#enable_at_startup = 1
endif

call plug#end()

" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" trigger InsertLeave when using Ctrl-C
inoremap <C-c> <ESC>

" NERDcommenter config
filetype plugin on
let g:NERDCreateDefaultMappings = 1
let g:NERDCustomDelimiters = { 'c': { 'left': '//', } }
let g:NERDSpaceDelims = 2
let g:NERDCompactSexyComs = 1

let g:LanguageClient_serverCommands = {
                  \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
                  \ 'javascript': ['/usr/local/bin/javascript-typescript-stdio'],
                  \ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
                  \ 'python': ['~/.local/bin/pyls'],
                  \ 'ruby': ['~/.rbenv/shims/solargraph', 'stdio'],
                  \ 'c': ['clangd'],
                  \ 'cpp': ['clangd'],
                  \ 'cuda': ['clangd'],
                  \ }
let g:LanguageClient_diagnosticsMaxSeverity = "Warning"
set completeopt-=preview
" autocmd InsertLeave * silent! pclose!

let g:echodoc#enable_at_startup = 1
let g:echodoc#type = "floating"

