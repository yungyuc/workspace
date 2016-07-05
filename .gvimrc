set columns=85 lines=25
set guioptions=gmirte
set visualbell
set background=dark
colors koehler

" key bind for window height.
noremap <silent> <C-o> :set lines=999<CR>
noremap <silent> <C-p> :set lines=35<CR>
inoremap <silent> <C-o> <C-o>:set lines=999<CR>
inoremap <silent> <C-p> <C-p>:set lines=35<CR>

if filereadable(expand('~/self/dot_gvimrc'))
  so ~/self/dot_gvimrc
endif
