" ---------------------------------------------------------------------------

" first the disabled features due to security concerns
set modelines=0         " no modelines [http://www.guninski.com/vim1.html]
"let g:secure_modelines_verbose=1 " securemodelines vimscript

" ---------------------------------------------------------------------------

" configure other scripts


" ---------------------------------------------------------------------------

" operational settings
set nocompatible                " vim defaults, not vi!
syntax on                       " syntax on
set hidden                      " allow editing multiple unsaved buffers
set more                        " the 'more' prompt
filetype on                     " automatic file type detection
set autoread                    " watch for file changes by other programs
set visualbell                  " visual beep
"set backup                      " produce *~ backup files"
"set backupext=~                 " add ~ to the end of backup files
":set patchmode=~                " only produce *~ if not there
set noautowrite                 " don't automatically write on :next, etc
"let maplocalleader=','          " all my macros start with ,
set wildmenu                    " : menu has tab completion, etc
set scrolloff=5                 " keep at least 5 lines above/below cursor
set sidescrolloff=5             " keep at least 5 columns left/right of cursor

" ---------------------------------------------------------------------------

" meta
map ce :edit ~/.vimrc          " quickly edit this file
map cs :source ~/.vimrc        " quickly source this file

" ---------------------------------------------------------------------------
" window spaceing
set cmdheight=2                 " make command line two lines high
set ruler                       " show the line number on bar
set lazyredraw                  " don't redraw when running macros
set number                      " show line number on each line
set winheight=999               " maximize split windows
set winminheight=0              " completely hide other windws

"map w+ 100+  " grow by 100
"map w- 100-  " shrink by 100

" ---------------------------------------------------------------------------
" mouse settings
set mouse=a                     " mouse support in all modes
set mousehide                   " hide the mouse when typing text

" ,p and shift-insert will paste the X buffer, even on the command line
nmap p i
"imap  
"cmap  

" this makes the mouse paste a block of text without formatting it 
" (good for code)
map  "*p

" ---------------------------------------------------------------------------
" global editing settings
set autoindent smartindent      " turn on auto/smart indenting
set expandtab                   " use spaces, not tabs
set smarttab                    " make  and  smarter
set tabstop=4                   " tabstops of 4
set shiftwidth=4                " indents of 4
set backspace=eol,start,indent  " allow backspacing over indent, eol, & start
set undolevels=1000             " number of forgivable mistakes
set updatecount=100             " write swap file to disk every 100 chars
set complete=.,w,b,u,U,t,i,d    " do lots of scanning on tab completion
set viminfo=%,'20,/20,h,\"500,:100,n~/.viminfo

" ---------------------------------------------------------------------------
" searching...
set hlsearch                   " enable search highlight globally
set incsearch                  " show matches as soon as possible
set showmatch                  " show matching brackets when typing
" disable last one highlight
nmap nh :nohlsearch

set diffopt=filler,iwhite       " ignore all whitespace and sync

" ---------------------------------------------------------------------------
" spelling...
if v:version >= 700
  let b:lastspelllang='en'
  function! ToggleSpell()
    if &spell == 1
      let b:lastspelllang=&spelllang
      setlocal spell!
    elseif b:lastspelllang
      setlocal spell spelllang=b:lastspelllang
    else
      setlocal spell spelllang=en
    endif
  endfunction

  nmap ss :call ToggleSpell()

  setlocal spell spelllang=en
endif

" ---------------------------------------------------------------------------
" some useful mappings

" disable yankring
let loaded_yankring = 22

" Y yanks from cursor to $
map Y y$
" toggle list mode
nmap tl :set list!
" toggle paste mode
nmap pp :set paste!
" change directory to that of current file
nmap cd :cd%:p:h
" change local directory to that of current file
nmap lcd :lcd%:p:h
" correct type-o's on exit
nmap q: :q

" word swapping
nmap  gw "_yiw:s/\(\%#\w\+\)\(\W\+\)\(\w\+\)/\3\2\1/
" char swapping
nmap  gc xph

" save and build
nmap m  :w:make

" ---------------------------------------------------------------------------
"  buffer management, note 'set hidden' above

" Move to next buffer
map bn :bn
" Move to previous buffer
map bp :bp
" List open buffers
map bb :ls

" ---------------------------------------------------------------------------

" status line 
set laststatus=2
if has('statusline')
        " Status line detail: (from Rafael Garcia-Suarez)
        " %f		file path
        " %y		file type between braces (if defined)
        " %([%R%M]%)	read-only, modified and modifiable flags between braces
        " %{'!'[&ff=='default_file_format']}
        "			shows a '!' if the file format is not the platform
        "			default
        " %{'$'[!&list]}	shows a '*' if in list mode
        " %{'~'[&pm=='']}	shows a '~' if in patchmode
        " (%{synIDattr(synID(line('.'),col('.'),0),'name')})
        "			only for debug : display the current syntax item name
        " %=		right-align following items
        " #%n		buffer number
        " %l/%L,%c%V	line number, total number of lines, and column number
        function! SetStatusLineStyle()
                if &stl == '' || &stl =~ 'synID'
                        let &stl="%f %y%([%R%M]%)%{'!'[&ff=='".&ff."']}%{'$'[!&list]}%{'~'[&pm=='']}%=#%n %l/%L,%c%V "
                else
                        let &stl="%f %y%([%R%M]%)%{'!'[&ff=='".&ff."']}%{'$'[!&list]} (%{synIDattr(synID(line('.'),col('.'),0),'name')})%=#%n %l/%L,%c%V "
                endif
        endfunc

        call SetStatusLineStyle()
        if has('title')
                set titlestring=%t%(\ [%R%M]%)
        endif

        highlight StatusLine    ctermfg=White ctermbg=DarkBlue cterm=bold
        highlight StatusLineNC  ctermfg=White ctermbg=DarkBlue cterm=NONE
endif

" ---------------------------------------------------------------------------



set t_Co=256
"set t_AB=^[[48;5;%dm
"set t_AF=^[[38;5;%dm



" ---------------------------------------------------------------------------

" tabs
map tc :tabnew %    " create a new tab       
map td :tabclose    " close a tab
map tn :tabnext     " next tab
map tp :tabprev     " previous tab
map tm :tabmove         " move a tab to a new location


"TabMessage: Put output of ex commands in a new tab.
function! TabMessage(cmd)
        redir => message
        silent execute a:cmd
        redir END
        tabnew
        silent put=message
        set nomodified
endfunction
command! -nargs=+ -complete=command TabMessage call TabMessage()

" ---------------------------------------------------------------------------
"import other files...


let $kernel_version=system('uname -r | tr -d "\n"')
set tags=./tags,tags,../tags,../../tags,../../../tags,../../../../tags,/lib/modules/$kernel_version/build/tags,/usr/include/tags

helptags ~/.vim/doc

set dictionary=/usr/share/vim/vim73/doc            " used with CTRL-X CTRL-K

" ---------------------------------------------------------------------------

"configure other scripts

" enable autoinstall of scripts w/o markup
" see :h :GLVS
let g:GetLatestVimScripts_allowautoinstall=1

if has("autocmd")
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif

" ------------------------------------------------------------------

call togglebg#map("<F5>")
colorscheme lucifer

" ------------------------------------------------------------------
