# Some bash (1 and 2) settings to avoid trouble on a failed program
# call.. bash .. *sigh*..
if test -n "$BASH" ; then
	set +o posix
	no_exit_on_failed_exec=1
	type shopt > /dev/null 2>&1 && shopt -s execfail
	set +e > /dev/null 2>&1
fi

# The preferred window manager
WINDOWMANAGER="/usr/bin/awesome"

# What to do if the window manager fails:
#failsafe="xterm -ls -T Failsave -geometry 80x24-0-0"
#trap "exec $failsafe" EXIT SIGHUP SIGINT SIGPIPE SIGTERM SIGIO

# Check for other window managers if the one specified above isn't there:
if test -n "$WINDOWMANAGER" ; then
        WINDOWMANAGER=`type -p $WINDOWMANAGER`
fi

# Add new fonts
xset +fp /home/lucifer/.fonts/
xset fp rehash

# Load Users X11 resource database
# ~/.Xdefaults
if test -f $HOME/.Xdefaults ; then
	xrdb $HOME/.Xdefaults
fi
# ~/.Xresources
if test -f $HOME/.Xresources ; then
	xrdb $HOME/.Xresources
fi

# ~/.Xmodmap
if test -f $HOME/.Xmodmap ; then
	xmodmap $HOME/.Xmodmap
fi

# Activate NumlockX
numlockx &

# MPD run in backgpound
#mpd ~/.mpd/mpd.conf
#pidof mpdscribble >& /dev/null

#if [ $? -ne 0 ]; then
#    mpdscribble &
#fi

# Start rxvt-unicode daemon
exec urxvtd -q -o -f >& /dev/null &

# Start wicd DisplayTray
exec wicd-gtk >& /dev/null &

# Pkg Update client
exec pkgupdate_gtk.py >& /dev/null &

# ntop Daemon
#exec ntop -d >& /dev/null &

# Start the window manager...
if test "$WINDOWMANAGER" = "/usr/bin/awesome" ; then
#        exec /usr/bin/awmtt start -N -D 1 -S 1366x768
        exec /usr/bin/awesome
else
        echo "No Good"
fi
