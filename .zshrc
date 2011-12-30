# If not running interactively, don't do anything
# [[ $- != *i* ]] && return

#case ${TERM} in
#  xterm*|rxvt*|Eterm|aterm|kterm|gnome*)
#    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
#                                                        
#    ;;
#  screen)
#    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
#    ;;
#esac

# Test and then source exported variables.
if [ -f ~/.zsh/config/zshexports ]; then
        source ~/.zsh/config/zshexports
else
        print "Note: ~/.zsh/config/zshexports is unavailable."
fi

# HOSTNAME = HELL
if [ ${HOSTNAME} = HELL ] && [ -e ~/.zsh/config/zshdevel ]; then
	source ~/.zsh/config/zshdevel
fi

# Test and then source prompt
#if [ -f ~/.zsh/config/zshprompt ]; then
#        source ~/.zsh/config/zshprompt
#else
#        print "Note: ~/.zsh/config/zshprompt is unavailable."
#fi

# Test and then source some options
if [ -f ~/.zsh/config/zshoptions ]; then
        source ~/.zsh/config/zshoptions
else
        print "Note: ~/.zsh/config/zshoptions is unavailable."
fi

# Test and then source alias definitions.
if [ -f ~/.zsh/config/zshaliases ]; then
        source ~/.zsh/config/zshaliases
else
        print "Note: ~/.zsh/config/zshaliases is unavailable."
fi

# Test and then source the functions.
if [ -f ~/.zsh/config/zshfunctions ]; then
        source ~/.zsh/config/zshfunctions
else
        print "Note: ~/.zsh/config/zshfunctions is unavailable."
fi

# Test and then source the line editor
if [ -f ~/.zsh/config/zshzle ]; then
        source ~/.zsh/config/zshzle
else
        print "Note: ~/.zsh/config/zshzle is unavailable."
fi

# Test and then source the key bindings
if [ -f ~/.zsh/config/zshbindings ]; then
        source ~/.zsh/config/zshbindings
else
        print "Note: ~/.zsh/config/zshbindings is not available."
fi

# Test and then source the completion system
if [ -f ~/.zsh/config/zshcompctl ]; then
        source ~/.zsh/config/zshcompctl
else
        print "Note: ~/.zsh/config/zshcompctl is unavailable."
fi

# Test and then source the zstyles
if [ -f ~/.zsh/config/zshstyle ]; then
        source ~/.zsh/config/zshstyle
else
        print "Note: ~/.zsh/config/zshstyle is unavailable."
fi

# Test and then source the wretched rest 
if [ -f ~/.zsh/config/zshmisc ]; then
        source ~/.zsh/config/zshmisc
else
        print "Note: ~/.zsh/config/zshmisc is unavailable."
fi

CVSROOT=/home/lucifer/build/cvs
export CVSROOT

d=.dircolors
test -r $d && eval "$(dircolors $d)"


#source ~/.zsh/syntaxhighlighting.zsh
