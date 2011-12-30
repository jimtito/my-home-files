" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start
" do want title
set title

colorscheme inte_fult
" use all the wonderful 256 colors that urxvt supply
"set t_Co=256

set fdm=marker
set incsearch		" do incremental searching
set nobackup
"set backupdir=./.backup,.,/tmp
"set directory=.,./.backup,/tmp
set fileformat=unix
set history=50		" keep 50 lines of command line history
" Display
set ruler		" show the cursor position all the time
set number		" I like line numbers
set numberwidth=3	" I usually only edit small files so therefore 3 digits should be enough
set nolazyredraw		" redraw!
set showcmd		" display incomplete commands
set smartcase		" searching
set cmdheight=1
set scrolloff=2		" I like to know what's next
set wildmenu
set wildmode=list:longest " wildmode works great this way
set fillchars=stl:-,stlnc:-,vert:\|,fold:-,diff:-
set smarttab
set list
set listchars=trail:-,tab:\>\ 
set autoindent		" indentation for the win!
set smartindent   
set softtabstop=4
set shiftwidth=4
set tabstop=4
set copyindent
set noexpandtab
set completeopt=menu,longest,preview
filetype plugin indent on
syntax on		" syntax
set hlsearch		" hilight searches
set showmode

" mappings
" rot13 haxorize
map <F12> ggVGg?
" open tha nurdtread
map <F11> :NERDTreeToggle<Return>
" input current time and date
map <F5> :r !date<Return><Esc>$<Esc>a **<Esc>i
" Use hjkl you tit!
map <Up> <NOP>
map <Down> <NOP>
map <Left> <NOP>
map <Right> <NOP>


" grep should always generate a file-name
set grepprg=grep\ -nH\ $*

" make sure .tex-files is opened as latex-files
let g:tex_flavor='latex'

"dictionary thingies
set iskeyword+=:
set dictionary-=/usr/share/dict/words dictionary+=/usr/share/dict/words

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END
" Open MS word doc with antiword
autocmd BufReadPre *.doc set ro
autocmd BufReadPre *.doc set hlsearch!
autocmd BufReadPost *.doc %!antiword "%"
