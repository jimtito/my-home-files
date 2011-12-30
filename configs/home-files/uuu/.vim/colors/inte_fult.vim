" Vim color file
" Maintainer:   Your name <youremail@something.com>
" Last Change:  
" URL:      

" cool help screens
" :he group-name
" :he highlight-groups
" :he cterm-colors

" your pick:
set background=dark
hi clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name="inte_fult"


" A good way to see what your colorscheme does is to follow this procedure:
" :w 
" :so % 
"
" Then to see what the current setting is use the highlight command.  
" For example,
"   :hi Cursor
" gives

" Uncomment and complete the commands you want to change from the default.
hi Normal ctermfg=White
hi Cursor     ctermfg=cyan
hi CursorIM   ctermfg=darkCyan
hi Directory cterm=bold ctermfg=LightBlue
"hi DiffAdd     
"hi DiffChange  
"hi DiffDelete  
"hi DiffText    
hi Error cterm=bold ctermbg=white
hi ErrorMsg cterm=bold ctermbg=black
hi VertSplit ctermfg=Grey ctermbg=Black
hi Folded  ctermfg=Red ctermbg=Black
hi FoldColumn cterm=italic
hi IncSearch cterm=bold ctermfg=cyan  ctermbg=grey
hi LineNr cterm=italic ctermfg=lightblue
hi ModeMsg cterm=bold ctermfg=red
"hi MoreMsg     
"hi NonText     
"hi Question    
hi Search ctermfg=Black ctermbg=yellow
hi SpecialKey cterm=bold ctermfg=yellow 
hi StatusLine cterm=bold ctermfg=grey
hi StatusLineNC ctermfg=grey
hi Title ctermfg=White
hi Visual ctermfg=green cterm=bold ctermbg=black
"hi VisualNOS   
"hi WarningMsg cterm=bold ctermfg=grey ctermbg=black
"hi WildMenu    
"hi Menu        
"hi Scrollbar   
"hi Tooltip     

" syntax highlighting groups
hi Comment ctermfg=Grey
hi Constant ctermfg=cyan
hi Identifier ctermfg=Brown
hi Statement cterm=bold ctermfg=cyan
hi PreProc ctermfg=cyan
hi Type cterm=bold ctermfg=Darkgrey
hi Special cterm=bold ctermfg=Red
"hi Underlined  
"hi Ignore      
hi Error ctermfg=red
"hi Todo        

