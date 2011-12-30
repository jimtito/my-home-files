source ~/.vim/colors/leo.vim

" Remove some annoying highlights
hi VertSplit ctermfg=17 ctermbg=17
hi Comment ctermfg=243
hi CursorLine ctermbg=235
hi String ctermbg=NONE
hi Special ctermbg=NONE
hi SpecialKey ctermbg=NONE
hi AlmostOver ctermbg=233
hi OverLength ctermbg=234
hi Underlined cterm=NONE

" Properly highlight matching paren
hi MatchParen cterm=NONE ctermbg=20 ctermfg=NONE

" Highlight tree directory slash correctly
hi link treeDirSlash Function
