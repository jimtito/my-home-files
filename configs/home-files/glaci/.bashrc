#
# Lucas de Vries' .bashrc
# Nick: GGLucas
# Mail: lucas@glacicle.org
# Website: lucas.glacicle.org
#

# {{{ Prompt
setprompt(){
    # Capture last return code
    local rts=$?

    # Get path with tilde for home
    if [[ "$PWD" == "$HOME" ]]; then
        local dir="~"
    elif [[ "${PWD:0:${#HOME}}" == "$HOME" ]]; then
        local dir="~${PWD:${#HOME}}"
    else
        local dir=$PWD
    fi

    # Truncate path if it's long
    if [[ ${#dir} -gt 19 ]]; then
        local offset=$((${#dir}-18))
        dir="+${dir:$offset:18}"
    fi

    # Path color indicates host
    case "$HOSTNAME" in
        "ayu") local dircol="\[\e[1;35m\]"; ;; # Desktop
        "hitagi") local dircol="\[\e[1;32m\]"; ;; # Laptop
        "izaya") local dircol="\[\e[1;31m\]"; ;; # Server
        "GGLucas-VM") local dircol="\[\e[1;36m\]"; ;; # Virtual Machine
        *) local dircol="\[\e[1;37m\]"; ;; # Other
    esac

    # Marker char indicates root or user
    [[ $UID -eq 0 ]] && local marker='#' || local marker='$'

    # Marker color indicates successful execution
    [[ $rts -eq 0 ]] && local colormarker="\[\e[1;37m\]$marker" \
                     || local colormarker="\[\e[1;31m\]$marker"

    # Set PS1
    PS1="${dircol}${dir} ${colormarker}\[\e[0;37m\] "

    # Append history to saved file
    history -a
}
PROMPT_COMMAND="setprompt &> /dev/null"
# }}}
# {{{ Bash settings
# Applications
export PAGER='vimpager'
export EDITOR='vim'
export BROWSER='fxs'

# History control
export HISTCONTROL="ignoreboth"
export HISTFILESIZE=5000000
export HISTIGNORE="cd:..*:no:na:clear:reset:j *:exit:hc:h:-"

# Check for current bash version
if [[ ${BASH_VERSINFO[0]} -ge 4 ]]; then
    shopt -s autocd cdspell
    shopt -s dirspell globstar
fi

# General options
shopt -s cmdhist nocaseglob
shopt -s histappend extglob

# Complete only directories on cd
complete -d cd

if [[ -x /bin/stty ]]; then
    # Don't echo ^C
    stty -ctlecho

    # Remove shortcuts for start and stop
    stty stop undef
    stty start undef
fi

# Load autojump
if [[ -f /etc/profile.d/autojump.bash ]]; then
    . /etc/profile.d/autojump.bash
fi

# Give ls more colors
if [[ -x /bin/dircolors ]]; then
    eval $(/bin/dircolors ~/.dircolors)
fi
# }}}
# {{{ Key bindings and macros
case "$-" in *i*)
    # Remove annoying fc map
    bind -m vi -r v

    # Walk through completions with ^N
    bind "\C-n: menu-complete"

    # Clear screen with ^L
    bind "\C-l: clear-screen"

    # Add pager pipe with ^T
    bind '"\C-t":" | $PAGER \C-m"'

    # Background & ignore with <C-b>
    bind '"\C-b":" &> /dev/null &\C-m"'

    # Special backwards search
    bind '\C-f: reverse-search-history'
    bind '"\C-r":" f\C-m"'

    # Quick directory jump
    bind '"\C-s":" fcd\C-m"'

    # Search
    bind '"\C-w":" | ack "'

    # Reset and clear
    bind '"\C-a":"reset ; clear \C-m"'
    bind '"\C-k":"cd ; clear \C-m"'
    bind '"\C-e":"clear \C-m"'
;; esac;
# }}}
# {{{ General shortcuts
# Ls
alias ls='ls --color=auto -Fh --group-directories-first'
alias ll='ls -lah'
alias no='ls'
alias na='ll'

# Movement
alias qmv='qmv -o "spaces,indicator2=│→│    "'

# Devtodo
alias t='todo'
alias td='todo --database ~/.todo.daily'
alias ts='todo --database ~/.todo.schedule'

# Editor
alias v='vim'
alias vv='sudo vim'

# Backward search
f() {
    fname=$(mktemp)
    fzsel ~/.bash_history $fname
    cmd=$(cat $fname)
    rm $fname

    if [[ -n "$cmd" ]]; then
        echo -e "\e[1;32m$cmd\e[0;37m"
        eval "$cmd"
    fi
}

# Quick folder jump
fcd() {
    fname=$(mktemp)
    fzsel ~/.folder_index $fname
    dir=$(cat $fname)
    rm $fname

    if [[ -n "$dir" ]]; then
        echo -e "\e[1;34m$dir\e[0;37m"
        cd "$dir"
    fi
}

# Refresh quick folder index
icd() {
    echo > ~/.folder_index
    find /data/{anime,series,music} -type d >> ~/.folder_index
}

# Cowsay
alias qsay='cowsay -f qb'

# Tmux
tm() { tmux -2 attach -t $1; }
tmn() { tmux -2 new -s $1 $1; }

# Misc
## mount encrypted filesystems
alias m='encMount'
## start xorg
x(){ builtin cd ~; exec xinit $@; }
## sync music to iriver
syncm() { sudo rsync -vhru --progress /data/music/Anime/ /mnt/sansa/MUSIC/Anime; }
## compile & view tex
re() { texi2pdf $1.tex && zathura $1.pdf; }
# }}}
# {{{ Git shortcuts
alias a='git add'
alias ai='git add -i'
alias aip='git add -i -p'
alias d='git diff'
alias p='git push origin master'
alias pu='git pull origin master'
alias pb='git pull --rebase origin master'
alias gpo='git push origin'
alias gpuo='git pull origin'
alias gp='git push'
alias gpu='git pull'
alias gsp='git stash; git svn rebase; git stash pop &> /dev/null; git status -uno'
alias gsu='git svn fetch'
alias gsc='git stash; git svn dcommit; git stash pop &> /dev/null;'
alias gs='git status -uno'
alias gst='git status'
alias gpm='git submodule foreach git pull origin master'

# Commit everything or specified path
c() {
    if [[ "$1" == "-i" ]]; then
        shift; git commit -s --interactive $@
    else
        if [[ -n "$@" ]]; then
            git commit -s $@
        else
            git commit -s -a
        fi;
    fi;
}
alias ci='c -i';

# Show diff for a particular commit
dn() {
    if [[ "$1" == "" ]]; then
        git diff HEAD~..HEAD
    else
        git diff $1~..$1
    fi
}

# Git show relevant status
sa() {
    git status | ack -B 999 --no-color "Untracked"
}
# }}}
# {{{ Directory navigation
# General
alias h='builtin cd'
hc() { builtin cd; clear; }
mcd() { mkdir -p "$1" && eval cd "$1"; }

# Directory up
..() { cd "../$@"; }
..2() { cd "../../$@"; }
..3() { cd "../../../$@"; }
..4() { cd "../../../../$@"; }
..5() { cd "../../../../../$@"; }

# Ls after CD
cd() { if [[ -n "$1" ]]; then builtin cd "$1" && ls;
                         else builtin cd && ls; fi; }
,cd() { [[ -n "$1" ]] && builtin cd "$1" || builtin cd; }
ca() { ,cd "$1"; ls -la; }
cn() { ,cd "$1"; ls -a; }

# Directory stack
di() { dirs -v; }
po() { if [[ -n "$1" ]]; then popd "$1" 1>/dev/null && ls;
                         else popd 1>/dev/null && ls; fi; }
ph() { pushd "$1" 1>/dev/null && ls; }

alias p+='ph +1'
alias p2='ph +2'
alias p3='ph +3'
alias p4='ph +4'
alias -- p-='ph -0'
alias -- p-1='ph -1'
alias -- p-2='ph -2'
alias -- p-3='ph -3'
alias -- p-4='ph -4'
alias -- -='cd -'
# }}}
# {{{ Fallback applications
# Fallback to grep if ack is not found
if [[ ! -x ~/bin/ack ]]; then
    alias ack="grep -i --color=always"
else
    alias ack="command ack --smart-case"
fi

# Unpack programs
if [[ -x '/usr/bin/aunpack' ]]; then
    alias un='aunpack'
else
    alias un='tar xvf'
fi
# }}}
# {{{ Watch list
w()   { ani watch: $@; }
lo()  { ani log: $@; }
li()  { ani list: $@; }
wh()  { ani hist; }
an()  { ani list: +w =anime; }
anh() { ani hist: =anime; }
tn()  { ani list: +w =tv; }
tnh() { ani hist: =tv; }

las() { find /data/series -mtime -7 -type d; }
laa() { find /data/anime -mtime -7 -type d; }
# }}}
# {{{ Feed update
fu()  { feed-update >> ~/.feeds.update; }
fo()  { cat ~/.feeds.update | while read url; do [[ -n "$url" ]] && $BROWSER $url; done; echo -n; :>~/.feeds.update; }
# }}}
# {{{ Daemons
rc.d() { [[ -d /etc/rc.d ]] && sudo /etc/rc.d/$@;
         [[ -d /etc/init.d ]] && sud /etc/init.d/$@; }
dr() { for d in $@; do rc.d $d restart; done; }
ds() { for d in $@; do rc.d $d start; done; }
dt() { for d in $@; do rc.d $d stop; done; }
# }}}
# {{{ Package management helper functions
# Root where packages are stored
PACKAGE_ROOT=/mnt/data-5/others/packages
alias i='makepkg -fi'

# Download package from abs
absd() {
    abs $1/$2
    cp -R /var/abs/$1/$2 $PACKAGE_ROOT/abs
    builtin cd $PACKAGE_ROOT/abs/$2
}

# Download package from aur
aurd() {
    if wget http://aur.archlinux.org/packages/$1/$1.tar.gz \
             -O $PACKAGE_ROOT/aur/$1.tar.gz;
    then
        builtin cd $PACKAGE_ROOT/aur
        tar xvf $1.tar.gz || return 1
        rm $1.tar.gz
        cd $1
    fi
}

# Make a git package, then show the log
gi() {
    gitdir=$1; shift
    from=$(git --git-dir=src/$gitdir/.git rev-parse HEAD)
    makepkg -fi $@
    git --git-dir=src/$gitdir/.git log --stat $from..HEAD
}

# Go to a package directory
ga() { cd $PACKAGE_ROOT/$1/$2; }
# }}}
# {{{ Misc functions
## Map function for bash.
# Courtesy downdiagonal on reddit.
# http://www.reddit.com/r/linux/comments/akt3j
map() {
    local command i rep
    if [ $# -lt 2 ] || [[ ! "$@" =~ :[[:space:]] ]];then
        echo "Invalid syntax." >&2; return 1
    fi
    until [[ $1 =~ : ]]; do
        command="$command $1"; shift
    done
    command="$command ${1%:}"; shift
    for i in "$@"; do
        if [[ $command =~ \{\} ]]; then
            rep="${command//\{\}/\"$i\"}"
            eval "${rep//\\/\\\\}"
        else
            eval "${command//\\/\\\\} \"${i//\\/\\\\}\""
        fi
    done
}

## wrapper for tvtime
tvtime() {
    sudo modprobe -a saa7134_alsa saa7134
    while [[ ! -e /dev/video0 ]]; do sleep 0.5; done;
    sudo /usr/bin/tvtime
    cp ~/.tvtime/tvtime.xml.orig ~/.tvtime/tvtime.xml
    sudo modprobe -r saa7134_alsa
}
# }}}

# vim: set fdm=marker :
