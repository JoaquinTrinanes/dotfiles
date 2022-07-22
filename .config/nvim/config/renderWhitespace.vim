highlight Conceal ctermbg=NONE ctermfg=gray
" syn match Conceal / / conceal cchar=·
if exists('space_match')
      call matchdelete(space_match)
endif

let space_match = matchadd('Conceal', '\v(^ *)@<= ', -1, -1, {'conceal': '·'})
" au BufEnter * :syn match Conceal '^ \+' conceal cchar=·
" highlight ExtraWhitespace ctermbg=red guibg=red
" match ExtraWhitespace /^ \+/

" hi TrailingWhitespace ctermbg=NONE guibg=NONE ctermfg=LightGray
" call matchadd("TrailingWhitespace", '\v\s+$')

set list
set listchars=""
set listchars=tab:→\ ,trail:·,precedes:←,extends:→,nbsp:·
set conceallevel=1

