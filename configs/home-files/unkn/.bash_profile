#!/bin/bash
source /etc/profile
source /etc/bash_completion.d/git
# shows a fortune upon login
#fortune
# sets the path
PATH=/usr/share/perl5/vendor_perl/auto/share/dist/Cope:$PATH:$HOME/bin:/usr/local/bin:$HOME/.local/share/uzbl/scripts:/opt/nanoblogger:/opt/java/bin
export PATH

# dobbs rulez!
#echo " "
#ddate +'Today is %{%A, the %e of %B%}, in the YOLD %Y. %. %N%nCelebrate %H'

# Sets the Mail env
MAIL=/var/spool/mail/dunz0r && export MAIL

# set umask
umask=0007
set show-all-if-ambiguos on

source ~/.aliasrc
# source completion for git
#source $HOME/.git-completion.sh
#set TERM rxvt-256color; export TERM
# Set some variables
PROMPT_COMMAND=pprom2
export LESS="-P ?f%f(?b%bb/?B%B Byte)Line %lb of %L %pb\% ?eEOF"
EDITOR=/usr/bin/vim
#TERMCAP=`cat $HOME/.termcap`; export TERMCAP
#TERMPATH=/etc/termcap; export TERMPATH
MPD_PORT=6600
MPD_HOST=localhost
PAGER=`which less`
GREP_OPTIONS='--colour=auto'
# Set the options for the historyfile
shopt -s histappend
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=10000
# Colours in ma term
export LESS_TERMCAP_mb=$(printf "\e[1;31m")
export LESS_TERMCAP_md=$(printf "\e[1;33m")
export LESS_TERMCAP_me=$(printf "\e[1;34m")
export LESS_TERMCAP_se=$(printf "\e[0m")
export LESS_TERMCAP_so=$(printf "\e[1;47;30m")
export LESS_TERMCAP_ue=$(printf "\e[0m")
export LESS_TERMCAP_us=$(printf "\e[0;36m")
# make ls nicer
LS_OPTIONS='--color=auto'
LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;*.htm=00;31:*.html=00;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.qt=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.pdf=00;32:*.ps=00;32:*.txt=00;32:*.patch=00;32:*.diff=00;32:*.log=00;32:*.tex=00;32:*.doc=00;32:*.mp3=01;35:*.mpc=00;36:*.ogg=00;36:*.wav=00;36:*.mid=00;36:*.midi=00;36:*.au=00;36:*.flac=00;36:*.aac=00;36:*.torrent=00;31:*.rar=01;31:*.smc=00;36:*.xm=00;36:*.mod=00;36'
# fix locale-shit
LANG=en_gb.utf8
LC_ALL=en_GB
LOCALE=sv_SE.utf8
export HISTSIZE HISTFILESIZE LC_ALL LANG LOCALE HISTCONTROL LS_COLORS GREP_OPTIONS PAGER LESS MPD_HOST MPD_PORT PROMTP_COMMAND EDITOR VISUAL LS_OPTIONS GREP_COLOR http_proxy HTTP_PROXY

# Some nice aliases
alias rar=unrar
alias playing='mpc playlist | egrep -A 4 -B 4 ">[0-9]{1,5}.*"'
alias mpg='mpc --format %number[[%artist% - ]%title%]|[%file%] playlist | egrep -i'
alias mpa='mpc add'
alias ls='ls $LS_OPTIONS'
alias mpi='mpc --format "%album%, %artist% - %title%"'
alias lock='vlock -n'
alias aurbuild='sudo -E aurbuild'
alias webshare='python -c "import SimpleHTTPServer;SimpleHTTPServer.test()"'
alias funfact='elinks -dump randomfunfacts.com | egrep "\|.*\||\+\-"'
alias sshot='scrot -cd 5 screen-%y.%m.%d.%H.%m.png -e "mv \$f ~/gfx/pics/screenshots/ ; echo \" \$n: \$s\n \$wx\$h\n $s\""'
alias scrotum='scrot -cd 5 %bscrot.png'
if which git &> /dev/null ; then
	alias gc='git commit -a' 
	alias gb='git branch' 
	alias go='git checkout' 
	alias gp='git push'
	alias gu='git pull' # git update...-ish. 
	alias gs='git status' 
	alias gl='git log' 
	alias ga='git add' 
	alias gC='gc && gp'
fi


#alias jewtube='mplayer -fs $(echo "http://youtube.com/get_video.php?$(curl -s $youtube_url | sed -n "/watch_fullscreen/s;.*\(video_id.\+\)&title.*;\1;p")")'

#----------------------------------------
# Functions

# This is the main function for the prompt
function pprom2 {
# Capture the exit status
ESTATUS=$PIPESTATUS

local        BLUE="\[\033[0;34m\]"
local  LIGHT_GREY="\[\033[0;37m\]"
local LIGHT_GREEN="\[\033[1;32m\]"
local  LIGHT_BLUE="\[\033[1;34m\]"
local  LIGHT_CYAN="\[\033[1;36m\]"
local        CYAN="\[\033[0;36m\]"
local      YELLOW="\[\033[0;33m\]"
local LIGHT_YELLOW="\[\033[1;33m\]"
local       WHITE="\[\033[1;37m\]"
local	     GREY="\[\033[1;30m\]"
local         RED="\[\033[0;31m\]"
local  BRIGHT_RED="\[\033[1;31m\]"
local   NO_COLOUR="\[\033[0m\]"
local       GREEN="\[\033[0;32m\]"

if [ $UID != 0 ]; then
	WARNCOL=$GREEN
else
	WARNCOL=$RED
fi

# sets the titlebar if we are in an xterm
case $TERM in
   xterm*|rxvt*)
	#TITLEBAR="\[\033]0;::<span color='#d2bb4b'>$0</span>::\h:$PWD\007\]"
	TITLEBAR="\[\033]0;::$0::\h:$PWD\007\]"
#trap 'printf "\e]2;%s\a" "$(echo "::<span color=\"#e7db52\">$0</span>::$HOSTNAME:$PWD:$BASH_COMMAND")" > /dev/tty' DEBUG
	trap 'printf "\e]2;%s\a" "$(echo "::$0::$HOSTNAME:$PWD:$BASH_COMMAND")" > /dev/tty' DEBUG
	LINE=$(asciiecho q)
	ULINE=$(asciiecho lq)
	LLINE=$(asciiecho mq)
	ARROW=$(asciiecho z)
        ;;
    *)
        TITLEBAR=""
        LINE="-"
        LLINE="<"
        ULINE=">"
	ARROW=">"
        ;;
esac

# change colour of hostname depending on host
case $HOSTNAME in
	kremlonzwei)
	local HOSTCOLOUR=$WHITE
	;;
	gertrud)
	local HOSTCOLOUR=$BRIGHT_RED
	;;
	ninjaloot.se)
	local HOSTCOLOUR=$GREEN
	;;
	*)
	local HOSTCOLOUR=$CYAN
	;;
esac
# sets the color to red if exitstatuts is anything but 0
case $ESTATUS in
	0)
local	ECOLOR="\[\033[1;32m\]"
	;;
	*)
	ECOLOR="\[\033[1;31m\]"
	;;
esac
# the prompt starts here
#PS1="$TITLEBAR$GREY<$WHITE\j$GREY>$WHITE-$GREY<$WHITE\w$GREY>-<$HOSTCOLOUR$(hostname)$GREY>\n\
#$WHITE[$ECOLOR$ESTATUS$NO_COLOUR$WHITE]$GREY-$WHITE[$CYAN$(__git_ps1 " %s")$WHITE]$GREY$WARNCOL\$$NO_COLOUR:>$NO_COLOUR "
#PS2="-]$GREEN#$WHITE>$NO_COLOUR "
#PS4='+ '
PS1="$TITLEBAR\
$GREY$ULINE(:$ECOLOR$ESTATUS\
$GREY)$GREY$LINE(\
$WHITE\w\
$GREY)$LINE($YELLOW\t$GREY)$LINE$(__git_ps1 " %s"$LINE)($HOSTCOLOUR\h$GREY)$LINE\n\
$LLINE($WHITE\j\
$GREY)$LINE$LIGHT_GREY\$$NO_COLOUR "

PS2="$LIGHT_YELLOW$LINE$YELLOW$LINE$GREY$LINE$ARROW$NO_COLOUR "
}



# checks the current tty
function ttycheck
{
	temp=$(tty) ; echo ${temp:5}
}

function asciiecho
{
echo -e "\033(0$1\033(B"
}

function mpsa()
{
	mpc search $1 "$2" | shuf -n $3 | mpc add
}

# That's the end of functions
#---------------------------------------------------------------
function wiki {
dig +short txt $1.wp.dg.cx
}
BROWSER=elinks
export BROWSER
alias dmget='wget --load-cookies=/home/dunz0r/.local/share/uzbl/cookies.txt --user-agent=Firefox'
function iptget
{
wget --load-cookies=/home/dunz0r/.local/share/uzbl/cookies.txt --content-disposition --user-agent=Firefox "$1?torrent_pass=926acf49474367cd4619a28f1abe23ef"
}
