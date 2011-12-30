"
" Lucas de Vries' .vimrc
" Nick: GGLucas
" Mail: lucas@glacicle.org
" Website: lucas.glacicle.org
"

" {{{ Key mappings
"" {{{ Convenience shortcuts
""" {{{ Mapleader
let mapleader=","
""" }}}
""" {{{ File actions
" Save file
nmap ƒ :up<CR>

" Close everything
nmap ZN :wqa<CR>

" Close the tab
nmap ZV :tabclose<CR>
""" }}}
""" {{{ Window navigation
nmap <Left> <C-w>h
nmap <Down> <C-w>j
nmap <Up> <C-w>k
nmap <Right> <C-w>l
""" }}}
""" {{{ Buffer navigation
nmap <silent> ∩ :A<CR>
nmap <silent> ∪ :e .<CR>
nmap <silent> <Leader>- <C-^>

nmap <silent> ♥ :bnext<CR>
nmap <silent> √ :bprev<CR>
""" }}}
""" {{{ Editing shortcuts
" Creating new lines without comment leader
nmap go o<Esc>S
nmap gO O<Esc>S

" Return to visual mode after indenting
xmap < <gv
xmap > >gv

" Consistency!
nnoremap Y y$

" Double dash for end of line, double underscore for beginning
noremap -- $
noremap __ ^

" Use ,, for regular , (since it's the leader)
nnoremap ,, ,

" Faster scrolling
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" Clear screen and remove highlighting
nnoremap <silent> <C-l> :nohl<CR>

" Swap ` and '
noremap ' `
noremap ` '

" Go back to start of edit after repeat
nmap . .'[

" Insert/remove braces around single line
nnoremap ysb mZkA {<Esc>jo}<Esc>`Z
nnoremap dsb mZkA<BS><BS><Esc>jjddk`Z

" Wordwise C-Y
inoremap <silent> <C-E> <C-C>:let @z = @"<CR>mz
\:exec 'normal!' (col('.')==1 && col('$')==1 ? 'k' : 'kl')<CR>
\:exec (col('.')==col('$')-1 ? 'let @" = @_' : 'normal! yiW')<CR>
\`zp:let @" = @z<CR>a
""" }}}
""" {{{ Spellcheck
nmap <Leader>ss :set nospell<CR>
nmap <Leader>se :set spell spelllang=en<CR>
nmap <Leader>sn :set spell spelllang=nl<CR>
""" }}}
""" {{{ Quickfix window
nmap <silent> <Leader>vp :call Pep8()<CR>
nnoremap <silent> ]t :cnext<CR>
nnoremap <silent> [t :cprev<CR>
""" }}}
""" {{{ Remove inconvenient binds
xmap K k
nmap Q <Nop>
""" }}}
"" }}}
"" {{{ Plugin bindings
""" {{{ Bisect
nmap ↓ <Plug>BisectDown
nmap ↑ <Plug>BisectUp
nmap ← <Plug>BisectLeft
nmap → <Plug>BisectRight
nmap Æ <Plug>StopBisect

xmap ↓ <Plug>VisualBisectDown
xmap ↑ <Plug>VisualBisectUp
xmap ← <Plug>VisualBisectLeft
xmap → <Plug>VisualBisectRight
xmap Æ <Plug>VisualStopBisect
""" }}}
""" {{{ Command-T
nmap <silent> <Leader>t :CommandT<CR>
nmap <silent> <Leader>T :CommandTFlush<CR>
""" }}}
""" {{{ Lusty Explorer
nmap <silent> <Leader>n :LustyBufferExplorer<CR>
nmap <silent> <Leader>G :LustyFilesystemExplorer<CR>
nmap <silent> <Leader>r :LustyFilesystemExplorerFromHere<CR>
""" }}}
""" {{{ Taglist
nmap <silent> <Leader>l :TlistOpen<CR>
nmap <silent> <Leader>L :TlistToggle<CR>
""" }}}
""" {{{ NERD Tree
nmap <silent> <Leader>h :call TreeOpenFocus()<CR>
nmap <silent> <Leader>H :NERDTreeToggle<CR>
""" }}}
""" {{{ BClose
nmap <silent> <Leader>d :Bclose<CR>
nmap <silent> <Leader>D :Bclose!<CR>
""" }}}
""" {{{ Operator-Replace
map <Leader>_ <Plug>(operator-replace)
""" }}}
""" {{{ LateX Suite
fun! RefreshTex()
    let dir = getcwd()
    cd %:p:h
    silent call Tex_CompileLatex()
    silent !pkill -USR1 xdvi
    exe "cd " . dir
    redraw!
endfun

nmap <Leader>z :call RefreshTex()<CR>
""" }}}
""" {{{ Git
nmap <Leader>ga :Git add<Space>
nmap <silent> <Leader>gr :!sh -c "git pull origin master; read -n1"<CR>:e<CR>
nmap <silent> <Leader>gw :!sh -c "git pull --rebase origin master; read -n1"<CR>:e<CR>
nmap <silent> <Leader>gR :!sh -c "git stash && git pull origin master && git stash pop; read -n1"<CR>:e<CR>
nmap <silent> <Leader>gp :Git push origin master<CR>
nmap <silent> <Leader>gl :Gitv<CR>:redraw!<CR>
nmap <silent> <Leader>gL :Gitv!<CR>:redraw!<CR>
vmap <silent> <Leader>gl :Gitv!<CR>:redraw!<CR>
nmap <silent> <Leader>gc :Gcommit -s -a<CR>:redraw!<CR>
nmap <silent> <Leader>gC :Gcommit -s<CR>:redraw!<CR>
nmap <silent> <Leader>gs :Gstatus<CR>:redraw!<CR>
nmap <silent> <Leader>gd :Git diff<CR>:redraw!<CR>
nmap <silent> <Leader>gb :Gblame<CR>:redraw!<CR>
""" }}}
"" }}}
"" {{{ Text objects
vnoremap iP :<C-U>silent! normal! }kV{jj<CR>
omap iP :normal ViP<CR>
"" }}}
" }}}
"" {{{ Configuration
"" {{{ Plugin configuration
""" {{{ Pathogen
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
""" }}}
""" {{{ Supertab
let g:SuperTabDefaultCompletionType = "<c-x><c-n>"
""" }}}
""" {{{ NERD Commenter
let NERDDefaultNesting = 1
""" }}}
""" {{{ NERD Tree
let NERDTreeIgnore = ['\~$', '\.pyc$', '\.swp$', '\.class$', '\.o$', '\.pyo$']
let NERDTreeSortOrder = ['\/$', '\.[ch]$', '\.py$', '*']
""" }}}
""" {{{ Taglist
let Tlist_Use_Right_Window = 1
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Show_One_File = 1
let Tlist_Enable_Fold_Column = 0
""" }}}
""" {{{ Python syntax
let python_highlight_all = 1
let python_highlight_space_errors = 0
""" }}}
""" {{{ Command-T
let g:CommandTMaxHeight = 10
let g:CommandTAlwaysShowDotFiles = 1
let g:CommandTScanDotDirectories = 1
let g:CommandTSelectPrevMap = ['<C-p>']
let g:CommandTSelectNextMap = ['<Tab>', '<C-n>']
""" }}}
""" {{{ snipMate
let g:snips_author = "Lucas de Vries"
let g:snips_mail = "lucas@glacicle.org"
let g:snippets_dir = "~/.vim/snippets"
""" {{{ delimitMate
let g:delimitMate_expand_space = 1
let g:delimitMate_expand_cr = 1
let g:delimitMate_balance_matchpairs = 1
""" }}}
""" {{{ ZenCoding
let g:user_zen_settings = {'indentation': '  ',}
let g:user_zen_leader_key = '<C-t>'
""" }}}
""" {{{ Don't load ruby if we don't have it
if !has('ruby')
    let g:command_t_loaded = 1
    let g:loaded_lustyexplorer = 1
endif
""" }}}
""" {{{ EasyMotion
let g:EasyMotion_leader_key = '-'
let g:EasyMotion_keys = 'aoeuhtnsAOEUHTNSbcdfgijklmpqrvwxyzBCDFGIJKLMPQRVWXYZ'

nmap -J -j
nmap -K -k
nmap -h -f
nmap -H -F
""" }}}
"" }}}
"" {{{ Vim settings
""" {{{ General
" Use UTF-8 encoding
set encoding=utf-8

" Allow hidden buffers with changes
set hidden

" Put swapfiles in central directory
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" Data to store in the viminfo file
set viminfo='100,f1,<50,:50,/50,h,!

" File patterns to ignore in completions
set wildignore=*.o,*.pyc,*.pyo,.git,.svn

" Allow more memory
set maxmempattern=5000

" Don't use filetype indent
filetype on
filetype plugin on
filetype indent on

""" }}}
""" {{{ Display
" Characters to use in list mode
set listchars=tab:│\ ,trail:·
set list

" Always display statusline
set laststatus=2

" Show chain while typing
set showcmd

" Show search match while typing
set incsearch

" Show line and column number
set number
set ruler

" Show matching brackets when typed
set showmatch

" Number of lines from the edge to scroll
set scrolloff=3

" Display shorter messages
set shortmess=aAtI

" Don't show so many completions
set pumheight=8

" Highlight matches on a search
set hls

" Don't fold less than 2 lines
set foldminlines=2

" By default, marker folding
set fdm=marker

" Only fold one level by default
set fdn=1

" Highlight syntax
syntax on
""" }}}
""" {{{ Editing
" Text width
let g:textwidth=0
set textwidth=0

" Use actual block mode for visual block
set virtualedit=block

" Global match by default
set gdefault

" Smart case insensitive search
set ignorecase
set smartcase
""" }}}
""" {{{ Formatting
" Enter spaces when tab is pressed:
set expandtab

" Use 4 spaces to represent a tab
set tabstop=4
set softtabstop=4

" Number of spaces to use for auto indent
set shiftwidth=4

" Copy indent from current line when starting a new line
set autoindent

" Don't go mad reindenting
set cinkeys="0{,0},0)"

" Allow backspacing over more items
set backspace=indent,eol,start

" Options for formatting blocks (gq)
set formatoptions=tcn12

" Don't display a user completion scratch window
set completeopt=menu,menuone
""" }}}
""" {{{ Colors
" Color Schemes
if $TERM == 'linux'
    " Virtual Console
    colorscheme delek
else
    " Color terminal
    set t_Co=256
    colorscheme customleo
endif
""" }}}
"" }}}
" }}}
" {{{ Autocommands
"" {{{ Filetype detection
autocmd BufNewFile,BufRead *.{md,mkd,mark,markdown} set ft=markdown
autocmd BufNewFile,BufRead *.tex set ft=tex
autocmd BufNewFile,BufRead *.go set ft=go
autocmd BufNewFile,BufRead *.as set ft=cpp
autocmd BufNewFile,BufRead COMMIT_EDITMSG set ft=gitcommit
autocmd BufNewFile,BufRead *.ftl set ft=html
"" }}}
"" {{{ Filetype settings
" Files to indent with two spaces
autocmd FileType xhtml,html,xml,sass,tex,plaintex,yaml silent setlocal ts=2 sts=2 sw=2

" cindent
autocmd FileType c,cpp setlocal cindent

" Git: Don't jump to last position, no modeline
autocmd FileType gitcommit call setpos('.', [0, 1, 1, 0])
autocmd FileType git setlocal nomodeline

" Files to set default textwidth
autocmd FileType mail,tex setlocal textwidth=78
autocmd FileType mail,tex let b:textwidth=78
"" }}}
"" {{{ Filetype highlighting
" Python keywords
autocmd FileType python syn keyword Identifier self
autocmd FileType python syn keyword Type True False None

" Mail header highlighting
autocmd FileType mail hi link mailHeader Comment
autocmd FileType mail hi link mailSubject Function
"" }}}
"" {{{ Other
" Project-specifics
autocmd BufReadPost /mnt/starruler/* set noet inc= lcs=tab:\ \ ,trail:·
autocmd BufReadPost /mnt/starruler/*.txt set ft=starruler

" Rainbow Parenthesis
command Rainbow so ~/.vim/plugin/RainbowParenthsis.vim
autocmd BufReadPost * Rainbow

" Jump to last known cursor position
autocmd BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\   exe "normal! g`\"" |
\ endif
"" }}}
" }}}
" {{{ Functions
"" {{{ TreeOpenFocus(): Open the nerd tree or focus it.
function! TreeOpenFocus()
    let wnr = bufwinnr("NERD_tree_1")
    if wnr == -1
        :NERDTreeToggle
    else
        exec wnr."wincmd w"
    endif
endfunction
"" }}}
" vim:fdm=marker
