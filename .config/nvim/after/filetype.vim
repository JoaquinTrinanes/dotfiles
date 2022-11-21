if exists("did_load_filetypes_userafter")
  finish
endif
let did_load_filetypes_userafter = 1

augroup filetypedetect
  au!
  au BufRead,BufNewFile .*rc setfiletype sh
  au BufRead,BufNewFile .env,.env.* setfiletype sh
augroup END
