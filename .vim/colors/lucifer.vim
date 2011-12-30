" Ripped this off the lucius color scheme
" took away the norm bg color and reversed the LineNR bg/fg

hi clear
if exists("syntax_on")
    syntax reset
endif
let colors_name="lucius custom"

set background=dark

" set colorcolumn=21,37,53,68,86,100


hi Normal       guifg=#e0e0e0   guibg=#202020   ctermfg=253    ctermbg=NONE      gui=none      cterm=none
hi Comment      guifg=#707070   guibg=NONE      ctermfg=240    ctermbg=NONE      gui=none      cterm=none
hi Constant     guifg=#e0e090   guibg=NONE      ctermfg=187    ctermbg=NONE      gui=none      cterm=none
hi BConstant    guifg=#e0e090   guibg=NONE      ctermfg=187    ctermbg=NONE      gui=bold      cterm=bold
hi Identifier   guifg=#c0e0a0   guibg=NONE      ctermfg=150    ctermbg=NONE      gui=none      cterm=none
hi BIdentifier  guifg=#c0e0a0   guibg=NONE      ctermfg=150    ctermbg=NONE      gui=bold      cterm=bold
hi Statement    guifg=#80d0f0   guibg=NONE      ctermfg=74     ctermbg=NONE      gui=none      cterm=none
hi BStatement   guifg=#80d0f0   guibg=NONE      ctermfg=74     ctermbg=NONE      gui=bold      cterm=bold
hi PreProc      guifg=#a0e0d0   guibg=NONE      ctermfg=115    ctermbg=NONE      gui=none      cterm=none
hi BPreProc     guifg=#a0e0d0   guibg=NONE      ctermfg=115    ctermbg=NONE      gui=bold      cterm=bold
hi Type         guifg=#a0d0e0   guibg=NONE      ctermfg=116    ctermbg=NONE      gui=none      cterm=none
hi BType        guifg=#a0d0e0   guibg=NONE      ctermfg=116    ctermbg=NONE      gui=bold      cterm=bold
hi BSpecial     guifg=#c0a0d0   guibg=NONE      ctermfg=182    ctermbg=NONE      gui=bold      cterm=bold

" == Text Markup ==
hi Underlined   guifg=fg        guibg=NONE      ctermfg=fg     ctermbg=NONE      gui=underline cterm=underline
hi Error        guifg=#e07070   guibg=#503030   ctermfg=167    ctermbg=236       gui=none      cterm=none
hi Todo         guifg=#e0e090   guibg=#505000   ctermfg=186    ctermbg=NONE      gui=none      cterm=none
hi MatchParen   guifg=bg        guibg=#c0e070   ctermfg=234    ctermbg=192       gui=none      cterm=bold
hi NonText      guifg=#405060   guibg=NONE      ctermfg=24     ctermbg=NONE      gui=none      cterm=none
hi SpecialKey   guifg=#406050   guibg=NONE      ctermfg=23     ctermbg=NONE      gui=none      cterm=none
hi Title        guifg=#50b0d0   guibg=NONE      ctermfg=74     ctermbg=NONE      gui=bold      cterm=bold

" == Text Selection ==
hi Cursor       guifg=bg        guibg=fg        ctermfg=234    ctermbg=fg        gui=none      cterm=none
hi CursorIM     guifg=bg        guibg=fg        ctermfg=234    ctermbg=fg        gui=none      cterm=none
hi CursorColumn guifg=NONE      guibg=#484848   ctermfg=NONE   ctermbg=237       gui=none      cterm=none
hi CursorLine   guifg=NONE      guibg=#484848   ctermfg=NONE   ctermbg=237       gui=none      cterm=none
hi Visual       guifg=NONE      guibg=#205070   ctermfg=NONE   ctermbg=24        gui=none      cterm=none
hi VisualNOS    guifg=fg        guibg=NONE      ctermfg=fg     ctermbg=NONE      gui=underline cterm=underline
hi IncSearch    guifg=bg        guibg=#50d0d0   ctermfg=234    ctermbg=116       gui=none      cterm=none
hi Search       guifg=bg        guibg=#e0a020   ctermfg=234    ctermbg=214       gui=none      cterm=none

" == UI ==
hi Pmenu        guifg=#000000   guibg=#b0b0b0   ctermfg=234    ctermbg=252       gui=none      cterm=none
hi PmenuSel     guifg=#e0e0e0   guibg=#205070   ctermfg=fg     ctermbg=24        gui=none      cterm=none
hi PMenuSbar    guifg=bg        guibg=#b0b0b0   ctermfg=234    ctermbg=254       gui=none      cterm=none
hi PMenuThumb   guifg=NONE      guibg=#808080   ctermfg=fg     ctermbg=244       gui=none      cterm=none
hi StatusLine   guifg=bg        guibg=#b0b0b0   ctermfg=234    ctermbg=252       gui=bold      cterm=bold
hi StatusLineNC guifg=#404040   guibg=#b0b0b0   ctermfg=240    ctermbg=252       gui=none      cterm=none
hi TabLine      guifg=bg        guibg=#b0b0b0   ctermfg=234    ctermbg=252       gui=none      cterm=none
hi TabLineFill  guifg=#404040   guibg=#b0b0b0   ctermfg=240    ctermbg=252       gui=none      cterm=none
hi TabLineSel   guifg=#e0e0e0   guibg=#205070   ctermfg=fg     ctermbg=24        gui=bold      cterm=bold
hi VertSplit    guifg=#606060   guibg=#b0b0b0   ctermfg=245    ctermbg=252       gui=none      cterm=none
hi Folded       guifg=bg        guibg=#808080   ctermfg=234    ctermbg=246       gui=none      cterm=none
hi FoldColumn   guifg=bg        guibg=#808080   ctermfg=234    ctermbg=246       gui=none      cterm=none

" == Spelling ==
hi SpellBad     guisp=#ee0000                   ctermfg=fg     ctermbg=160       gui=undercurl cterm=undercurl
hi SpellCap     guisp=#eeee00                   ctermfg=234    ctermbg=226       gui=undercurl cterm=undercurl
hi SpellRare    guisp=#ffa500                   ctermfg=234    ctermbg=214       gui=undercurl cterm=undercurl
hi SpellLocal   guisp=#ffa500                   ctermfg=234    ctermbg=214       gui=undercurl cterm=undercurl

" == Diff ==
hi DiffAdd      guifg=fg        guibg=#405040   ctermfg=fg     ctermbg=22        gui=none      cterm=none
hi DiffChange   guifg=fg        guibg=#605040   ctermfg=fg     ctermbg=58        gui=none      cterm=none
hi DiffDelete   guifg=fg        guibg=#504040   ctermfg=fg     ctermbg=52        gui=none      cterm=none
hi DiffText     guifg=#e0b050   guibg=#605040   ctermfg=220    ctermbg=58        gui=bold      cterm=bold

" == Misc ==
hi Directory    guifg=#b0d0a0   guibg=NONE      ctermfg=151    ctermbg=NONE      gui=none      cterm=none
hi ErrorMsg     guifg=#ee0000   guibg=NONE      ctermfg=196    ctermbg=NONE      gui=none      cterm=none
hi SignColumn   guifg=#a0b0b0   guibg=#282828   ctermfg=145    ctermbg=233       gui=none      cterm=none
hi LineNr       guifg=bg        guibg=#808080   ctermfg=246    ctermbg=234       gui=none      cterm=none
hi MoreMsg      guifg=#60c0d0   guibg=NONE      ctermfg=117    ctermbg=NONE      gui=none      cterm=none
hi ModeMsg      guifg=fg        guibg=NONE      ctermfg=234    ctermbg=NONE      gui=none      cterm=none
hi Question     guifg=fg        guibg=NONE      ctermfg=fg     ctermbg=NONE      gui=none      cterm=none
hi WarningMsg   guifg=#e07060   guibg=NONE      ctermfg=173    ctermbg=NONE      gui=none      cterm=none
hi WildMenu     guifg=NONE      guibg=#205070   ctermfg=NONE   ctermbg=24        gui=none      cterm=none
hi ColorColumn  guifg=NONE      guibg=#484038   ctermfg=NONE   ctermbg=101       gui=none      cterm=none
hi Ignore       guifg=bg                        ctermfg=234

" == Vimwiki Colors ==
hi link VimwikiHeader1 BIdentifier
hi link VimwikiHeader2 BPreProc
hi link VimwikiHeader3 BStatement
hi link VimwikiHeader4 BSpecial
hi link VimwikiHeader5 BConstant
hi link VimwikiHeader6 BType

" == Tagbar Colors ==
hi link TagbarAccessPublic Constant
hi link TagbarAccessProtected Type
hi link TagbarAccessPrivate PreProc
